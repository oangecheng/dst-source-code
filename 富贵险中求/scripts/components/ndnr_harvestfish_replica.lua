local function OnProductDirty(self, inst)
    self.product = self._product:value()
end

local HarvestFish = Class(function(self, inst)
    self.inst = inst
    self._product = net_string(inst.GUID, "ndnr_harvestfish._product", "ndnr_productdirty")
    inst:ListenForEvent("ndnr_productdirty", function(inst) OnProductDirty(self, inst) end)
end, nil, {})

function HarvestFish:SetProduct(product)
    self._product:set_local(product)
    self._product:set(product)
end

function HarvestFish:GetProduct()
    return self.product
end

function HarvestFish:OnHarvest(fn)
    self.harvestfn = fn
end

return HarvestFish
