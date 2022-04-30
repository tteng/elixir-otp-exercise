defmodule Servy.BearsController do
  @moduledoc false

  alias Servy.Wildthings

  def index(conv) do
    response_body = Wildthings.list_bears() |> Enum.map(&("<li>#{&1.name}-#{&1.kind}</li>")) |> Enum.join("\n")
    %{conv | response_body: "<ul>\n#{response_body}\n</ul>", status: 200}
  end

  def show(conv, %{"id" => id}) do
    %{conv | response_body: "Hello, this is bear #{id}!", status: 200}
  end

  def create(conv, %{"name" => name, "kind" => kind} = _params) do
    %{conv | response_body: "Bear##{name} created with kind #{kind}", status: 201}
  end

end
