std = "luajit"
cache = true
codes = true
color = true
globals = {
	"vim",
	---`plenary` test functions
	"describe",
	"it",
	"assert",
}
exclude_files = {
	".luarocks/**",
	"luarocks/**",
}
