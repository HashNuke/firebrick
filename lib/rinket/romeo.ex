defmodule Romeo do

  # methods to delegate to authenticator
  def routes do
  end


  def authenticators do
    [
     [module: Romeo.UserPasswordAuthenticator],
     [module: Romeo.TokenAuthenticator]
    ]
  end

  def authenticate(params) do
    :application.get_env(:romeo, :authenticators)
      |> Enum.take_while
  end


  def authenticate(authenticator, params) do
    if authenticator.authenticate(params) do
      
    end
  end
end
