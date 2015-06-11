defmodule Firebrick.Repo.Migrations.CreateMembershipsTable do
  use Ecto.Migration

  def change do
    create table(:memberships) do
      add :user_id, :integer
      add :mailbox_id, :integer
    end
  end
end
