use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :firebrick, Firebrick.Endpoint,
  http: [port: 4001],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :firebrick, Firebrick.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "firebrick_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 1 # Use a single connection for transactional tests


config :firebrick, :jwt, [name: "HS256", secret: "E3azkLmEGrWiJB4mDPLlOGKn0Ib5no4iQY1W5lTnKT8="]
