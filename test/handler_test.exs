defmodule HandlerTest do

  use ExUnit.Case, async: true
  import Servy.Handler, only: [handle: 1]

  test "get /wild_things" do
    request = """
    GET /wild_things HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 66\r
    \r
    🎉🎉🎉🎉🎉
    Tigers, Bears and Lions!
    🎉🎉🎉🎉🎉
    """
  end

  test "get /dagou" do
    request = """
    GET /dagou HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 404 Not Found\r
    Content-Type: text/html\r
    Content-Length: 16\r
    \r
    No /dagou found!
    """
  end

  test "get /bears/10" do
    request = """
    GET /bears/10 HTTP/1.1\r
    HOST: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 116\r
    \r
    🎉🎉🎉🎉🎉
    <h1>Show Bear</h1>
    <p>
    Is Kenai hibernating? <strong> false </strong>
    </p>
    🎉🎉🎉🎉🎉
    """
  end

  test "get /wild_life" do
    request = """
    GET /wild_life HTTP/1.1\r
    HOST: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 66\r
    \r
    🎉🎉🎉🎉🎉
    Tigers, Bears and Lions!
    🎉🎉🎉🎉🎉
    """
  end

  test "get /bears?id=9" do
    request = """
    GET /bears?id=9 HTTP/1.1\r
    HOST: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 116\r
    \r
    🎉🎉🎉🎉🎉
    <h1>Show Bear</h1>
    <p>
    Is Iceman hibernating? <strong> true </strong>
    </p>
    🎉🎉🎉🎉🎉
    """
  end

  test "get /about" do
    request = """
    GET /about HTTP/1.1\r
    HOST: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 206\r
    \r
    🎉🎉🎉🎉🎉
    <!DOCTYPE html>
    <html lang=\"en\">
    <head>
        <meta charset=\"UTF-8\">
        <title>Hello Servy</title>
    </head>
    <body>
        <p>
          Elixir wins!
        </p>
    </body>
    </html>
    🎉🎉🎉🎉🎉
    """
  end

  test "get /static/tim" do
    request = """
    GET /static/tim HTTP/1.1\r
    HOST: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 187\r
    \r
    🎉🎉🎉🎉🎉
    <!DOCTYPE html>
    <html lang=\"en\">
    <head>
        <meta charset=\"UTF-8\">
        <title>Hello</title>
    </head>
    <body>
    <p>
        I am tim!
    </p>
    </body>
    </html>
    🎉🎉🎉🎉🎉
    """
  end

  test "post /bears" do
    request = """
    POST /bears HTTP/1.1\r
    HOST: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/x-www-urlencoded\r
    Content-Length: 187\r
    \r
    name=holiday&kind=brown\r
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 201 Created\r
    Content-Type: text/html\r
    Content-Length: 36\r
    \r
    Bear#holiday created with kind brown
    """
  end

  test "delete /bears/1" do
    request = """
    DELETE /bears/1 HTTP/1.1\r
    HOST: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 403 Forbidden\r
    Content-Type: text/html\r
    Content-Length: 27\r
    \r
    Bear#1 Must Not Be Deleted!
    """
  end

  test "get /api/bears" do
    request = """
    GET /api/bears HTTP/1.1\r
    HOST: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: application/json\r
    Content-Length: 605\r
    \r
    [
      {\"name\":\"Brutus\",\"kind\":\"Grizzly\",\"id\":6,\"hibernating\":false},
      {\"name\":\"Iceman\",\"kind\":\"Polar\",\"id\":9,\"hibernating\":true},
      {\"name\":\"Kenai\",\"kind\":\"Grizzly\",\"id\":10,\"hibernating\":false},
      {\"name\":\"Paddington\",\"kind\":\"Brown\",\"id\":3,\"hibernating\":false},
      {\"name\":\"Roscoe\",\"kind\":\"Panda\",\"id\":8,\"hibernating\":false},
      {\"name\":\"Rosie\",\"kind\":\"Black\",\"id\":7,\"hibernating\":true},
      {\"name\":\"Scarface\",\"kind\":\"Grizzly\",\"id\":4,\"hibernating\":true},
      {\"name\":\"Smokey\",\"kind\":\"Black\",\"id\":2,\"hibernating\":false},
      {\"name\":\"Snow\",\"kind\":\"Polar\",\"id\":5,\"hibernating\":false},
      {\"name\":\"Teddy\",\"kind\":\"Brown\",\"id\":1,\"hibernating\":true}
    ]
    """
    assert remove_white_space(expected_response) == remove_white_space(response)
  end

  test "get /bears" do
    request = """
    GET /bears HTTP/1.1\r
    HOST: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 356\r
    \r
    🎉🎉🎉🎉🎉
    <h1>AlltheBears!</h1>
    <ul>
      <li>Brutus-Grizzly</li>
      <li>Iceman-Polar</li>
      <li>Kenai-Grizzly</li>
      <li>Paddington-Brown</li>
      <li>Roscoe-Panda</li>
      <li>Rosie-Black</li>
      <li>Scarface-Grizzly</li>
      <li>Smokey-Black</li>
      <li>Snow-Polar</li>
      <li>Teddy-Brown</li>
    </ul>
    🎉🎉🎉🎉🎉
    """
    assert remove_white_space(expected_response) == remove_white_space(response)
  end

  test "POST /api/bears" do
    request = """
    POST /api/bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/json\r
    Content-Length: 21\r
    \r
    {"name": "Breezly", "type": "Polar"}
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 201 Created\r
    Content-Type: text/html\r
    Content-Length: 36\r
    \r
    Bear#Breezly created with type Polar
    """
  end

  test "get /faq" do
    request = """
    GET /faq HTTP/1.1\r
    HOST: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 428\r\r
    🎉🎉🎉🎉🎉
    # Frequently Asked Questions

    - **Have you really seen Bigfoot?**

    Yes! In this [totally believable video](https://www.youtube.com/watch?v=v77ijOO8oAk)!

    - **No, I mean seen Bigfoot *on the refuge*?**

    Oh! Not yet, but we're *still looking*...

    - **Can you just show me some code?**

    Sure! Here's some Elixir:

    ```elixir
      [\"Bigfoot\", \"Yeti\", \"Sasquatch\"] |> Enum.random()
    ```
    🎉🎉🎉🎉🎉
    """
    assert remove_white_space(expected_response) == remove_white_space(response)
  end

  defp remove_white_space(text) do
    String.replace(text, ~r{\s}, "")
  end

end
