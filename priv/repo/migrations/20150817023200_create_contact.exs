defmodule Firebrick.Repo.Migrations.CreateContact do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add :name, :string
      add :email, :string
      add :gravatar_hash, :string
      add :user_id, :integer

      timestamps
    end

  end
end
