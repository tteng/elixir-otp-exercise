defmodule Servy.Services.GenServers.FourOhFourCounterServer do

  @server_name __MODULE__

  use GenServer

  ###server
  def start do
    GenServer.start(__MODULE__, %{}, name: @server_name)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call({:get_count, path}, _from, state) do
    value = Map.get(state, path)
    {:reply, value, state}
  end

  def handle_call(:get_counts, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:bump_count, path}, _from, state) do
    new_state = Map.update(state, path, 1, fn count -> count + 1 end)
    {:reply, :ok, new_state}
  end

  def handle_cast(:reset, _state) do
    {:noreply, %{}}
  end

  def handle_cast(unexpected, state) do
    IO.puts "Unexpected message: #{inspect unexpected}"
    {:noreply, state}
  end

  ###client
  def bump_count(path) do
    GenServer.call(@server_name, {:bump_count, path})
  end

  def get_count(path) do
    GenServer.call(@server_name, {:get_count, path})
  end

  def get_counts do
    GenServer.call(@server_name, :get_counts)
  end

  def reset do
    GenServer.cast(@server_name, :reset)
  end

end
