defmodule Mix.Tasks.Firebrick.Check do
  use Mix.Task
  import Ecto.Model
  import Ecto.Query
  alias Firebrick.Repo

  @shortdoc "Check firebrick"
  def run(_) do
    Mix.Task.run "app.start", []

    role_names = Repo.all(from role in Firebrick.Role, select: role.name)
    Mix.shell.info "Roles: #{Enum.join(role_names, ", ")}"


    Mix.shell.info "Admin users:"
    Repo.all(from role in Firebrick.Role, where: role.name == "admin", select: role)
    |> assoc(:users)
    |> Repo.all
    |> Enum.map( &(&1.email) )
    |> IO.inspect
  end
end
