defmodule Mix.Tasks.Firebrick.Setup do
  use Mix.Task
  import Ecto.Query

  @shortdoc "Setup firebrick"
  def run(_) do
    Mix.Task.run "app.start", []

    roles = ["admin", "member"]
    Enum.each roles, fn(role_name)->
      query = from role in Firebrick.Role, where: role.name == ^role_name
      if Firebrick.Repo.all(query) == [] do
        Firebrick.Repo.insert %Firebrick.Role{name: role_name}
      end
    end

  end
end
