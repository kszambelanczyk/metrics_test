defmodule MetricsDemoWeb.ChartLive.Index do
  use MetricsDemoWeb, :live_view

  alias MetricsDemo.Charts
  alias MetricsDemo.Charts.Chart

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :charts, Charts.list_charts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Chart")
    |> assign(:chart, Charts.get_chart!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Chart")
    |> assign(:chart, %Chart{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Charts")
    |> assign(:chart, nil)
  end

  @impl true
  def handle_info({MetricsDemoWeb.ChartLive.FormComponent, {:saved, chart}}, socket) do
    {:noreply, stream_insert(socket, :charts, chart)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    chart = Charts.get_chart!(id)
    {:ok, _} = Charts.delete_chart(chart)

    {:noreply, stream_delete(socket, :charts, chart)}
  end
end
