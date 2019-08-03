import mapboxgl from 'mapbox-gl';

const initMapbox = () => {
  const mapElement = document.getElementById('map');

  const fitMapToMarkers = (map, markers) => {
    const bounds = new mapboxgl.LngLatBounds();
    bounds.extend([ markers.start_address.lng, markers.start_address.lat ]);
    bounds.extend([ markers.end_address.lng, markers.end_address.lat ]);
    map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 });
  };

  if (mapElement) { // only build a map if there's a div#map to inject into
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
    const map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v10'
    });

    const markers = JSON.parse(mapElement.dataset.markers);
    new mapboxgl.Marker()
      .setLngLat([ markers.start_address.lng, markers.start_address.lat ])
      .addTo(map);
    new mapboxgl.Marker()
      .setLngLat([ markers.end_address.lng, markers.end_address.lat ])
      .addTo(map);

    fitMapToMarkers(map, markers);
  }
};

export { initMapbox };
