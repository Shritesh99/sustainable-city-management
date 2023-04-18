CREATE TABLE "noise_data"
(
    "monitor_id"     int PRIMARY KEY,
    "location"       varchar not null,
    "latitude"       float not null,
    "longitude"      float not null,
    "record_time"    varchar not null,
    "laeq"           float   not null,
    "current_rating" int     not null,
    "daily_avg"      float   not null,
    "hourly_avg"     float   not null
);