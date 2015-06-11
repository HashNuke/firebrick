defmodule Firebrick.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :text
      add :encrypted_password, :text
      add :role_id, :integer
    end
  end
end
