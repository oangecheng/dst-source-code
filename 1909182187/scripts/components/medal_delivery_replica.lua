local Medal_Delivery =Class(function(self, inst)
	self.inst = inst
	self.screen = nil
    self.opentask = nil

    if TheWorld.ismastersim then
        self.classified = SpawnPrefab("medal_delivery_classified")
        self.classified.entity:SetParent(inst.entity)
    else
        if self.classified == nil and inst.medal_delivery_classified ~= nil then
            self.classified = inst.medal_delivery_classified
            inst.medal_delivery_classified.OnRemoveEntity = nil
            inst.medal_delivery_classified = nil
            self:AttachClassified(self.classified)
        end
    end
end)

--------------------------------------------------------------------------

function Medal_Delivery:OnRemoveFromEntity()
    if self.classified ~= nil then
        if TheWorld.ismastersim then
            self.classified:Remove()
            self.classified = nil
        else
            self.classified._parent = nil
            self.inst:RemoveEventCallback("onremove", self.ondetachclassified, self.classified)
            self:DetachClassified()
        end
    end
end

Medal_Delivery.OnRemoveEntity = Medal_Delivery.OnRemoveFromEntity

--------------------------------------------------------------------------
--Client triggers writing based on receiving access to classified data
--------------------------------------------------------------------------

local function OpenScreen(inst, self)
    self.opentask = nil
    self:OpenScreen(ThePlayer)
end

function Medal_Delivery:AttachClassified(classified)
    self.classified = classified

    self.ondetachclassified = function() self:DetachClassified() end
    self.inst:ListenForEvent("onremove", self.ondetachclassified, classified)

    self.opentask = self.inst:DoTaskInTime(0, OpenScreen, self)
end

function Medal_Delivery:DetachClassified()
    self.classified = nil
    self.ondetachclassified = nil
    self:CloseScreen()
end

--------------------------------------------------------------------------
--Common interface
--------------------------------------------------------------------------
--传送
function Medal_Delivery:Delivery(deliverier, index)
    if self.inst.components.medal_delivery ~= nil then
        self.inst.components.medal_delivery:Delivery(deliverier, index)
    elseif self.classified ~= nil and deliverier == ThePlayer then
        SendModRPCToServer(MOD_RPC.functional_medal.Delivery, self.inst, index)
    end
end

--打开界面
function Medal_Delivery:OpenScreen(doer)
    if self.inst.components.medal_delivery ~= nil then
        if self.opentask ~= nil then
            self.opentask:Cancel()
            self.opentask = nil
        end
        self.inst.components.medal_delivery:OpenScreen(doer)
    elseif self.classified ~= nil
        and self.opentask == nil
        and doer ~= nil
        and doer == ThePlayer then

        if doer.HUD == nil then
            -- abort
        else -- if not busy...
            self.screen = doer.HUD:ShowMedalTownportalScreen(self.inst)
        end
    end
end
--关闭界面
function Medal_Delivery:CloseScreen()
    if self.opentask ~= nil then
        self.opentask:Cancel()
        self.opentask = nil
    end
    if self.inst.components.medal_delivery ~= nil then
        self.inst.components.medal_delivery:CloseScreen()
    elseif self.classified ~= nil then
        SendModRPCToServer(MOD_RPC.functional_medal.CloseScreen, self.inst)
    end
    
    -- elseif self.screen ~= nil then
	-- 	if ThePlayer ~= nil and ThePlayer.HUD ~= nil then
    --         ThePlayer.HUD:CloseMedalTownportalScreen()
    --     elseif self.screen.inst:IsValid() then
    --         --Should not have screen and no writer, but just in case...
    --         self.screen:Kill()
    --     end
    --     self.screen = nil
    -- end
end
--设置传送者
function Medal_Delivery:SetDeliverier(deliverier)
    self.classified.Network:SetClassifiedTarget(deliverier or self.inst)
    if self.inst.components.medal_delivery == nil then
        --Should only reach here during medal_delivery construction
        assert(deliverier == nil)
    end
end

--移除标记点
function Medal_Delivery:RemoveMarkPos(index)
    if self.inst.components.medal_delivery ~= nil then
        self.inst.components.medal_delivery:RemoveMarkPos(index)
    elseif self.classified ~= nil then
        SendModRPCToServer(MOD_RPC.functional_medal.RemoveMarkPos, self.inst, index)
    end
end

--切换传送目标
function Medal_Delivery:SetTarget(index)
    if self.inst.components.medal_delivery ~= nil then
        self.inst.components.medal_delivery:SetTarget(index)
    elseif self.classified ~= nil then
        SendModRPCToServer(MOD_RPC.functional_medal.SetTarget, self.inst, index)
    end
end

return Medal_Delivery
