defmodule Servy.Supervisor do
  use Supervisor

  def start_link do
    IO.puts "Starting the top level supervisor..."
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  #callbacks
  def init(:ok) do
    children = [
      Servy.Services.GenServers.KickStarter,
      Servy.Services.GenServers.FourOhFourCounterServer,
      Servy.Services.Supervisors.ServicesSupervisor
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
