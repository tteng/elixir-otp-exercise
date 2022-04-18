require Logger

defmodule Servy.Handler do

  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> emojify
    |> format_response
  end

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split
    %{method: method, path: path, status: nil, response_body: ""}
  end

  def rewrite_path(%{path: "/wild_life"} = conv) do
    %{conv | path: "/wild_things"}
  end

  def rewrite_path(%{path: "/bears?id=" <> id} = conv) do
    %{conv | path: "/bears/" <> id}
  end

  def rewrite_path(conv), do: conv

  def log(conv), do: conv |> IO.inspect

  def route(%{method: "GET", path: "/about"} = conv) do
    result = Path.expand("../../pages", __DIR__) |> Path.join("about.html") |> File.read
    handle_file(result, conv)
  end

  def route(%{method: "GET", path: "/static/" <> page} = conv) do
    result = Path.expand("../../pages", __DIR__) |> Path.join("#{page}.html") |> File.read
    handle_file(result, conv)
  end

  def handle_file({:ok, content}, conv) do
    %{conv | response_body: content, status: 200}
  end

  def handle_file({:error, :enoent}, conv) do
    %{conv | response_body: "File not exist!", status: 404}
  end

  def handle_file({:error, reason}, conv) do
    %{conv | response_body: "File error, reason: #{reason}", status: 500}
  end

  def route(%{method: "GET", path: "/wild_things"} = conv) do
    %{conv | response_body: "Tigers, Bears and Lions!", status: 200}
  end

  def route(%{method: "GET", path: "/bears"} = conv) do
    %{conv | response_body: "Teddy, Smokey and Paddington!", status: 200}
  end

  def route(%{method: "GET", path: "/bears/" <> id} = conv) do
    %{conv | response_body: "Hello, this is bear #{id}!", status: 200}
  end

  def route(%{method: "DELETE", path: "/bears/" <> id} = conv) do
    %{conv | response_body: "Bear##{id} Must Not Be Deleted!", status: 403}
  end

  def route(%{path: path} = conv) do
    %{conv | response_body: "No #{path} found!", status: 404}
  end

  def track(%{status: 404, path: path} = conv) do
    Logger.warn("Warning: #{path} is on loose!")
    conv
  end

  def track(conv), do: conv

  def emojify(%{status: 200} = conv) do
    emojies = String.duplicate("🎉", 5)
    response_body = emojies <> "\n" <> conv.response_body <> "\n" <> emojies
    %{conv | response_body: response_body}
  end

  def emojify(conv), do: conv

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Length: #{conv.response_body |> byte_size}

    #{conv.response_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end

end

#request = """
#GET /wild_things HTTP/1.1
#HOST: example.com
#User-Agent: ExampleBrowser/1.0
#Accept: */*
#
#"""

#request = """
#GET /dagou HTTP/1.1
#HOST: example.com
#User-Agent: ExampleBrowser/1.0
#Accept: */*
#
#"""

#request = """
#GET /bears/100 HTTP/1.1
#HOST: example.com
#User-Agent: ExampleBrowser/1.0
#Accept: */*
#
#"""
#

#request = """
#GET /wild_life HTTP/1.1
#HOST: example.com
#User-Agent: ExampleBrowser/1.0
#Accept: */*
#
#"""

#request = """
#GET /bears?id=99 HTTP/1.1
#HOST: example.com
#User-Agent: ExampleBrowser/1.0
#Accept: */*
#
#"""

#request = """
#GET /about HTTP/1.1
#HOST: example.com
#User-Agent: ExampleBrowser/1.0
#Accept: */*
#
#"""

request = """
GET /static/tim HTTP/1.1
HOST: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""


request |> Servy.Handler.handle |> IO.puts