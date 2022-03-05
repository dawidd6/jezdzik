export GOBIN := $(shell go env GOPATH)/bin
export PATH := $(GOBIN):$(PATH)

image:
	packer init template.pkr.hcl
	packer build template.pkr.hcl

flash:
	test -x $(GOBIN)/packer-plugin-arm-image || go install github.com/solo-io/packer-plugin-arm-image@c70b0d92efd9
	flasher
