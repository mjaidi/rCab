import mapboxgl from "mapbox-gl";
import MapboxDirections from "@mapbox/mapbox-gl-directions/dist/mapbox-gl-directions.js";

const initMapboxDirections = () => {
  const mapElement = document.getElementById("map-dir");
  if (mapElement) {
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
    let map = new mapboxgl.Map({
      container: "map-dir",
      style: "mapbox://styles/mapbox/streets-v11",
      center: [-7.6, 33.56],
      zoom: 6
    });

    let options = {
      accessToken: mapboxgl.accessToken,
      unit: "metric",
      placeholderOrigin: "Choissisez un point de départ",
      placeholderDestination: "Choissisez un point d'arriver",
      controls: {
        instructions: false,
        profileSwitcher: false
      }
    };

    if (mapElement.dataset.withInputs === "true") {
      let directions = new MapboxDirections(options);
      map.addControl(directions, "top-left");
      // const startAddress = document.querySelector("#course_start_address");
      // startAddress.addEventListener("change", e => {
      //   console.log(e);
      //   directions.setOrigin(startAddress.value);
      // });
      // const endAddress = document.querySelector("#course_end_address");
      // endAddress.addEventListener("change", e => {
      //   console.log(e);
      //   directions.setDestination(endAddress.value);
      // });

      let originValue = {};
      let destinationValue = {};
      let route = {};
      directions.on("origin", e => {
        const origin = document.querySelector(
          "#mapbox-directions-origin-input input"
        );
        originValue = { name: origin.value };
      });
      directions.on("destination", e => {
        const destination = document.querySelector(
          "#mapbox-directions-destination-input input"
        );
        destinationValue = { name: destination.value };
      });
      directions.on("route", e => {
        document.getElementById("course_start_address").value =
          originValue.name;
        document.getElementById("course_end_address").value =
          destinationValue.name;
        document.getElementById("submit_new_course").classList.remove("hidden");
      });
    } else {
      const markers = JSON.parse(mapElement.dataset.markers);
      options.controls.inputs = false;
      let directions = new MapboxDirections(options);
      map.addControl(directions, "top-left");
      map.on("load", e => {
        directions.setOrigin([
          markers.start_address.lng,
          markers.start_address.lat
        ]);
        directions.setDestination([
          markers.end_address.lng,
          markers.end_address.lat
        ]);
      });
    }
  }
};

export default initMapboxDirections;
