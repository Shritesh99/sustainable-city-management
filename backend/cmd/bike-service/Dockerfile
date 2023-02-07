FROM golang:alpine AS builder
WORKDIR /app

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 go build -o bike cmd/bike-service/main.go

FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/bike .
EXPOSE 8080
CMD ["./bike"]