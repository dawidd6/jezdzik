.PHONY: build
.ONESHELL:
build:
	sudo bash <<'EOF'
		export PATH="$(PATH):/bin:/sbin"
		export PACKER_CACHE_DIR="$(CURDIR)/.packer-cache"
		export PACKER_PLUGIN_PATH="$(CURDIR)/.packer-plugins"
		packer init .
		packer build -var-file config.json .
		chmod -R 777 jezdzik.img "$$PACKER_PLUGIN_PATH" "$$PACKER_CACHE_DIR"
	EOF

.PHONY: flash
.ONESHELL:
flash:
ifndef DEVICE
	$(error DEVICE is undefined)
endif
	sudo bash <<'EOF'
		pv --sync < jezdzik.img > '$(DEVICE)'
	EOF
