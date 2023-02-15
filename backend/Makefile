GOPATH:=$(shell go env GOPATH)
.PHONY:
init:
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install github.com/micro/micro/v3/cmd/protoc-gen-micro@latest
	go install github.com/micro/micro/v3/cmd/protoc-gen-openapi@latest

.PHONY: proto
proto:
	protoc -I=proto/ --go_out=pb/ --go-grpc_out=pb/ proto/**/*.proto

.PHONY: docker
docker-build:
	docker build . -t asecr.azurecr.io/shritesh99/air:latest
	docker build . -t asecr.azurecr.io/shritesh99/bin:latest
	docker build . -t asecr.azurecr.io/shritesh99/bus:latest
	docker build . -t asecr.azurecr.io/shritesh99/bike:latest
	docker build . -t asecr.azurecr.io/shritesh99/gateway:latest

docker-upload:
	docker push asecr.azurecr.io/shritesh99/air:latest
	docker push asecr.azurecr.io/shritesh99/bin:latest
	docker push asecr.azurecr.io/shritesh99/bus:latest
	docker push asecr.azurecr.io/shritesh99/bike:latest
	docker push asecr.azurecr.io/shritesh99/gateway:latest

FILES := $(shell docker ps -aq)

down-local:
	docker stop $(FILES)
	docker rm $(FILES)

# develop:
# 	docker-compose -f docker-compose.yaml up -d --build

install_all:
	kubens default
	helm repo update
	helm install monitoring prometheus-community/kube-prometheus-stack
	helm install -f deployment/values.yaml sustinable-city-management deployment/

uninstall_all:
	kubens default
	helm uninstall monitoring
	helm uninstall sustinable-city-management

port_forward_microservice:
	kubens default
	kubectl port-forward services/gateway-microservice-service 8000:8000

minikube_start:
	minikube start --memory 16000 --cpus 4

grafana_password:
	kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo	
