
.PHONY: clean chmod tests verbose

SHELL := $(shell command -v bash)
DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
export PATH := $(DIR)bin:$(DIR)sbin:$(PATH)
OUTPUT := $(DIR)tests/output
FIXTURES := $(DIR)tests/fixtures
FIXTURES_RC_D := $(DIR)tests/fixtures/rc_d_test
BATS_JOBS := $(shell PATH=$(PATH) $(DIR)bin/rcdocker image --base | wc -l)
BATS_JOBS := $(shell echo $$(($(BATS_JOBS)+1)))

jobs:
	@echo $(BATS_JOBS)

clean:
	@rm -rf $(OUTPUT); rm -rf $(FIXTURES_RC_D)/share

chmod:
	@for i in bin sbin; do chmod +x $(DIR)$${i}/* 2>/dev/null || true; done

tests: clean chmod
	@bats $(DIR)tests --jobs $(BATS_JOBS) --print-output-on-failure --recursive

verbose: clean chmod
	@bats $(DIR)tests --gather-test-outputs-in $(OUTPUT) --jobs $(BATS_JOBS) --no-tempdir-cleanup --output $(OUTPUT) \
--print-output-on-failure --recursive --show-output-of-passing-tests --timing --trace --verbose-run
