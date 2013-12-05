defmodule ThreadsApiRouter do
  use Dynamo.Router
  import Firebrick.RouterUtils

  prepare do
    conn = authenticate_user!(conn)
  end


  get "/in/:category" do
    user = conn.assigns[:current_user]
    #TODO invalidate if category is not inbox/sent/trash
    {threads, count, start} = Thread.query(
      "type:thread AND user_id:#{user.id} AND category:#{conn.params[:category]}"
      []) #TODO sort using the options
    thread_attributes = lc thread inlist threads, do: thread.public_attributes
    json_response thread_attributes, conn
  end


  # get "/:thread_id" do
  #   #TODO
  # end


  delete "/:thread_id" do
    #TODO
  end

end
