defmodule MetricsDemoWeb.CurrentPage do
  def on_mount(:get_current_page, _params, _session, socket) do
    {:cont, mount_current_page(socket)}
  end

  defp mount_current_page(%{view: view} = socket) do
    current =
      view
      |> to_string()
      |> String.split(".")
      |> Enum.at(2, nil)

    Phoenix.Component.assign(socket, :current_page, current)
  end
end
