import mapboxgl from "mapbox-gl";
import MapboxDirections from "@mapbox/mapbox-gl-directions/dist/mapbox-gl-directions.js";
import style from "./mapbox_style";
import axios from "axios";

const initMapboxDirections = () => {
  const mapElement = document.getElementById("map-dir");
  if (mapElement) {
    // initialize map with custom styling
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
      placeholderOrigin: "Choissisez un point de départ",
      placeholderDestination: "Choissisez un point d'arriver",
      controls: {
        instructions: false,
        profileSwitcher: false
      }
    };

    if (mapElement.dataset.withInputs === "true") {
      // initialize mapbox directions and add input controls
      let directions = new MapboxDirections(options);
      map.addControl(directions, "top-left");

      // initialize gelocation values and names to pass to form
      let originValue = {};
      let destinationValue = {};
      let route = {};

      // workflow for geolication based on current position (get coordinates, reverse geolocate and set directions origin)
      document
        .getElementById("current-position")
        .addEventListener("click", e => {
          navigator.geolocation.getCurrentPosition(p => {
            reverseGeocode(
              p.coords.latitude,
              p.coords.longitude,
              mapElement.dataset.mapboxApiKey
            ).then(r => {
              directions.setOrigin(r);
            });
          });
          document.getElementById("current-position").classList.add("hidden");
        });

      //show geolocation button again on origin clear
      directions.on("clear", e => {
        if (e.type === "origin") {
          document
            .getElementById("current-position")
            .classList.remove("hidden");
        }
      });

      // set name coordinates of origin on origin input
      directions.on("origin", e => {
        const origin = document.querySelector(
          "#mapbox-directions-origin-input input"
        );
        let name = origin.value;
        if (
          origin.value.match(
            /^([-+]?)([\d]{1,2})(((\.)(\d+)(,)))(\s*)(([-+]?)([\d]{1,3})((\.)(\d+))?)$/g
          )
        ) {
          name = `localitation départ au : ${origin.value}`;
        }
        document.getElementById("current-position").classList.add("hidden");
        originValue = {
          name: name,
          lat: e.feature.geometry.coordinates[1],
          lng: e.feature.geometry.coordinates[0]
        };
      });

      // set name coordinates of destination on destination input
      directions.on("destination", e => {
        const destination = document.querySelector(
          "#mapbox-directions-destination-input input"
        );
        let name = destination.value;
        if (
          destination.value.match(
            /^([-+]?)([\d]{1,2})(((\.)(\d+)(,)))(\s*)(([-+]?)([\d]{1,3})((\.)(\d+))?)$/g
          )
        ) {
          name = `localitation arrivé au : ${destination.value}`;
        }
        destinationValue = {
          name: name,
          lat: e.feature.geometry.coordinates[1],
          lng: e.feature.geometry.coordinates[0]
        };
      });

      // set form values on route calculation
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
      // on views without the form initiaize mapbox directions with markers and route but without input boxes
      const markers = JSON.parse(mapElement.dataset.markers);
      options.controls.inputs = false;
      options.interactive = false;
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

async function reverseGeocode(lat, lon, token) {
  let address = "";
  await axios
    .get(
      `https://api.mapbox.com/geocoding/v5/mapbox.places/${lon},${lat}.json?access_token=${token}`
    )
    .then(r => {
      address = r.data.features[0].place_name;
    });
  return address;
}

export default initMapboxDirections;
