defmodule Firebrick.Installer do
  def create_index do
    :ok = RiakPool.run(fn(pid)->
      :riakc_pb_socket.create_search_index(pid, "firebrick_index")
    end)
  end

  def create_admin_user(domain_id) do
    {:ok, _user_id} = User[
      first_name: "Admin",
      username: "admin", 
      password: "password",
      role: "admin",
      domain_id: domain_id
    ].save
  end


  def add_first_domain do
    #TODO remove this. This is supposed to go into the installation screen.
    domain = Domain[name: :net_adm.localhost]
    domain.save
    domain
  end

  def install do
    create_index
    domain = Domain[name: :net_adm.localhost]
    {:ok, domain_id} = domain.save
    
    create_admin_user(domain_id)
  end
end
