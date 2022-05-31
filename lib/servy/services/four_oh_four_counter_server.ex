defmodule Servy.Services.FourOhFourCounterServer do

  @server_name __MODULE__

  ###server
  def start do
    pid = spawn(__MODULE__, :loop, [%{}])
    Process.register(pid, @server_name)
    pid
  end

  def loop(state) do
    receive do
      {sender, :increase, path} ->
        new_state = Map.update(state, path, 1, fn count -> count + 1 end)
        send(sender, {:response, :ok})
        loop(new_state)
      {sender, :get_count, path} ->
        value = Map.get(state, path)
        send(sender, {:response, value})
        loop(state)
      {sender, :get_counts} ->
        send(sender, {:response, state})
        loop(state)
      others ->
        IO.puts "Unexpected message: #{inspect others}"
        loop(state)
    end
  end

  ###client
  def bump_count(path) do
    send(@server_name, {self(), :increase, path})
    receive do
      {:response, result} -> result
    end
  end

  def get_count(path) do
    send(@server_name, {self(), :get_count, path})
    receive do
      {:response, value} -> value
    end
  end

  def get_counts do
    send(@server_name, {self(), :get_counts})
    receive do
      {:response, value} -> value
    end
  end

end
