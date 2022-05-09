defmodule Servy.Controllers.Api.BearsController do

  alias Servy.Services.Wildthings
  alias Servy.Models.Bear
  alias Servy.Views.BearsView


  def index(conv) do
    bears = Wildthings.list_bears
              |> Enum.sort(&Bear.order_asc_by_name/2)
              |> Poison.encode!
    %{conv | response_body: bears, status: 200, response_content_type: "application/json"}
  end
end
