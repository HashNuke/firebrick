defmodule Firebrick.RouterUtils do

  def json_response(data, conn, status // 200) do
    {:ok, json} = JSEX.encode(data)
    conn.resp status, json
  end


  def whitelist_params(params, allowed) do
    whitelist_params(params, allowed, [])
  end


  def whitelist_params(params, [], collected) do
    collected
  end


  def whitelist_params(params, allowed, collected) do
    [field | rest] = allowed
    if Dict.has_key?(params, field) do
      collected = ListDict.merge collected, [{ field, Dict.get(params, field) }]
    end
    whitelist_params(params, rest, collected)
  end

end