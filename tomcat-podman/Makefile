# Define variables

# import config.
# You can change the default config with `make cnf="config_special.env" build`
#cnf ?= config.env
##include $(cnf)
#export $(shell sed 's/=.*//' $(cnf))

# import deploy config
# You can change the default deploy config with `make cnf="deploy_special.env" release`
#dpl ?= deploy.env
#include $(dpl)
#export $(shell sed 's/=.*//' $(dpl))
s
# grep the version from the mix file
#VERSION=$(shell ./version.sh)


IMAGE_NAME=foobar-tomcat
CONTAINER_NAME=foobar-dev-tomcat
BASE_HOME=/home/samtm/foobar
#prod QA dev
BASE_ENV=dev

# Paths for volumes on the host
WEBAPPS_VOLUME_PATH=$(BASE_HOME)//${BASE_ENV}/webapps
LOGS_VOLUME_PATH=$(BASE_HOME)//${BASE_ENV}/logs
CONF_VOLUME_PATH=$(BASE_HOME)/$(BASE_ENV)/conf
TOMCAT_PACKAGE=10.0.20.tar.gz
TOMCAT_URL=https://archive.apache.org/dist/tomcat/tomcat-10/v10.0.20/bin/apache-tomcat-10.0.20.tar.gz

## Ensure the conf directory exists and has default configurations if needed
prepare-conf:
	mkdir -p $(CONF_VOLUME_PATH)
	# Optionally, add commands to copy default conf files to $(CONF_VOLUME_PATH) if empty
	mkdir -p $(WEBAPPS_VOLUME_PATH)
	mkdir -p $(LOGS_VOLUME_PATH)
	touch  $(LOGS_VOLUME_PATH)/catalina.out
	cp build/server.xml $(CONF_VOLUME_PATH)
	cd build	
	[ ! -f build/$(TOMCAT_PACKAGE) ] && wget -O build/$(TOMCAT_PACKAGE) $(TOMCAT_URL) || echo "build/$(TOMCAT_PACKAGE) File already exists"


build: prepare-conf ## Build the Docker (Podman) image
	export BUILDAH_FORMAT=docker
	podman build -t $(IMAGE_NAME) .

run: ## Run the container with volumes
	podman run -d --name $(CONTAINER_NAME) \
	-v $(WEBAPPS_VOLUME_PATH):/opt/tomcat/webapps:z \
	-v $(LOGS_VOLUME_PATH):/opt/tomcat/logs:z \
	-v $(CONF_VOLUME_PATH):/opt/tomcat/conf:z \
	-p 8080:8080 $(IMAGE_NAME)

clean: ## Stop and remove the container
	podman stop $(CONTAINER_NAME)
	podman rm $(CONTAINER_NAME)
wipe: ## Delete all images
	
	podman rmi -a -f


export: ## Export running container to tarball
	#podman save $(CONTAINER_NAME) -o $(CONTAINER_NAME).tar
	foo=$(podman ps -aq);podman export -o $foo.tar $foo

import : ## Import Container tarball
	echo "import me"
	
.PHONY: help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'



all: build run ## The Default target to build and run
