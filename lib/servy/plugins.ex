import Logger

defmodule Servy.Plugins do
  @moduledoc "Servy Plugin functions"

  alias Servy.Conv
  alias Servy.Services.FourOhFourCounterServer

  def rewrite_path(%Conv{path: "/wild_life"} = conv) do
    %{conv | path: "/wild_things"}
  end

  def rewrite_path(%Conv{path: "/bears?id=" <> id} = conv) do
    %{conv | path: "/bears/" <> id}
  end

  def rewrite_path(%Conv{} = conv), do: conv

  def log(%Conv{} = conv) do
    if Mix.env() == :dev do
      conv |> IO.inspect
    end
    conv
  end

  @doc "Log 404 requests"
  def track(%Conv{status: 404, path: path} = conv) do
    if Mix.env() != :test do
      warn("Warning: #{path} is on loose!")
      FourOhFourCounterServer.bump_count(path)
    end
    conv
  end

  def track(%Conv{} = conv), do: conv

end
