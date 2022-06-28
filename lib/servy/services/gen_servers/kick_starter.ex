defmodule Servy.Services.GenServers.KickStarter do

  use GenServer

  @server_name __MODULE__

  def start_link(_args) do
    IO.puts "Starting the kick starter..."
    GenServer.start_link(__MODULE__, :ok, name: @server_name)
  end

  #callbacks
  def init(:ok) do
    Process.flag(:trap_exit, true)
    server_pid = start_http_server()
    {:ok, server_pid}
  end

  def handle_info({:EXIT, _from, reason}, _state) do
    IO.puts "http server exit with reason: #{inspect reason}, going to restart it..."
    server_pid = start_http_server()
    {:noreply, server_pid}
  end

  def handle_call(:get_http_server_pid, _from, state) do
    {:reply, state, state}
  end

  defp start_http_server do
    IO.puts "Starting the http server..."
    port = Application.get_env(:servy, :port, 4000)
    server_pid = spawn_link(Servy.HttpServer, :start, [port])
    Process.register(server_pid, :http_server)
    server_pid
  end

  #client interface
  def get_http_server_pid do
    GenServer.call(@server_name, :get_http_server_pid)
  end

end
