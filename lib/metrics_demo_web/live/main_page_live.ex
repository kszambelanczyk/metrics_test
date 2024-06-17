defmodule MetricsDemoWeb.MainPageLive do
  use MetricsDemoWeb, :live_view

  alias MetricsDemo.Charts
  alias MetricsDemo.MetricsListener

  import MetricsDemoWeb.Components.Plot

  @impl true
  def render(assigns) do
    ~H"""
    <div class="container px-6 py-8 mx-auto">
      <div class="flex flex-wrap gap-2">
        <%= for chart <- @charts do %>
          <.plot id={"plot-component-#{chart.id}"} />
        <% end %>
      </div>
    </div>
    """
  end

  @refresh_chart_interval 1000

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Process.send_after(self(), :update, @refresh_chart_interval)

      socket =
        socket
        |> load_charts()
        |> send_charts_data()

      {:ok, socket}
    else
      {:ok, assign(socket, charts: [])}
    end
  end

  @impl true
  def handle_info(:update, socket) do
    Process.send_after(self(), :update, @refresh_chart_interval)

    {:noreply, send_charts_data(socket)}
  end

  defp load_charts(socket), do: assign(socket, charts: Charts.list_charts())

  defp send_charts_data(%{assigns: %{charts: charts}} = socket) do
    Enum.reduce(charts, socket, fn chart, socket ->
      data = MetricsListener.get_chart_data(chart.id)

      push_event(socket, "update_chart_plot-component-#{chart.id}", data)
    end)
  end
end
