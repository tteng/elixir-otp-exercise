defmodule Servy.Services.UserApi do

  @api_host "https://jsonplaceholder.typicode.com/users/"

  def query(user_id) when is_integer(user_id) do
    user_id |> Integer.to_string |> query
  end

  def query(user_id) when is_binary(user_id) do
    HTTPoison.get(@api_host <> user_id) |> parse
  end

  def parse({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    body_map = Poison.Parser.parse!(body, %{})
    {:ok, body_map |> get_in(["address", "city"])}
  end

  def parse({:ok, %HTTPoison.Response{status_code: status_code, body: body}}) do
    {:error, "server #{status_code}, reason: #{body}"}
  end

  def parse({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end

end
