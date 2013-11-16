defmodule Rinket.Db do

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

end
