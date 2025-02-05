name: Code quality check

on:
  push:
    branches:
      - main

  pull_request:
    branches:
      - main
    types:
      - opened
      - synchronize
      - reopened

jobs:
  code-check:
    name: Check code quality
    runs-on: ubuntu-latest

    steps:
        - name: Checkout repo
          uses: actions/checkout@v4
          with:
            fetch-depth: 0

        - name: Install Lua
          run: |
            sudo apt-get update
            sudo apt-get install -y luajit

            echo -e "\n\033[32mLuaJIT has been successfully installed!\033[0m"
            echo -e "\033[32m$(luajit -v)\033[0m"

        - name: Install Luarocks
          run: |
            sudo apt-get update
            sudo apt-get install -y luarocks

            echo -e "\n\033[32mLuarocks has been successfully installed!\033[0m"
            echo -e "\033[32m$(luarocks --version)\033[0m"

        - name: Install Luacheck
          run: |
            sudo luarocks install luacheck

        - name: Get commits file list
          run: |
            if [ "$GITHUB_EVENT_NAME" = "push" ]; then
                commit_range="${{ github.event.before }}..${{ github.sha }}"
            elif [ "$GITHUB_EVENT_NAME" = "pull_request" ]; then
                commit_range="origin/${{ github.base_ref }}..HEAD"
            else
                commit_range="HEAD~1..HEAD"
            fi

            modified_files=$(git diff --name-only $commit_range -- '*.lua')

            if [ -n "$modified_files" ]; then
                echo "Modified files: $modified_files"
                echo "files=$modified_files" >> "$GITHUB_ENV"
            else
                echo "No Lua files were modified."
                echo "files=" >> "$GITHUB_ENV"
            fi

        - name: Run linter check
          if: env.files != ''
          run: |
            luacheck src ${{ env.files }} 

        - name: Run formatter check
          if: env.files != ''
          uses: JohnnyMorganz/stylua-action@v4
          with:
            token: ${{ secrets.GITHUB_TOKEN }}
            version: 2.0.2
            args: --check ${{ env.files }}
