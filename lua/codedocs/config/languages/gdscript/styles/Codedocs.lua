return {
	annots = {
		comment = {
			placement = "current",
			blocks = {
				{
					name = "title",
					layout = {
						"# ${%snip_idx:description}",
					},
				},
			},
		},
		export = {
			placement = "current",
			blocks = {
				{
					name = "title",
					layout = {
						"@export ${%snip_idx:property}",
					},
				},
			},
		},
		onready = {
			placement = "current",
			blocks = {
				{
					name = "title",
					layout = {
						"@onready ${%snip_idx:property}",
					},
				},
			},
		},
		warning_ignore = {
			placement = "current",
			blocks = {
				{
					name = "title",
					layout = {
						'@warning_ignore("${%snip_idx:warning}")',
					},
				},
			},
		},
	},
}
