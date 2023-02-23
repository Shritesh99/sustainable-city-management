import { useControl } from "react-map-gl";
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder";
import "@mapbox/mapbox-gl-geocoder/dist/mapbox-gl-geocoder.css";
import { toast } from "./toast";

export default function GeocoderControl(props) {
  useControl(() => {
    const geocoder = new MapboxGeocoder({
      ...props,
      marker: false,
      accessToken: props.mapboxAccessToken,
    });
    // subscribe to the events and do sth.
    geocoder.on("loading", props.onLoading);
    geocoder.on("results", props.onResults);
    geocoder.on("result", (evt) => {
      // the event is the result of a search query
      const { result } = evt;
      const location =
        result &&
        (result.center ||
          (result.geometry?.type === "Point" && result.geometry.coordinates));
      if (location && props.marker) {
        props.addMarker(location[0], location[1], false);
        props.viewState({
          latitude: location[1],
          longitude: location[0],
          zoom: 5.5,
        });
      } else {
        toast({
          title: "An error occurred.",
          description: "Couldn't add marker to specified location",
          status: "error",
          duration: 3000,
          isClosable: true,
        });
      }
    });
    geocoder.on("error", props.onError);
    return geocoder;
  });
}

const noOperation = () => {};

GeocoderControl.defaultProps = {
  marker: true,
  onLoading: noOperation,
  onResults: noOperation,
  onResult: noOperation,
  onError: noOperation,
};
