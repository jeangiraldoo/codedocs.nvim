.PHONY: test, new-lang, quality-checks, install-dev, all-checks

SCRIPTS_DIR = cd scripts && .

quality-checks:
	$(SCRIPTS_DIR)/local_checks.sh

install-dev:
	$(SCRIPTS_DIR)/install_deps.sh

new-lang:
	$(SCRIPTS_DIR)/new_language.sh

test:
	busted tests

all-checks: quality-checks tests
