defmodule HttpServerTest do
  use ExUnit.Case

  alias Servy.HttpServer
  alias Servy.HttpClient

  test "accepts a request on a socket and sends back a response" do
    spawn(HttpServer, :start, [4004])

    request = """
    GET /wild_things HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = HttpClient.send_request('localhost', 4004, request)

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
    spawn(HttpServer, :start, [4005])

    {:ok, response} = HTTPoison.get "http://localhost:4005/wild_things"

    assert response.status_code == 200
    assert response.body == "🎉🎉🎉🎉🎉\nTigers, Bears and Lions!\n🎉🎉🎉🎉🎉"
  end

  @max_concurrent_requests 5
  @url "http://localhost:4006/wild_things"

  test "test concurrent requests via httpoison" do
    spawn(HttpServer, :start, [4006])

    1..@max_concurrent_requests
    |> Enum.map(fn(_) -> Task.async(fn -> HTTPoison.get(@url) end) end)
    |> Enum.map(&Task.await/1)
    |> Enum.map(&assert_response_ok/1)
  end

  defp assert_response_ok({:ok, response}) do
    assert response.status_code == 200
    assert response.body == "🎉🎉🎉🎉🎉\nTigers, Bears and Lions!\n🎉🎉🎉🎉🎉"
  end

end
