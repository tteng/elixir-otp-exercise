defmodule Servy.Handler do

  def handle(request) do
    request
    |> parse
    |> log
    |> route
    |> format_response
  end

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split
    %{method: method, path: path, response_body: ""}
  end

  def log(conv), do: conv |> IO.inspect

  def route(conv) do
    route(conv, conv.method, conv.path)
  end

  def route(conv, "GET", "/wild_things") do
    %{conv | response_body: "Tigers, Bears and Lions!"}
  end

  def route(conv, "GET", "/bears") do
    %{conv | response_body: "Teddy, Smokey and Paddington!"}
  end

  def format_response(conv) do
    """
    HTTP/1.1 200 OK
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
#
#request |> Servy.Handler.handle |> IO.puts