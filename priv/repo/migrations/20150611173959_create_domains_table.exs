defmodule Firebrick.Repo.Migrations.CreateDomainsTable do
  use Ecto.Migration

  def change do
    create table(:domains) do
      add :name, :text
    end
  end
end
