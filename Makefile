SUBMODULES = build_utils
SUBTARGETS = $(patsubst %,%/.git,$(SUBMODULES))

UTILS_PATH := build_utils
TEMPLATES_PATH := .

# Name of the service
SERVICE_NAME := common-api
# Service image default tag
SERVICE_IMAGE_TAG ?= $(shell git rev-parse HEAD)
# The tag for service image to be pushed with
SERVICE_IMAGE_PUSH_TAG ?= $(SERVICE_IMAGE_TAG)

BUILD_IMAGE_TAG := f3732d29a5e622aabf80542b5138b3631a726adb

CALL_ANYWHERE := \
	all submodules init build java.compile java.deploy

CALL_W_CONTAINER := $(CALL_ANYWHERE)

all: build

-include $(UTILS_PATH)/make_lib/utils_image.mk
-include $(UTILS_PATH)/make_lib/utils_container.mk

.PHONY: $(CALL_W_CONTAINER)

$(SUBTARGETS): %/.git: %
	git submodule update --init $<
	touch $@

submodules: $(SUBTARGETS)

# NPM

build:
	npm install
	npm run build

start:
	npm start

# wercker

dev:
	wercker dev --publish 3000 --direct-mount

# Java

ifdef SETTINGS_XML
DOCKER_RUN_OPTS = -v $(SETTINGS_XML):$(SETTINGS_XML)
DOCKER_RUN_OPTS += -e SETTINGS_XML=$(SETTINGS_XML)
endif

ifdef LOCAL_BUILD
DOCKER_RUN_OPTS += -v $$HOME/.m2:/home/$(UNAME)/.m2:rw
endif

COMMIT_HASH := $(shell git --no-pager log -1 --pretty=format:"%h")
NUMBER_COMMITS := $(shell git rev-list --count HEAD)

JAVA_PKG_VERSION := 1.$(NUMBER_COMMITS)-$(COMMIT_HASH)

ifdef BRANCH_NAME
ifeq "$(findstring epic,$(BRANCH_NAME))" "epic"
JAVA_PKG_VERSION := $(JAVA_PKG_VERSION)-epic
endif
endif

MVN = mvn -s $(SETTINGS_XML) -Dcommit.number="$(NUMBER_COMMITS)"

java.swag.compile_client:
	$(if $(SETTINGS_XML),,echo "SETTINGS_XML not defined" ; exit 1)
	$(MVN) clean && \
	$(MVN) compile -P="client"

java.swag.deploy_client:
	$(if $(SETTINGS_XML),,echo "SETTINGS_XML not defined" ; exit 1)
	$(MVN) clean && \
	$(MVN) versions:set versions:commit -DnewVersion="$(JAVA_PKG_VERSION)-client" && \
	$(MVN) deploy -P="client"

java.swag.install_client:
	$(if $(SETTINGS_XML),,echo "SETTINGS_XML not defined" ; exit 1)
	$(MVN) clean && \
    $(MVN) versions:set versions:commit -DnewVersion="$(JAVA_PKG_VERSION)-client" && \
    $(MVN) install -P="client"

java.swag.compile_server:
	$(if $(SETTINGS_XML),,echo "SETTINGS_XML not defined" ; exit 1)
	$(MVN) clean && \
	$(MVN) compile -P="server"

java.swag.deploy_server:
	$(if $(SETTINGS_XML),,echo "SETTINGS_XML not defined" ; exit 1)
	$(MVN) clean && \
	$(MVN) versions:set versions:commit -DnewVersion="$(JAVA_PKG_VERSION)-server" && \
	$(MVN) deploy -P="server"

java.swag.install_server:
	$(if $(SETTINGS_XML),,echo "SETTINGS_XML not defined" ; exit 1)
	$(MVN) clean && \
    $(MVN) versions:set versions:commit -DnewVersion="$(JAVA_PKG_VERSION)-server" && \
    $(MVN) install -P="server"

java.compile: java.settings
	$(MVN) compile

java.deploy: java.settings
	$(MVN) versions:set versions:commit -DnewVersion="$(JAVA_PKG_VERSION)" && \
	$(MVN) deploy

java.install: java.settings
	$(MVN) clean && \
	$(MVN) versions:set versions:commit -DnewVersion="$(JAVA_PKG_VERSION)" && \
	$(MVN) install

java.settings:
	$(if $(SETTINGS_XML),, echo "SETTINGS_XML not defined"; exit 1)
