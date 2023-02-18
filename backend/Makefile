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
	docker build . -t shritesh99/air:latest
	docker build . -t shritesh99/bin:latest
	docker build . -t shritesh99/bus:latest
	docker build . -t shritesh99/bike:latest
	docker build . -t shritesh99/gateway:latest

docker-upload:
	docker push shritesh99/air:latest
	docker push shritesh99/bin:latest
	docker push shritesh99/bus:latest
	docker push shritesh99/bike:latest
	docker push shritesh99/gateway:latest

FILES := $(shell docker ps -aq)

down-local:
	docker stop $(FILES)
	docker rm $(FILES)

# develop:
# 	docker-compose -f docker-compose.yaml up -d --build

install_monitoring:
	kubens default
	helm repo update
	helm install monitoring prometheus-community/kube-prometheus-stack

create_namespace_certi:
	kubectl create namespace cert-manager

install_certi:
	kubens cert-manager
	helm repo update
	helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.10.1 --set installCRDs=true

install_ingress:
	kubens default
	helm repo update
	helm install nginx-ingress ingress-nginx/ingress-nginx --set controller.publishService.enabled=true

install_app:
	kubens default
	helm repo update
	helm install -f deployment/values.yaml sustinable-city-management deployment/

uninstall_monitoring:
	kubens default
	helm uninstall monitoring

uninstall_certi:
	kubens cert-manager
	helm uninstall cert-manager

uninstall_ingress:
	kubens default
	helm uninstall nginx-ingress

uninstall_app:
	kubens default
	helm uninstall sustinable-city-management