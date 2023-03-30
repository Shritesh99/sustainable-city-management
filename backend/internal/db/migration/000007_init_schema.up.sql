CREATE TABLE "bike_data"
(
    "id"               int PRIMARY KEY,
    "contract_name"    varchar   not null,
    "name"             varchar   not null,
    "address"          varchar   not null,
    "latitude"         float     not null,
    "longitude"        float     not null,
    "status"           varchar   not null,
    "last_update"      timestamp not null,
    "bikes"            int       not null,
    "stands"           int       not null,
    "mechanical_bikes" int       not null,
    "electrical_bikes" int       not null
);