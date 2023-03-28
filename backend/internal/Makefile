# for database migration
# generate migrate up and down sql file
generate_migrate:
	migrate create -ext sql -dir db/migration -seq init_schema

migrateup:
	migrate -path db/migration -database "postgresql://group_admin:group007@18.202.24.40:5432/masterdb?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://group_admin:group007@18.202.24.40:5432/masterdb?sslmode=disable" -verbose down

# There's a param need to be changed at the last of this command.(Version)
migrategoto:
	migrate -path db/migration -database "postgresql://group_admin:group007@18.202.24.40:5432/masterdb?sslmode=disable" -verbose goto 5

# database migration only for github actions
action_migrateup:
	migrate -path db/migration -database "postgresql://group_admin:group007@18.202.24.40:5432/masterdb?sslmode=disable" -verbose up

# action_migratedown:
# 	migrate -path db/migration -database "postgresql://postgres:password@ec2-54-75-62-18.eu-west-1.compute.amazonaws.com:5432/city_management?sslmode=disable" -verbose down

# generate sql code based on sql script stored in db/query
sqlc:
	sqlc generate
