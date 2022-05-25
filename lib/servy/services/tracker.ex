defmodule Servy.Services.Tracker do

  import String, only: [downcase: 1, to_atom: 1]

  def get_location(wildthing) do
    locations = %{
      teddy: %{ lat: "44.4280 N", lng: "112.3883 W" },
      smokey: %{ lat: "43.4280 N", lng: "112.223 W" },
      paddington: %{ lat: "46.4280 N", lng: "112.7876 W" }
    }
    Map.get(locations, wildthing |> downcase |> to_atom)
  end

end
