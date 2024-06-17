defmodule MetricsDemoWeb.Components.Plot do
  use MetricsDemoWeb, :html

  def plot(assigns) do
    ~H"""
    <div id={@id} class="h-96 w-[500px]" phx-hook="Plot" phx-update="ignore" />
    """
  end
end
