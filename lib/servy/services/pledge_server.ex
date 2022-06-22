defmodule Servy.Services.PledgeServer do

  use GenServer

  @server_name __MODULE__

  defmodule State do
    defstruct cache_size: 3, pledges: []
  end

  def start do
    GenServer.start(__MODULE__, %State{}, name: @server_name)
  end

  ###server callbacks
  def init(state) do
    {:ok, state}
  end

  def handle_call({:create, name, amount}, _from, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    new_pledges = [{name, amount} | Enum.take(state.pledges, state.cache_size - 1)]
    {:reply, id, %State{state | pledges: new_pledges}}
  end

  def handle_call(:recent, _from, state) do
    {:reply, state.pledges, state}
  end

  def handle_call(:total_pledged, _from, state) do
    total = state.pledges |> Enum.reduce(0, fn({_, amount}, acc) -> amount + acc end)
    {:reply, total, state}
  end

  def handle_cast(:clear, state) do
    {:noreply, %State{state | pledges: []}}
  end

  def handle_cast({:update_cache_size, size}, state) do
    {:noreply, %State{state | cache_size: size}}
  end

  def handle_info(message, state) do
    IO.inspect("can't touch this #{inspect message}")
    {:noreply, state}
  end

  ###client
  def create_pledge(name, amount) do
    GenServer.call(@server_name, {:create, name, amount})
  end

  def recent_pledges do
    GenServer.call(@server_name, :recent)
  end

  def total_amount do
    GenServer.call(@server_name, :total_pledged)
  end

  def clear do
    GenServer.cast(@server_name, :clear)
  end

  def update_cache_size(size) do
    GenServer.cast(@server_name, {:update_cache_size, size})
  end

  defp send_pledge_to_service(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

end
