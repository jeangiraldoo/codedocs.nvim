local Validate = {}

function Validate.logging(opts)
	vim.validate {
		["config.logging"] = { opts, "table" },
	}
	vim.validate {
		["config.logging.path"] = { opts.path, "string" },
	}
	vim.validate {
		["config.logging.level"] = { opts.level, "number" },
	}
end

function Validate.languages(languages_opts)
	vim.validate {
		["config.languages"] = { languages_opts, "table" },
	}

	for lang_name, opts in pairs(languages_opts) do
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

function Validate.all(config)
	Validate.logging(config.logging)
	Validate.languages(config.languages)
end

return Validate
