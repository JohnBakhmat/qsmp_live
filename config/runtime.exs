import Config
import Dotenvy

source!([".env", System.get_env()])

config :qsmplive,
  port: env!("PORT", :integer!),
  twitch_client_id: env!("TWITCH_CLIENT_ID", :string!),
  twitch_client_secret: env!("TWITCH_CLIENT_SECRET",:string!)
