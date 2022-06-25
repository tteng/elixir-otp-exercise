defmodule Servy.Services.GenServers.SensorServer do

  alias Servy.Services.VideoCam
  alias Servy.Services.Tracker

  use GenServer

  @server_name __MODULE__

  defmodule State do
    defstruct sensor_data: %{}, refresh_interval: :timer.seconds(5)
  end

  def start_link(_args) do
    IO.puts "Staring the Sensor server..."
    GenServer.start_link(__MODULE__, %State{}, name: @server_name)
  end

  #callbacks

  def init(state) do
    sensor_data = get_snapshots_and_location_from_external()
    schedule_the_refresh(state.refresh_interval)
    {:ok, %State{state | sensor_data: sensor_data}}
  end

  def handle_info(:refresh, state) do
    IO.puts("refreshing the cache...")
    new_sensor_data = get_snapshots_and_location_from_external()
    schedule_the_refresh(state.refresh_interval)
    {:noreply, %State{state | sensor_data: new_sensor_data}}
  end

  defp schedule_the_refresh(interval) do
    Process.send_after(self(), :refresh, interval)
  end

  def handle_call(:get_snapshots_and_location, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:update_refresh_interval, seconds}, state) do
    new_state = %State{state | refresh_interval: :timer.seconds(seconds)}
    {:noreply, new_state}
  end

  defp get_snapshots_and_location_from_external do
    snapshots = ["cam-1", "cam-2", "cam-3"]
      |> Enum.map(&Task.async(fn -> VideoCam.get_snapshot(&1) end))
      |> Enum.map(&Task.await/1)
    pid4 = Task.async(fn -> Tracker.get_location("Teddy") end)
    teddy_location = Task.await(pid4)
    %{snapshots: snapshots, location: teddy_location}
  end

  #client interface
  def get_snapshots do
    GenServer.call(@server_name, :get_snapshots_and_location)
  end

  def update_refresh_interval(seconds) do
    GenServer.cast(@server_name, {:update_refresh_interval, seconds})
  end

end
