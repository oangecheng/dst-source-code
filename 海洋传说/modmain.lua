GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})
PrefabFiles = {
	"yuzai_foods",
	"yuzai_food_buff",
	"rain_flower_stone",
	"lg_granary",
	"lg_litichi_tree",
	"lg_lemon_tree",
	"lg_veggie",
	"lg_sculpture",
	"lg_sculpture",
	"lg_king_mace",
	"lg_blade",
	"lg_actinine_plant",
	"lg_fruit_rack",
	"lg_fruit_dried",
	"lg_fishgirl",
}
Assets = {
	Asset("ATLAS", "images/tab/lg_tech.xml"),
    Asset("IMAGE", "images/tab/lg_tech.tex")
}
modimport("main/containers.lua")
modimport("scripts/yuzai_foods.lua") 
modimport("main/tech.lua")
modimport("main/recipes.lua") 
modimport("main/bufftime.lua")
modimport("main/minimapicon.lua")
modimport("main/plants.lua")
modimport("main/strings.lua") 
modimport("main/actions.lua")

--为了在菜谱和农谱里显示材料的图片，所以不管玩家设置，还是要注册一遍
RegisterInventoryItemAtlas("images/inventoryimages/lg_litichi.xml","lg_litichi.tex")
RegisterInventoryItemAtlas("images/inventoryimages/lg_lemon.xml","lg_lemon.tex")
RegisterInventoryItemAtlas("images/inventoryimages/lg_actinine.xml","lg_actinine.tex")

AddComponentPostInit("temperature", function(self)
	self.hot_fish_insulation = 0
	local oldGetInsulation = self.GetInsulation
	function self:GetInsulation(...)
		local a,b = oldGetInsulation(self,...)
		return math.max(0, a+self.hot_fish_insulation), b
	end
end)

if GetModConfigData("legend_lighting") then
	AddPrefabPostInit("world", function(inst)
		inst:WatchWorldState("cycles", function()
			local day = TheWorld.state.cycles+1
			if day%7 == 0 then
				local chance = math.random()
				if chance > 0.6 then
					TheWorld:PushEvent("ms_forceprecipitation")
				elseif chance > 0.2 then
					for i, v in ipairs(AllPlayers) do
						if v:IsValid() then
							local num_lightnings = math.random(5,7)
							local pt = v:GetPosition()
							v:StartThread(function()
								for k = 0, num_lightnings do
									local rad = math.random(3, 12)
									local angle = k * 4 * PI / num_lightnings
									local pos = pt + Vector3(rad * math.cos(angle), 0, rad * math.sin(angle))
									TheWorld:PushEvent("ms_sendlightningstrike", pos)
									Sleep(.3 + math.random() * .2)
								end
							end)
						end
					end
				end
			end
		end)
	end)
end
AddPrefabPostInit("world", function(inst)
	inst:AddComponent("legend_girlfishspawn")
end)
