#!/usr/bin/env bash

set -ex

git config --global --add safe.directory $PWD

export CGO_ENABLED=0
export BUILD_VERSION=${VERSION:-v3.11.12}

LDFLAGS=(
  "-w -s"
  "-X yunion.io/x/onecloud-operator/pkg/version.Version=${BUILD_VERSION}"
)

export GOARCH=amd64
go build -o ./_output/bin/onecloud-controller-manager-${GOARCH} -ldflags "${LDFLAGS[*]}" cmd/onecloud-operator/main.go

export GOARCH=arm64
go build -o ./_output/bin/onecloud-controller-manager-${GOARCH} -ldflags "${LDFLAGS[*]}" cmd/onecloud-operator/main.go
