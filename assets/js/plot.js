import Plotly from "plotly.js-dist";

const Plot = {
  drawChart(target) {
    Plotly.newPlot(
      target,
      [
        {
          x: [1, 2, 3, 4, 5],
          y: [1, 2, 4, 8, 16],
        },
      ],
      {
        margin: { t: 0 },
      },
    );
  },

  updateChart(target, data) {
    Plotly.react(
      target,
      [
        {
          x: data.x,
          y: data.y,
        },
      ],
      {
        margin: { t: 0 },
      },
    );
  },

  mounted() {
    console.log("Plot mounted");

    let elem = document.getElementById("plot-component");

    this.drawChart(elem);

    this.handleEvent("update_chart", (data) => {
      this.updateChart(elem, data);
    });
    //
    // // global scope
    // window.webPageViewerComponent = {
    //   data: [],
    // };

    // // bind view hook this to global scope
    // window.webPageViewerComponent.viewHookThis = this;

    // after initialization sending info to get new data
    //   this.pushEventTo("#web-page-component", "get-data", true, (data) => {
    //     ({data} = data);
    //     // setAsync(false);
    //     window.webPageViewerComponent.data = data;
    //     drawElements();
    //   });
  },

  destroyed() {
    // let boundClearEvents = clearEvents.bind(this);
    // boundClearEvents();

    // clearMapEvents();

    // clearLeafletMap();

    console.log("Destroyed plot");
  },
};

export default Plot;
