import Config

config :docusign,
  hostname: "account-d.docusign.com",
  client_id: System.fetch_env!("DOCUSIGN_CLIENT_ID"),
  private_key: System.fetch_env!("DOCUSIGN_PRIVATE_KEY")
