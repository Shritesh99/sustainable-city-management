
GOPATH:=$(shell go env GOPATH)
.PHONY: init
init:
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install github.com/micro/micro/v3/cmd/protoc-gen-micro@latest
	go install github.com/micro/micro/v3/cmd/protoc-gen-openapi@latest

.PHONY: proto
proto:
	protoc -I=proto/ --go_out=pb/ --go-grpc_out=pb/ proto/**/*.proto

.PHONY: docker
docker-build:
	docker build . -t air -f cmd/air/Dockerfile
	docker build . -t bin -f cmd/bin/Dockerfile
	docker build . -t bus -f cmd/bus/Dockerfile
	docker build . -t bike -f cmd/bike/Dockerfile
	docker build . -t gateway -f cmd/gateway/Dockerfile