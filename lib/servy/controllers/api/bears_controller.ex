defmodule Servy.Controllers.Api.BearsController do

  alias Servy.Services.Wildthings
  alias Servy.Models.Bear
  # alias Servy.Views.BearsView


  def index(conv) do
    bears = Wildthings.list_bears
              |> Enum.sort(&Bear.order_asc_by_name/2)
              |> Poison.encode!
    conv = put_resp_content_type(conv, "application/json")
    %{conv | response_body: bears, status: 200}
  end

  def create(conv, %{"name" => name, "type" => type}) do
    %{conv | response_body: "Bear##{name} created with type #{type}", status: 201}
  end

  defp put_resp_content_type(conv, content_type) do
    new_headers = %{conv.response_headers | "Content-Type" => content_type}
    %{conv | response_headers: new_headers}
  end
end
