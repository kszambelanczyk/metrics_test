defmodule MetricsDemo.ChartsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MetricsDemo.Charts` context.
  """

  @doc """
  Generate a chart.
  """
  def chart_fixture(attrs \\ %{}) do
    {:ok, chart} =
      attrs
      |> Enum.into(%{
        filters: %{},
        metric: "some metric"
      })
      |> MetricsDemo.Charts.create_chart()

    chart
  end
end
