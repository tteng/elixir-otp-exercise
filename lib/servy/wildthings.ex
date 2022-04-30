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

end
