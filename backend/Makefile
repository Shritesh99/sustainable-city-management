# start the application
server:
	go run main.go

# for database migration
# generate migrate up and down sql file
generate_migrate:
	migrate create -ext sql -dir db/migration -seq init_schema

migrateup:
	migrate -path db/migration -database "postgresql://group_admin:group007@sustainable-city-management.cdxqy8kbzxjs.eu-west-1.rds.amazonaws.com:5432/masterdb?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://group_admin:group007@sustainable-city-management.cdxqy8kbzxjs.eu-west-1.rds.amazonaws.com:5432/masterdb?sslmode=disable" -verbose down

# database migration only for github actions
action_migrateup:
	migrate -path db/migration -database "postgresql://group_admin:group007@localhost:5432/masterdb?sslmode=disable" -verbose up

# action_migratedown:
# 	migrate -path db/migration -database "postgresql://group_admin:group007@localhost:5432/masterdb?sslmode=disable" -verbose down 

# generate sql code based on sql script stored in db/query
sqlc:
	sqlc generate

# run all test
test:
	go test -v -cover ./...

local:
	@echo Clearing prometheus data
	rm -rf ./prometheus
	@echo Starting local docker compose
	docker-compose -f docker-compose.yaml up -d --build

# Docker support

FILES := $(shell docker ps -aq)

down-local:
	docker-compose down
clean:
	docker system prune -f

logs-local:
	docker logs -f $(FILES)
# using proto plugin to generate golang code
proto:
	rm -f pb/*.go
	protoc --proto_path=proto --go_out=pb --go_opt=paths=source_relative \
        --go-grpc_out=pb --go-grpc_opt=paths=source_relative \
        proto/*.proto

.PHONY: server generate_migrate migrateup migratedown sqlc test action_migrateup proto
