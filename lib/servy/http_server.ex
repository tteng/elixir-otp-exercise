# server() ->
#   {ok, LSock} = gen_tcp:listen(5678, [binary, {packet, 0},
#                                       {active, false}]),
#   {ok, Sock} = gen_tcp:accept(LSock),
#   {ok, Bin} = do_recv(Sock, []),
#   ok = gen_tcp:close(Sock),
#   ok = gen_tcp:close(LSock),
#   Bin.

# do_recv(Sock, Bs) ->
#   case gen_tcp:recv(Sock, 0) of
#       {ok, B} ->
#           do_recv(Sock, [Bs, B]);
#       {error, closed} ->
#           {ok, list_to_binary(Bs)}
#   end.


defmodule Servy.HttpServer do

  # def server() do
  #   {:ok, lsock} = :gen_tcp.listen(5678, [:binary, packet: 0, active: false])
  #   {:ok, sock} = :gen_tcp.accept(lsock)
  #   {:ok, bin} = :gen_tcp.recv(sock, 0)
  #   :ok = :gen_tcp.close(sock)
  #   :ok = :gen_tcp.close(lsock)
  #   bin
  # end

  def start(port) when is_integer(port) and port > 1023 do
    {:ok, listen_socket} = :gen_tcp.listen(port, [:binary, packet: 0, active: false, reuseaddr: true])
    IO.puts("listening for connection request on #{port}...\n")
    accept_loop(listen_socket)
  end

  def accept_loop(socket) do
    IO.puts("⏳ Waiting to accept a client connection...\n")
    {:ok, client_socket} = :gen_tcp.accept(socket)
    IO.puts("⚡️ Connection accepted!\n")
    # concurrent style
    pid = spawn(fn -> serve_client(client_socket) end)
    # if pid died unexpectly, this ensures vm will auto close the client_socket
    :ok = :gen_tcp.controlling_process(client_socket, pid)
    # sequential style
    # serve_client(client_socket)
    accept_loop(socket)
  end

  def serve_client(client_socket) do
    client_socket
      |> read_request
      |> Servy.Handler.handle
      |> write_response(client_socket)
  end

  def read_request(client_socket) do
    {:ok, request} = :gen_tcp.recv(client_socket, 0)
    IO.puts("➡️ Received request:\n")
    IO.puts request
    request
  end

  def generate_response(_request) do
    """
    HTTP/1.1 200 OK\r
    Content-Type: text/plain\r
    Content-Length: 6\r
    \r
    Hello!
    """
  end

  def write_response(response, client_socket) do
    :ok = :gen_tcp.send(client_socket, response)
    IO.puts("⬅ Sent response: \n")
    IO.puts(response)
    :gen_tcp.close(client_socket)
  end

end
