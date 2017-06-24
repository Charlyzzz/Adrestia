defmodule Adrestia.Request do
  alias Adrestia.Cache

  defstruct [:verb, :conn, :path, 
             :query_string, :response, 
             :endpoint, :headers, :status_code, 
             :cacheable?, :body]

  def from_conn(conn) do    
    %Adrestia.Request{verb: verb(conn)}
      |> Map.put(:conn, conn)
      |> Map.put(:path, path(conn))
      |> Map.put(:query_string, query_string(conn))
      |> Map.put(:cacheable?, cacheable?(conn))
  end

  def put_endpoint(request, server) do
    %{request | endpoint: server}
  end

  def put_response(request, %HTTPotion.ErrorResponse{} = response) do
    %{request | response: response}
  end

  def put_response(request, response) do
    request
      |> Map.put(:response, response)
      |> Map.put(:headers, response.headers.hdrs)
      |> Map.put(:status_code, response.status_code)
      |> Map.put(:body, response.body)
  end

  def send(request) do
    {_, endpoint} = request.endpoint
    url = endpoint <> "/" <> request.path <> request.query_string
    response = HTTPotion.request(request.verb, url)    
    put_response(request, response)
  end

  defp verb(conn), do: conn.method |> String.downcase |> String.to_atom

  defp path(conn), do: Enum.join(conn.path_info, "/")

  defp query_string(conn) do
    case conn.query_string do
                     "" -> ""
                     qs -> "?" <> qs
    end
  end

  defp cacheable?(conn) do
    non_cacheable = fn(header) -> header in [{"cache-control", "no-cache"}, {"expires", "0"}] end
    not Enum.any?(conn.req_headers, non_cacheable) and Cache.enabled?()
  end
end
