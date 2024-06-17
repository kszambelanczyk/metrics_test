defmodule MetricsDemo.Repo.Migrations.CreateCharts do
  use Ecto.Migration

  def change do
    create table(:charts) do
      add :metric, :string
      add :filters, :jsonb

      timestamps(type: :utc_datetime)
    end
  end
end
