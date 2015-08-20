defmodule Mix.Tasks.Firebrick.DbStats do
  use Mix.Task
  import Ecto.Query
  import Ecto.Model
  alias Firebrick.Repo


  @shortdoc "Delete all firebrick data from database"
  def run(_) do
    Mix.Task.run "app.start", []

    [
      Firebrick.UserRole,
      Firebrick.Domain,
      Firebrick.User,
      Firebrick.Contact,
      Firebrick.MailThread,
      Firebrick.Mail,
      Firebrick.MailLabel
    ]
    |> Enum.map fn(module)->
      record_count = Repo.one(from m in module, select: count(m.id))
      IO.puts "#{module}: #{record_count}"
    end

  end
end
