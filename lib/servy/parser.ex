defmodule Servy.Parser do
  @moduledoc "Parse the request into structured map"

  alias Servy.Conv

  @doc "parse the request string into a map with `method`, `path`, `status`, `response_body` keys"
  def parse(request) do
    [top, params_string] = request |> String.split("\r\n\r\n")
    [request_line | header_lines] = top |> String.split("\r\n")
    [method, path, _] = request_line |> String.split(" ")
    headers = parse_headers(header_lines, %{})
    params = parse_params(headers["Content-Type"], params_string)
    %Conv{method: method, path: path, params: params, headers: headers}
  end

  @doc """
  Parses the given param string of the form `key1=value1&key2=value2`
  into a map with corresponding keys and values.

  ## Examples
      iex> params_string = "name=Baloo&type=Brown"
      iex> Servy.Parser.parse_params("application/x-www-urlencoded", params_string)
      %{"name" => "Baloo", "type" => "Brown"}
      iex> Servy.Parser.parse_params("multipart/form-data", params_string)
      %{}
  """
  def parse_params("application/x-www-urlencoded", params_string) do
    params_string |> String.trim |> URI.decode_query
  end

  def parse_params(_, _), do: %{}

#  defp parse_headers([head | tail], headers) do
#    [key, value] = String.split(head, ": ")
#    headers = Map.put(headers, key, value)
#    parse_headers(tail, headers)
#  end
#
#  defp parse_headers([], headers), do: headers

  def parse_headers(header_lines, acc) do
    header_lines |> Enum.reduce(acc, fn(line, acc) ->
      [key, value] = String.split(line, ": ")
      Map.put(acc, key, value)
    end)
  end

end
