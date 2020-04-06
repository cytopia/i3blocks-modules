ifneq (,)
.error This Makefile requires GNU Make.
endif

# -------------------------------------------------------------------------------------------------
# Default configuration
# -------------------------------------------------------------------------------------------------
.PHONY: help lint install uninstall

# Configuration
SHELL = /bin/sh
MKDIR_P = mkdir -p

FL_VERSION = 0.3
FL_IGNORES = .git/,.github/

# -------------------------------------------------------------------------------------------------
# Default Target
# -------------------------------------------------------------------------------------------------
help:
	@echo "Type 'make install' or 'make uninstall'"
	@echo
	@echo "make install"
	@echo "   Will install files to ~/.config/i3blocks-modules"
	@echo ""
	@echo "make uninstall"
	@echo "   Will uninstall files from ~/.config/i3blocks-modules"


# -------------------------------------------------------------------------------------------------
# Targets
# -------------------------------------------------------------------------------------------------
lint:
	@$(MAKE) --no-print-directory _lint-file
	@$(MAKE) --no-print-directory _lint-bash

_lint-file: _pull-docker-filelint
	@# Lint all files
	@echo "################################################################################"
	@echo "# File lint"
	@echo "################################################################################"
	@docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/data cytopia/file-lint:$(FL_VERSION) file-cr --text --ignore '$(FL_IGNORES)' --path .
	@docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/data cytopia/file-lint:$(FL_VERSION) file-crlf --text --ignore '$(FL_IGNORES)' --path .
	@docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/data cytopia/file-lint:$(FL_VERSION) file-trailing-single-newline --text --ignore '$(FL_IGNORES)' --path .
	@docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/data cytopia/file-lint:$(FL_VERSION) file-trailing-space --text --ignore '$(FL_IGNORES)' --path .
	@docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/data cytopia/file-lint:$(FL_VERSION) file-utf8 --text --ignore '$(FL_IGNORES)' --path .
	@docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/data cytopia/file-lint:$(FL_VERSION) file-utf8-bom --text --ignore '$(FL_IGNORES)' --path .
	@echo

_lint-bash: _pull-docker-shellcheck
	@# Lint all files
	@echo "################################################################################"
	@echo "# File bash"
	@echo "################################################################################"
	docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/mnt koalaman/shellcheck:stable --exclude=SC2034 --shell=bash modules/backlight
	docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/mnt koalaman/shellcheck:stable --exclude=SC2034 --shell=bash modules/battery
	docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/mnt koalaman/shellcheck:stable --exclude=SC2034 --shell=bash modules/bitcoin
	docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/mnt koalaman/shellcheck:stable --exclude=SC2034 --shell=bash modules/bitcoincash
	docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/mnt koalaman/shellcheck:stable --exclude=SC2034 --shell=bash modules/cpu
	docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/mnt koalaman/shellcheck:stable --exclude=SC2034 --shell=bash modules/cputemp
	docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/mnt koalaman/shellcheck:stable --exclude=SC2034 --shell=bash modules/date
	docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/mnt koalaman/shellcheck:stable --exclude=SC2034 --shell=bash modules/disk
	docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/mnt koalaman/shellcheck:stable --exclude=SC2034 --shell=bash modules/ethereum
	docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/mnt koalaman/shellcheck:stable --exclude=SC2034 --shell=bash modules/gateway
	docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/mnt koalaman/shellcheck:stable --exclude=SC2034 --shell=bash modules/iface
	docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/mnt koalaman/shellcheck:stable --exclude=SC2034 --shell=bash modules/memory
	docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/mnt koalaman/shellcheck:stable --exclude=SC2034 --shell=bash modules/online
	docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/mnt koalaman/shellcheck:stable --exclude=SC2034 --shell=bash modules/volume
	docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/mnt koalaman/shellcheck:stable --exclude=SC2034 --shell=bash modules/wifi


install:
	@# root check
	@[ `id -u` != 0 ] || { echo "Must be run as normal user"; exit 1; }

	@# Create dir
	${MKDIR_P} "${HOME}/.config/i3blocks-modules"
	${MKDIR_P} "${HOME}/.config/i3blocks-modules/bin"

	@# Install config
	install -m 0644 etc/contrib.conf   "${HOME}/.config/i3blocks-modules/contrib.conf"

	@# Install modules
	install -m 0755 modules/backlight   "${HOME}/.config/i3blocks-modules/bin/backlight"
	install -m 0755 modules/battery     "${HOME}/.config/i3blocks-modules/bin/battery"
	install -m 0755 modules/bitcoin     "${HOME}/.config/i3blocks-modules/bin/bitcoin"
	install -m 0755 modules/bitcoincash "${HOME}/.config/i3blocks-modules/bin/bitcoincash"
	install -m 0755 modules/cpu         "${HOME}/.config/i3blocks-modules/bin/cpu"
	install -m 0755 modules/cputemp     "${HOME}/.config/i3blocks-modules/bin/cputemp"
	install -m 0755 modules/date        "${HOME}/.config/i3blocks-modules/bin/date"
	install -m 0755 modules/disk        "${HOME}/.config/i3blocks-modules/bin/disk"
	install -m 0755 modules/ethereum    "${HOME}/.config/i3blocks-modules/bin/ethereum"
	install -m 0755 modules/gateway     "${HOME}/.config/i3blocks-modules/bin/gateway"
	install -m 0755 modules/iface       "${HOME}/.config/i3blocks-modules/bin/iface"
	install -m 0755 modules/memory      "${HOME}/.config/i3blocks-modules/bin/memory"
	install -m 0755 modules/online      "${HOME}/.config/i3blocks-modules/bin/online"
	install -m 0755 modules/volume      "${HOME}/.config/i3blocks-modules/bin/volume"
	install -m 0755 modules/wifi        "${HOME}/.config/i3blocks-modules/bin/wifi"


uninstall:
	@# root check
	@[ `id -u` != 0 ] || { echo "Must be run as normal user"; exit 1; }

	@# Remove config
	rm -f "${HOME}/.config/i3blocks-modules/contrib.conf"

	@# Remove modules
	rm -f "${HOME}/.config/i3blocks-modules/bin/backlight"
	rm -f "${HOME}/.config/i3blocks-modules/bin/battery"
	rm -f "${HOME}/.config/i3blocks-modules/bin/bitcoin"
	rm -f "${HOME}/.config/i3blocks-modules/bin/bitcoincash"
	rm -f "${HOME}/.config/i3blocks-modules/bin/cpu"
	rm -f "${HOME}/.config/i3blocks-modules/bin/cputemp"
	rm -f "${HOME}/.config/i3blocks-modules/bin/date"
	rm -f "${HOME}/.config/i3blocks-modules/bin/disk"
	rm -f "${HOME}/.config/i3blocks-modules/bin/ethereum"
	rm -f "${HOME}/.config/i3blocks-modules/bin/gateway"
	rm -f "${HOME}/.config/i3blocks-modules/bin/iface"
	rm -f "${HOME}/.config/i3blocks-modules/bin/memory"
	rm -f "${HOME}/.config/i3blocks-modules/bin/online"
	rm -f "${HOME}/.config/i3blocks-modules/bin/volume"
	rm -f "${HOME}/.config/i3blocks-modules/bin/wifi"

	@# Remove dirs
	rmdir "${HOME}/.config/i3blocks-modules/bin"
	rmdir "${HOME}/.config/i3blocks-modules"


# -------------------------------------------------------------------------------------------------
# Helper Target
# -------------------------------------------------------------------------------------------------

_pull-docker-filelint:
	docker pull cytopia/file-lint:$(FL_VERSION)

_pull-docker-shellcheck:
	docker pull koalaman/shellcheck:stable
