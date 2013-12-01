defmodule Firebrick.Installer do
  def create_admin_user(domain_id) do
    {:ok, _user_id} = User[
      first_name: "Admin",
      username: "admin", 
      password: "password",
      role: "admin",
      domain_id: domain_id
    ].save
  end

  def install do
    domain = Domain[name: "#{:net_adm.localhost}"]
    {:ok, domain_id} = domain.save
    create_admin_user(domain_id)
    :ok
  end
end
