defmodule Adrestia.ActiveCheck do

  def health_check(endpoints) do
    Enum.each(endpoints,fn(endpoint) ->
      GenServer.cast(Adrestia.Balancer, {server_status(endpoint), endpoint})
    end)
    GenServer.cast(Adrestia.Balancer, :status)
  end

  defp server_status(%{:host => url}) do
    case HTTPotion.get(url) do
        %HTTPotion.Response{} -> :server_up
        %HTTPotion.ErrorResponse{} -> :server_down
    end
  end
end
