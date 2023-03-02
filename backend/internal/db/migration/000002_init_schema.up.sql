CREATE TABLE "aqi_data"
(
    "id"   serial PRIMARY KEY,
    "station_id"  varchar not null ,
    "station_name"  varchar not null,
    "aqi"  float not null,
    "measure_time"  varchar not null,
    "epa" varchar not null ,
    "pm25"  float not null,
    "pm10"  float not null,
    "ozone"  float not null,
    "no2"  float not null,
    "so2"  float not null,
    "co"  float not null,
    "insert_time"  timestamp not null ,
    "updated_time"  timestamp not null,
    "latitude" float not null ,
    "longitude" float not null
);