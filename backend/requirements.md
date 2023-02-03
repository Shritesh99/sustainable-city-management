# Requirements for backend

Develop on branch: backend

## Download and Install Go

https://go.dev/doc/install --- Go version: 1.19

Add `$GOPATH` to your `PATH` (for macOS add following to ~/.bashrc or ~/.zshrc):

```
# go
export GOPATH=$(go env GOPATH)
export PATH="$PATH:$GOPATH/bin"
```

## IDE

VScode with Go(v0.37.1) extension

## RESTful HTTP Framework

Fiber - https://docs.gofiber.io/
configuration - https://docs.gofiber.io/api/fiber#config
install with command: go get github.com/gofiber/fiber/v2

## tool for reading configurations from config file or environment variables

viper - https://github.com/spf13/viper
install with command:

```
go get github.com/spf13/viper
```

## Makefile

Common command lines should be included in the Makefile file
e.g. using `make server` simply starts the application

# GO MICRO

https://micro.dev
After installment, if there occur `command not found` error, add `$GOPATH` to your PATH

## Database middleware

sqlc - https://github.com/kyleconroy/sqlc/tree/v1.16.0
see configuration - https://docs.sqlc.dev/en/latest/reference/config.html

## Database migration

golang-migrate - https://github.com/golang-migrate/migrate
for installation check - https://github.com/golang-migrate/migrate/tree/master/cmd/migrate

## unitest

golang testify - https://github.com/stretchr/testify
install with command: go get github.com/stretchr/testify

## Local running the server

make local

## Stopping the server

make down-local
