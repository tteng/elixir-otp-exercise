defmodule Servy.View do

  @templates_path Path.expand("../../templates", __DIR__)

  def render(conv, template, bindings) do
    path = Path.join(@templates_path, template)
    response_body = path |> EEx.eval_file(bindings)
    %{conv | response_body: response_body, status: 200}
  end

end
