DOCKER_VERSION := $(shell docker --version 2>/dev/null)
UBUNTU_DIR := ubuntu-dev
GLADE_DIR := glade-3
OSC_DIR := osc-mingw
TARGETS = ubuntu-dev-18.04 ubuntu-dev glade-3 osc-mingw
CLEAN_TARGETS := $(addprefix rm_, $(TARGETS))
PREFIX ?= /usr/local
Q := @

ifeq ($(strip $(DOCKER_VERSION)),)
$(info Make sure docker is installed!)
$(error 1)
endif

# make V=1 to be verbose when running make
ifeq ($(V),1)
Q =
endif

.PHONY: glade-3 osc-mingw

all: $(TARGETS)

# $1: image name
# $2: directory where to look for the Dockerfile and build the image
# $3: Optional dependencies
# $4: Optional image tag. If given the make target will be appended with "-$4"
define do_image
$(2)/$(1)$(if $(4),-$(4)): $(2)/Dockerfile$(if $(4),.$(4)) $(3)
	$(Q)cd $2 && docker build $(ARGS) -t $1`[ -n "$4" ] && echo ":$4"` -f `basename $$<` .
	$(Q)touch $$@

$(1)$(if $(4),-$(4)): $(2)/$(1)$(if $(4),-$(4))
endef

# define build targets.
$(eval $(call do_image,glade-3,$(GLADE_DIR),$(UBUNTU_DIR)/ubuntu-dev-18.04))
$(eval $(call do_image,osc-mingw,$(OSC_DIR),$(UBUNTU_DIR)/ubuntu-dev-18.04))
$(eval $(call do_image,ubuntu-dev,$(UBUNTU_DIR)))
$(eval $(call do_image,ubuntu-dev,$(UBUNTU_DIR),,18.04))

install:
	$(Q)install -d $(PREFIX)/bin
	$(Q)echo	"       INSTALL drun"
	$(Q)install -m 755 drun $(PREFIX)/bin

# $1: image name
# $2: directory where things where built
# $3: Optional image tag. If given the make target will be appended with "-$3"
define do_rm
rm_$(1)$(if $(3),-$(3)):
	$(Q)rm -f $2/$1`[ -n "$3" ] && echo "-$3"` 2>/dev/null
	$(Q)docker rmi -f $2`[ -n "$3" ] && echo ":$3"`
endef

# define remove targets. It must match the targets defined in @CLEAN_TARGETS
$(eval $(call do_rm,glade-3,$(GLADE_DIR)))
$(eval $(call do_rm,ubuntu-dev,$(UBUNTU_DIR),18.04))
$(eval $(call do_rm,ubuntu-dev,$(UBUNTU_DIR)))
$(eval $(call do_rm,osc-mingw,$(OSC_DIR)))

clean: $(CLEAN_TARGETS)

help:
	$(Q)echo Cleaning targets:
	$(Q)echo "	clean			Removes all built docker images;"
	$(Q)for img in $(CLEAN_TARGETS); do \
		printf "\t%s %35s\n" "$$img" "Removes $${img/rm_/} image;"; \
	done
	$(Q)echo ""
	$(Q)echo "Build targets:"
	$(Q)echo "	all 			Default target. Build all images;"
	$(Q)echo "	ubuntu-dev-18.04	Build ubuntu18.04 based imaged with minimal set of dev tools;"
	$(Q)echo "	ubuntu-dev		Build ubuntu latest based imaged with minimal set of dev tools;"
	$(Q)echo "	glade-3			Build image to run glade-3;"
	$(Q)echo "	osc-mingw		Build image to easily build osc for windows;"
	$(Q)echo ""
	$(Q)echo "Install targets:"
	$(Q)echo "	install			Install drun utility script;"
