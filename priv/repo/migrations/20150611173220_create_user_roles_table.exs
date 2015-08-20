defmodule Firebrick.Repo.Migrations.CreateUserRolesTable do
  use Ecto.Migration

  def change do
    create table(:user_roles) do
      add :name, :string

      timestamps
    end
  end
end
