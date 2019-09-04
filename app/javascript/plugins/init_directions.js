import mapboxgl from "mapbox-gl";
import MapboxDirections from "@mapbox/mapbox-gl-directions/dist/mapbox-gl-directions.js";
import style from "./mapbox_style";

const initMapboxDirections = () => {
  const mapElement = document.getElementById("map-dir");
  if (mapElement) {
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
    let map = new mapboxgl.Map({
      container: "map-dir",
      style: "mapbox://styles/mjaidi/ck053p1qb10og1crdi9qq63vy",
      center: [-7.6, 33.56],
      zoom: 6
    });

    let options = {
      accessToken: mapboxgl.accessToken,
      styles: style,
      unit: "metric",
      interactive: false,
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
      let originValue = {};
      let destinationValue = {};
      let route = {};
      directions.on("origin", e => {
        const origin = document.querySelector(
          "#mapbox-directions-origin-input input"
        );
        originValue = {
          name: origin.value,
          lat: e.feature.geometry.coordinates[1],
          lng: e.feature.geometry.coordinates[0]
        };
      });
      if ("geolocation" in navigator) {
        navigator.geolocation.getCurrentPosition(p => {
          directions.setOrigin([p.coords.longitude, p.coords.latitude]);
        });
      }

      directions.on("destination", e => {
        const destination = document.querySelector(
          "#mapbox-directions-destination-input input"
        );
        destinationValue = {
          name: destination.value,
          lat: e.feature.geometry.coordinates[1],
          lng: e.feature.geometry.coordinates[0]
        };
      });
      directions.on("route", e => {
        document.getElementById("course_start_address").value =
          originValue.name;
        document.getElementById("course_start_lat").value = originValue.lat;
        document.getElementById("course_start_lon").value = originValue.lng;
        document.getElementById("course_end_address").value =
          destinationValue.name;
        document.getElementById("course_end_lat").value = destinationValue.lat;
        document.getElementById("course_end_lon").value = destinationValue.lng;
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
