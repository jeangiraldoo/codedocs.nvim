local Customizer = {}
Customizer.__index = Customizer

function Customizer.new(reader)
	assert(reader, "Customizer requires a Reader instance")
	assert(reader.cached_styles, "Reader must expose cached_styles")

	return setmetatable({
		reader = reader,
	}, Customizer)
end

function Customizer:set_default_lang_style(new_styles)
	for lang_name, new_default_style in pairs(new_styles) do
		if type(new_default_style) ~= "string" then
			error("The value assigned as the default docstring style for " .. lang_name .. " must be a string")
		end

		if not self.reader.is_lang_supported(lang_name) then
			error("There is no language called " .. lang_name .. " available in codedocs")
		end

		local lang_data = self.reader.get_lang_data(lang_name)

		if not lang_data.styles[new_default_style] then
			error(lang_name .. " does not have a docstring style called " .. new_default_style)
		end

		lang_data.default_style = new_default_style
	end
end

local function update_style_opts(section_opts, struct_section)
	for opt_name, opt_val in pairs(section_opts) do
		local opt_default_val = struct_section[opt_name]
		if opt_default_val ~= nil then struct_section[opt_name] = opt_val end
	end
end

function Customizer:process_style_structs(structs, style_name, lang_name)
	for struct_name, struct_sections in pairs(structs) do
		local struct_style = self.reader:get_struct_style(lang_name, struct_name, style_name)
		for section_name, section_opts in pairs(struct_sections) do
			local struct_section = struct_style[section_name]
			if struct_section == nil then
				error(
					"There is no section called "
						.. section_name
						.. " in the "
						.. struct_name
						.. " structrure in "
						.. lang_name
				)
			end
			update_style_opts(section_opts, struct_section)
		end
	end
end

function Customizer:update_style(user_opts)
	for lang_name, styles in pairs(user_opts) do
		if not self.reader.is_lang_supported(lang_name) then
			error("There is no language called " .. lang_name .. " available in codedocs")
		end

		for style_name, structs in pairs(styles) do
			self:process_style_structs(structs, style_name, lang_name)
		end
	end
end

return Customizer
