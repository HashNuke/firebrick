defmodule Rinket.Db do

  def create(bucket, data) do
    json = :jsx.encode(data)
    {:ok, obj} = :riakc_obj.new(bucket, :undefined, json, "application/json")
      |> RiakPool.put
    :riakc_obj.key(obj)
  end


  def get(bucket, key) do
    {:ok, obj} = RiakPool.get(bucket, key)
    :riakc_obj.get_values(obj)
      |> hd
      |> :jsx.decode
  end


  def update(bucket, key, data) do
    :riakc_obj.new(bucket, key, data) |> RiakPool.put
  end


  def patch(bucket, key, patch_data) do
    new_data = get(bucket, key) |> Dict.merge(patch_data)
    {:ok, obj} = :riakc_obj.new(bucket, key, :jsx.encode(new_data))
      |> RiakPool.put

    :riakc_obj.key(obj)
  end


  def search(bucket, query, options // []) do
    {:ok, {:search_results, results, _, _count}} = RiakPool.run(fn(worker)->
      :riakc_pb_socket.search(worker, bucket, query, options)
    end)

    # Cleans up, by removing the bucket names from the results
    :lists.map(fn(item)->
      {bucket, obj} = item
      obj
    end, results)
  end


  def delete(bucket, key) do
    RiakPool.delete(bucket, key)
  end

end
