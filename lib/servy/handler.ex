defmodule Servy.Handler do

  @moduledoc "Handles HTTP requests."

  alias Servy.Conv

  import Servy.Config.Routes, only: [route: 1]
  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.Parser,  only: [parse: 1]


  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> emojify
    |> put_response_length
    |> format_response
  end

  def emojify(%Conv{status: 200, response_headers: %{"Content-Type" => "text/html"}} = conv) do
    emojies = String.duplicate("🎉", 5)
    response_body = emojies <> "\n" <> conv.response_body <> "\n" <> emojies
    %{conv | response_body: response_body}
  end

  def emojify(%Conv{} = conv), do: conv

  def put_response_length(%Conv{} = conv) do
    response_headers = Map.put(conv.response_headers, "Content-Length", conv.response_body |> byte_size)
    %{conv | response_headers: response_headers}
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    #{format_response_headers(conv)}
    \r
    #{conv.response_body}
    """
  end

  defp format_response_headers(conv) do
    for {k, v} <- conv.response_headers do
      "#{k}: #{v}\r"
    end |> Enum.sort |> Enum.reverse |> Enum.join("\n")
  end

end
