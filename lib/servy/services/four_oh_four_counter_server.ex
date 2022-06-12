defmodule Servy.Services.FourOhFourCounterServer do

  @server_name __MODULE__

  alias Servy.Services.GenericServer

  ###server
  def start do
    GenericServer.start(__MODULE__, %{}, @server_name)
  end

  def handle_call({:get_count, path}, state) do
    value = Map.get(state, path)
    {value, state}
  end

  def handle_call(:get_counts, state) do
    {state, state}
  end

  def handle_call({:bump_count, path}, state) do
    new_state = Map.update(state, path, 1, fn count -> count + 1 end)
    {:ok, new_state}
  end

  def handle_cast(:reset, _state) do
    %{}
  end

  def handle_cast(unexpected, state) do
    IO.puts "Unexpected message: #{inspect unexpected}"
    state
  end

  ###client
  def bump_count(path) do
    GenericServer.call(@server_name, {:bump_count, path})
  end

  def get_count(path) do
    GenericServer.call(@server_name, {:get_count, path})
  end

  def get_counts do
    GenericServer.call(@server_name, :get_counts)
  end

  def reset do
    GenericServer.cast(@server_name, :reset)
  end

end
