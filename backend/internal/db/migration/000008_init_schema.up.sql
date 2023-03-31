CREATE TABLE "pedestrian_data"
(
    "id"          serial PRIMARY KEY,
    "street_name" varchar   not null,
    "latitude"    float     not null,
    "longitude"   float     not null,
    "time"        timestamp not null,
    "amount"      int       not null
);