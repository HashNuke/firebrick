defmodule Firebrick.Router do
  use Phoenix.Router

  plug Plug.Static, at: "/static", from: :firebrick
  get "/", Firebrick.Controllers.Pages, :index, as: :page
end
