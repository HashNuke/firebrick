defmodule Firebrick.Plugs.JwtAuth do
  @behaviour Plug

  alias Plug.Conn


  def init(opts) do
    %{}
  end


  def call(conn, level) do
    jwt = conn.cookies["jwt"]
    process_req(conn, jwt)
  end


  defp process_req(conn, nil) do
    auth_fail!(conn)
  end


  defp process_req(conn, jwt) do
    case Firebrick.Jwt.decode(jwt) do
      {:ok, data} ->
        Conn.assign(conn, :jwt_data, data)
      {:error, reason} ->
        auth_fail!(conn)
    end
  end


  def auth_fail!(conn) do
    Conn.send_resp(conn, 401, "")
    |> Conn.halt
  end
end
