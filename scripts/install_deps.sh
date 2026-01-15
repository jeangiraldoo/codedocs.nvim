display_step_title() {
	printf "\033[36m$1\033[0m"
}

display_step_title "<< Development dependency installation >>\n\n"

sudo apt update

display_step_title "\nInstalling Luarocks package manager:\n"
sudo apt install luarocks
luarocks --version

display_step_title "\nInstalling Stylua:\n"
brew install stylua

display_step_title "\nInstalling Luacheck:\n"
luarocks install luacheck

display_step_title "\nInstalling Commitlint:\n"
npm install -g @commitlint/cli @commitlint/config-conventional

display_step_title "\nInstalling Markdownlint:\n"
npm install -g markdownlint-cli
