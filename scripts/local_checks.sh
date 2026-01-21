#!/bin/bash
# Description: Runs the same quality checks as the CI system, allowing issues to be caught locally before pushing changes
# Author: Jean Giraldo
# Date Created: 2026-01-14
#
failed=0

display_title() {
	printf "\033[36m$1\033[0m\n"
}

run_check() {
	local check_title="$1"
	local check_command="$2"

	local check_output
	check_output="$(bash -c "$check_command" 2>&1)"
	local status=$?

	if [ "$status" -ne 0 ]; then
		display_title "\n$check_title"
		printf "%s\n" "$check_output"
		failed=1
	fi
}

display_title "<< Local quality checks >>"

run_check "Checking Lua formatting:" "stylua --check ."

run_check "Linting Lua code:" "luacheck --quiet ."

run_check "Linting commits:" "npx commitlint --from origin/main --to HEAD"

run_check "Linting Markdown files:" "markdownlint ."

exit "$failed"
