defmodule Adrestia.Balancer do
  use GenServer

  def start_link(endpoints, strategy) do
    GenServer.start_link(__MODULE__, {endpoints, [], strategy}, name: __MODULE__)
  end

  def init({endpoints, _, strategy}) do
    servers = Enum.map(endpoints, fn(server) ->
      weight = Map.get(server, :weight, 1)
      server
        |> Map.put(:weight, weight)
        |> Map.put(:remaining_weight, weight)
    end)
    {:ok, {servers, [], strategy}}
  end

  def handle_call(:next_server, _from, {[], _, _} = state) do
    {:reply, :error, state}
  end

  def handle_call(:next_server, _from, {ups, downs, strategy}) do
    {server, new_ups} = Kernel.apply(strategy, :next_server, [ups])
    {:reply, server, {new_ups, downs, strategy}}
  end

  def handle_cast({:server_down, host}, {ups, downs, strategy}) do
    server = find_by_host(host, ups ++ downs)
    rest = List.delete(ups, server)
    {:noreply, {rest, as_set([server | downs]), strategy}}
  end

  def handle_cast({:server_up, host}, {ups, downs, strategy}) do
    server = find_by_host(host, downs ++ ups)
    rest = List.delete(downs, server)
    {:noreply, {as_set([server | ups]), rest, strategy}}
  end

  def handle_cast(:status, state) do
    IO.inspect state
    {:noreply, state}
  end

  defp find_by_host(host, endpoints) do
    same_host = fn(%{:host => sv_host}) -> sv_host == host end
    Enum.find(endpoints, same_host)
  end

  defp as_set(list), do: list |> MapSet.new |> MapSet.to_list
end
