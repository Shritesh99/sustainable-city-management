CREATE TABLE "bus_data"
(
    "vehicle_id"   varchar PRIMARY KEY,
    "latitude"     float   not null,
    "longitude"    float   not null,
    "route_id"     varchar not null,
    "direction_id" int not null
);