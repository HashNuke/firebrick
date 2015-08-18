defmodule Firebrick.Services.Mail do

  import Ecto.Query

  alias Firebrick.Repo
  alias Firebrick.Mail
  alias Firebrick.MailParser
  alias Firebrick.Services


  def save(identity, data) do
    parsed = MailParser.parse(data)

    subject = parsed["Subject"]
    user = identity.user
    from_id = Services.Contact.find_or_create user, [parsed["From"]]
    to_ids = Services.Contact.find_or_create user, parsed["To"]
    cc_ids = Services.Contact.find_or_create user, parsed["Cc"]
    bcc_ids = Services.Contact.find_or_create user, parsed["Bcc"]

    mail = %Mail{
      raw_from: data["From"],
      raw_to: data["To"],
      raw_cc: data["Cc"],
      raw_bcc: data["Bcc"],
      from_id: from_id,
      to_ids: to_ids,
      cc_ids: cc_ids,
      bcc_ids: bcc_ids,
      subject: parsed["Subject"],
      plain_body: data["plain_body"],
      html_body: data["html_body"],
      unique_mail_id: data["Message-ID"]
    }

    Repo.insert mail
  end
end
