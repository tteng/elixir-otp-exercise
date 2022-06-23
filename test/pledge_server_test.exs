defmodule PledgeServerTest do

  use ExUnit.Case
  alias Servy.Services.GenServers.PledgeServer

  test "caches most 3 recent pledges and their total then clear" do
    PledgeServer.start()
    [{"tim", 100}, {"tiger", 80}, {"holiday", 100}]
      |> Enum.map(fn {name, amount} -> PledgeServer.create_pledge(name, amount) end)
    assert([{"holiday", 100}, {"tiger", 80}, {"tim", 100}] == PledgeServer.recent_pledges())
    assert(280 == PledgeServer.total_amount())

    PledgeServer.clear()
    assert([] == PledgeServer.recent_pledges())
    assert(0 == PledgeServer.total_amount())
  end


  #test "test update cache size" do
  #  PledgeServer.start()
  #  [{"tim", 100}, {"tiger", 80}, {"holiday", 100}]
  #    |> Enum.map(fn {name, amount} -> PledgeServer.create_pledge(name, amount) end)

  #  PledgeServer.update_cache_size(5)

  #  [{"max", 12}, {"moon", 15}, {"cake", 18}]
  #    |> Enum.map(fn {name, amount} -> PledgeServer.create_pledge(name, amount) end)
  #  assert([{"cake", 18}, {"moon", 15}, {"max", 12}, {"holiday", 100}, {"tiger", 80}] == PledgeServer.recent_pledges())

  #  assert(225 == PledgeServer.total_amount())
  #end

end
