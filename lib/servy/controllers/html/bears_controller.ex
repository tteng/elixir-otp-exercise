defmodule Servy.Controllers.Html.BearsController do
  @moduledoc false

  alias Servy.Services.Wildthings
  alias Servy.Models.Bear
  alias Servy.Views.BearsView
  #import Servy.View, only: [render: 3]

  def index(conv) do
    bears = Wildthings.list_bears |> Enum.sort(&Bear.order_asc_by_name/2)
    %{conv | response_body: BearsView.index(bears), status: 200}
#    render(conv, "index.eex", bears: bears)
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.find_bear(id)
    %{conv | response_body: BearsView.show(bear), status: 200}
#    render(conv, "show.eex", bear: bear)
  end

  def create(conv, %{"name" => name, "kind" => kind} = _params) do
    %{conv | response_body: "Bear##{name} created with kind #{kind}", status: 201}
  end

  def destroy(conv, %{"id" => id}) do
    %{conv | response_body: "Bear##{id} Must Not Be Deleted!", status: 403}
  end

end
