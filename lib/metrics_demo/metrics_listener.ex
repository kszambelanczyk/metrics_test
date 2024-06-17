defmodule MetricsDemo.MetricsListener do
  use GenServer

  import Telemetry.Metrics

  alias MetricsDemo.Charts

  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(state) do
    Process.flag(:trap_exit, true)

    :ets.new(:metrics_store, [:set, :public, :named_table, write_concurrency: true])

    {:ok, state, {:continue, :attach_reporter}}
  end

  @impl true
  def handle_continue(:attach_reporter, state) do
    {:noreply, set_up_listener(state)}
  end

  @impl true
  def terminate(_reason, %{events: events}) do
    detach_all(events)

    :ok
  end

  @buckets [2, 10, 20, 50, 200, 500, 1000]

  def get_chart_data(chart_id) do
    buckets = @buckets ++ ["#{List.last(@buckets)}+"]

    y =
      Enum.map(buckets, fn bucket ->
        key = {chart_id, bucket}

        case :ets.lookup(:metrics_store, key) do
          [{_key, value}] -> value
          _ -> 0
        end
      end)

    %{x: buckets, y: y}
  end

  defp handle_metrics(_event_name, measurements, metadata, metrics),
    do: Enum.map(metrics, &handle_metric(&1, measurements, metadata))

  defp handle_metric(%{metric: metric, chart: chart}, measurements, metadata) do
    duration = extract_datapoint_for_metric(metric, measurements, metadata)

    update_distribution(@buckets, duration, chart)

    Logger.info("distribution - #{inspect(:ets.match_object(:metrics_store, {{:_, :_}, :_}))}")
  end

  defp extract_datapoint_for_metric(metric, measurements, metadata) do
    with true <- keep?(metric, metadata),
         measurement = extract_measurement(metric, measurements),
         true <- measurement != nil do
      measurement
    else
      _ -> nil
    end
  end

  defp keep?(%{keep: keep}, metadata) when keep != nil, do: keep.(metadata)
  defp keep?(_metric, _metadata), do: true

  defp extract_measurement(metric, measurements) do
    case metric.measurement do
      fun when is_function(fun, 1) -> fun.(measurements)
      key -> measurements[key]
    end
  end

  defp update_distribution([], _duration, chart) do
    key = {chart.id, "#{List.last(@buckets)}+"}
    :ets.update_counter(:metrics_store, key, 1, {key, 0})
  end

  defp update_distribution([head | _buckets], duration, chart) when duration <= head do
    key = {chart.id, head}
    :ets.update_counter(:metrics_store, key, 1, {key, 0})
  end

  defp update_distribution([_head | buckets], duration, chart) do
    update_distribution(buckets, duration, chart)
  end

  defp set_up_listener(state) do
    charts = Charts.list_charts()

    metrics_per_event =
      charts
      |> Enum.map(fn %{metric: metric} = chart ->
        %{chart: chart, metric: distribution(metric, unit: {:native, :millisecond})}
      end)
      |> Enum.group_by(fn %{metric: metric} -> metric.event_name end)

    events =
      for {event_name, metrics} <- metrics_per_event do
        id = {__MODULE__, event_name, self()}
        :telemetry.attach(id, event_name, &handle_metrics/4, metrics)
        event_name
      end

    Map.put(state, :events, events)
  end

  defp detach_all(events) do
    for event <- events do
      :telemetry.detach({__MODULE__, event, self()})
    end
  end
end
