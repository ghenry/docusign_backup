# SPDX-License-Identifier: AGPL-3.0
# Copyright (c) 2023 Gavin Henry <ghenry@sentrypeer.org>

import Config

config :docusign,
  hostname: "account.docusign.com",
  client_id: System.fetch_env!("DOCUSIGN_CLIENT_ID"),
  private_key: System.fetch_env!("DOCUSIGN_PRIVATE_KEY"),
  account_id: System.fetch_env!("DOCUSIGN_ACCOUNT_ID")

import_config "#{config_env()}.exs"
