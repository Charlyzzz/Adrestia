defmodule Adrestia.ActiveCheck do

  def health_check(endpoints, strategy) do
    Enum.each(endpoints,fn(endpoint) ->
      GenServer.cast(strategy, {server_status(endpoint), endpoint})
    end)
  end

  defp server_status({_, url}) do
    case HTTPotion.get(url) do
        %HTTPotion.Response{} -> :server_up
        %HTTPotion.ErrorResponse{} -> :server_down
    end
  end
end
