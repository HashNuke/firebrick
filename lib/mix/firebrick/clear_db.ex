defmodule Mix.Tasks.Firebrick.ClearDb do
  use Mix.Task
  import Ecto.Query
  import Ecto.Model
  alias Firebrick.Repo


  @shortdoc "Delete all firebrick data from database"
  def run(_) do
    Mix.Task.run "app.start", []

    [
      Firebrick.Contact,
      Firebrick.MailThread,
      Firebrick.Mail,
      Firebrick.MailLabel,
      Firebrick.Domain,
      Firebrick.User,
      Firebrick.UserRole
    ]
    |> Enum.map &(Repo.delete_all &1)
  end
end
