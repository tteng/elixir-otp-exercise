defmodule Servy.Api.BearsController do

  alias Servy.Wildthings
  alias Servy.Bear
  alias Servy.BearsView


  def index(conv) do
    bears = Wildthings.list_bears
              |> Enum.sort(&Bear.order_asc_by_name/2)
              |> Poison.encode!
    %{conv | response_body: bears, status: 200, response_content_type: "application/json"}
  end
end
