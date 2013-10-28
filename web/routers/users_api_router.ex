defmodule UsersApiRouter do
  use Dynamo.Router

  prepare do
    conn.fetch([:cookies, :params])
  end

  get "/" do
    #TODO get users list
  end

  get "/:user_id" do
    #TODO get a particular user id
  end

  put "/:user_id" do
    #TODO update user
  end

  delete "/:user_id" do
    #TODO delete user
  end

end
