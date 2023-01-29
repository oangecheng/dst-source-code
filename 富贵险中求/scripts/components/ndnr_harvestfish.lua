local HarvestFish = Class(function(self, inst)
    self.inst = inst
    self.harvestfn = nil
    self.product = nil
end, nil, {})

function HarvestFish:SetProduct(product)
    self.product = product
    self:SyncProduct()
end

function HarvestFish:GetProduct()
    return self.product
end

function HarvestFish:OnHarvest(fn)
    self.harvestfn = fn
end

function HarvestFish:Do(doer)
    if self.harvestfn ~= nil then
        return self.harvestfn(self.inst, doer)
    end
end

function HarvestFish:SyncProduct()
    if self.inst.replica.ndnr_harvestfish then
        self.inst.replica.ndnr_harvestfish:SetProduct(self.product)
    end
end

function HarvestFish:OnSave()
    return
    {
        product = self.product,
    }
end

function HarvestFish:OnLoad(data)
	if data and data.product ~= nil then
		self.product = data.product
        self:SyncProduct()
	end
end

return HarvestFish
