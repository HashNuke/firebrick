# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :firebrick, Firebrick.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "FzyA236FHNjtii8gF0+vStMo7NO75Ppfo444yAc/zxOEg4yo1DqzwH8m1FsmOti1",
  debug_errors: false,
  pubsub: [name: Firebrick.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  default_format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.

import_config "#{Mix.env}.exs"


# This line was automatically added by ansible-elixir-stack setup script
if System.get_env("SERVER") do
  config :phoenix, :serve_endpoints, true
end
