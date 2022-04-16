require Logger

defmodule Servy.Handler do

  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
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

#  def route(conv) do
#    route(conv, conv.method, conv.path)
#  end

  def route(%{method: "GET", path: "/wild_things"} = conv) do
    %{conv | response_body: "Tigers, Bears and Lions!", status: 200}
  end

  def route(%{method: "GET", path: "/bears"} = conv) do
    %{conv | response_body: "Teddy, Smokey and Paddington!", status: 200}
  end

  def route(%{method: "GET", path: "/bears/" <> id} = conv) do
    %{conv | response_body: "Hello, this is bear #{id}!", status: 200}
  end

  def route(%{path: path} = conv) do
    %{conv | response_body: "No #{path} found!", status: 404}
  end

  def track(%{status: 404, path: path}=conv) do
    Logger.warn("Warning: #{path} is on loose!")
    conv
  end

  def track(conv), do: conv

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

request = """
GET /bears?id=99 HTTP/1.1
HOST: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""


request |> Servy.Handler.handle |> IO.puts