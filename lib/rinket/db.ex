defmodule Rinket.Db do

  def create(bucket, data) do
    #TODO create object
    riak_obj = :riakc_obj.new bucket, :undefined, data
    RiakPool.put(riak_obj)
  end

  def get(bucket, key) do
    riak_obj = RiakPool.get(bucket, key)
    json = :riakc_obj.get_values(riak_obj)
    :jsx.decode(json)
  end

  def update(bucket, key, data) do
    riak_obj = :riakc_obj.new(bucket, key, data)
    RiakPool.put(riak_obj)
  end

  def patch(bucket, key, patch_data) do
    old_data = __MODULE__.get(bucket, key)
    new_data = Dict.merge(old_data, patch_data)
    new_riak_obj = :riakc_obj.new(bucket, key, new_data)
    RiakPool.put(new_riak_obj)
  end

  def delete(bucket, key) do
    RiakPool.delete(bucket, key)
  end

end
