.PHONY: tests

quality-checks:
	./scripts/local_checks.sh

install-dev:
	./scripts/install_deps.sh

tests:
	nvim --headless -c "PlenaryBustedDirectory tests" -c "qa"

all-checks: quality-checks tests
