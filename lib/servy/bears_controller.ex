defmodule Servy.BearsController do
  @moduledoc false

  alias Servy.Wildthings
  alias Servy.Bear

  def index(conv) do
    response_body = Wildthings.list_bears()
                    |> Enum.filter(&Bear.is_grizzly/1)
                    |> Enum.sort(&Bear.order_asc_by_name/2)
                    |> Enum.map(&bear_item/1)
                    |> Enum.join("\n")
    %{conv | response_body: "<ul>\n#{response_body}\n</ul>", status: 200}
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.find_bear(id)
    %{conv | response_body: "Hello, this is bear #{bear.name}!", status: 200}
  end

  def create(conv, %{"name" => name, "kind" => kind} = _params) do
    %{conv | response_body: "Bear##{name} created with kind #{kind}", status: 201}
  end

  def destroy(conv, %{"id" => id}) do
    %{conv | response_body: "Bear##{id} Must Not Be Deleted!", status: 403}
  end

  defp bear_item(bear) do
    "<li>#{bear.name}-#{bear.kind}</li>"
  end

end
