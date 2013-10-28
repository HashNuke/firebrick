defmodule ApiRouter do
  use Dynamo.Router

  forward "/users", to: UsersApiRouter
end
