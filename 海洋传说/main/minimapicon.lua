local map_icons = {
	"lg_granary",
    "lg_litichi_tree",
    "lg_lemon_tree",
    "lg_sculpture",
    "lg_actinine_plant",
    "lg_fishgirl",
}

for k,v in pairs(map_icons) do
	table.insert(Assets, Asset( "IMAGE", "images/map_icons/"..v..".tex" ))
    table.insert(Assets, Asset( "ATLAS", "images/map_icons/"..v..".xml" ))
    AddMinimapAtlas("images/map_icons/"..v..".xml")
end