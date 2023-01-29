--[[
	写在前面：根箱共享物品我本想用rpc来实现同步，调试了一下午，没成功，然后看了一下永不妥协的实现，就“借鉴”了过来。
	PS：RPC如果能成功的话，可以实现跨世界共享，永不妥协里的这种方式没法跨世界。
]]
local RootChestInventory = Class(function(self, inst)
	self.inst = inst
	self.inst:DoTaskInTime(0,function() self:SpawnTrunk() end)
end)


function RootChestInventory:OnSave()
	local data = {}
	local refs = {}
	if self.trunk and self.trunk:IsValid() then
		data.trunk = self.trunk.GUID
		table.insert(refs,data.trunk)
	end
	return data, refs
end

function RootChestInventory:OnLoad(data)
	if data.trunk then
		self.cancelspawn = true
	end
end

function RootChestInventory:LoadPostPass(ents, data)
	if data.trunk and ents[data.trunk] then
		self.trunk = ents[data.trunk].entity
	end
end

function RootChestInventory:LongUpdate(dt)

end

function RootChestInventory:OnUpdate( dt )

end

function RootChestInventory:empty(target)
	local t_cont = target.components.container
	local cont = self.trunk.components.container
	if t_cont and cont then
		for i,slot in pairs(cont.slots) do
			local item = cont:RemoveItemBySlot(i)
			t_cont:GiveItem(item, i, nil, nil, true)
		end
	end
end

function RootChestInventory:fill( source )
	local s_cont = source.components.container
	local cont = self.trunk.components.container
	if s_cont and cont then
		for i,slot in pairs(s_cont.slots) do
			local item = s_cont:RemoveItemBySlot(i)
			cont:GiveItem(item, i, nil, nil, true)
		end
	end
end

function RootChestInventory:SpawnTrunk()
	if not self.trunk then
		self.trunk = SpawnPrefab("ndnr_treasurechest_root_child")
	end

    self.trunk.entity:AddTag("NOBLOCK")

    if self.trunk.Physics then
        self.trunk.Physics:SetActive(false)
    end
    if self.trunk.Light and self.trunk.Light:GetDisableOnSceneRemoval() then
        self.trunk.Light:Enable(false)
    end
    if self.trunk.AnimState then
        self.trunk.AnimState:Pause()
    end
    if self.trunk.DynamicShadow then
        self.trunk.DynamicShadow:Enable(false)
    end
    if self.trunk.MiniMapEntity then
        self.trunk.MiniMapEntity:SetEnabled(false)
    end
end

return RootChestInventory
