CREATE TABLE "bus_data"
(
    "vehicle_id"   int PRIMARY KEY,
    "latitude"     float   not null,
    "longitude"    float   not null,
    "route_id"     varchar not null,
    "direction_id" varchar not null,
    "detail"       varchar not null
);