defmodule Servy.Conv do

  defstruct method: "",
            path: "",
            status: nil,
            response_body: "",
            response_headers: %{"Content-Type" => "text/html"},
            params: %{},
            headers: %{}

  def full_status(conv) do
    "#{conv.status} #{status_reason(conv.status)}"
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end

end
