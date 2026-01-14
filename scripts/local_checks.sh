#!/bin/bash
# Description: Runs the same quality checks as the CI system, allowing issues to be caught locally before pushing changes
# Author: Jean Giraldo
# Date Created: 2026-01-14
#
display_check_title() {
	printf "\033[36m$1\033[0m"
}

display_check_title "<< Local quality checks >>\n\n"

display_check_title "Checking Lua formatting:\n"
stylua --check .

display_check_title "\nLinting Lua code:\n"
luacheck .

display_check_title "\nLinting commits:\n"
npx commitlint --from origin/main --to HEAD

display_check_title "\nLinting Markdown files:\n"
markdownlint .
