defmodule Servy.Parser do
  @moduledoc "Parse the request into structured map"

  @doc "parse the request string into a map with `method`, `path`, `status`, `response_body` keys"
  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split
    %{method: method, path: path, status: nil, response_body: ""}
  end

end
