defmodule ApiRouter do
  use Dynamo.Router

  forward "/users", to: UsersApiRouter
  forward "/mails", to: MailsApiRouter
end
