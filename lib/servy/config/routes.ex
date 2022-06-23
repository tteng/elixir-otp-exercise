defmodule Servy.Config.Routes do

  alias Servy.Conv
  alias Servy.Services.VideoCam
  alias Servy.Services.GenServers.FourOhFourCounterServer
  alias Servy.Controllers.Html.BearsController, as: HtmlBearsController
  alias Servy.Controllers.Html.PledgesController, as: HtmlPledgesController
  alias Servy.Controllers.Api.BearsController,  as: ApiBearsController
  alias Servy.Services.GenServers.SensorServer


  import Servy.Config.FileHandler, only: [handle_file: 2]

  @pages_path Path.expand("../../../pages", __DIR__)

  def route(%Conv{method: "POST", path: "/pledges"} = conv) do
    HtmlPledgesController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/pledges/new"} = conv) do
    HtmlPledgesController.new(conv)
  end

  def route(%Conv{method: "GET", path: "/pledges"} = conv) do
    HtmlPledgesController.recent_pledges(conv)
  end

  def route(%Conv{ method: "GET", path: "/sensors" } = conv) do
    sensor_data = SensorServer.get_snapshots.sensor_data
    %{ conv | status: 200, response_body: Servy.Views.SnapshotsView.index(sensor_data.snapshots, sensor_data.location)}
  end

  def route(%Conv{ method: "GET", path: "/snapshots" } = conv) do
    snapshots = ["cam-1", "cam-2", "cam-3"]
      |> Enum.map(&Task.async(fn -> VideoCam.get_snapshot(&1) end))
      |> Enum.map(&Task.await/1)
    %{ conv | status: 200, response_body: inspect snapshots}
  end

  def route(%Conv{method: "GET", path: "/kaboom"}) do
    raise "Kaboom!"
  end

  def route(%Conv{method: "GET", path: "/hibernate/" <> time} = conv) do
    time |> String.to_integer |> :timer.sleep
    %{conv | status: 200, response_body: "Awake!"}
  end

  def route(%Conv{method: "POST", path: "/api/bears"} = conv) do
    ApiBearsController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    result = @pages_path |> Path.join("about.html") |> File.read
    handle_file(result, conv)
  end

  def route(%Conv{method: "GET", path: "/faq"} = conv) do
    result = @pages_path |> Path.join("faq.md") |> File.read
    handle_file(result, conv) |> markdown_to_html
  end

  def route(%Conv{method: "GET", path: "/static/" <> page} = conv) do
    result = @pages_path |> Path.join("#{page}.html") |> File.read
    handle_file(result, conv)
  end

  def route(%Conv{method: "GET", path: "/wild_things"} = conv) do
    %{conv | response_body: "Tigers, Bears and Lions!", status: 200}
  end

  def route(%Conv{method: "GET", path: "/api/bears"} = conv) do
    ApiBearsController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    HtmlBearsController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    HtmlBearsController.show(conv, params)
  end

  def route(%Conv{method: "DELETE", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    HtmlBearsController.destroy(conv, params)
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    HtmlBearsController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/404s"} = conv) do
    counts = FourOhFourCounterServer.get_counts()
    %{conv | response_body: inspect(counts), status: 200}
  end

  def route(%Conv{path: path} = conv) do
    %{conv | response_body: "No #{path} found!", status: 404}
  end


  defp markdown_to_html(%Conv{status: 200} = conv) do
    Map.put(conv, "response_body", conv.response_body |> Earmark.as_html!)
  end

  defp markdown_to_html(%Conv{} = conv), do: conv

end
