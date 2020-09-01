import mapboxgl from "mapbox-gl";
import axios from "axios";
import initMapboxDirections, { map } from "./init_directions.js";
import createChannel from "../cable/setup";

// Axios Config
const csrfToken = document.querySelector('meta[name="csrf-token"]').attributes
  .content.value;
const config = {
  headers: {
    Accept: "application/json",
    "Content-Type": "application/json",
    "X-CSRF-Token": csrfToken
  },
  credentials: "same-origin"
};

// import mapbox directions from mapbox direction file and import the map on its on to overlay a marker on top of it
initMapboxDirections();
// implementing realtime geolocation of driver using pubnub
const mapElement = document.getElementById("map-dir");

// only run this code on pages with a map
if (mapElement && mapElement.dataset.withInputs === "false") {
  let last_lat =
    new Date() - new Date(mapElement.dataset.driverLastUpdate) > 300000
      ? 0
      : parseFloat(mapElement.dataset.driverLastLat) || 0;
  let last_lng =
    new Date() - new Date(mapElement.dataset.driverLastUpdate) > 300000
      ? 0
      : parseFloat(mapElement.dataset.driverLastLng) || 0;
  // initialize marker
  const element = document.createElement("div");
  element.className = "driver-marker";
  const marker = new mapboxgl.Marker(element)
    .setLngLat([last_lng, last_lat])
    .addTo(map);

  //updating marker position
  function setMarker(lat, lng) {
    marker.setLngLat([lng, lat]).addTo(map);
  }

  // for updating position when getting new coordinates
  function setLocation(position) {
    last_lat = position.coords.latitude;
    last_lng = position.coords.longitude;
    const formData = {
      user: {
        last_lat,
        last_lng
      },
      course_id: mapElement.dataset.course
    };
    axios
      .patch(
        `/api/v1/users/${mapElement.dataset.driverId}/set_location`,
        formData,
        config
      )
      .then(r => console.log(r));
  }

  // FUNCTION FOR SETTING UP ActionCable geolocation
  function location() {
    createChannel(
      { channel: "LocationChannel", id: mapElement.dataset.course },
      {
        received({ lat, lng }) {
          console.log(lat, lng);
          last_lat = lat;
          last_lng = lng;
          setMarker(last_lat, last_lng);
        }
      }
    );

    // publish a message if I am a driver telling the channel what my current location is
    if (mapElement.dataset.driver === "true") {
      setInterval(() => {
        if (navigator.geolocation) {
          navigator.geolocation.getCurrentPosition(setLocation, () => {}, {
            enableHighAccuracy: true
          });
        }
      }, 10000);
    }
  }

  // run only on map of current course not on map where user is setting the course
  if (mapElement.dataset.stream === "true") {
    location();
  }
}
