# SPDX-License-Identifier: AGPL-3.0
# Copyright (c) 2023 Gavin Henry <ghenry@sentrypeer.org>

import Config

config :docusign,
  hostname: "account-d.docusign.com",
  client_id: System.fetch_env!("DOCUSIGN_CLIENT_ID"),
  private_key: System.fetch_env!("DOCUSIGN_PRIVATE_KEY")

import_config "#{config_env()}.exs"
