import Logger

defmodule Servy.Plugins do
  @moduledoc "Servy Plugin functions"

  def rewrite_path(%{path: "/wild_life"} = conv) do
    %{conv | path: "/wild_things"}
  end

  def rewrite_path(%{path: "/bears?id=" <> id} = conv) do
    %{conv | path: "/bears/" <> id}
  end

  def rewrite_path(conv), do: conv

  def log(conv), do: conv |> IO.inspect

  @doc "Log 404 requests"
  def track(%{status: 404, path: path} = conv) do
    warn("Warning: #{path} is on loose!")
    conv
  end

  def track(conv), do: conv

end
