defmodule Adrestia.Cache do

  @cache __MODULE__

  def get(request) do
    Cachex.get(@cache, key(request)) |> elem(1)      
  end

  def set(request) do    
    key = key(request)
    {:ok, exists} = Cachex.exists?(@cache, key)
    if not exists, do: Cachex.set(@cache, key, request.response)
  end

  defp key(request) do
    request.path <> request.query_string
  end

  def enabled? do
    case Application.fetch_env(Adrestia.app(), :cache_ttl) do
      {:ok, _} -> true
      _ -> false
    end
  end
end
