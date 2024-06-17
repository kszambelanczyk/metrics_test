defmodule MetricsDemo.ChartStore do
  use GenServer

  def start_link(%{id: id} = params) do
    name = {:via, Registry, {MetricsDemo.ChartsRegistry, "chart_store_#{id}"}}
    GenServer.start_link(__MODULE__, params, name: name)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end
end
