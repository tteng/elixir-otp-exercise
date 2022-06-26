defmodule Servy do

  use Application

  def start(_type, _args) do
    IO.puts "Start the application..."
    Servy.Supervisor.start_link()
  end

end
