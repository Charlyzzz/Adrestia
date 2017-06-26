defmodule Adrestia do
  use Application
  @moduledoc """
  Documentation for Adrestia.
  
  """

  def start(:normal, _) do             
    port = Application.get_env(app(), :port, 4000)
    ttl = Application.get_env(app(), :cache_ttl, 5000)
    check_time = Application.get_env(app(), :active_check_time, 3)
    endpoints = Application.fetch_env!(app(), :endpoints)
    balance_strategy = Application.get_env(app(), :strategy, Adrestia.RoundRobin)

    HTTPotion.start

    import Supervisor.Spec    
    children = [
      worker(balance_strategy, [endpoints]),
      worker(Cachex, [Adrestia.Cache, [default_ttl: ttl]]),
      Plug.Adapters.Cowboy.child_spec(:http, Adrestia.Endpoint, [], port: port)
    ] 
    
    :timer.apply_interval(
      :timer.seconds(check_time), 
      Adrestia.ActiveCheck, 
      :health_check, 
      [endpoints, balance_strategy])

    Supervisor.start_link(children, strategy: :one_for_one, name: Adrestia.Supervisor)
  end

  def app, do: :adrestia
end
