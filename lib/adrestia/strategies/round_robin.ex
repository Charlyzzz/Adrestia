defmodule Adrestia.RoundRobin do
  use GenServer

  def start_link(endpoints) do
    GenServer.start_link(__MODULE__, {endpoints, []}, name: __MODULE__)
  end

  def handle_call(:next_server, _from, {[], _} = state) do
    {:reply, :error, state}
  end

  def handle_call(:next_server, _from, {[next_server | rest], unavailable}) do
    {:reply, next_server, {rest ++ [next_server], unavailable}}
  end

  def handle_cast({:server_down, server}, {ups, downs}) do
    IO.inspect {ups, downs}
    rest = List.delete(ups, server)
    {:noreply, {rest, as_set([ server | downs])}}
  end  

  def handle_cast({:server_up, server}, {ups, downs}) do
    IO.inspect {ups, downs}
    rest = List.delete(downs, server)
    {:noreply, {as_set(ups ++ [server]), rest}}
  end  

  defp as_set(list), do: list |> MapSet.new |> MapSet.to_list
end
