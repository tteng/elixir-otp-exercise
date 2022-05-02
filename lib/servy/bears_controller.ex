defmodule Servy.BearsController do
  @moduledoc false

  alias Servy.Wildthings
  alias Servy.Bear
  alias Servy.BearsView

  @templates_path Path.expand("../../templates", __DIR__)

  defp render(conv, template, bindings) do
    path = Path.join(@templates_path, template)
    response_body = path |> EEx.eval_file(bindings)
    %{conv | response_body: response_body, status: 200}
  end

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
