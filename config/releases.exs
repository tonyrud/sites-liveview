# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

# ------------------------------
#   Release ENVs
# ------------------------------

# database_url =
#   System.get_env("DATABASE_URL") ||
#     raise """
#     environment variable DATABASE_URL is missing.
#     For example: ecto://USER:PASS@HOST/DATABASE
#     """
username = System.fetch_env!("POSTGRES_USER")
password = System.fetch_env!("POSTGRES_PASSWORD")
database = System.fetch_env!("POSTGRES_DB")
hostname = System.fetch_env!("POSTGRES_HOST")

secret_key_base = System.fetch_env!("SECRET_KEY_BASE")

host = System.fetch_env!("HOST")

config :demo, Demo.Repo,
  # ssl: true,
  # url: database_url,
  username: username,
  password: password,
  database: database,
  hostname: hostname,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  show_sensitive_data_on_connection_error: true,
  types: Demo.PostgresTypes

config :demo, DemoWeb.Endpoint,
  url: [host: host],
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
config :demo, DemoWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
