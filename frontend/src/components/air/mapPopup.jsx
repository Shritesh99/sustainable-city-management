import { Popup } from "react-map-gl";
import { useRecoilState } from "recoil";
import { MapMarkers } from "../../../utils/atoms";
import React, { memo } from "react";
import axios from "axios";
import { toast } from "./toast";
import {
  Container,
  Tooltip,
  Typography,
  Popover,
  Portal,
  List,
  ListItem,
  Grid,
  Divider,
  ListItemText,
  Stack,
} from "@mui/material/";
import { Info, QuestionMark } from "@mui/icons-material";
import MuiLink from "@mui/material/Link";
import { useState } from "react";

const AQI_ACCESS_TOKEN = process.env.AQI_ACCESS_TOKEN;

function MapPopup(props) {
  const [mapMarkers, setMapMarkers] = useRecoilState(MapMarkers);
  const [anchorEl, setAnchorEl] = useState(null);

  const handlePopoverOpen = (evt) => {
    setAnchorEl(evt.currentTarget);
  };

  const handlePopoverClose = () => {
    setAnchorEl(null);
  };

  const openAnchor = Boolean(anchorEl);

  const getAQI = (key, lat, lng) => {
    // prevent re-request
    if (Object.keys(mapMarkers.markers[key].aqiData).length === 0) {
      axios
        .get(
          `https://api.waqi.info/feed/geo:${lat};${lng}/?token=${AQI_ACCESS_TOKEN}`
        )
        .then((rsp) => {
          // push aqi data into the marker
          setMapMarkers(() => {
            let markers = JSON.parse(JSON.stringify(mapMarkers));
            console.log("aqidata: ", rsp.data);
            markers.markers[key].aqiData = rsp.data.data;
            return markers;
          });
        })
        .catch((err) => {
          console.log(err);
          toast({
            title: "An error occurred.",
            description: err.message,
            status: "error",
            duration: 5000,
            isClosable: true,
          });
        });
    }
    return mapMarkers.markers[key];
  };

  const marker = getAQI(props.markerKey, props.latitude, props.longitude);
  const markerProps = {};
  const aqiData = marker.aqiData;
  const aqi = parseInt(aqiData.aqi);

  if (aqi <= 50) {
    markerProps["background"] = "#38A169";
    markerProps["tooltipLabel"] = "Good";
  } else if (aqi <= 100) {
    markerProps["background"] = "#D69E2E";
    markerProps["tooltipLabel"] = "Moderate";
  } else if (aqi <= 150) {
    markerProps["background"] = "#DD6B20";
    markerProps["tooltipLabel"] = "Unhealthy for Sensitive Groups";
  } else if (aqi <= 200) {
    markerProps["background"] = "#E53E3E";
    markerProps["tooltipLabel"] = "Unhealthy";
  } else if (aqi <= 300) {
    markerProps["background"] = "#805AD5";
    markerProps["tooltipLabel"] = "Very Unhealthy";
  } else if (aqi > 300) {
    markerProps["background"] = "#822727";
    markerProps["tooltipLabel"] = "Hazardous";
  }

  return (
    <Popup
      latitude={props.latitude}
      longitude={props.longitude}
      closeOnClick={mapMarkers.hidePopupOnClick}
      closeOnMove={mapMarkers.hidePopupOnClick}
      onClose={() => {
        setMapMarkers(() => {
          let markers = JSON.parse(JSON.stringify(mapMarkers));
          markers.markers[props.markerKey].showPopup = false;
          return markers;
        });
      }}
      closeButton={true}
      offset={0}
      focusAfterOpen={false}
    >
      <Container
        sx={{
          alignContent: "center",
          padding: "6px",
          background: `${markerProps.background}`,
          borderRadius: "8px",
        }}
      >
        {!isNaN(aqiData.aqi) ? (
          <Stack direction="row">
            <Tooltip title={`${markerProps.tooltipLabel}`} arrow>
              <Typography variant="h3">{aqiData.aqi}</Typography>
            </Tooltip>
            <Info
              // define the anchor of this popup info
              aria-owns={openAnchor ? "mouse-over-popover" : undefined}
              aria-haspopup="true"
              onMouseEnter={handlePopoverOpen}
              onMouseLeave={handlePopoverClose}
            />
            <Popover
              id="mouse-over-popover"
              sx={{ pointerEvents: "none" }}
              open={openAnchor}
              anchorEl={anchorEl}
              anchorOrigin={{ vertical: "top", horizontal: "right" }}
              transformOrigin={{ vertical: "bottom", horizontal: "left" }}
              onClose={handlePopoverClose}
              disableRestoreFocus
            >
              <Portal>
                <List>
                  <ListItem>
                    <ListItemText primary={`Station: ${aqiData.city.name}`} />
                  </ListItem>
                  <Divider light />
                  <ListItem>
                    <Grid columns={3} container spacing="2px">
                      {Object.entries(aqiData.iaqi).map(([key, value]) => {
                        return (
                          <Stack key={key} direction="row" spacing="2px">
                            <Typography variant={"h6"}>{key}:</Typography>
                            <Typography>
                              {parseFloat(value.v).toFixed(2)}
                            </Typography>
                          </Stack>
                        );
                      })}
                    </Grid>
                  </ListItem>
                  <Divider light />
                  <ListItem>
                    <MuiLink href={aqiData.attributions[0].url}>
                      {aqiData.attributions[0].name}
                    </MuiLink>
                  </ListItem>
                  <Divider light />
                </List>
              </Portal>
            </Popover>
          </Stack>
        ) : (
          <Tooltip title={"Data not found"} arrow>
            <span>
              <QuestionMark />
            </span>
          </Tooltip>
        )}
      </Container>
    </Popup>
  );
}

export default memo(MapPopup);
