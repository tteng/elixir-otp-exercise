defmodule Servy.Handler do

  def handle(request) do
    request
    |> parse
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

  def route(conv) do
    %{conv | response_body: "Tigers, Bears and Lions!"}
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

request = """
GET /wildthings HTTP/1.1
HOST: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

request |> Servy.Handler.handle |> IO.puts