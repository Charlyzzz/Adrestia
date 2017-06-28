
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :adrestia, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:adrestia, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"
config :adrestia,
  port: 1234,
  endpoints: [{"server1", "localhost:4567"}, {"server2", "localhost:5678"}],
  cache_ttl: 1_000,
  strategy: Adrestia.RoundRobin
