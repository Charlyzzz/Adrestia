defmodule Adrestia.ActiveCheck do

  def health_check(endpoints) do
    Enum.each(endpoints, fn(%{:host => host}) ->
      GenServer.cast(Adrestia.Balancer, {server_status(host), host})
    end)
    GenServer.cast(Adrestia.Balancer, :status)
  end

  defp server_status(url) do
    case HTTPotion.head(url) do
        %HTTPotion.Response{} -> :server_up
        %HTTPotion.ErrorResponse{} -> :server_down
    end
  end
end
