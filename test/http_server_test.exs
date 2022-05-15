defmodule HttpServerTest do
  use ExUnit.Case

  alias Servy.HttpServer
  alias Servy.HttpClient

  test "accepts a request on a socket and sends back a response" do
    spawn(HttpServer, :start, [4000])

    request = """
    GET /wild_things HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = HttpClient.send_request('localhost', 4000, request)

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

  test "test via httpoison" do
    spawn(HttpServer, :start, [4000])

    {:ok, response} = HTTPoison.get "http://localhost:4000/wild_things"

    assert response.status_code == 200
    assert response.body == "🎉🎉🎉🎉🎉\nTigers, Bears and Lions!\n🎉🎉🎉🎉🎉"
  end

  @max_concurrent_requests 5

  test "test concurrent requests via httpoison" do
    spawn(HttpServer, :start, [4000])

    parent = self()

    for _ <- 1..@max_concurrent_requests do
      {:ok, response} = HTTPoison.get "http://localhost:4000/wild_things"
      send(parent, {:ok, response})
    end

    for _ <- 1..@max_concurrent_requests do
      receive do
        {:ok, response} ->
          assert response.status_code == 200
          assert response.body == "🎉🎉🎉🎉🎉\nTigers, Bears and Lions!\n🎉🎉🎉🎉🎉"
      end
    end
  end

end
