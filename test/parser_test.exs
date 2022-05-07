defmodule ParserTest do
  use ExUnit.Case
  doctest Servy.Parser

  alias Servy.Parser

  test "parse a list of header fields into a map" do
    header_lines = ["A: 1", "B: 2", "C: 3"]
    result = Parser.parse_headers(header_lines, %{})
    assert(result == %{"A" => "1", "B" => "2", "C" => "3"})
  end

end
