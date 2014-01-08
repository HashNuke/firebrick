defmodule ThreadsApiRouter do
  use Dynamo.Router
  import Firebrick.RouterUtils

  prepare do
    conn = authenticate_user!(conn)
  end


  get "/in/:category" do
    user = conn.assigns[:current_user]
    #TODO invalidate if category is not inbox/sent/trash
    {thread_objs, count, start} = Thread.query(
      "type:thread AND user_id:#{user.id} AND category:#{conn.params[:category]}",
      [sort: "updated_at_dt desc"])
    threads = lc thread inlist thread_objs, do: thread.public_attributes
    json_response [threads: threads], conn
  end


  get "/:thread_id" do
    user = conn.assigns[:current_user]
    thread = Thread.find conn.params[:thread_id]
    {mails, count, start} = Mail.query("type:mail AND thread_id:#{conn.params[:thread_id]}", [sort: "created_at_dt desc"])
    mail_attributes = lc mail inlist mails, do: mail.public_attributes
    json_response ListDict.merge(thread.public_attributes, [mails: mail_attributes]), conn
  end


  delete "/:thread_id" do
    #TODO
  end

end
