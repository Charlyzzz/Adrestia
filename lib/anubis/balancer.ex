defmodule Anubis.Balancer do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, {}, name: __MODULE__)
  end  
end
