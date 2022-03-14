#!/bin/bash

set -e

CGO_ENABLED=0 GOARCH=arm go build -o jezdzikd cmd/jezdzikd/main.go
go build -o jezdzikctl cmd/jezdzikctl/main.go
