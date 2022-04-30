defmodule Servy.Wildthings do
  @moduledoc false
  alias Servy.Bear

  def list_bears do
    [
      %Bear{id: 1, name: "Teddy",  kind: "Brown", hibernating: true},
      %Bear{id: 2, name: "Smokey", kind: "Black"},
      %Bear{id: 3, name: "Paddington", kind: "Brown"},
      %Bear{id: 4, name: "Scarface", kind: "Grizzly", hibernating: true},
      %Bear{id: 5, name: "Snow", kind: "Polar"},
      %Bear{id: 6, name: "Brutus", kind: "Grizzly"},
      %Bear{id: 7, name: "Rosie", kind: "Black", hibernating: true},
      %Bear{id: 8, name: "Roscoe", kind: "Panda"},
      %Bear{id: 9, name: "Iceman", kind: "Polar", hibernating: true},
      %Bear{id: 10, name: "Kenai", kind: "Grizzly"}

    ]
  end

  def find_bear(id) when is_integer(id) do
    list_bears |> Enum.find(&(&1.id == id))
  end

  def find_bear(id) when is_binary(id) do
    id |> String.to_integer |> find_bear
  end

end
