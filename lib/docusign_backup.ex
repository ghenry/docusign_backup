defmodule DocusignBackup do
  @moduledoc """
  Documentation for `DocusignBackup`.
  """

  alias DocuSign.Api
  require Logger
  use Timex

  @doc """
  One simple function to export all your Docusign documents as combined PDFs.

  It takes three arguments:

   1. The DocuSign User ID UUID. You can find this in the DocuSign Admin panel.
   2. The directory path for saving PDFs
   3. An optional date range. Default is the last 30 days.

  ## Examples

      iex> DocusignBackup.export_complete_combined_pdfs("b36de136-53b0-11ee-894d-d05099894ba6", "/tmp/docusign_backup", "2023-01-01")


  """
  def export_complete_combined_pdfs(
        user_id,
        path,
        from_date \\ Timex.shift(Date.utc_today(), days: -30)
      ) do
    Logger.debug("Fetching envelopes...")

    case Api.Envelopes.envelopes_get_envelopes(connection(user_id), account_id(),
           from_date: from_date
         ) do
      {:ok, %DocuSign.Model.EnvelopesInformation{envelopes: envelopes}} ->
        Logger.debug("Fetched envelopes: #{inspect(envelopes)}")

        Enum.each(envelopes, fn envelope ->
          Logger.debug("Fetching envelope #{envelope.envelopeId}...")

          case Api.EnvelopeDocuments.documents_get_document(
                 connection(user_id),
                 account_id(),
                 "combined",
                 envelope.envelopeId
               ) do
            {:ok,
             %Tesla.Env{
               headers: headers,
               body: combined_pdf
             }} ->
              Logger.debug("Fetched envelope #{envelope.envelopeId}...")
              datetime_now = DateTime.now!("Europe/London") |> DateTime.to_unix()

              pdf_file_names = find_pdf_file_names(headers)

              pdf_filename =
                Regex.run(~r/filename\*\=UTF-8''(.*\.pdf)/, pdf_file_names,
                  capture: :all_but_first
                )

              pdf_filename_with_datetime = "#{datetime_now}_#{pdf_filename}"

              File.mkdir(path)
              full_path = Path.join([path, pdf_filename_with_datetime])
              File.write!(full_path, combined_pdf)

              {:ok, created_datetime, _secs} = DateTime.from_iso8601(envelope.createdDateTime)
              unix_time = DateTime.to_unix(created_datetime)

              File.touch!(full_path, unix_time)
              Logger.debug("Wrote envelope #{envelope.envelopeId} to #{full_path}")

            {:error, %Tesla.Env{body: error}} ->
              Logger.error(inspect(error))
              {:error, error}
          end
        end)

        {:ok, envelopes}

      {:error, %Tesla.Env{body: error}} ->
        Logger.error(inspect(error))
        {:error, error}
    end
  end

  defp find_pdf_file_names(headers) do
    Logger.debug("Headers: #{inspect(headers)}")

    Enum.find(headers, fn {key, _value} ->
      key == "content-disposition"
    end)
    |> elem(1)
  end

  defp connection(user_id) do
    case DocuSign.Connection.get(user_id) do
      {:ok, conn} ->
        conn

      {:error, %Tesla.Env{body: error}} ->
        Logger.error(inspect(error))
        {:error, error}
    end
  end

  defp account_id, do: Application.get_env(:docusign, :account_id)
end
