-- Lua linter configuration file

-- Define globals that are provided by LÖVE2D
globals = {
	"love",
}

-- If you're using a specific version of Lua, you can specify it here
std = "luajit"

-- Ignore some common warnings if needed
ignore = {
	"212", -- Unused argument (common in LÖVE callbacks)
	"213", -- Unused loop variable
}

-- Exclude third-party libraries if needed
exclude_files = {
	"libs/",
}
