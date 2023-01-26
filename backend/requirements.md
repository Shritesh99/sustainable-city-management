# Requirements for backend

Develop on branch: backend

## Download and Install Go

https://go.dev/doc/install --- Go version: 1.19

## IDE

VScode with Go(v0.37.1) extension

## RESTful HTTP Framework

Fiber - https://docs.gofiber.io/

configuration - https://docs.gofiber.io/api/fiber#config

install fiber with command: go get github.com/gofiber/fiber/v2

## tool for reading configurations from config file or environment variables

viper - https://github.com/spf13/viper
install viper with command: go get github.com/spf13/viper

## Makefile

Common command line should be included in the Makefile file
e.g. using 'make server' simply starts the application
