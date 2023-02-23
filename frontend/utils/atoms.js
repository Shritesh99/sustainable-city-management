import { atom } from "recoil";

export const ViewState = atom({
  key: "viewState",
  default: {
    latitude: 53.35014,
    longitude: -6.266155,
    zoom: 5.5,
  },
});

export const Theme = atom({
  key: "theme",
  default: {
    themeStyle: "light",
    mapStyle: "mapbox://styles/mapbox/streets-v11",
  },
});

export const MapLoaded = atom({
  key: "isMapLoaded",
  default: false,
});

export const InitialRun = atom({
  key: "initialRun",
  default: true,
});

export const MapMarkers = atom({
  key: "mapMarkers",
  default: {
    totalMapMarkers: 1,
    showDefaultPopup: true,
    hidePopupOnClick: false,
    markers: {
      0: {
        key: 0,
        longitude: 40.866667,
        latitude: 34.566667,
        showPopup: true,
        aqiData: {},
      },
    },
  },
});
