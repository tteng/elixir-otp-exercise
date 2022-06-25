defmodule Servy.Services.Supervisors.ServicesSupervisor do

  use Supervisor

  def start_link(_args) do
    IO.puts "Starting the services supervisor..."
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  #callbacks
  def init(:ok) do
    children = [
      Servy.Services.GenServers.PledgeServer,
      Servy.Services.GenServers.SensorServer
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end

end
