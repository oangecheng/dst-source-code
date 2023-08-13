name = "Permenant Fertilizer"
description = [[
	Getting tired of dumping manure on your berry bushes all the time?
	With this mod, you can craft a permenant fertilizer for berry bushes, grass tufts, and even farms!
]]
author = "Snowhusky5"
version = "1.2"

forumthread = ""

api_version = 10

icon_atlas = "modicon.xml"
icon = "modicon.tex"

all_clients_require_mod = true
client_only_mod = false
dst_compatible = true
server_filter_tags = {"Permenant Fertilizer"}

configuration_options =
{
	{
		name = "Recipe",
		options = 
		{
			{description = "Caves", data = "caves"},
			{description = "No Caves", data = "nocaves"},
		},
		default = "caves",
	},
	{
		name = "Batch Size",
		options =
		{
			{description = "One", data = 1},
			{description = "Two", data = 2},
			{description = "Four", data = 4},
			{description = "Eight", data = 8},
		},
		default = 4,
	},
}