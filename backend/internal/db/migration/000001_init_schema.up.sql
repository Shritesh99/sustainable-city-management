CREATE TABLE "users" (
  "user_id" serial PRIMARY KEY,
  "first_name" text NOT NULL,
  "last_name" text NOT NULL
);

CREATE TABLE "login_details" (
  "role_id" int NOT NULL,
  "user_id" int NOT NULL,
  "email" varchar(100) PRIMARY KEY,
  "password" varchar(100) NOT NULL
);

CREATE TABLE "roles" (
  "role_id" serial PRIMARY KEY,
  "role_name" text NOT NULL
);

ALTER TABLE "login_details" ADD FOREIGN KEY ("role_id") REFERENCES "roles" ("role_id");

ALTER TABLE "login_details" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("user_id");
