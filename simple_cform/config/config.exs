# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :simple_cform,
  ecto_repos: [SimpleCform.Repo]

# Configures the endpoint
config :simple_cform, SimpleCformWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "l+q8/Ud2J+3msCdfLEb3UUZy1r4jiuZFIOGlkhQfxnIkKekV3/eaR/fXAvhBDv08",
  render_errors: [view: SimpleCformWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SimpleCform.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
