defmodule Firebrick.Installer do

  import Firebrick.RiakRealm
  bucket_info

  def config do
    # set_bucket_properties
    :ok = RiakPool.run(fn(pid)->
      {:ok, bucket_properties} = :riakc_pb_socket.get_bucket(pid, bucket)
      new_bucket_props = ListDict.merge(bucket_properties, [allow_mult: false])
      :riakc_pb_socket.set_bucket(pid, bucket, new_bucket_props)
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

  # For localhost Firebrick.Installer.install("#{:net_adm.localhost}")
  def install(domain_name) do
    {:ok, domain_id} = Domain[name: domain_name].save
    create_admin_user(domain_id)
    :ok
  end

  def clear_all do
    {:ok, keys} = Firebrick.RiakRealm.list_keys(bucket)
    :ok = RiakPool.run(fn(pid)->
      delete_keys = lc key inlist keys, do: :riakc_pb_socket.delete(pid, bucket, key)
      :ok
    end)
  end

end
