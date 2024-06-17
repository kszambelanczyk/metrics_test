defmodule MetricsDemo.Charts.Chart do
  use Ecto.Schema
  import Ecto.Changeset

  schema "charts" do
    field :filters, :map
    field :metric, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(chart, attrs) do
    chart
    |> cast(attrs, [:metric, :filters])
    |> validate_required([:metric])
  end
end
