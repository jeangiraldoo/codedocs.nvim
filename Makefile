.PHONY: tests

quality-checks:
	./scripts/local_checks.sh

install-dev:
	./scripts/install_deps.sh

test:
	busted tests

all-checks: quality-checks tests
