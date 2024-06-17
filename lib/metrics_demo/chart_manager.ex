defmodule MetricsDemo.ChartManager do
  use GenServer

  alias MetricsDemo.Charts
  alias MetricsDemo.ChartStore

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(state) do
    {:ok, state, {:continue, :set_up_manager}}
  end

  @impl true
  def handle_continue(:set_up_manager, state) do
    # start dynamic supervisor
    {:ok, _pid} =
      DynamicSupervisor.start_link(name: ChartsDynamicSupervisor, strategy: :one_for_one)

    # load charts
    charts = Charts.list_charts()

    # spawn chart workers
    Enum.each(charts, &spawn_chart/1)

    {:noreply, state}
  end

  def spawn_chart(chart) do
    DynamicSupervisor.start_child(ChartsDynamicSupervisor, {ChartStore, chart})
  end
end
