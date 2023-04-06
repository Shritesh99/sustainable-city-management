FROM golang:alpine AS builder

ENV CGO_ENABLED=0
WORKDIR /build

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .

RUN go build -o app cmd/main.go

WORKDIR /dist

RUN cp /build/app .

FROM ubuntu:latest
RUN apt-get update && apt-get install -y \
    ca-certificates \
    bash

COPY . .

COPY --from=builder /dist/app /

ENTRYPOINT ["/app"]
