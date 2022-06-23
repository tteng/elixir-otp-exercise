defmodule Servy.Controllers.Html.PledgesController do

  def recent_pledges(conv) do
    pledges = Servy.Services.GenServers.PledgeServer.recent_pledges()
    %{conv | status: 200, response_body: Servy.Views.PledgesView.recent_pledges(pledges)}
  end

  def new(conv) do
    %{conv | status: 200, response_body: Servy.Views.PledgesView.new()}
  end

  def create(conv, %{"name" => name, "amount" => amount}) do
    id = Servy.Services.GenServers.PledgeServer.create_pledge(name, String.to_integer(amount))
    %{conv | status: 201, response_body: "#{id} - #{name} pledged #{amount} !"}
  end

end
