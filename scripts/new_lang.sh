#!/usr/bin/env bash
# Description: Creates all the files and directories necessary to add support for a language
# Author: Jean Giraldo
# Date Created: 2026-04-10

display_step_title() {
	printf "\033[36m%s\033[0m\n\n" "${1}"
}

display_step_title "<< Creating new language >>"

LANGS_DIR_PATH=../lua/codedocs/config/languages
DEFAULT_ANNOTATION_TEST_PATH=../tests/annotations/defaults/test_cases/

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
read -r lang_name

lang_dir_path="${LANGS_DIR_PATH}/${lang_name}"

mkdir "${lang_dir_path}"

####################################################################
# Creates the language files that are placed in a specific directory
# Arguments:
#   directory name
#   template string to be placed in each file
####################################################################
create_language_dir_files() {
	echo "What ${1} are there?"

	local var_name="${1}"
	declare -n ref="${var_name}"
	read -a ref
	dir="${lang_dir_path}/${1}"
	mkdir "${dir}"

	for file_name in "${ref[@]}"; do
		echo "${2}" >> "${dir}/${file_name}.lua"
	done
}

create_language_dir_files "styles" "$STYLE_TEMPLATE"

create_language_dir_files "targets" "$TARGET_TEMPLATE"

lang_init_content=$(cat << END
return {
	default_style = "${styles[0]}",
	styles = {},
	targets = {},
}
END
)

echo "${lang_init_content}" >> "${lang_dir_path}/init.lua"

default_annotation_test_content=$({
	printf "return {\n"
	targets=("comment" "${targets[@]}")

	for target_name in "${targets[@]}"; do
		printf "\t%s = {\n" "${target_name}"
		printf "\t\t{\n"
		printf "\t\t\tstructure = {},\n"
		printf "\t\t\tcursor_pos = 1,\n"
		printf "\t\t\texpected_annotation = {\n"
		for style_name in "${styles[@]}"; do
			printf "\t\t\t\t%s = {},\n" "${style_name}"
		done
		printf "\t\t\t}\n"
		printf "\t\t}\n"
		printf "\t},\n"
	done
	echo "}"
})

echo "${default_annotation_test_content}" >> "${DEFAULT_ANNOTATION_TEST_PATH}/${lang_name}.lua"
