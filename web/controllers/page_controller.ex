defmodule Firebrick.PageController do
  use Firebrick.Web, :controller

  @jwt_options Application.get_env(:firebrick, :jwt)

  plug Firebrick.Plugs.JwtAuth when action in [:verify]
  plug :action

  def index(conn, _params) do
    # render conn, "index.html"
    {:ok, jwt} = Firebrick.Jwt.encode(%{user_id: 123}, @jwt_options)
    put_resp_cookie(conn, "jwt", jwt)
    |> text ("JWT: #{jwt}")
  end


  def verify(conn, _params) do
    text conn, "JWT Data: #{Poison.encode!(conn.assigns[:jwt_data])}"
  end

end
