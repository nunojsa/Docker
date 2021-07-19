DOCKER_VERSION := $(shell docker --version 2>/dev/null)
UBUNTU_DIR := ubuntu-dev
GLADE_DIR := glade-3
TARGETS = ubuntu-dev-18.04 glade-3
CLEAN_TARGETS := $(addprefix rm_, $(TARGETS))
PREFIX ?= /usr/local

ifeq ($(strip $(DOCKER_VERSION)),)
$(info Make sure docker is installed!)
$(error 1)
endif

.PHONY: glade-3

all: $(TARGETS)

$(UBUNTU_DIR)/ubuntu-dev-18.04: $(UBUNTU_DIR)/Dockerfile
	@docker build $(ARGS) -t ubuntu-dev:18.04 -f $(UBUNTU_DIR)/Dockerfile .
	@touch $@

$(GLADE_DIR)/glade-3: $(UBUNTU_DIR)/ubuntu-dev-18.04 $(GLADE_DIR)/Dockerfile
	@docker build $(ARGS) -t glade-3 -f $(GLADE_DIR)/Dockerfile .
	@touch $@

ubuntu-dev-18.04: $(UBUNTU_DIR)/ubuntu-dev-18.04
glade-3: $(GLADE_DIR)/glade-3

install:
	@install -d $(PREFIX)/bin
	@echo	"       INSTALL drun"
	@install -m 755 drun $(PREFIX)/bin

define do_rm
rm_$(1):
	@rm -f $3 2>/dev/null
	@docker rmi -f $2
endef

# define remove targets. It must match the targets defined in @CLEAN_TARGETS
$(eval $(call do_rm,glade-3,glade-3,$(GLADE_DIR)/glade-3))
$(eval $(call do_rm,ubuntu-dev-18.04,ubuntu-dev:18.04,$(UBUNTU_DIR)/ubuntu-dev-18.04))

clean: $(CLEAN_TARGETS)

help:
	@echo Cleaning targets:
	@echo "	clean			Removes all built docker images;"
	@for img in $(CLEAN_TARGETS); do \
		printf "\t%s %35s\n" "$$img" "Removes $${img/rm_/} image;"; \
	done
	@echo ""
	@echo "Build targets:"
	@echo "	all 			Default target. Build all images;"
	@echo "	ubuntu-dev-18.04	Build ubuntu18.04 based imaged with minimal set of dev tools;"
	@echo "	glade-3			Build image to run glade-3;"
	@echo "Install targets:"
	@echo "	install			Install drun utility script;"
