defmodule Firebrick.Plugs.JwtAuth do
  @behaviour Plug

  alias Plug.Conn

  def init(opts), do: %{}


  def call(conn, level) do
    jwt = conn.cookies["jwt"]
    if jwt == nil do
      auth_fail!(conn)
    else
      case Firebrick.Jwt.decode(jwt) do
        {:ok, data} ->
          Conn.assign(conn, :jwt_data, data)
        {:error, reason} ->
          auth_fail!(conn)
      end
    end
  end


  def auth_fail!(conn) do
    Conn.send_resp(conn, 401, "")
    |> Conn.halt
  end
end
