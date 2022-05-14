defmodule Servy.Handler do

  @moduledoc "Handles HTTP requests."

  alias Servy.Conv
  alias Servy.Controllers.Html.BearsController, as: HtmlBearsController
  alias Servy.Controllers.Api.BearsController,  as: ApiBearsController

  @pages_path Path.expand("../../pages", __DIR__)

  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.Parser,  only: [parse: 1]
  import Servy.FileHandler, only: [handle_file: 2]

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

  def route(%Conv{method: "GET", path: "/kaboom"}) do
    raise "Kaboom!"
  end

  def route(%Conv{method: "GET", path: "/hibernate/" <> time} = conv) do
    time |> String.to_integer |> :timer.sleep
    %{conv | status: 200, response_body: "Awake!"}
  end

  def route(%Conv{method: "POST", path: "/api/bears"} = conv) do
    ApiBearsController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    result = @pages_path |> Path.join("about.html") |> File.read
    handle_file(result, conv)
  end

  def route(%Conv{method: "GET", path: "/faq"} = conv) do
    result = @pages_path |> Path.join("faq.md") |> File.read
    handle_file(result, conv) |> markdown_to_html
  end

  def route(%Conv{method: "GET", path: "/static/" <> page} = conv) do
    result = @pages_path |> Path.join("#{page}.html") |> File.read
    handle_file(result, conv)
  end

  def route(%Conv{method: "GET", path: "/wild_things"} = conv) do
    %{conv | response_body: "Tigers, Bears and Lions!", status: 200}
  end

  def route(%Conv{method: "GET", path: "/api/bears"} = conv) do
    ApiBearsController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    HtmlBearsController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    HtmlBearsController.show(conv, params)
  end

  def route(%Conv{method: "DELETE", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    HtmlBearsController.destroy(conv, params)
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    HtmlBearsController.create(conv, conv.params)
  end

  def route(%Conv{path: path} = conv) do
    %{conv | response_body: "No #{path} found!", status: 404}
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

  defp markdown_to_html(%Conv{status: 200} = conv) do
    Map.put(conv, "response_body", conv.response_body |> Earmark.as_html!)
  end

  defp markdown_to_html(%Conv{} = conv), do: conv

end

#request = """
#GET /bears HTTP/1.1
#HOST: example.com
#User-Agent: ExampleBrowser/1.0
#Accept: */*
#
#"""

#request |> Servy.Handler.handle |> IO.puts
