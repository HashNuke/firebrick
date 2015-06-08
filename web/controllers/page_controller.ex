defmodule Firebrick.PageController do
  use Firebrick.Web, :controller

  plug :action

  def index(conn, _params) do
    render conn, "index.html"
  end
end
