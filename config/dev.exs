use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :review, Review.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  cache_static_lookup: false,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin"]]

# Watch static and templates for browser reloading.
config :review, Review.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development.
# Do not configure such in production as keeping
# and calculating stacktraces is usually expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :review, Review.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "jocke",
  password: "",
  database: "review_dev",
  hostname: "localhost",
  pool_size: 10

# Skip db logging in dev, except when doing db imports since
# disabling logging breaks that for some unknown reason.
if !System.get_env("DB_IMPORT") do
  config :review, Review.Repo, log: false
end

# no keys needed in dev
config :review,
  auth_key: nil,
  webhook_secret: nil
