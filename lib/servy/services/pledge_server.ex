defmodule Servy.Services.PledgeServer do

  alias Servy.Services.GenericServer

  @server_name __MODULE__

  def start do
    GenericServer.start(__MODULE__, [], @server_name)
  end

  ###server callbacks
  def handle_call({:create, name, amount}, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    new_state = [{name, amount} | Enum.take(state, 2)]
    {id, new_state}
  end

  def handle_call(:recent, state) do
    {state, state}
  end

  def handle_call(:total_pledged, state) do
    reply = state |> Enum.reduce(0, fn({_, amount}, acc) -> amount + acc end)
    {reply, state}
  end

  def handle_cast(:clear, _state) do
    []
  end

  ###client
  def create_pledge(name, amount) do
    GenericServer.call(@server_name, {:create, name, amount})
  end

  def recent_pledges do
    GenericServer.call(@server_name, :recent)
  end

  def total_amount do
    GenericServer.call(@server_name, :total_pledged)
  end

  def clear do
    GenericServer.cast(@server_name, :clear)
  end

  defp send_pledge_to_service(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

end
