import { Map, GoogleApiWrapper, Marker } from "google-maps-react";
import { useState, useEffect } from "react";

function MapContainer(props) {
  const [position, setPosition] = useState({ lat: null, lng: null });

  useEffect(() => {
    if (navigator.geolocation) {
      navigator.geolocation.watchPosition((pos) => {
        const { latitude, longitude } = pos.coords;
        setPosition({ lat: latitude, lng: longitude });
      });
    }
  }, []);

  return (
    <Map google={props.google} zoom={14} center={position}>
      <Marker position={position} />
    </Map>
  );
}

export default GoogleApiWrapper({
  apiKey: "AIzaSyA286L9wrNlZcoijdgS6kBpf0ctDza6zYg",
})(MapContainer);
