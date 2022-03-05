image:
	packer init template.pkr.hcl
	sudo -H env PATH=$(PATH) packer build template.pkr.hcl

flash:
	test -x $(GOBIN)/packer-plugin-arm-image || go install github.com/solo-io/packer-plugin-arm-image@c70b0d92efd9
	flasher
