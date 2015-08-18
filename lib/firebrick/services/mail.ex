defmodule Firebrick.Services.Mail do

  import Ecto.Query

  alias Firebrick.Repo
  alias Firebrick.Mail
  alias Firebrick.Services


  def save(identity, unique_id, data) do
    user = identity.user
    from_id = Services.Contact.find_or_create user, [data["From"]]
    to_ids = Services.Contact.find_or_create user, data["To"]
    cc_ids = Services.Contact.find_or_create user, data["Cc"]
    bcc_ids = Services.Contact.find_or_create user, data["Bcc"]

    %Mail{
      from_id: from_id,
      to_ids: to_ids,
      cc_ids: cc_ids,
      bcc_ids: bcc_ids,
      subject: data["Subject"],
      plain_body: data["plain_body"],
      html_body: data["html_body"],
      unique_mail_id: data["Message-ID"]
    }
    |> Repo.insert
  end
end
