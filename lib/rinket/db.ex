defmodule Rinket.Db do

  def create(bucket, data) do
    {:ok, json} = JSEX.encode(data)
    {:ok, obj} = :riakc_obj.new(bucket, :undefined, json, "application/json")
    |> RiakPool.put

    :riakc_obj.key(obj)
  end

  def get(bucket, key) do
    {:ok, obj} = RiakPool.get(bucket, key)
    {:ok, data} = :riakc_obj.get_values(obj)
    |> hd
    |> JSEX.decode
    data
  end


  def put(bucket, key, data) do
    {:ok, json} = JSEX.encode data
    result = :riakc_obj.new(bucket, key, json, "application/json") |> RiakPool.put
    cond do
      key == :undefined ->
        :riakc_obj.key([result][:ok])
      true ->
        key
    end
  end


  def patch(bucket, key, patch_data) do
    new_data = get(bucket, key) |> Dict.merge(patch_data)
    {:ok, json} = JSEX.encode(new_data)
    :ok = :riakc_obj.new(bucket, key, json, "application/json")
    |> RiakPool.put
    key
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


end
