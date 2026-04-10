.PHONY: tests, new-lang

quality-checks:
	./scripts/local_checks.sh

install-dev:
	./scripts/install_deps.sh

new-lang:
	cd scripts && ./new_language.sh

test:
	busted tests

all-checks: quality-checks tests
