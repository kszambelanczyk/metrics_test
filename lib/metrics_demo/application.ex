defmodule MetricsDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MetricsDemoWeb.Telemetry,
      MetricsDemo.Repo,
      {DNSCluster, query: Application.get_env(:metrics_demo, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MetricsDemo.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: MetricsDemo.Finch},
      MetricsDemo.MetricsListener,

      # Start a worker by calling: MetricsDemo.Worker.start_link(arg)
      # {MetricsDemo.Worker, arg},
      # Start to serve requests, typically the last entry
      MetricsDemoWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MetricsDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MetricsDemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
