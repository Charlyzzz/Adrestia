defmodule Anubis do
  use Application
  @moduledoc """
  Documentation for Anubis.
  """

  def start(:normal, _) do    
    port = Application.get_env(:anubis, :port, 4000)
    Plug.Adapters.Cowboy.http(Anubis.Endpoint, [], port: port)

    import Supervisor.Spec

    children = [worker(Anubis.Balancer, [])]
    Supervisor.start_link(children, strategy: :one_for_one, name: Anubis.Balancer.Supervisor)
  end    
end
