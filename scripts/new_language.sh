#!/usr/bin/env bash
# Description: Creates all the files and directories necessary to add support for a language
# Author: Jean Giraldo
# Date Created: 2026-04-10

display_step_title() {
	printf "\033[36m$1\033[0m"
}

display_step_title "<< Creating new language >>\n\n"

LANGUAGES_PATH=../lua/codedocs/config/languages

STYLE_TEMPLATE='local lang_utils = require "codedocs.config.languages.utils"

return {
	comment = {
		relative_position = "empty_target_or_above",
		indented = false,
		blocks = {
			lang_utils.new_section {
				name = "title",
				layout = {
					"// ${%snippet_tabstop_idx:description}",
				},
			},
		},
	},
}'

TARGET_TEMPLATE='local extractors = {}

return {
	node_identifiers = {
	},
	extractors = extractors,
	opts = {},
}'

echo "What's the language name?"
read name
mkdir $LANGUAGES_PATH/$name

####################################################################
# Creates the language files that are placed in a specific directory
# Arguments:
#   directory name
#   template string to be placed in each file
####################################################################
create_language_dir_files() {
	echo "What $1 are there?"
	read -a array
	dir=$LANGUAGES_PATH/$name/$1
	mkdir $dir

	if [ "$1" = "styles" ]; then
		first_style="${array[0]}"
	fi

	for file_name in "${array[@]}"; do
		echo "$2" >> $dir/$file_name.lua
	done
}

create_language_dir_files "styles" "$STYLE_TEMPLATE"

create_language_dir_files "targets" "$TARGET_TEMPLATE"

INIT_TEMPLATE="return {
	default_style = \"$first_style\",
	styles = {},
	targets = {}
}"

echo "$INIT_TEMPLATE" >> $LANGUAGES_PATH/$name/init.lua
