name = "Leisurely Peasants[开心农场]"
description = "啊，好变态！"
author = "哎呀，看看是谁想知道作者？"
version = "1.2"

forumthread = ""

dst_compatible = true
all_clients_require_mod= false 
api_version = 6

api_version_dst = 10  

icon_atlas = "modicon.xml"
icon = "modicon.tex"

configuration_options =
{
    {
		name = "to_oversize",
		label = "All crops are oversize/所有种出来的作物都是最大的",
		hover = "All crops are oversize/所有种出来的作物都是最大的",
		options =	
		{
			{description = "No/不是", data = false},
			{description = "Yes/当然", data = true},
		},
		default = false,
	},
    {
        name = "no_rotten",
        label = "Crops no rotten/植物长成之后不会腐烂",
        hover = "Crops no rotten/植物长成之后不会腐烂",
        options = 
        {
			{description = "No/不是", data = false},
			{description = "Yes/当然", data = true},
        },
        default = false,
    },
    {
		name = "to_auto_aligning",
		label = "Auto Aligning/土丘自动对齐",
		hover = "Auto Aligning/土丘自动对齐",
		options =	
		{
			{description = "No/不是", data = false},
			{description = "3*3", data = true},
			{description = "4*4", data = "4*4"},
		},
		default = false,
	},
    {
		name = "quick_plant",
		label = "Fast Planting/快速种植",
		hover = "Fast Planting/快速种植",
		options =	
		{
			{description = "No/不是", data = false},
			{description = "Yes/当然", data = true},
		},
		default = false,
	},
}