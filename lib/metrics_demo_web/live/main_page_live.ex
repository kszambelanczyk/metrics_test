defmodule MetricsDemoWeb.MainPageLive do
  use MetricsDemoWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container px-6 py-8 mx-auto">
      <.plot />
    </div>
    """
  end

  defp plot(assigns) do
    ~H"""
    <div id="plot-component" class="h-96 w-[500px]" phx-hook="Plot" phx-update="ignore" />
    """
  end

  @refresh_chart_interval 1000

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Process.send_after(self(), :update, @refresh_chart_interval)
    end

    {:ok, socket}
  end

  @impl true
  def handle_info(:update, socket) do
    Process.send_after(self(), :update, @refresh_chart_interval)

    # random data
    x = 1..10 |> Enum.to_list()
    y = 1..10 |> Enum.map(fn _ -> :rand.uniform() end)

    {:noreply, push_event(socket, "update_chart", %{x: x, y: y})}
  end
end
