local dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h")

local Config = {}

local function validate_config(config)
	vim.validate {
		["config.logging"] = { config.logging, "table" },
	}
	vim.validate {
		["config.logging.path"] = { config.logging.path, "string" },
	}
	vim.validate {
		["config.logging.level"] = { config.logging.level, "number" },
	}

	vim.validate {
		["config.languages"] = { config.languages, "table" },
	}

	for lang_name, opts in pairs(config.languages) do
		local lang_path = ("config.languages.%s"):format(lang_name)
		vim.validate {
			[lang_path] = { opts, "table" },
		}

		vim.validate {
			[lang_path .. ".default_style"] = { opts.default_style, "string" },
		}
		vim.validate {
			[lang_path .. ".styles"] = { opts.styles, "table" },
		}
		vim.validate {
			[lang_path .. ".targets"] = { opts.targets, "table" },
		}

		for style_name, style_opts in pairs(opts.styles) do
			for annot_name, annotation_opts in pairs(style_opts.annots) do
				local annotation_path = lang_path .. (".styles.%s.%s"):format(style_name, annot_name)

				vim.validate {
					[annotation_path] = {
						annotation_opts,
						"table",
					},
				}
				vim.validate {
					[annotation_path .. ".placement"] = {
						annotation_opts.placement or annotation_opts.relative_position,
						"string",
					},
				}

				for idx, block in ipairs(annotation_opts.blocks) do
					local block_idx_path = annotation_path .. ".blocks(" .. idx .. ")"
					vim.validate {
						[block_idx_path] = { block, "table" },
					}

					vim.validate {
						[block_idx_path .. ".name"] = { block.name, "string" },
					}

					vim.validate {
						[block_idx_path .. ".layout"] = { block.layout, "table" },
					}

					if block.items then
						vim.validate {
							[block_idx_path .. " .items"] = { block.items, "table" },
						}

						for item_block_idx, item_block in ipairs(block.items) do
							vim.validate {
								[block_idx_path .. ".items[" .. item_block_idx .. "].name"] = {
									item_block.name,
									"string",
								},
							}
							vim.validate {
								[block_idx_path .. ".items[" .. item_block_idx .. "].layout"] = {
									item_block.layout,
									"table",
								},
							}
							vim.validate {
								[block_idx_path .. "items[" .. item_block_idx .. "].insert_gap_between"] = {
									item_block.insert_gap_between,
									"table",
								},
							}
							vim.validate {
								[block_idx_path .. ".items[" .. item_block_idx .. "].insert_gap_between.enabled"] = {
									item_block.insert_gap_between.enabled,
									"boolean",
								},
							}
							vim.validate {
								[block_idx_path .. ".items[" .. item_block_idx .. "].insert_gap_between.text"] = {
									item_block.insert_gap_between.text,
									"string",
								},
							}
							vim.validate {
								[block_idx_path .. ".items[" .. item_block_idx .. "].gap_before"] = {
									item_block.gap_before,
									"table",
								},
							}

							for block_name, gap_opts in ipairs(item_block.gap_before) do
								vim.validate {
									[block_idx_path .. ".items[" .. item_block_idx .. "].gap_before[" .. block_name .. "].enabled"] = {
										gap_opts.enabled,
										"boolean",
									},
								}
								vim.validate {
									[block_idx_path .. ".items[" .. item_block_idx .. "].gap_before[" .. block_name .. "].text"] = {
										gap_opts.text,
										"string",
									},
								}
							end
						end
					end
				end
			end
		end
	end
end

---@alias CodedocsSupportedLanguages
---| "lua"
---| "python"
---| "javascript"
---| "typescript"
---| "go"
---| "rust"
---| "c"
---| "cpp"
---| "java"
---| "kotlin"
---| "php"
---| "ruby"
---| "bash"

---@class CodedocsLanguagesConfigs
---@field bash CodedocsBashConfig
---@field c CodedocsCConfig
---@field cpp CodedocsCPPConfig
---@field go CodedocsGoConfig
---@field java CodedocsJavaConfig
---@field kotlin CodedocsKotlinConfig
---@field javascript CodedocsJSConfig
---@field lua CodedocsLuaConfig
---@field php CodedocsPHPConfig
---@field python CodedocsPythonConfig
---@field ruby CodedocsRubyConfig
---@field rust CodedocsRustConfig
---@field typescript CodedocsTSConfig

---@class CodedocsSectionOpts {
---@field name "" | string,
---@field layout string[],
---@field insert_gap_between {
---        enabled: boolean,
---        text: "" | string },
---@field items {
---        layout: string[],
---        insert_gap_between: {
---            enabled: boolean,
---            text: "" | string }}?} Section

---@class CodedocsAnnotationStyleOpts
---@field sections CodedocsSectionOpts[]
---@field placement "above" | "below" | "current"

---@class CodedocsLanguageConfig
---@field default_style string? Default style name
---@field styles table<string, table<string, CodedocsAnnotationStyleOpts>>

---@class CodedocsConfig
---@field debug boolean? Wether or not to enable debug mode
---@field aliases table<string, CodedocsSupportedLanguages>? Aliases for filetypes -> supported languages
---@field languages CodedocsLanguagesConfigs? Languages configuration

local function build_dir_tbl(rel_lua_path)
	local path = rel_lua_path:gsub("%.", "/")

	local fs_path = vim.fs.joinpath(dir, path)

	return vim.iter(vim.fs.dir(fs_path)):fold({}, function(acc, item_name, item_type)
		if item_type ~= "directory" then return acc end

		local dir_tbl = require(("codedocs.config.%s.%s"):format(rel_lua_path, item_name))

		acc[item_name] = dir_tbl

		return acc
	end)
end

---@type CodedocsConfig
Config.opts = {
	logging = {
		level = vim.log.levels.INFO,
		path = (vim.fn.stdpath "log") .. "/codedocs.log",
	},
	---The `languages` table is created dynamically when the plugin first loads as there's a lot of languages;
	---a literal `require` call per language is not pretty
	languages = vim.iter(vim.fs.dir(vim.fs.joinpath(dir, "languages"))):fold({}, function(acc, name, type)
		if type ~= "directory" then return acc end

		local lang_utils = require "codedocs.config.languages.utils"
		local base_lang_config = require("codedocs.config.languages." .. name)

		base_lang_config.styles = build_dir_tbl("languages." .. name .. ".styles")

		for item_name, tbl in pairs(base_lang_config.styles) do
			tbl.annots = build_dir_tbl("languages." .. name .. ".styles." .. item_name)
		end

		for _, style_opts in pairs(base_lang_config.styles) do
			for _, annotation_opts in pairs(style_opts.annots) do
				annotation_opts.blocks = lang_utils.new_blocks_list(annotation_opts.blocks)
			end
		end

		base_lang_config.targets = build_dir_tbl("languages." .. name .. ".targets")

		for target_name, tbl in pairs(base_lang_config.targets) do
			tbl.extractors = build_dir_tbl("languages." .. name .. ".targets." .. target_name)
		end

		acc[name] = base_lang_config
		return acc
	end),
	annot_builder = {
		state = {
			lines = {},
			snip_idx_counter = 1,
		},
		placeholders = {
			general = {
				["%%>"] = function(_)
					if not vim.bo.expandtab then return "\t" end

					local shiftwidth = vim.bo.shiftwidth
					if shiftwidth == 0 then shiftwidth = vim.bo.tabstop end

					return string.rep(" ", shiftwidth)
				end,
				["%%snip_idx"] = function(state)
					local snip_idx_label = tostring(state.snip_idx_counter)

					state.snip_idx_counter = state.snip_idx_counter + 1

					return snip_idx_label
				end,
			},
			items = {
				["%%item_name"] = function(_, item) return item.name end,
				["%%item_type"] = function(_, item) return item.type end,
			},
		},
	},
}

function Config.setup(user_config)
	vim.validate {
		user_config = { user_config, "table" },
	}

	if not user_config then return end

	local opts = Config.opts
	local merged = vim.tbl_deep_extend("force", opts, user_config)

	for k in pairs(opts) do
		opts[k] = nil
	end
	for k, v in pairs(merged) do
		opts[k] = v
	end

	validate_config(merged)
end

return Config
