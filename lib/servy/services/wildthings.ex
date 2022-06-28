defmodule Servy.Services.Wildthings do
  @moduledoc false
  alias Servy.Models.Bear

  @db_path Path.expand("../../../db", __DIR__)

  def list_bears do
    @db_path
    |> Path.join("bears.json")
    |> read_json
    |> Poison.decode!(as: %{"bears" => [%Bear{}]})
    |> Map.get("bears")
  end

  def find_bear(id) when is_integer(id) do
    list_bears() |> Enum.find(&(&1.id == id))
  end

  def find_bear(id) when is_binary(id) do
    id |> String.to_integer |> find_bear
  end

  defp read_json(path) do
    case File.read(path) do
      {:ok, contents} -> contents
      {:error, reason} ->
        IO.inspect("Error reading #{path}, reason: #{reason}")
        "[]"
    end
  end

end
