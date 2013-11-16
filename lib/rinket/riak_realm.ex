defmodule Rinket.RiakRealm do
  defmacro __using__([]) do
    quote do

      def assign_attributes(record, params) do
        Enum.reduce(params, record, fn({param, value}, updated_record)->
          apply(updated_record, :"#{param}", [value])
        end)
      end
      defoverridable [assign_attributes: 2]


      def public_attributes(record) do
        lc attr inlist safe_attributes do
          { "#{attr}", apply(record, :"#{attr}", []) }
        end
      end


      def find(obj_id) do
        data = Rinket.Db.get(bucket, obj_id)
        assign_attributes(__MODULE__[id: obj_id], data)
      end


      def saveable_attributes(record) do
        clean_attrs = Enum.reduce skip_attributes, record.attributes, fn(attr, attrs)->
          ListDict.delete(attrs, attr)
        end
        Enum.filter(clean_attrs, fn({attr, value})-> value != nil end)
      end


      def save(record) do
        record = record.validate
        if length(record.errors) == 0 do
          id = record.id || :undefined
          bucket = tuple_to_list(record) |> hd |> apply(:bucket, [])

          case record.id do
            nil ->
              {:ok, Rinket.Db.put(bucket, :undefined, record.saveable_attributes) }
            _ ->
              {:ok, Rinket.Db.patch(bucket, id, record.saveable_attributes) }
          end
        else
          {:error, record}
        end
      end


      def search(query, options // []) do
        {:ok, {:search_results, search_results, _, _count}} = RiakPool.run(fn(worker)->
          :riakc_pb_socket.search(worker, bucket, query, options)
        end)

        # Cleans up, by removing the bucket names from the results
        results = :lists.map(fn(item)->
          {_, obj} = item
          obj
        end, search_results)

        lc result inlist results do
          assign_attributes(__MODULE__[], result)
        end
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

    end
  end
end
