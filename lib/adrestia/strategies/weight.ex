defmodule Adrestia.Weight do

  def next_server(endpoints) do
    [server|rest] = Enum.sort_by(endpoints, &Map.get(&1, :remaining_weight), &>=/2)


    {_, next_server} = Map.get_and_update(server, :remaining_weight, fn(prev_weight) -> {prev_weight, prev_weight - 1} end)

    new_endpoints = [next_server|rest]
    if (Enum.all?(new_endpoints, fn(%{:remaining_weight => value}) -> value == 0 end)) do
      new_endpoints = Enum.map(new_endpoints, fn(%{:weight => weight} = server) -> Map.put(server, :remaining_weight, weight) end)
    end

    {next_server, new_endpoints}
  end

end
