FROM golang:alpine AS builder
WORKDIR /app

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .

RUN CGO_ENABLED=0 go build -o bin cmd/bin-service/main.go

FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/bin .
EXPOSE 8080
CMD ["./bin"]