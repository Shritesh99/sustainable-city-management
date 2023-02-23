import Map, {
  GeolocateControl,
  NavigationControl,
  FullscreenControl,
} from "react-map-gl";
import MapMarker from "./mapMarker";
import MapPopup from "./mapPopup";
import {
  InitialRun,
  MapLoaded,
  MapMarkers,
  Theme,
  ViewState,
} from "../../../utils/atoms";
import "mapbox-gl/dist/mapbox-gl.css";
import { useRecoilState, useRecoilValue } from "recoil";
import { useEffect } from "react";
import { Box } from "@mui/material";
import { toast } from "./toast";
import axios from "axios";
import GeocoderControl from "./geocoder";

const MAPBOX_TOKEN = process.env.MAP_BOX_ACCESS_TOKEN;

export default function MainMap() {
  const [viewState, setViewState] = useRecoilState(ViewState);
  const [initialRun, setInitialRun] = useRecoilState(InitialRun);
  const [mapLoaded, setMapLoaded] = useRecoilState(MapLoaded);
  const globalTheme = useRecoilValue(Theme);
  const [mapMarkers, setMapMarkers] = useRecoilState(MapMarkers);

  useEffect(() => {
    if (initialRun) {
      axios
        .get("https://api.bigdatacloud.net/data/reverse-geocode-client")
        .then((rsp) => {
          const { latitude, longitude } = rsp.data;
          setViewState({
            ...viewState,
            latitude: latitude,
            longitude: longitude,
          });
          setInitialRun(false);
          addMarker(longitude, latitude, true);
        })
        .catch((err) => {
          console.log(err);
          toast({
            title: "An error occurred.",
            description: err.message,
            status: "error",
            duration: 3000,
            isClosable: true,
          });
        });
    }
  }, [initialRun]);

  useEffect(() => {
    if (!mapLoaded) {
      setMapLoaded(true);
      toast({
        title: "Map Loaded Successfully",
        description: "Click to see air quality index",
        status: "success",
        duration: 5000,
        isClosable: true,
      });
    }
  }, [mapLoaded]);

  const addMarker = (lng, lat, removeZero = false) => {
    // get all markers that are on the map
    let index = Object.keys(mapMarkers.markers).length;
    if (removeZero) {
      index = 0;
    }

    setMapMarkers(() => {
      // this is the global MapMarker obj that is stored in the atom.js
      let markers = JSON.parse(JSON.stringify(mapMarkers));
      markers.markers[index] = {
        key: index,
        longitude: lng,
        latitude: lat,
        showPopup: true,
        aqiData: {},
      };
      markers.totalMapMarkers = markers.totalMapMarkers += 1;
      console.log(markers.totalMapMarkers);
      return markers;
    });
  };

  return (
    <Box>
      <Map
        mapboxAccessToken={MAPBOX_TOKEN}
        {...viewState}
        style={{
          width: `calc(100vw - 100px)`,
          height: `calc(100vh - 100px)`,
          zIndex: 0,
          position: "absolute",
        }}
        mapStyle={globalTheme.mapStyle}
        onMove={(evt) => setViewState(evt.viewState)}
        onClick={(evt) => {
          // register event: once map is clicked, add marker based on lat & lng
          addMarker(evt.lngLat.lng, evt.lngLat.lat, false);
        }}
      >
        {mapLoaded &&
          Object.entries(mapMarkers.markers).map(([key, value]) => {
            // render all the markers
            return (
              <Box key={key}>
                <MapMarker
                  longitude={value.longitude}
                  latitude={value.latitude}
                  markerKey={key}
                />
                {/* implement map popup */}
                {mapMarkers.markers[key].showPopup &&
                  mapMarkers.showDefaultPopup && (
                    <MapPopup
                      latitude={value.latitude}
                      longitude={value.longitude}
                      markerKey={key}
                    />
                  )}
              </Box>
            );
          })}

        <GeocoderControl
          mapboxAccessToken={MAPBOX_TOKEN}
          position="top-left"
          addMarker={addMarker}
          viewState={setViewState}
        />
        <GeolocateControl
          showAccuracyCircle={false}
          showUserLocation={false}
          onGeolocate={(evt) => {
            addMarker(evt.coords.longitude, evt.coords.latitude, false);
          }}
          position={"bottom-right"}
        />
        <FullscreenControl position={"bottom-right"} />
        <NavigationControl />
      </Map>
    </Box>
  );
}
