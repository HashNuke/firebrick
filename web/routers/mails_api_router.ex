defmodule MailsApiRouter do
  use Dynamo.Router
  import Firebrick.RouterUtils

  prepare do
    conn = authenticate_user!(conn)
  end


  get "/:mail_id" do
    #TODO make sure the mail belongs to the user
    user = conn.assigns[:current_user]
    mail = Mail.find(conn.params[:mail_id])
    json_response mail.public_attributes, conn
  end


  delete "/:mail_id" do
    #TODO
  end

end
