export GOBIN := $(shell go env GOPATH)/bin

tools:
	test -x $(GOBIN)/packer-plugin-arm-image || go install github.com/solo-io/packer-plugin-arm-image@c70b0d92efd9
	test -x $(GOBIN)/packer || go install github.com/hashicorp/packer@v1.7.6

image:
	packer build template.pkr.hcl

flash:
	flasher
