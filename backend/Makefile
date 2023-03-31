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
	docker build . -t shritesh99/scm:latest

docker-upload:
	docker push shritesh99/scm:latest

run-app:
	go run cmd/main.go

kill-app:
	kill -9 $(lsof -ti :8000)
FILES := $(shell docker ps -aq)

down-local:
	docker stop $(FILES)
	docker rm $(FILES)

develop:
	docker-compose -f docker-compose.yaml up -d --build

stop-develop:
	docker-compose -f docker-compose.yaml down

install_monitoring:
	kubens default
	helm repo update
	helm install monitoring prometheus-community/kube-prometheus-stack

create_namespace:
	kubectl create namespace ingress-nginx
	kubectl create namespace cert-manager

install_certi:
	kubens cert-manager
	helm repo update
	helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.10.1 --set installCRDs=true

install_cretificate:
	kubens cert-manager
	kubectl apply -f deployment/certificate_issuer.yaml

install_ingress:
	kubens ingress-nginx
	helm repo update
	helm install nginx-ingress --namespace=ingress-nginx ingress-nginx/ingress-nginx --set controller.publishService.enabled=true 

install_app:
	kubens default
	helm repo update
	helm install -f deployment/services/values.yaml scm deployment/services

upgrade_app:
	kubens default
	helm repo update
	helm upgrade -f deployment/services/values.yaml scm deployment/services

uninstall_monitoring:
	kubens default
	helm uninstall monitoring

uninstall_certi:
	kubens cert-manager
	helm uninstall cert-manager

uninstall_ingress:
	kubens ingress-nginx
	helm uninstall nginx-ingress

uninstall_app:
	kubens default
	helm uninstall scm

ci_install_app:
	helm install -f deployment/services/values.yaml scm deployment/services --namespace default

ci_uninstall_app:
	helm uninstall scm --namespace default