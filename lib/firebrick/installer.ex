defmodule Firebrick.Installer do
  def set_bucket_properties do
    RiakPool.run(fn(pid)->
      {:ok, bucket_properties} = :riakc_pb_socket.get_bucket(pid, {"firebrick_type", "firebrick"})
      new_bucket_props = ListDict.merge(bucket_properties, [allow_mult: false])
      :ok = :riakc_pb_socket.set_bucket(pid, {"firebrick_type", "firebrick"}, new_bucket_props)
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

  # For localhost pass "#{:net_adm.localhost}"
  def install(domain_name) do
    set_bucket_properties()
    {:ok, domain_id} = Domain[name: domain_name].save
    create_admin_user(domain_id)
    :ok
  end

  def clear_all do
    bucket = {"firebrick_type", "firebrick"}
    {:ok, keys} = Firebrick.RiakRealm.list_keys(bucket)
    RiakPool.run(fn(pid)->
      delete_keys = lc key inlist keys, do: :riakc_pb_socket.delete(pid, bucket, key)
      :ok
    end)
  end
end
