defmodule Servy.Handler do

  def hande(request) do
    request
    |> parse
    |> route
    |> format_response
  end

  def parse(request) do

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