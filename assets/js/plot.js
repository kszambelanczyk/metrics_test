import Plotly from "plotly.js-dist";

const Plot = {
  drawChart(target) {
    Plotly.newPlot(
      target,
      [
        {
          x: [],
          y: [],
          type: "bar",
        },
      ],
      {
        margin: { t: 0 },
        xaxis: { type: "category" },
      },
    );
  },

  updateChart(target, data) {
    console.log("Update chart", data);
    Plotly.react(
      target,
      [
        {
          x: data.x,
          y: data.y,
          type: "bar",
        },
      ],
      {
        margin: { t: 0 },
        xaxis: { type: "category" },
      },
    );
  },

  mounted() {
    console.log("Plot mounted");

    const elem = this.el;

    this.drawChart(elem);

    this.handleEvent("update_chart_" + elem.id, (data) => {
      this.updateChart(elem, data);
    });
  },

  destroyed() {
    console.log("Destroyed plot");
  },
};

export default Plot;
