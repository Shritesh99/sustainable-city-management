# syntax=docker/dockerfile:1

## Build
FROM golang:1.19.5-buster AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./
RUN go mod download

COPY . ./

RUN go build -o /hidocker

## Deploy
FROM gcr.io/distroless/base-debian10

WORKDIR /

COPY --from=build /hidocker /hidocker
COPY --from=build /app/*.env .

EXPOSE 8080

USER nonroot:nonroot

ENTRYPOINT ["./hidocker"]