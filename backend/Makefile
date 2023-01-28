# start the application
server:
	go run main.go

# for database migration
migrateup:
	migrate -path db/migration -database "postgresql://group_admin:group007@sustainable-city-management.cdxqy8kbzxjs.eu-west-1.rds.amazonaws.com:5432/masterdb?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://group_admin:group007@sustainable-city-management.cdxqy8kbzxjs.eu-west-1.rds.amazonaws.com:5432/masterdb?sslmode=disable" -verbose down

# database migration only for github actions
action_migrateup:
	migrate -path db/migration -database "postgresql://group_admin:group007@localhost:5432/masterdb?sslmode=disable" -verbose up

# action_migratedown:
# 	migrate -path db/migration -database "postgresql://group_admin:group007@localhost:5432/masterdb?sslmode=disable" -verbose down 

# generate sql code based on sql script stored at db/query
sqlc:
	sqlc generate

# run all test
test:
	go test -v -cover ./...

.PHONY: server migrateup migratedown sqlc test action_migrateup