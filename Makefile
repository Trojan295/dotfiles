
all: prepare_debian install dotfiles

prepare_debian:
	chmod +x ./scripts/debian.sh
	./scripts/debian.sh

install:
	chmod +x ./scripts/install.sh
	./scripts/install.sh

dotfiles:
	chmod +x ./scripts/dotfiles.sh
	./scripts/dotfiles.sh


.PHONY: all prepare_debian install dotfiles

