local PluckPlant = Class(function(self, inst)
    self.inst = inst
    self.canpluck = true
end, nil, {})

function PluckPlant:Do(doer, target)
    if target.components.growable and target.components.farmplantstress then
        self.canpluck = false
        target:RemoveTag("ndnr_canpluckplant")

        target.components.farmplantstress.stress_points = target.components.farmplantstress.stress_points + 2
        target.components.growable:DoGrowth()
    end
end

function PluckPlant:OnSave()
    return {
        canpluck = self.canpluck,
    }
end

function PluckPlant:OnLoad(data)
    if data then
        self.canpluck = data.canpluck
    end
end

return PluckPlant