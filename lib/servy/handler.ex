defmodule Servy.Handler do

  @moduledoc "Handles HTTP requests."

  alias Servy.Conv

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
    |> format_response
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    result = @pages_path |> Path.join("about.html") |> File.read
    handle_file(result, conv)
  end

  def route(%Conv{method: "GET", path: "/static/" <> page} = conv) do
    result = @pages_path |> Path.join("#{page}.html") |> File.read
    handle_file(result, conv)
  end

  def route(%Conv{method: "GET", path: "/wild_things"} = conv) do
    %{conv | response_body: "Tigers, Bears and Lions!", status: 200}
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    %{conv | response_body: "Teddy, Smokey and Paddington!", status: 200}
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    %{conv | response_body: "Hello, this is bear #{id}!", status: 200}
  end

  def route(%Conv{method: "DELETE", path: "/bears/" <> id} = conv) do
    %{conv | response_body: "Bear##{id} Must Not Be Deleted!", status: 403}
  end

  def route(%Conv{path: path} = conv) do
    %{conv | response_body: "No #{path} found!", status: 404}
  end

  def emojify(%Conv{status: 200} = conv) do
    emojies = String.duplicate("🎉", 5)
    response_body = emojies <> "\n" <> conv.response_body <> "\n" <> emojies
    %{conv | response_body: response_body}
  end

  def emojify(%Conv{} = conv), do: conv

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: text/html
    Content-Length: #{conv.response_body |> byte_size}

    #{conv.response_body}
    """
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