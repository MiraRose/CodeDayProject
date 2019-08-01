# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :code_day_project,
  ecto_repos: [CodeDayProject.Repo]

# Configures the endpoint
config :code_day_project, CodeDayProjectWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "laEx0inZRm8FBamnp50UZZzd8LUlmwmfNXX9a4tD4790GC2t9X5siWMboAFRtaFj",
  render_errors: [view: CodeDayProjectWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CodeDayProject.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
