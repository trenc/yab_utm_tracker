.PHONY: all clean distclean compile help lint lint-fix serve stop vendor

SHELL := /bin/bash

DOCKER_PATH := ../..
PWD := $(shell pwd)
UID := $(shell id -u)
GID := $(shell id -g)
PLUGIN_NAME := $(notdir $(CURDIR))
PHP	:= sudo docker run --rm -v $(PWD):/$(PLUGIN_NAME) -w /$(PLUGIN_NAME) --user $(UID):$(GID) scto-php:8.2

all: compile

clean:
	@rm -rf dist

compile:
	@$(PHP) ./vendor/bin/scto-compile manifest.json README.textile textpack.txt src dist

distclean: clean
	@rm -rf vendor composer.lock

lint:
	@$(PHP) ./vendor/bin/pint --test -v

lint-fix:
	@$(PHP) ./vendor/bin/pint

serve:
	@cd $(DOCKER_PATH) && sudo docker compose up --detach

stop:
	@cd $(DOCKER_PATH) && sudo docker compose down

vendor: distclean
	@$(PHP) composer install

help:
	@echo "Manage project"
	@echo ""
	@echo "Usage:"
	@echo "  $$ make [command]"
	@echo ""
	@echo "Commands:"
	@echo ""
	@echo "  $$ make serve"
	@echo "  Serve the development webserver"
	@echo ""
	@echo "  $$ make stop"
	@echo "  Stop the development webserver"
	@echo ""
	@echo "  $$ make lint"
	@echo "  Lint code style"
	@echo ""
	@echo "  $$ make lint-fix"
	@echo "  Lint and fix code style"
	@echo ""
	@echo "  $$ make compile"
	@echo "  Compiles the plugin"
	@echo ""
	@echo "  $$ make clean"
	@echo "  Delete distribution files and folders."
	@echo ""
	@echo "  $$ make distclean"
	@echo "  Clear the stage, delete dependencies and distribution files."
	@echo ""
	@echo "  $$ make serve"
	@echo "  Start the webserver with textpattern."
	@echo ""
	@echo "  $$ make stop"
	@echo "  Stop the webserver."
	@echo ""
	@echo "  $$ make vendor"
	@echo "  Install dependencies"
	@echo ""
