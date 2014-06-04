defmodule Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres

  def conf do
    parse_url Application.get_env(:firebrick, :db_url)
  end


  def priv do
    app_dir(:firebrick, "priv/repo")
  end
end
