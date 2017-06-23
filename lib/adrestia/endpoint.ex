defmodule Adrestia.Endpoint do
  import Plug.Conn

  def init(strategy), do: strategy

  def call(conn, strategy) do
    url = path(conn, strategy)    
    _headers = conn.req_headers
    
    verb = conn.method |> String.downcase |> String.to_atom
    
    response = HTTPotion.request(verb, url, ibrowse: [max_sessions: 100, max_pipeline_size: 1])
    
    conn
      |> put_resp_headers(response.headers)
      |> send_resp(response.status_code, response.body)
  end

  defp put_resp_headers(conn, %{:hdrs => headers}) do
    Map.put(conn, :resp_headers, Map.to_list(headers))
  end

  defp path(conn, strategy) do
    base = server_address(strategy) <> "/" <> Enum.join(conn.path_info, "/")
    case conn.query_string do
      "" -> base
      qs -> base <> "?" <> qs
    end
  end

  defp server_address(strategy) do
    strategy
      |> GenServer.call(:next_server)
      |> elem(1)
  end
end
