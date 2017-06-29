defmodule Adrestia.Weight do

  def next_server(endpoints) do
    [server|rest] = sort_servers_by_remaining_weight(endpoints)

    {_, next_server} = update_remaining_weight(server)

    {next_server, get_endpoints_from([next_server|rest])}
  end

  defp sort_servers_by_remaining_weight(endpoints) do
    Enum.sort_by(endpoints, &Map.get(&1, :remaining_weight), &>=/2)
  end

  defp update_remaining_weight(server) do
    Map.get_and_update(server, :remaining_weight, fn(prev_weight) -> {prev_weight, prev_weight - 1} end)
  end

  defp get_endpoints_from(endpoints) do
    if all_remaining_weight_zero?(endpoints) do
      Enum.map(endpoints, fn(%{:weight => weight} = server) -> Map.put(server, :remaining_weight, weight) end)
    else
      endpoints
    end
  end

  defp all_remaining_weight_zero?(endpoints) do
    Enum.all?(endpoints, fn(%{:remaining_weight => value}) -> value == 0 end)
  end
end
