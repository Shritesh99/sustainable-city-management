import React, { memo } from "react";
import { Marker } from "react-map-gl";
import { useRecoilState } from "recoil";
import { MapMarkers } from "../../../utils/atoms";

function MapMarker(props) {
  const [mapMarkers, setMapMarkers] = useRecoilState(MapMarkers);
  return (
    <Marker
      longitude={props.longitude}
      latitude={props.latitude}
      onClick={(evt) => {
        evt.originalEvent.stopPropagation();
        setMapMarkers(() => {
          let markers = JSON.parse(JSON.stringify(mapMarkers));
          markers.markers[props.markerKey].showPopup = true;
          return markers;
        });
      }}
    />
  );
}

export default memo(MapMarker);
