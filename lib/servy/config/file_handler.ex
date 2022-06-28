defmodule Servy.Config.FileHandler do
  @moduledoc "Serves static html files"

  def handle_file({:ok, content}, conv) do
    %{conv | response_body: content, status: 200}
  end

  def handle_file({:error, :enoent}, conv) do
    %{conv | response_body: "File not exist!", status: 404}
  end

  def handle_file({:error, reason}, conv) do
    %{conv | response_body: "File error, reason: #{reason}", status: 500}
  end

end
