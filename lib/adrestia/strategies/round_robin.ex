defmodule Adrestia.RoundRobin do
  use GenServer

  defstruct [:servers]

  def start_link(endpoints) do
    GenServer.start_link(__MODULE__, endpoints, name: __MODULE__)
  end

  def handle_call(:next_server, _from, [next_server|rest]) do
    {:reply, next_server, rest ++ [next_server]}
  end  

  def upstream(endpoints\\[]), do: struct(__MODULE__, servers: endpoints)
end
