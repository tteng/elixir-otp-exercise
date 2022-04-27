import Logger

defmodule Servy.Plugins do
  @moduledoc "Servy Plugin functions"

  alias Servy.Conv

  def rewrite_path(%Conv{path: "/wild_life"} = conv) do
    %{conv | path: "/wild_things"}
  end

  def rewrite_path(%Conv{path: "/bears?id=" <> id} = conv) do
    %{conv | path: "/bears/" <> id}
  end

  def rewrite_path(%Conv{} = conv), do: conv

  def log(%Conv{} = conv), do: conv |> IO.inspect

  @doc "Log 404 requests"
  def track(%Conv{status: 404, path: path} = conv) do
    warn("Warning: #{path} is on loose!")
    conv
  end

  def track(%Conv{} = conv), do: conv

end
