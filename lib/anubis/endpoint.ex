defmodule Anubis.Endpoint do
  import Plug.Conn

  def init(_) do
    :ok
  end  

  def call(conn, _opts) do
    send_resp(conn, 200, "Pong")
  end
end
