defmodule MetricsDemoWeb.ChartLiveTest do
  use MetricsDemoWeb.ConnCase

  import Phoenix.LiveViewTest
  import MetricsDemo.ChartsFixtures

  @create_attrs %{filters: %{}, metric: "some metric"}
  @update_attrs %{filters: %{}, metric: "some updated metric"}
  @invalid_attrs %{filters: nil, metric: nil}

  defp create_chart(_) do
    chart = chart_fixture()
    %{chart: chart}
  end

  describe "Index" do
    setup [:create_chart]

    test "lists all charts", %{conn: conn, chart: chart} do
      {:ok, _index_live, html} = live(conn, ~p"/charts")

      assert html =~ "Listing Charts"
      assert html =~ chart.metric
    end

    test "saves new chart", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/charts")

      assert index_live |> element("a", "New Chart") |> render_click() =~
               "New Chart"

      assert_patch(index_live, ~p"/charts/new")

      assert index_live
             |> form("#chart-form", chart: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#chart-form", chart: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/charts")

      html = render(index_live)
      assert html =~ "Chart created successfully"
      assert html =~ "some metric"
    end

    test "updates chart in listing", %{conn: conn, chart: chart} do
      {:ok, index_live, _html} = live(conn, ~p"/charts")

      assert index_live |> element("#charts-#{chart.id} a", "Edit") |> render_click() =~
               "Edit Chart"

      assert_patch(index_live, ~p"/charts/#{chart}/edit")

      assert index_live
             |> form("#chart-form", chart: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#chart-form", chart: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/charts")

      html = render(index_live)
      assert html =~ "Chart updated successfully"
      assert html =~ "some updated metric"
    end

    test "deletes chart in listing", %{conn: conn, chart: chart} do
      {:ok, index_live, _html} = live(conn, ~p"/charts")

      assert index_live |> element("#charts-#{chart.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#charts-#{chart.id}")
    end
  end

  describe "Show" do
    setup [:create_chart]

    test "displays chart", %{conn: conn, chart: chart} do
      {:ok, _show_live, html} = live(conn, ~p"/charts/#{chart}")

      assert html =~ "Show Chart"
      assert html =~ chart.metric
    end

    test "updates chart within modal", %{conn: conn, chart: chart} do
      {:ok, show_live, _html} = live(conn, ~p"/charts/#{chart}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Chart"

      assert_patch(show_live, ~p"/charts/#{chart}/show/edit")

      assert show_live
             |> form("#chart-form", chart: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#chart-form", chart: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/charts/#{chart}")

      html = render(show_live)
      assert html =~ "Chart updated successfully"
      assert html =~ "some updated metric"
    end
  end
end
