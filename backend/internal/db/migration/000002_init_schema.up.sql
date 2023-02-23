CREATE TABLE "air_data"
(
    "id"        serial PRIMARY KEY,
    "long"      float NOT NULL,
    "lati"      float NOT NULL,
    "timestamp" int   NOT NULL,
    "detail"    text  NOT NULL
);