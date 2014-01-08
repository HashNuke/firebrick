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
      def intercept_obj(record, obj), do: obj


      def save(record) do
        record = record.before_save |> validate

        if length(record.errors) == 0 do
          id = record.id || :undefined
          bucket = tuple_to_list(record) |> hd |> apply(:bucket, [])

          case record.id do
            nil ->
              {:ok, json} = JSEX.encode record.saveable_attributes
              obj = :riakc_obj.new(bucket, :undefined, json, "application/json")
              obj = __MODULE__.intercept_obj(record, obj)
              {:ok, result} = RiakPool.put(obj)
              {:ok, :riakc_obj.key(result)}
            _ ->
              {:ok, old_data} = get(bucket, record.id)
              new_data = Dict.merge(old_data, record.saveable_attributes)
              {:ok, json} = JSEX.encode(new_data)
              obj = :riakc_obj.new(bucket, record.id, json, "application/json")
              obj = __MODULE__.intercept_obj(record, obj)
              :ok = RiakPool.put(obj)
              {:ok, record.id}
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


      def query(solr_query, options // []) do
        options = ListDict.merge options, [q: solr_query, wt: 'json']
        encoded_params = lc {option_name, option_value} inlist options do
          "#{option_name}=#{:ibrowse_lib.url_encode('#{option_value}')}"
        end

        url = 'http://localhost:8098/search/#{index_name}?#{Enum.join(encoded_params, "&")}'
        {:ok, _, _, content} = :ibrowse.send_req(url, [], :get)
        {:ok, data} = JSEX.decode "#{content}"
        case data["error"] do
          nil ->
            resp = data["response"]
            case resp["docs"] do
              [] -> {[], resp["numFound"], resp["start"]}
              _ ->
                keys = lc doc inlist resp["docs"], do: doc["_yz_rk"]
                models = lc key inlist keys, do: __MODULE__.find(key)
                {models, resp["numFound"], resp["start"]}
            end
          _ ->
            {:error, data["error"]}
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


      defoverridable [
        assign_attributes: 2,
        before_save: 1,
        public_attributes: 1,
        intercept_obj: 2
      ]
    end
  end


  defmacro bucket_info(bucket_name // "firebrick") do
    full_bucket_type = "#{bucket_name}_#{Mix.env}_type"
    full_index_name  = "#{bucket_name}_#{Mix.env}_index"
    full_bucket_name = "#{bucket_name}_#{Mix.env}"
    quote do
      def bucket, do: { unquote(full_bucket_type), unquote(full_bucket_name) }
      def index_name, do: unquote(full_index_name)
    end
  end


  def get(bucket, key) do
    {:ok, obj} = RiakPool.get(bucket, key)
    {:ok, data} = :riakc_obj.get_values(obj)
    |> hd
    |> JSEX.decode
    {:ok, data}
  end


  def timestamp(now // {:erlang.date(), :erlang.time()}) do
    "#{:qdate.to_string("Y-m-d", now)}T#{:qdate.to_string("H:i:s", now)}Z"
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


  def patch(bucket, key, patch_data) do
    {:ok, old_data} = get(bucket, key)
    new_data = Dict.merge(old_data, patch_data)
    {:ok, json} = JSEX.encode(new_data)
    :ok = :riakc_obj.new(bucket, key, json, "application/json")
    |> RiakPool.put
    {:ok, key}
  end


  def list_keys(bucket) do
    RiakPool.run fn (pid)->
      :riakc_pb_socket.list_keys pid, bucket
    end
  end

end
