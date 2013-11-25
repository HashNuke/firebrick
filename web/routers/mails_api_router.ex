defmodule MailsApiRouter do
  use Dynamo.Router
  import Firebrick.RouterUtils

  prepare do
    conn = authenticate_user!(conn)
  end


  get "/" do
    user = conn.assigns[:current_user]
    {threads, count} = Thread.search("user_id:#{user.id}")
    thread_attributes = lc thread inlist threads, do: thread.public_attributes
    json_response thread_attributes, conn
  end


  get "/:mail_id" do
    #TODO
  end


  delete "/:mail_id" do
    #TODO
  end

end
