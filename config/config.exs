
use Mix.Config

# Available parameters are
# port: Balancer port. Default: 1234
# endpoints: List of upstream servers.
#   Available keys: 
#     -name: Server name. Optional
#     -host: Server address.
#     -weight: Only works with Adrestia.Weight strategy. Default: 1
#     Ej: [%{name: "Foo", host: "localhost:1234", weight: 5}, ....]
# strategy: Load distribution strategy. One of Adrestia.RoundRobin, Adrestia.Weight, Adrestia.Random. Default: Adrestia.RoundRobin.module_info
# cache_ttl: Cache duration in ms. If not specified it's off.
# active_check_time: Servers heartbeath check time in seconds. Default: 3.
config :adrestia, 
  endpoints: [%{name: "server1", host: "localhost:4567", weight: 3}, %{name: "server2", host: "localhost:5678"}],
  cache_ttl: 1_000,
  strategy: Adrestia.RoundRobin
