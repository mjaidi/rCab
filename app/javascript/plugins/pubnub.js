import PubNub from "pubnub";
import mapboxgl from "mapbox-gl";
import initMapboxDirections, { map } from "./init_directions.js";
// import mapbox directions from mapbox direction file and import the map on its on to overlay a marker on top of it
initMapboxDirections();
// implementing realtime geolocation of driver using pubnub
const mapElement = document.getElementById("map-dir");

// only run this code on pages with a map
if (mapElement) {
  let lat = 0;
  let lng = 0;

  // initialize marker
  const element = document.createElement("div");
  element.className = "driver-marker";
  const marker = new mapboxgl.Marker(element).setLngLat([lng, lat]).addTo(map);

  //updating marker position
  function setMarker(lat, lng) {
    marker.setLngLat([lng, lat]).addTo(map);
  }

  // geting initial location
  function getLocation() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(updatePosition);
    }
    return null;
  }
  // updating location
  function updatePosition(position) {
    if (position) {
      lat = position.coords.latitude;
      lng = position.coords.longitude;
    }
  }

  // update location on setInterval
  setInterval(function() {
    updatePosition(getLocation());
  }, 5000);

  // message that will be sent with PubNUV
  function currentLocation() {
    return { lat: lat || 0, lng: lng || 0 };
  }

  // FUNCTION FOR SETTING UP PUBNUB
  function pubs() {
    const channel = `map-course-${mapElement.dataset.course}`;
    console.log(channel);
    const pubnub = new PubNub({
      publishKey: "pub-c-e5ec906f-6f05-4111-9b18-1bb39b99da9f",
      subscribeKey: "sub-c-eb3ea4c0-200a-11ea-92cf-86076a99d5da"
    });
    pubnub.subscribe({
      channels: [channel]
    });

    // listen to messages from channel and set driver marker
    pubnub.addListener({
      message: function(m) {
        console.log(m);
        lat = m.message["lat"];
        lng = m.message["lng"];
        setMarker(lat, lng);
      }
    });

    // set last known location of driver
    pubnub.history(
      {
        channel: channel,
        count: 100, // how many items to fetch
        stringifiedTimeToken: true
      },
      function(status, response) {
        // handle status, response
        const messages = response.messages;
        if (messages.length > 0) {
          setMarker(
            messages[messages.length - 1].entry["lat"],
            messages[messages.length - 1].entry["lng"]
          );
        }
      }
    );

    // publish a message if I am a driver telling the channel what my current location is
    if (mapElement.dataset.driver === "true") {
      setInterval(function() {
        pubnub.publish({
          channel: channel,
          message: currentLocation(),
          storeInHistory: true
        });
      }, 5000);
    }
  }

  // run only on map of current course not on map where user is setting the course
  if (mapElement.dataset.withInputs !== "true") {
    pubs();
  }
}
