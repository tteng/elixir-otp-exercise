defmodule Servy.HttpClient do
  # client() ->
  #   SomeHostInNet = "localhost", % to make it runnable on one machine
  #   {ok, Sock} = gen_tcp:connect(SomeHostInNet, 5678,
  #                                [binary, {packet, 0}]),
  #   ok = gen_tcp:send(Sock, "Some Data"),
  #   ok = gen_tcp:close(Sock).

  def send_request(host, port, request \\ the_request) do
    {:ok, socket} = :gen_tcp.connect(host, port, [:binary, packet: :raw, active: false])
    :ok = :gen_tcp.send(socket, request)
    {:ok, response} = :gen_tcp.recv(socket, 0)
    :ok = :gen_tcp.close(socket)
    IO.puts("Client received response: \n")
    IO.puts(response)
    response
  end

  def the_request do
    """
    GET /api/bears HTTP/1.1\r
    HOST: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """
  end

end
