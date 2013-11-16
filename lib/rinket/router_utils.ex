defmodule RouterUtils do

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