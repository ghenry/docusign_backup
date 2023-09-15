import Config

config :docusign,
  hostname: "account.docusign.com",
  client_id: System.fetch_env!("DOCUSIGN_CLIENT_ID"),
  private_key: System.fetch_env!("DOCUSIGN_PRIVATE_KEY"),
  account_id: System.fetch_env!("DOCUSIGN_ACCOUNT_ID")
