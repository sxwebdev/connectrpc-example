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

markdown:
	go run -v ./cmd/app --markdown --file ENVS.md

validate:
	go run -v ./cmd/app --validate

fmt:
	gofumpt -l -w .

upgrade:
	GOWORK=off go-mod-upgrade
	go mod tidy

.PHONY: genproto
genproto:
	rm -rf pb/*
	rm -rf gen
	protoc \
	--go_opt=module=$(MODULE) \
	--go-grpc_opt=module=$(MODULE) \
	--go_out=. \
	--go-grpc_out=. \
	$(PROTO_FILES)

buf:
	rm -rf pb/*
	buf generate --path ./schema/proto \
		--config ./schema/proto/buf.yaml \
		--template ./schema/proto/buf.gen.yaml

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
