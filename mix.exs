defmodule DocusignBackup.MixProject do
  use Mix.Project

  def project do
    [
      app: :docusign_backup,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {DocusignBackup.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:docusign, "~> 1.1.1"},
      {:timex, "~> 3.7"},
      {:tesla, "~> 1.4"},

      # optional, but recommended adapter
      {:hackney, "~> 1.17"}
    ]
  end
end
