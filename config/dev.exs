use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :firebrick, Firebrick.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  cache_static_lookup: false,
  watchers: [node: ["frontend/node_modules/ember-cli/bin/ember", "serve"]]

# Watch static and templates for browser reloading.
config :firebrick, Firebrick.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, default_format: "[$level] $message\n"

# Configure your database
config :firebrick, Firebrick.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "firebrick_dev",
  size: 10 # The amount of database connections in the pool


config :firebrick, :jwt, [name: "HS256", secret: "E3azkLmEGrWiJB4mDPLlOGKn0Ib5no4iQY1W5lTnKT8="]
