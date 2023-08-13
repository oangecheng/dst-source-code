local _G = GLOBAL
local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local Recipe = GLOBAL.Recipe
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local TECH = GLOBAL.TECH

require 'AllAchiv/allachivbalance'

local LAN_ = GetModConfigData('Language')
if LAN_ then
	require 'AllAchiv/strings_acm_c'
	TUNING.AllAchivLan = "cn"
else
	require 'AllAchiv/strings_acm_e'
	TUNING.AllAchivLan = "en"
end

require "AllAchiv/allachivrpc"

PrefabFiles = {
	"seffc",
	"klaussack_placer",
	"achivbooks",
}

Assets = {
	Asset("ATLAS", "images/inventoryimages/klaussack.xml"),
    Asset("IMAGE", "images/inventoryimages/klaussack.tex"),

    Asset("ATLAS", "images/inventoryimages/achivbook_birds.xml"),
    Asset("IMAGE", "images/inventoryimages/achivbook_birds.tex"),

    Asset("ATLAS", "images/inventoryimages/achivbook_brimstone.xml"),
    Asset("IMAGE", "images/inventoryimages/achivbook_brimstone.tex"),

    Asset("ATLAS", "images/inventoryimages/achivbook_gardening.xml"),
    Asset("IMAGE", "images/inventoryimages/achivbook_gardening.tex"),

    Asset("ATLAS", "images/inventoryimages/achivbook_sleep.xml"),
    Asset("IMAGE", "images/inventoryimages/achivbook_sleep.tex"),

    Asset("ATLAS", "images/inventoryimages/achivbook_tentacles.xml"),
    Asset("IMAGE", "images/inventoryimages/achivbook_tentacles.tex"),

    Asset("ATLAS", "images/hud/bigtitle_cn.xml"),
    Asset("IMAGE", "images/hud/bigtitle_cn.tex"),

    Asset("ATLAS", "images/hud/bigtitle_en.xml"),
    Asset("IMAGE", "images/hud/bigtitle_en.tex"),

    Asset("ATLAS", "images/hud/achivbg_act.xml"),
    Asset("IMAGE", "images/hud/achivbg_act.tex"),
    Asset("ATLAS", "images/hud/achivbg_dact.xml"),
    Asset("IMAGE", "images/hud/achivbg_dact.tex"),

    Asset("ATLAS", "images/button/last_act.xml"),
    Asset("IMAGE", "images/button/last_act.tex"),
    Asset("ATLAS", "images/button/last_dact.xml"),
    Asset("IMAGE", "images/button/last_dact.tex"),

    Asset("ATLAS", "images/button/next_act.xml"),
    Asset("IMAGE", "images/button/next_act.tex"),
    Asset("ATLAS", "images/button/next_dact.xml"),
    Asset("IMAGE", "images/button/next_dact.tex"),

    Asset("ATLAS", "images/button/close.xml"),
    Asset("IMAGE", "images/button/close.tex"),

    Asset("ATLAS", "images/button/infobutton.xml"),
    Asset("IMAGE", "images/button/infobutton.tex"),

    Asset("ATLAS", "images/button/info_cn.xml"),
    Asset("IMAGE", "images/button/info_cn.tex"),
    
    Asset("ATLAS", "images/button/info_en.xml"),
    Asset("IMAGE", "images/button/info_en.tex"),

    Asset("ATLAS", "images/button/checkbutton.xml"),
    Asset("IMAGE", "images/button/checkbutton.tex"),

    Asset("ATLAS", "images/button/checkbuttonglow.xml"),
    Asset("IMAGE", "images/button/checkbuttonglow.tex"),

    Asset("ATLAS", "images/button/coinbutton.xml"),
    Asset("IMAGE", "images/button/coinbutton.tex"),

    Asset("ATLAS", "images/button/coinbuttonglow.xml"),
    Asset("IMAGE", "images/button/coinbuttonglow.tex"),

    Asset("ATLAS", "images/button/config_act.xml"),
    Asset("IMAGE", "images/button/config_act.tex"),

    Asset("ATLAS", "images/button/config_dact.xml"),
    Asset("IMAGE", "images/button/config_dact.tex"),

    Asset("ATLAS", "images/button/config_bg.xml"),
    Asset("IMAGE", "images/button/config_bg.tex"),

    Asset("ATLAS", "images/button/config_bigger.xml"),
    Asset("IMAGE", "images/button/config_bigger.tex"),

    Asset("ATLAS", "images/button/config_smaller.xml"),
    Asset("IMAGE", "images/button/config_smaller.tex"),

    Asset("ATLAS", "images/button/config_drag.xml"),
    Asset("IMAGE", "images/button/config_drag.tex"),

    Asset("ATLAS", "images/button/config_remove.xml"),
    Asset("IMAGE", "images/button/config_remove.tex"),

    Asset("ATLAS", "images/button/remove_info_cn.xml"),
    Asset("IMAGE", "images/button/remove_info_cn.tex"),

    Asset("ATLAS", "images/button/remove_info_en.xml"),
    Asset("IMAGE", "images/button/remove_info_en.tex"),

    Asset("ATLAS", "images/button/remove_yes.xml"),
    Asset("IMAGE", "images/button/remove_yes.tex"),

    Asset("ATLAS", "images/button/remove_no.xml"),
    Asset("IMAGE", "images/button/remove_no.tex"),
}

local namelist = {
	"intogame",
	"firsteat",
	"supereat",
	"danding",
	"messiah",
	"walkalot",
	"stopalot",
	"tooyoung",
	"evil",
	"snake",
	"deathalot",
	"nosanity",
	"sick",
	"coldblood",
	"burn",
	"freeze",
	"goodman",
	"brother",
	"fishmaster",
	"pickmaster",
	"chopmaster",
	"cookmaster",
	"buildmaster",
	"longage",
	"noob",
	"luck",
	"black",
	"tank",
	"angry",
	"icebody",
	"firebody",
	"moistbody",
	"rigid",
	"ancient",
	"queen",
	"king",
	"all",
}

for k,v in pairs(namelist) do
	table.insert(Assets, Asset("ATLAS", "images/hud/achivtile_act_"..TUNING.AllAchivLan.."_"..v..".xml"))
    table.insert(Assets, Asset("IMAGE", "images/hud/achivtile_act_"..TUNING.AllAchivLan.."_"..v..".tex"))
    table.insert(Assets, Asset("ATLAS", "images/hud/achivtile_dact_"..TUNING.AllAchivLan.."_"..v..".xml"))
    table.insert(Assets, Asset("IMAGE", "images/hud/achivtile_dact_"..TUNING.AllAchivLan.."_"..v..".tex"))
end

local coinlist = {
	"hungerup",
	"sanityup",
	"healthup",
	"hungerrateup",
	"healthregen",
	"sanityregen",
	"speedup",
	"damageup",
	"absorbup",
	"crit",
	"fireflylight",
	"nomoist",
	"doubledrop",
	"goodman",
	"fishmaster",
	"pickmaster",
	"chopmaster",
	"cookmaster",
	"buildmaster",
	"refresh",
	"icebody",
	"firebody",
	"supply",
	"reader",
}

for k,v in pairs(coinlist) do
	table.insert(Assets, Asset("ATLAS", "images/coin_"..TUNING.AllAchivLan.."/"..v..".xml"))
    table.insert(Assets, Asset("IMAGE", "images/coin_"..TUNING.AllAchivLan.."/"..v..".tex"))
end

--独立同名书本，解决与可做书人物冲突的问题
AddRecipe("achivbook_birds", {Ingredient("papyrus", 2),Ingredient("bird_egg", 2)},
RECIPETABS.MAGIC, TECH.NONE, nil, nil, nil, nil, "achivbookbuilder", 
"images/inventoryimages.xml", "book_birds.tex" )

AddRecipe("achivbook_gardening", {GLOBAL.Ingredient("papyrus", 2), GLOBAL.Ingredient("seeds", 1), GLOBAL.Ingredient("poop", 1)},
RECIPETABS.MAGIC, TECH.NONE, nil, nil, nil, nil, "achivbookbuilder", 
"images/inventoryimages.xml", "book_gardening.tex" )

AddRecipe("achivbook_sleep", {GLOBAL.Ingredient("papyrus", 2), GLOBAL.Ingredient("nightmarefuel", 2)}, 
RECIPETABS.MAGIC, TECH.NONE, nil, nil, nil, nil, "achivbookbuilder", 
"images/inventoryimages.xml", "book_sleep.tex" )

AddRecipe("achivbook_brimstone", {GLOBAL.Ingredient("papyrus", 2), GLOBAL.Ingredient("redgem", 1)}, 
RECIPETABS.MAGIC, TECH.NONE, nil, nil, nil, nil, "achivbookbuilder", 
"images/inventoryimages.xml", "book_brimstone.tex" )

AddRecipe("achivbook_tentacles", {GLOBAL.Ingredient("papyrus", 2), GLOBAL.Ingredient("tentaclespots", 1)}, 
RECIPETABS.MAGIC, TECH.NONE, nil, nil, nil, nil, "achivbookbuilder", 
"images/inventoryimages.xml", "book_tentacles.tex" )

--添加克劳斯背包建造
AddRecipe("klaus_sack", {Ingredient("redmooneye",1),Ingredient("bluemooneye",1),Ingredient("silk",8)}, RECIPETABS.MAGIC, TECH.NONE, 
"klaussack_placer", --placer
nil, -- min_spacing
nil, -- nounlock
nil, -- numtogive
"achiveking", -- builder_tag
"images/inventoryimages/klaussack.xml", -- atlas
"klaussack.tex") -- image

--添加克劳斯背包钥匙建造
AddRecipe("deer_antler1", {Ingredient("boneshard",2),Ingredient("twigs",1)}, RECIPETABS.MAGIC, TECH.NONE, 
nil, --placer
nil, -- min_spacing
nil, -- nounlock
nil, -- numtogive
"achiveking", -- builder_tag
"images/inventoryimages.xml", -- atlas
"deer_antler1.tex") -- image

--预运行
AddPlayerPostInit(function(inst)
	inst.checkintogame = GLOBAL.net_shortint(inst.GUID,"checkintogame")
	inst.checkfirsteat = GLOBAL.net_shortint(inst.GUID,"checkfirsteat")
	inst.checksupereat = GLOBAL.net_shortint(inst.GUID,"checksupereat")
	inst.checkdanding = GLOBAL.net_shortint(inst.GUID,"checkdanding")
    inst.checkmessiah = GLOBAL.net_shortint(inst.GUID,"checkmessiah")
    inst.checkwalkalot = GLOBAL.net_shortint(inst.GUID,"checkwalkalot")
    inst.checkstopalot = GLOBAL.net_shortint(inst.GUID,"checkstopalot")
    inst.checktooyoung = GLOBAL.net_shortint(inst.GUID,"checktooyoung")
    inst.checkevil = GLOBAL.net_shortint(inst.GUID,"checkevil")
    inst.checksnake = GLOBAL.net_shortint(inst.GUID,"checksnake")
    inst.checkdeathalot = GLOBAL.net_shortint(inst.GUID,"checkdeathalot")
    inst.checknosanity = GLOBAL.net_shortint(inst.GUID,"checknosanity")
    inst.checksick = GLOBAL.net_shortint(inst.GUID,"checksick")
    inst.checkcoldblood = GLOBAL.net_shortint(inst.GUID,"checkcoldblood")
    inst.checkburn = GLOBAL.net_shortint(inst.GUID,"checkburn")
    inst.checkfreeze = GLOBAL.net_shortint(inst.GUID,"checkfreeze")
    inst.checkgoodman = GLOBAL.net_shortint(inst.GUID,"checkgoodman")
    inst.checkbrother = GLOBAL.net_shortint(inst.GUID,"checkbrother")
    inst.checkfishmaster = GLOBAL.net_shortint(inst.GUID,"checkfishmaster")
    inst.checkpickmaster = GLOBAL.net_shortint(inst.GUID,"checkpickmaster")
    inst.checkchopmaster = GLOBAL.net_shortint(inst.GUID,"checkchopmaster")
    inst.checknoob = GLOBAL.net_shortint(inst.GUID,"checknoob")
    inst.checkcookmaster = GLOBAL.net_shortint(inst.GUID,"checkcookmaster")
    inst.checklongage = GLOBAL.net_shortint(inst.GUID,"checklongage")
    inst.checkluck = GLOBAL.net_shortint(inst.GUID,"checkluck")
    inst.checkblack = GLOBAL.net_shortint(inst.GUID,"checkblack")
    inst.checkbuildmaster = GLOBAL.net_shortint(inst.GUID,"checkbuildmaster")
    inst.checktank = GLOBAL.net_shortint(inst.GUID,"checktank")
    inst.checkangry = GLOBAL.net_shortint(inst.GUID,"checkangry")
    inst.checkicebody = GLOBAL.net_shortint(inst.GUID,"checkicebody")
    inst.checkfirebody = GLOBAL.net_shortint(inst.GUID,"checkfirebody")
    inst.checkrigid = GLOBAL.net_shortint(inst.GUID,"checkrigid")
    inst.checkancient = GLOBAL.net_shortint(inst.GUID,"checkancient")
    inst.checkqueen = GLOBAL.net_shortint(inst.GUID,"checkqueen")
    inst.checkking = GLOBAL.net_shortint(inst.GUID,"checkking")
    inst.checkmoistbody = GLOBAL.net_shortint(inst.GUID,"checkmoistbody")
    inst.checkall = GLOBAL.net_shortint(inst.GUID,"checkall")

	inst.currenteatamount = GLOBAL.net_shortint(inst.GUID,"currenteatamount")
	inst.currenteatmonsterlasagna = GLOBAL.net_shortint(inst.GUID,"currenteatmonsterlasagna")
    inst.currentrespawnamount = GLOBAL.net_shortint(inst.GUID,"currentrespawnamount")
    inst.currentwalktime = GLOBAL.net_shortint(inst.GUID,"currentwalktime")
    inst.currentstoptime = GLOBAL.net_shortint(inst.GUID,"currentstoptime")
    inst.currentevilamount = GLOBAL.net_shortint(inst.GUID,"currentevilamount")
    inst.currentdeathamouth = GLOBAL.net_shortint(inst.GUID,"currentdeathamouth")
    inst.currentnosanitytime = GLOBAL.net_shortint(inst.GUID,"currentnosanitytime")
    inst.currentsnakeamount = GLOBAL.net_shortint(inst.GUID,"currentsnakeamount")
    inst.currentfriendpig = GLOBAL.net_shortint(inst.GUID,"currentfriendpig")
    inst.currentfriendbunny = GLOBAL.net_shortint(inst.GUID,"currentfriendbunny")
    inst.currentfishamount = GLOBAL.net_shortint(inst.GUID,"currentfishamount")
    inst.currentpickamount = GLOBAL.net_shortint(inst.GUID,"currentpickamount")
    inst.currentchopamount = GLOBAL.net_shortint(inst.GUID,"currentchopamount")
    inst.currentcookamount = GLOBAL.net_shortint(inst.GUID,"currentcookamount")
    inst.currentbuildamount = GLOBAL.net_shortint(inst.GUID,"currentbuildamount")
    inst.currentattackeddamage = GLOBAL.net_shortint(inst.GUID,"currentattackeddamage")
    inst.currentonhitdamage = GLOBAL.net_int(inst.GUID,"currentonhitdamage")
    inst.currenticetime = GLOBAL.net_shortint(inst.GUID,"currenticetime")
    inst.currentfiretime = GLOBAL.net_shortint(inst.GUID,"currentfiretime")
    inst.currentmoisttime = GLOBAL.net_shortint(inst.GUID,"currentmoisttime")
    inst.currentage = GLOBAL.net_shortint(inst.GUID,"currentage")

    inst.checkbosswinter = GLOBAL.net_shortint(inst.GUID,"checkbosswinter")
    inst.checkbossspring = GLOBAL.net_shortint(inst.GUID,"checkbossspring")
    inst.checkbossdragonfly = GLOBAL.net_shortint(inst.GUID,"checkbossdragonfly")
    inst.checkbossautumn = GLOBAL.net_shortint(inst.GUID,"checkbossautumn")

	inst.currentcoinamount = GLOBAL.net_shortint(inst.GUID,"currentcoinamount")

	inst.currenthungerup = GLOBAL.net_shortint(inst.GUID,"currenthungerup")
	inst.currentsanityup = GLOBAL.net_shortint(inst.GUID,"currentsanityup")
	inst.currenthealthup = GLOBAL.net_shortint(inst.GUID,"currenthealthup")
	inst.currenthealthregen = GLOBAL.net_shortint(inst.GUID,"currenthealthregen")
	inst.currentsanityregen = GLOBAL.net_shortint(inst.GUID,"currentsanityregen")
	inst.currenthungerrateup = GLOBAL.net_shortint(inst.GUID,"currenthungerrateup")
	inst.currentspeedup = GLOBAL.net_shortint(inst.GUID,"currentspeedup")
	inst.currentabsorbup = GLOBAL.net_shortint(inst.GUID,"currentabsorbup")
	inst.currentdamageup = GLOBAL.net_shortint(inst.GUID,"currentdamageup")
	inst.currentcrit = GLOBAL.net_shortint(inst.GUID,"currentcrit")

	inst.currentdoubledrop = GLOBAL.net_shortint(inst.GUID,"currentdoubledrop")
	inst.currentfireflylight = GLOBAL.net_shortint(inst.GUID,"currentfireflylight")
	inst.currentnomoist = GLOBAL.net_shortint(inst.GUID,"currentnomoist")
	inst.currentgoodman = GLOBAL.net_shortint(inst.GUID,"currentgoodman")
	inst.currentrefresh = GLOBAL.net_shortint(inst.GUID,"currentrefresh")
	inst.currentfishmaster = GLOBAL.net_shortint(inst.GUID,"currentfishmaster")
	inst.currentcookmaster = GLOBAL.net_shortint(inst.GUID,"currentcookmaster")
	inst.currentchopmaster = GLOBAL.net_shortint(inst.GUID,"currentchopmaster")
	inst.currentpickmaster = GLOBAL.net_shortint(inst.GUID,"currentpickmaster")
	inst.currentbuildmaster = GLOBAL.net_shortint(inst.GUID,"currentbuildmaster")
	inst.currenticebody = GLOBAL.net_shortint(inst.GUID,"currenticebody")
	inst.currentfirebody = GLOBAL.net_shortint(inst.GUID,"currentfirebody")
	inst.currentsupply = GLOBAL.net_shortint(inst.GUID,"currentsupply")
	inst.currentreader = GLOBAL.net_shortint(inst.GUID,"currentreader")
	
    inst:AddComponent("allachivevent")
	inst:AddComponent("allachivcoin")
	if not GLOBAL.TheNet:GetIsClient() then
		inst.components.allachivevent:Init(inst)
		inst.components.allachivcoin:Init(inst)
	end
end)

--UI尺寸
local function PositionUI(self, screensize)
	local hudscale = self.top_root:GetScale()
	self.uiachievement:SetScale(.72*hudscale.x,.72*hudscale.y,1)
	--self.uiachievement.mainbutton.hudscale = self.top_root:GetScale()
end

--UI
local uiachievement = require("widgets/uiachievement")
local function Adduiachievement(self)
    self.uiachievement = self.top_root:AddChild(uiachievement(self.owner))
    local screensize = {GLOBAL.TheSim:GetScreenSize()}
    PositionUI(self, screensize)
    self.uiachievement:SetHAnchor(0)
    self.uiachievement:SetVAnchor(0)
    --H: 0=中间 1=左端 2=右端
    --V: 0=中间 1=顶端 2=底端
    self.uiachievement:MoveToFront()
    local OnUpdate_base = self.OnUpdate
	self.OnUpdate = function(self, dt)
		OnUpdate_base(self, dt)
		local curscreensize = {GLOBAL.TheSim:GetScreenSize()}
		if curscreensize[1] ~= screensize[1] or curscreensize[2] ~= screensize[2] then
			PositionUI(self, curscreensize)
			screensize = curscreensize
		end
	end
end
AddClassPostConstruct("widgets/controls", Adduiachievement)

--欧皇检测
AddPrefabPostInit("krampus_sack", function(inst)
    inst:AddComponent("ksmark")
end)