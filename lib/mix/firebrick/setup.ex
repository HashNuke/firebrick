defmodule Mix.Tasks.Firebrick.Setup do
  use Mix.Task
  import Ecto.Query
  import Ecto.Model
  alias Firebrick.Repo


  @shortdoc "Setup firebrick"
  def run(_) do
    Mix.Task.run "app.start", []

    ensure_roles
    ensure_admin_user
  end


  def ensure_roles do
    roles = ["admin", "member"]
    Enum.each roles, fn(role_name)->
      query = from role in Firebrick.UserRole, where: role.name == ^role_name
      if Repo.all(query) == [] do
        Repo.insert %Firebrick.UserRole{name: role_name}
      end
    end
  end


  def ensure_admin_user do
    admin_users = Repo.all(from role in Firebrick.UserRole, where: role.name == "admin", select: role)
    |> assoc(:users)
    |> Repo.all


    if admin_users == [] do
      # TODO create user admin@example.com:password
      # Create associated mailbox
      # User.create(email, password)
    end
  end
end
