CREATE TABLE "aqi_forecast"
(
    "station_id"    varchar PRIMARY KEY,
    "forecast_time" timestamp not null,
    "aqi"           float     not null,
    "pm25"          float     not null,
    "pm10"          float     not null,
    "ozone"         float     not null,
    "no2"           float     not null,
    "so2"           float     not null,
    "co"            float     not null,
    "latitude"      float     not null,
    "longitude"     float     not null
);