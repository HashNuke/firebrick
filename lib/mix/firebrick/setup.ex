defmodule Mix.Tasks.Firebrick.Setup do
  use Mix.Task
  import Ecto.Query
  import Ecto.Model
  alias Firebrick.Repo


  @shortdoc "Setup firebrick"
  def run(_) do
    Mix.Task.run "app.start", []

    ensure_example_domain
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


  def ensure_example_domain do
    domain_count = Repo.one(from d in Firebrick.Domain, select: count(d.id))
    if domain_count == 0 do
      Repo.insert %Firebrick.Domain{name: "example.com"}
    end
  end


  def ensure_admin_user do
    admin_role = Repo.one(from r in Firebrick.UserRole, where: r.name == "admin")
    admin_user = Repo.one(from u in Firebrick.User, where: u.user_role_id == ^admin_role.id)

    if !admin_user do
      Repo.insert %Firebrick.User{username: "admin", password: "password", user_role_id: admin_role.id}
    end
  end
end
