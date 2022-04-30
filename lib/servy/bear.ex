defmodule Servy.Bear do
  @moduledoc false

  defstruct id: nil, kind: "", name: "", hibernating: false

  def is_grizzly(bear) do
    bear.kind == "Grizzly"
  end

  def order_asc_by_name(b1, b2) do
    b1.name <= b2.name
  end

end
