defmodule Firebrick.Services.Mail do

  alias Firebrick.Repo
  alias Firebrick.Mail
  alias Firebrick.Contact
  alias Firebrick.MailParser


  def save(data) do
    #TODO handle cc & bcc
    parsed = MailParser.parse(data)

    subject = parsed["Subject"]
    from_id = find_or_create_participant parsed["From"]
    to_ids = find_or_create_participants parsed["To"]
    cc_ids = find_or_create_participants parsed["Cc"]
    bcc_ids = find_or_create_participants parsed["Bcc"]

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


  def find_or_create_participant(%{name: name, email: email}) do
    # If only outgoing mail sent, update name from incoming email
    # if incoming for the first time, create new contact
    # Repo.insert()
  end


  def find_or_create_participants(participant) do
  end


  def find_contact(name, email) do
    # find contact
    # if not found create
    # contact
  end
end
