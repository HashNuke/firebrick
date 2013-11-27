defmodule Firebrick.RiakRealm do
  defmacro __using__([]) do
    quote do

      import Firebrick.RiakRealm


      def assign_attributes(record, params) do
        Enum.reduce(params, record, fn({param, value}, updated_record)->
          apply(updated_record, :"#{param}", [value])
        end)
      end


      def public_attributes(record) do
        lc attr inlist safe_attributes do
          { "#{attr}", apply(record, :"#{attr}", []) }
        end
      end


      def find(obj_id) do
        {:ok, data} = get(bucket, obj_id)
        assign_attributes(__MODULE__[id: obj_id], data)
      end


      def saveable_attributes(record) do
        clean_attrs = Enum.reduce skip_attributes, record.attributes, fn(attr, attrs)->
          ListDict.delete(attrs, attr)
        end
        Enum.filter(clean_attrs, fn({attr, value})-> value != nil end)
      end


      def before_save(record), do: record


      def save(record) do
        record = record.before_save |> validate

        if length(record.errors) == 0 do
          id = record.id || :undefined
          bucket = tuple_to_list(record) |> hd |> apply(:bucket, [])

          case record.id do
            nil ->
              put(bucket, :undefined, record.saveable_attributes)
            _ ->
              patch(bucket, id, record.saveable_attributes)
          end
        else
          {:error, record}
        end
      end


      def force_save(record) do
        record = record.before_save |> validate

        if length(record.errors) == 0 do
          id = record.id || :undefined
          bucket = tuple_to_list(record) |> hd |> apply(:bucket, [])
          put(bucket, id, record.saveable_attributes)
        else
          {:error, record}
        end
      end


      def search(query, options // []) do
        RiakPool.run(fn(pid)->
          {:ok,
            {:search_results, search_results, _, count}
          } = :riakc_pb_socket.search(pid, bucket, query, options)

          mapred_input = :lists.map(fn({_, obj})->
            {bucket, obj["id"]}
          end, search_results)

          mapreduce_result = :riakc_pb_socket.mapred(pid, mapred_input,
            [{:map, {:modfun, :firebrick_mapred, :map_result}, :none, false},
             {:reduce, {:modfun, :firebrick_mapred, :reduce_result}, :none, true}]
          )

          case mapreduce_result do
            {:ok, [{1, objs}]} ->
              models = lc {key, json} inlist objs do
                {:ok, data} = JSEX.decode(json)
                assign_attributes(__MODULE__[], data).id(key)
              end
              {models, count}

            {:ok, []} -> {[], 0}
          end

        end)
      end


      def destroy(arg1) do
        cond do
          is_binary(arg1) ->
            RiakPool.delete(bucket, arg1)
          is_record(arg1) && arg1.id != nil ->
            RiakPool.delete(bucket, arg1.id)
          true ->
            :ok
        end
      end


    def list_keys do
      RiakPool.run fn (pid)->
        :riakc_pb_socket.list_keys pid, bucket
      end
    end

      defoverridable [assign_attributes: 2, before_save: 1, public_attributes: 1]
    end
  end


  def put(bucket, key, data) do
    {:ok, json} = JSEX.encode data
    result = :riakc_obj.new(bucket, key, json, "application/json") |> RiakPool.put
    cond do
      key == :undefined ->
        {:ok, :riakc_obj.key([result][:ok])}
      true ->
        {:ok, key}
    end
  end


  def get(bucket, key) do
    {:ok, obj} = RiakPool.get(bucket, key)
    {:ok, data} = :riakc_obj.get_values(obj)
    |> hd
    |> JSEX.decode
    {:ok, data}
  end


  def patch(bucket, key, patch_data) do
    {:ok, old_data} = get(bucket, key)
    new_data = Dict.merge(old_data, patch_data)
    {:ok, json} = JSEX.encode(new_data)
    :ok = :riakc_obj.new(bucket, key, json, "application/json")
    |> RiakPool.put
    {:ok, key}
  end
end
