CREATE TABLE "pedestrian_data"
(
    "id"            serial PRIMARY KEY,
    "location_name" varchar   not null,
    "total"         int       not null,
    "longitude"     float     not null,
    "latitude"      float     not null,
    "counter_time"  timestamp not null,
    "insert_time"   timestamp not null,
    "update_time"   timestamp not null
);