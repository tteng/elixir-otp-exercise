defmodule Servy.Handler do

  def hande(request) do
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

  end

  def format_response(conv) do

  end

end

request = """
GET /wildthings HTTP/1.1
HOST: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

expected_response = """
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 20

Bears, Lions, Tigers
"""