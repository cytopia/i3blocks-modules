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
	@echo "   Will install config to ~/.config/i3blocks-modules/conf"
	@echo "   Will install modules to ~/.local/share/i3blocks-modules/"
	@echo ""
	@echo "make uninstall"
	@echo "   Will remove config from ~/.config/i3blocks-modules/conf"
	@echo "   Will remove modules from ~/.local/share/i3blocks-modules/"


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
	docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/mnt koalaman/shellcheck:stable --exclude=SC2034 --shell=bash modules/stock
	docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/mnt koalaman/shellcheck:stable --exclude=SC2034 --shell=bash modules/volume
	docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/mnt koalaman/shellcheck:stable --exclude=SC2034 --shell=bash modules/weather
	docker run --rm $$(tty -s && echo "-it" || echo) -v $(PWD):/mnt koalaman/shellcheck:stable --exclude=SC2034 --shell=bash modules/wifi


install:
	@# root check
	@[ `id -u` != 0 ] || { echo "Must be run as normal user"; exit 1; }

	@# Create dir
	${MKDIR_P} "${HOME}/.config/i3blocks-modules/"
	${MKDIR_P} "${HOME}/.local/share/i3blocks-modules/"

	@# Install config
	install -m 0644 etc/conf   "${HOME}/.config/i3blocks-modules/conf"

	@# Install modules
	install -m 0755 modules/backlight   "${HOME}/.local/share/i3blocks-modules/backlight"
	install -m 0755 modules/battery     "${HOME}/.local/share/i3blocks-modules/battery"
	install -m 0755 modules/bitcoin     "${HOME}/.local/share/i3blocks-modules/bitcoin"
	install -m 0755 modules/bitcoincash "${HOME}/.local/share/i3blocks-modules/bitcoincash"
	install -m 0755 modules/cpu         "${HOME}/.local/share/i3blocks-modules/cpu"
	install -m 0755 modules/cputemp     "${HOME}/.local/share/i3blocks-modules/cputemp"
	install -m 0755 modules/date        "${HOME}/.local/share/i3blocks-modules/date"
	install -m 0755 modules/disk        "${HOME}/.local/share/i3blocks-modules/disk"
	install -m 0755 modules/ethereum    "${HOME}/.local/share/i3blocks-modules/ethereum"
	install -m 0755 modules/gateway     "${HOME}/.local/share/i3blocks-modules/gateway"
	install -m 0755 modules/iface       "${HOME}/.local/share/i3blocks-modules/iface"
	install -m 0755 modules/memory      "${HOME}/.local/share/i3blocks-modules/memory"
	install -m 0755 modules/online      "${HOME}/.local/share/i3blocks-modules/online"
	install -m 0755 modules/stock       "${HOME}/.local/share/i3blocks-modules/stock"
	install -m 0755 modules/volume      "${HOME}/.local/share/i3blocks-modules/volume"
	install -m 0755 modules/weather     "${HOME}/.local/share/i3blocks-modules/weather"
	install -m 0755 modules/wifi        "${HOME}/.local/share/i3blocks-modules/wifi"


uninstall:
	@# root check
	@[ `id -u` != 0 ] || { echo "Must be run as normal user"; exit 1; }

	@# Remove config
	rm -f "${HOME}/.config/i3blocks-modules/conf"

	@# Remove modules
	rm -f "${HOME}/.local/share/i3blocks-modules/backlight"
	rm -f "${HOME}/.local/share/i3blocks-modules/battery"
	rm -f "${HOME}/.local/share/i3blocks-modules/bitcoin"
	rm -f "${HOME}/.local/share/i3blocks-modules/bitcoincash"
	rm -f "${HOME}/.local/share/i3blocks-modules/cpu"
	rm -f "${HOME}/.local/share/i3blocks-modules/cputemp"
	rm -f "${HOME}/.local/share/i3blocks-modules/date"
	rm -f "${HOME}/.local/share/i3blocks-modules/disk"
	rm -f "${HOME}/.local/share/i3blocks-modules/ethereum"
	rm -f "${HOME}/.local/share/i3blocks-modules/gateway"
	rm -f "${HOME}/.local/share/i3blocks-modules/iface"
	rm -f "${HOME}/.local/share/i3blocks-modules/memory"
	rm -f "${HOME}/.local/share/i3blocks-modules/online"
	rm -f "${HOME}/.local/share/i3blocks-modules/stock"
	rm -f "${HOME}/.local/share/i3blocks-modules/volume"
	rm -f "${HOME}/.local/share/i3blocks-modules/weather"
	rm -f "${HOME}/.local/share/i3blocks-modules/wifi"

	@# Remove dirs
	rm -rf "${HOME}/.config/i3blocks-modules"
	rm -rf "${HOME}/.local/share/i3blocks-modules"


# -------------------------------------------------------------------------------------------------
# Helper Target
# -------------------------------------------------------------------------------------------------

_pull-docker-filelint:
	docker pull cytopia/file-lint:$(FL_VERSION)

_pull-docker-shellcheck:
	docker pull koalaman/shellcheck:stable
