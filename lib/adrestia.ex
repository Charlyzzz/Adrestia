defmodule Adrestia do
  use Application
  @moduledoc """
  Documentation for Adrestia.
  """

  def start(:normal, _) do    
    port = Application.get_env(:adrestia, :port, 4000)
    strategy_module = Application.get_env(:adrestia, :strategy, Adrestia.Strategy.RoundRobin)
    endpoints = Application.fetch_env!(:adrestia, :endpoints)

    HTTPotion.start

    import Supervisor.Spec

    children = [
      worker(strategy_module, [endpoints]),
      worker(Cachex, [Adrestia.Cache, [default_ttl: 5000], []]),
      Plug.Adapters.Cowboy.child_spec(:http, Adrestia.Endpoint, strategy_module, port: port)
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Adrestia.Supervisor)
  end    
end
