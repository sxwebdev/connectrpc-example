-include .env

MODULE           = $(shell go list -m)
PROTO_FILES      = $(wildcard ./schema/**/**/*.proto)
COPYRIGHT_YEARS	:= 2024
LICENSE_IGNORE	:= --ignore /testdata/

start:
	go run ./cmd/app/main.go

build:
	go build -o ./.build/app -v ./cmd/app

watch:
	air -c .air.toml

fmt:
	gofumpt -l -w .

gen:
	rm -rf pb/*
	buf generate
	license-header \
		--license-type apache \
		--copyright-holder "sxwebdev" \
		--year-range "$(COPYRIGHT_YEARS)" $(LICENSE_IGNORE)

grpcui:
	grpcui --plaintext --reflect-header "authorization: bearer foobar" :8080

%:
	@:
