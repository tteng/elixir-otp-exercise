defmodule Servy.Parser do
  @moduledoc "Parse the request into structured map"

  alias Servy.Conv

  @doc "parse the request string into a map with `method`, `path`, `status`, `response_body` keys"
  def parse(request) do
    [top, params_string] = request |> String.split("\n\n")
    [request_line | header_lines] = top |> String.split("\n")
    [method, path, _] = request_line |> String.split(" ")
    params = parse_params(params_string)
    %Conv{method: method, path: path, params: params}
  end

  defp parse_params(params_string) do
    params_string |> String.trim |> URI.decode_query
  end

end
