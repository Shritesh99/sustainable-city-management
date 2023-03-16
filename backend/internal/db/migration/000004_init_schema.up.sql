CREATE TABLE "noise_data"
(
    "monitor_id"     int PRIMARY KEY,
    "location"      varchar not null,
    "latitude"      varchar not null,
    "longitude"     varchar not null,
    "record_time"    varchar not null,
    "laeq"          float   not null,
    "current_rating" int     not null,
    "daily_avg"      float   not null,
    "hourly_avg"     float   not null
);