defmodule Adrestia.Endpoint do
  use Plug.Builder

  alias Adrestia.{Cache, Request}

  import Plug.Conn

  def call(conn, _) do
    conn
      |> Request.from_conn
      |> pipeline(server_address())
  end

  defp pipeline(request, :error) do
    send_resp(request.conn, :service_unavailable, "There are no servers available")
  end

  defp pipeline(request, address) do
    request
      |> Request.put_endpoint(address)
      |> read_cache
      |> read
      |> check
      |> write_cache
      |> write
  end

  defp read_cache(%{:verb => :get} = request) do
    {request, cache_get(request)}
  end

  defp read_cache(request) do
    {request, nil}
  end

  defp read({request, nil}) do
    Request.send(request)
  end

  defp read({request, cached_response}) do
    Request.put_response(request, cached_response)
  end

  defp check(%{:response => %HTTPotion.ErrorResponse{}} = request) do
    report_server_down(request.endpoint.host)
    pipeline(request, server_address())
  end

  defp check(request), do: request

  defp write_cache(%{:verb => :get} = request) do
    cache_set(request)
  end

  defp write_cache(req), do: req

  defp write(%Request{} = request) do
    request.conn
      |> put_resp_headers(request.headers)
      |> send_resp(request.status_code, request.body)
  end

  defp write(conn), do: conn

  defp report_server_down(server) do
    GenServer.cast(Adrestia.Balancer, {:server_down, server})
  end

  defp put_resp_headers(conn, headers) do
    reducer = fn({header_key, value}, connection) ->
      put_resp_header(connection, header_key, value)
    end
    Enum.reduce(headers, conn, reducer)
  end

  defp server_address do
    GenServer.call(Adrestia.Balancer, :next_server)
  end

  defp cache_get(request) do
    if request.cacheable?, do: Cache.get(request)
  end

  defp cache_set(request) do
    if request.cacheable?, do: Cache.set(request)
    request
  end
end
