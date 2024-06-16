defmodule MetricsDemo.MetricsListener do
  use GenServer

  import Telemetry.Metrics

  # Client

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  # def push(pid, element) do
  #   GenServer.cast(pid, {:push, element})
  # end
  #
  # def pop(pid) do
  #   GenServer.call(pid, :pop)
  # end

  # Server (callbacks)

  @impl true
  def init(state) do
    Process.flag(:trap_exit, true)

    {:ok, state, {:continue, :attach_reporter}}
  end

  @impl true
  def handle_continue(:attach_reporter, state) do
    {:noreply, set_up_listener(state)}
  end

  # @impl true
  # def handle_call(:pop, _from, state) do
  #   [to_caller | new_state] = state
  #   {:reply, to_caller, new_state}
  # end
  #
  # @impl true
  # def handle_cast({:push, element}, state) do
  #   new_state = [element | state]
  #   {:noreply, new_state}
  # end

  @impl true
  def terminate(_reason, %{events: events}) do
    for event <- events do
      :telemetry.detach({__MODULE__, event, self()})
    end

    :ok
  end

  def handle_metrics(_event_name, measurements, metadata, metrics) do
    # time = System.system_time(:microsecond)

    dbg(measurements)
    dbg(metrics)

    # entries =
    # for {metric, index} <- metrics,
    #   map = extract_datapoint_for_metric(metric, measurements, metadata, time) do
    # %{label: label, measurement: measurement, time: time} = map
    # {index, label, measurement, time}
    # end

    # send(parent, {:telemetry, entries})
  end

  defp set_up_listener(state) do
    metrics = get_metrics()

    metrics = Enum.with_index(metrics, 0)
    metrics_per_event = Enum.group_by(metrics, fn {metric, _} -> metric.event_name end)

    for {event_name, metrics} <- metrics_per_event do
      id = {__MODULE__, event_name, self()}
      :telemetry.attach(id, event_name, &__MODULE__.handle_metrics/4, metrics)
    end

    state
  end

  defp get_metrics() do
    # read the metrics from the database

    [
      %{metric: "phoenix.endpoint.stop.duration", filter: "to do: parse at form level"},
      %{metric: "phoenix.endpoint.stop.duration", filter: "different filter"},
      %{metric: "phoenix.socket_connected.duration", filter: "to do: parse at form level"}
    ]
    |> Enum.map(fn %{metric: metric, filter: _filter} ->
      distribution(metric)
    end)
  end
end
