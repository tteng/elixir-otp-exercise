defmodule Servy.Services.PledgeServer do

  ###server

  @server_name __MODULE__
  def start do
    pid = spawn(__MODULE__, :listen_loop, [])
    Process.register(pid, @server_name)
    pid
  end

  def listen_loop(state \\ []) do
    receive do
      {sender, :create, name, amount} ->
        {:ok, id} = send_pledge_to_service(name, amount)
        send(sender, {:response, id})
        new_state = Enum.take(state, 2)
        listen_loop([{name, amount} | new_state])
      {sender, :recent} ->
        send(sender, {:response, state})
        listen_loop(state)
      {sender, :total} ->
        send(sender, {:response, state |> Enum.reduce(0, fn({_, amount}, acc) -> amount + acc end)})
        listen_loop(state)
    end
  end

  ###client
  def create_pledge(name, amount) do
    send(@server_name, {self(), :create, name, amount})
    receive do
      {:response, id} ->
        id
    end
  end

  def recent_pledges do
    send(@server_name, {self(), :recent})
    receive do
      {:response, status} ->
        status
    end
  end

  def total_amount do
    send(@server_name, {self(), :total})
    receive do
      {:response, amount} -> amount
    end
  end

  defp send_pledge_to_service(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

end
