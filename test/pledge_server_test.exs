defmodule PledgeServerTest do

  use ExUnit.Case
  alias Servy.Services.PledgeServer

  test "caches most 3 recent pledges and their total" do
    server = PledgeServer.start()
    [{"tim", 100}, {"tiger", 80}, {"holiday", 100}]
      |> Enum.map(fn {name, amount} -> PledgeServer.create_pledge(name, amount) end)
    assert([{"holiday", 100}, {"tiger", 80}, {"tim", 100}] == PledgeServer.recent_pledges())
    assert(280 == PledgeServer.total_amount())
  end

end
