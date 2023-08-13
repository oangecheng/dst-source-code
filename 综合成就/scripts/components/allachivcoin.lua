local function getcoinamount(self,coinamount) self.inst.currentcoinamount:set(coinamount) end

local function currenthungerup(self,hungerupamount) self.inst.currenthungerup:set(hungerupamount) end
local function currentsanityup(self,sanityupamount) self.inst.currentsanityup:set(sanityupamount) end
local function currenthealthup(self,healthupamount) self.inst.currenthealthup:set(healthupamount) end
local function currenthealthregen(self,healthregenamount) self.inst.currenthealthregen:set(healthregenamount) end
local function currentsanityregen(self,sanityregenamount) self.inst.currentsanityregen:set(sanityregenamount) end
local function currenthungerrateup(self,hungerrateupamount) self.inst.currenthungerrateup:set(hungerrateupamount) end
local function currentspeedup(self,speedupamount) self.inst.currentspeedup:set(speedupamount) end
local function currentabsorbup(self,absorbupamount) self.inst.currentabsorbup:set(absorbupamount) end
local function currentdamageup(self,damageupamount) self.inst.currentdamageup:set(damageupamount) end
local function currentcrit(self,crit) self.inst.currentcrit:set(crit) end

local function currentdoubledrop(self,doubledrop) local c = 0 if doubledrop then c=1 end self.inst.currentdoubledrop:set(c) end
local function currentfireflylight(self,fireflylight) local c = 0 if fireflylight then c=1 end self.inst.currentfireflylight:set(c) end
local function currentnomoist(self,nomoist) local c = 0 if nomoist then c=1 end self.inst.currentnomoist:set(c) end
local function currentgoodman(self,goodman) local c = 0 if goodman then c=1 end self.inst.currentgoodman:set(c) end
local function currentrefresh(self,refresh) local c = 0 if refresh then c=1 end self.inst.currentrefresh:set(c) end
local function currentfishmaster(self,fishmaster) local c = 0 if fishmaster then c=1 end self.inst.currentfishmaster:set(c) end
local function currentcookmaster(self,cookmaster) local c = 0 if cookmaster then c=1 end self.inst.currentcookmaster:set(c) end
local function currentchopmaster(self,chopmaster) local c = 0 if chopmaster then c=1 end self.inst.currentchopmaster:set(c) end
local function currentpickmaster(self,pickmaster) local c = 0 if pickmaster then c=1 end self.inst.currentpickmaster:set(c) end
local function currentbuildmaster(self,buildmaster) local c = 0 if buildmaster then c=1 end self.inst.currentbuildmaster:set(c) end
local function currenticebody(self,icebody) local c = 0 if icebody then c=1 end self.inst.currenticebody:set(c) end
local function currentfirebody(self,firebody) local c = 0 if firebody then c=1 end self.inst.currentfirebody:set(c) end
local function currentsupply(self,supply) local c = 0 if supply then c=1 end self.inst.currentsupply:set(c) end
local function currentreader(self,reader) local c = 0 if reader then c=1 end self.inst.currentreader:set(c) end

local allachivcoin = Class(function(self, inst)
    self.inst = inst
    self.coinamount = 0

    self.hungerupamount = 0
    self.sanityupamount = 0
    self.healthupamount = 0
    self.healthregenamount = 0
    self.sanityregenamount = 0
    self.hungerrateupamount = 0
    self.speedupamount = 0
    self.absorbupamount = 0
    self.damageupamount = 0
    self.crit = 0

    self.doubledrop = false
    self.fireflylight = false
    self.nomoist = false
    self.goodman = false
    self.refresh = false
    self.fishmaster = false
    self.cookmaster = false
    self.chopmaster = false
    self.pickmaster = false
    self.buildmaster = false
    self.icebody = false
    self.firebody = false
    self.supply =  false
    self.reader = false

    self.fishtimemin = 4
    self.fishtimemax = 40
    self.hungermax = math.pi
    self.sanitymax = math.pi
    self.healthmax = math.pi
    self.hungerrate = math.pi
    self.speedcheck = math.pi
    self.maxMoistureRate = math.pi
    self.absorb = math.pi
    self.damagemul = math.pi
end,
nil,
{
    coinamount = getcoinamount,

    hungerupamount = currenthungerup,
    sanityupamount = currentsanityup,
    healthupamount = currenthealthup,
    healthregenamount = currenthealthregen,
    sanityregenamount = currentsanityregen,
    hungerrateupamount = currenthungerrateup,
    speedupamount = currentspeedup,
    absorbupamount = currentabsorbup,
    damageupamount = currentdamageup,
    crit = currentcrit,

    doubledrop = currentdoubledrop,
    fireflylight = currentfireflylight,
    nomoist = currentnomoist,
    goodman = currentgoodman,
    refresh = currentrefresh,
    fishmaster = currentfishmaster,
    cookmaster = currentcookmaster,
    chopmaster = currentchopmaster,
    pickmaster = currentpickmaster,
    buildmaster = currentbuildmaster,
    icebody = currenticebody,
    firebody = currentfirebody,
    supply =  currentsupply,
    reader =  currentreader,
})

--保存
function allachivcoin:OnSave()
    local data = {
        coinamount = self.coinamount,
        hungerupamount = self.hungerupamount,
        sanityupamount = self.sanityupamount,
        healthupamount = self.healthupamount,
        healthregenamount = self.healthregenamount,
        sanityregenamount = self.sanityregenamount,
        hungerrateupamount = self.hungerrateupamount,
        speedupamount = self.speedupamount,
        absorbupamount = self.absorbupamount,
        damageupamount = self.damageupamount,
        crit = self.crit,

        doubledrop = self.doubledrop,
        fireflylight = self.fireflylight,
        nomoist = self.nomoist,
        goodman = self.goodman,
        refresh = self.refresh,
        fishmaster = self.fishmaster,
        cookmaster = self.cookmaster,
        chopmaster = self.chopmaster,
        pickmaster = self.pickmaster,
        buildmaster = self.buildmaster,
        icebody = self.icebody,
        firebody = self.firebody,
        supply = self.supply,
        reader = self.reader,
    }
    return data
end

--载入
function allachivcoin:OnLoad(data)
    self.coinamount = data.coinamount or 0

    self.hungerupamount = data.hungerupamount or 0
    self.sanityupamount = data.sanityupamount or 0
    self.healthupamount = data.healthupamount or 0
    self.healthregenamount = data.healthregenamount or 0
    self.sanityregenamount = data.sanityregenamount or 0
    self.hungerrateupamount = data.hungerrateupamount or 0
    self.speedupamount = data.speedupamount or 0
    self.absorbupamount = data.absorbupamount or 0
    self.damageupamount = data.damageupamount or 0
    self.crit = data.crit or 0

    self.doubledrop = data.doubledrop or false
    self.fireflylight = data.fireflylight or false
    self.nomoist = data.nomoist or false
    self.goodman = data.goodman or false
    self.refresh = data.refresh or false
    self.fishmaster = data.fishmaster or false
    self.cookmaster = data.cookmaster or false
    self.chopmaster = data.chopmaster or false
    self.pickmaster = data.pickmaster or false
    self.buildmaster = data.buildmaster or false
    self.icebody = data.icebody or false
    self.firebody = data.firebody or false
    self.supply = data.supply or false
    self.reader = data.reader or false
end

--通用效果器 获取成功
function allachivcoin:ongetcoin(inst)
    inst.SoundEmitter:PlaySound("dontstarve/HUD/research_available")
end

--通用效果器 获取失败
function allachivcoin:cantgetcoin(inst)
    --播放声音
end

function allachivcoin:coinDoDelta(value)
    self.coinamount = self.coinamount + value
end

--提升饱腹获取
function allachivcoin:hungerupcoin(inst)
    if self.coinamount >= allachiv_coinuse["hungerup"] then
        self.hungerupamount = self.hungerupamount + 1
        local hunger_percent = inst.components.hunger:GetPercent()
        inst.components.hunger:SetMax(inst.components.hunger.max + allachiv_coindata["hungerup"])
        inst.components.hunger:SetPercent(hunger_percent)
        self.hungermax = inst.components.hunger.max
        self:coinDoDelta(-allachiv_coinuse["hungerup"])
        self:ongetcoin(inst)
    end
end

--提升精神获取
function allachivcoin:sanityupcoin(inst)
    if self.coinamount >= allachiv_coinuse["sanityup"] then
        self.sanityupamount = self.sanityupamount + 1
        local sanity_percent = inst.components.sanity:GetPercent()
        inst.components.sanity:SetMax(inst.components.sanity.max + allachiv_coindata["sanityup"])
        inst.components.sanity:SetPercent(sanity_percent)
        self.sanitymax = inst.components.sanity.max
        self:coinDoDelta(-allachiv_coinuse["sanityup"])
        self:ongetcoin(inst)
    end
end

--提升血量获取
function allachivcoin:healthupcoin(inst)
    if self.coinamount >= allachiv_coinuse["healthup"] then
        self.healthupamount = self.healthupamount + 1
        local health_percent = inst.components.health:GetPercent()
        inst.components.health:SetMaxHealth(inst.components.health.maxhealth + allachiv_coindata["healthup"])
        inst.components.health:SetPercent(health_percent)
        self.healthmax = inst.components.health.maxhealth
        self:coinDoDelta(-allachiv_coinuse["healthup"])
        self:ongetcoin(inst)
    end
end

--延缓饥饿获取
function allachivcoin:hungerrateupcoin(inst)
    if self.coinamount >= allachiv_coinuse["hungerrateup"] then
        self.hungerrateupamount = self.hungerrateupamount + 1
        inst.components.hunger.hungerrate = inst.components.hunger.hungerrate - allachiv_coindata["hungerrateup"]
        if inst.components.hunger.hungerrate <= .01 then
            inst.components.hunger.hungerrate = .01
        end
        self.hungerrate = inst.components.hunger.hungerrate
        self:coinDoDelta(-allachiv_coinuse["hungerrateup"])
        self:ongetcoin(inst)
    end
end

--自动回血获取
function allachivcoin:healthregencoin(inst)
    if self.coinamount >= allachiv_coinuse["healthregen"] then
        self.healthregenamount = self.healthregenamount + 1
        self:coinDoDelta(-allachiv_coinuse["healthregen"])
        self:ongetcoin(inst)
    end
end

--自动回血效果
function allachivcoin:healthregenfn(inst)
    inst:DoPeriodicTask(5, function()
        if inst
        and inst.components.health
        and inst.components.health.currenthealth < inst.components.health.maxhealth
        and inst.components.health.currenthealth > 0
        and self.healthregenamount > 0
        then
            inst.components.health:DoDelta(allachiv_coindata["healthregen"]*self.healthregenamount)
        end
    end)
end

--自动回脑获取
function allachivcoin:sanityregencoin(inst)
    if self.coinamount >= allachiv_coinuse["sanityregen"] then
        self.sanityregenamount = self.sanityregenamount + 1
        self:coinDoDelta(-allachiv_coinuse["sanityregen"])
        self:ongetcoin(inst)
    end
end

--自动回脑效果
function allachivcoin:sanityregenfn(inst)
    inst:DoPeriodicTask(5, function()
        if inst
        and inst.components.sanity
        and inst.components.sanity.current < inst.components.sanity.max
        and inst.components.health
        and inst.components.health.currenthealth > 0
        and self.sanityregenamount > 0
        then
            inst.components.sanity:DoDelta(allachiv_coindata["sanityregen"]*self.sanityregenamount)
        end
    end)
end

--提升速度获取
function allachivcoin:speedupcoin(inst)
    if self.coinamount >= allachiv_coinuse["speedup"] then
        self.speedupamount = self.speedupamount + 1
        inst.components.locomotor.externalspeedmultiplier = inst.components.locomotor.externalspeedmultiplier + allachiv_coindata["speedup"]
        self.speedcheck = inst.components.locomotor.externalspeedmultiplier
        self:coinDoDelta(-allachiv_coinuse["speedup"])
        self:ongetcoin(inst)
    end
end

--提升攻击获取
function allachivcoin:damageupcoin(inst)
    if self.coinamount >= allachiv_coinuse["damageup"] then
        self.damageupamount = self.damageupamount + 1
        inst.components.combat.damagemultiplier = inst.components.combat.damagemultiplier + allachiv_coindata["damageup"]
        self.damagemul = inst.components.combat.damagemultiplier
        self:coinDoDelta(-allachiv_coinuse["damageup"])
        self:ongetcoin(inst)
    end
end

--提升防御获取
function allachivcoin:absorbupcoin(inst)
    if self.coinamount >= allachiv_coinuse["absorbup"] then
        self.absorbupamount = self.absorbupamount + 1
        inst.components.health.absorb = inst.components.health.absorb + allachiv_coindata["absorbup"]
        if inst.components.health.absorb >= .95 then inst.components.health.absorb = .95 end
        self.absorb = inst.components.health.absorb
        self:coinDoDelta(-allachiv_coinuse["absorbup"])
        self:ongetcoin(inst)
    end
end

--暴击奖励获取
function allachivcoin:critcoin(inst)
    if self.coinamount >= allachiv_coinuse["crit"] then
        self.crit = self.crit + 1
        self:coinDoDelta(-allachiv_coinuse["crit"])
        self:ongetcoin(inst)
    end
end

--暴击奖励效果
function allachivcoin:critfn(inst)
    inst:ListenForEvent("onhitother", function(inst, data)
        local chance = allachiv_coindata["crit"]*self.crit
        local damage = data.damage
        local target = data.target
        if target and math.random(1,100) <= chance and not target:HasTag("wall") and self.crit > 0 and self.attackcheck ~= true then
            self.attackcheck = true
            target.components.combat:GetAttacked(inst, damage)
            local snap = SpawnPrefab("impact")
            snap.Transform:SetScale(3, 3, 3)
            snap.Transform:SetPosition(target.Transform:GetWorldPosition())
            if target.SoundEmitter ~= nil then
                target.SoundEmitter:PlaySound("dontstarve/common/whip_large")
            end
            if target.components.lootdropper and target.components.health:IsDead() then
                if target.components.freezable or target:HasTag("monster") then
                    target.components.lootdropper:DropLoot()
                end
            end
            inst:DoTaskInTime(.1, function() self.attackcheck = false end)
        end
    end)
end

--萤火微光获取
function allachivcoin:fireflylightcoin(inst)
    if self.fireflylight ~= true and self.coinamount >= allachiv_coinuse["fireflylight"] then
        self.fireflylight = true
        self:coinDoDelta(-allachiv_coinuse["fireflylight"])
        self:fireflylightfn(inst)
        self:ongetcoin(inst)
    end
end

--萤火微光效果
function allachivcoin:fireflylightfn(inst)
    if self.fireflylight then
        inst._fireflylight = SpawnPrefab("minerhatlight")
        inst._fireflylight.Light:SetRadius(4)
        inst._fireflylight.Light:SetFalloff(.7)
        inst._fireflylight.Light:SetIntensity(.5)
        inst._fireflylight.Light:SetColour(255/255,255/255,255/255)
        inst._fireflylight.entity:SetParent(inst.entity)
        if TheWorld.components.worldstate.data.isday then
            inst._fireflylight.Light:SetIntensity(0)
            inst._fireflylight.Light:Enable(false)
        end
        inst:WatchWorldState("startday", function()
            for i=1, 100 do
                inst:DoTaskInTime(i/25, function()
                    inst._fireflylight.Light:SetIntensity(.5-i/100*.5)
                end)
            end
            inst:DoTaskInTime(4, function() inst._fireflylight.Light:Enable(false) end)
        end)
        inst:WatchWorldState("startdusk", function()
            inst._fireflylight.Light:Enable(true)
            for i=1, 100 do
                inst:DoTaskInTime(i/25, function()
                    inst._fireflylight.Light:SetIntensity(i/100*.5)
                end)
            end
        end)
    end
end

--雨水免疫获取
function allachivcoin:nomoistcoin(inst)
    if self.nomoist ~= true and self.coinamount >= allachiv_coinuse["nomoist"] then
        self.nomoist = true
        inst.components.moisture.maxMoistureRate = 0
        self.maxMoistureRate = inst.components.moisture.maxMoistureRate
        self:coinDoDelta(-allachiv_coinuse["nomoist"])
        self:ongetcoin(inst)
    end
end

--双倍掉落获取
function allachivcoin:doubledropcoin(inst)
    if self.doubledrop ~= true and self.coinamount >= allachiv_coinuse["doubledrop"] then
        self.doubledrop = true
        self:coinDoDelta(-allachiv_coinuse["doubledrop"])
        self:ongetcoin(inst)
    end
end

--双倍掉落效果
function allachivcoin:doubledropfn(inst)
    inst:ListenForEvent("killed", function(inst, data)
        if self.doubledrop and data.victim.components.lootdropper then
            if data.victim.components.freezable or data.victim:HasTag("monster") then
                data.victim.components.lootdropper:DropLoot()
            end
        end
    end)
end

--好人标签获取
function allachivcoin:goodmancoin(inst)
    if self.goodman ~= true and self.coinamount >= allachiv_coinuse["goodman"] then
        self.goodman = true
        self:coinDoDelta(-allachiv_coinuse["goodman"])
        self:ongetcoin(inst)
    end
end

--好人标签效果
function allachivcoin:goodmanfn(inst)
    inst:DoPeriodicTask(1, function()
        if self.goodman then
            local pos = Vector3(inst.Transform:GetWorldPosition())
            local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 6)
            for k,v in pairs(ents) do
                if v.prefab then
                    if v.prefab == "pigman" or v.prefab == "bunnyman" then
                        if v.components.follower.leader == nil
                        and not v:HasTag("werepig")
                        and not v:HasTag("guard") then
                            if v.components.combat:TargetIs(inst) then
                                v.components.combat:SetTarget(nil)
                            end
                            inst.components.leader:AddFollower(v)
                        end
                    end
                end
            end
        end
    end)
end

--垂钓圣手获取
function allachivcoin:fishmastercoin(inst)
    if self.fishmaster ~= true and self.coinamount >= allachiv_coinuse["fishmaster"] then
        self.fishmaster = true
        self:coinDoDelta(-allachiv_coinuse["fishmaster"])
        self:ongetcoin(inst)

        if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).components
        and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).components.fishingrod then
            local fishingrod = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS).components.fishingrod
            self.fishtimemin = fishingrod.minwaittime
            self.fishtimemax = fishingrod.maxwaittime
            fishingrod:SetWaitTimes(1, 1)
        end
    end
end

--垂钓圣手效果
function allachivcoin:fishmasterfn(inst)
    inst:ListenForEvent("equip", function(inst, data)
        if  self.fishmaster and data.item and data.item.components.fishingrod then
            self.fishtimemin = data.item.components.fishingrod.minwaittime
            self.fishtimemax = data.item.components.fishingrod.maxwaittime
            data.item.components.fishingrod:SetWaitTimes(1, 1)
        end
    end)
    inst:ListenForEvent("unequip", function(inst, data)
        if self.fishmaster and data.item and data.item.components.fishingrod then
            data.item.components.fishingrod:SetWaitTimes(self.fishtimemin, self.fishtimemax)
        end
    end)
end

--双倍采集获取
function allachivcoin:pickmastercoin(inst)
    if self.pickmaster ~= true and self.coinamount >= allachiv_coinuse["pickmaster"] then
        self.pickmaster = true
        self:coinDoDelta(-allachiv_coinuse["pickmaster"])
        self:ongetcoin(inst)
    end
end

--双倍采集效果
function allachivcoin:pickmasterfn(inst)
    inst:ListenForEvent("picksomething", function(inst, data)
        if self.pickmaster and data.object and data.object.components.pickable and not data.object.components.trader then
            if data.object.components.pickable.product ~= nil then
                local item = SpawnPrefab(data.object.components.pickable.product)
                if item.components.stackable then
                    item.components.stackable:SetStackSize(data.object.components.pickable.numtoharvest)
                end
                inst.components.inventory:GiveItem(item, nil, data.object:GetPosition())
            end
        end
    end)
end

--砍树圣手获取
function allachivcoin:chopmastercoin(inst)
    if self.chopmaster ~= true and self.coinamount >= allachiv_coinuse["chopmaster"] then
        self.chopmaster = true
        self:coinDoDelta(-allachiv_coinuse["chopmaster"])
        self:ongetcoin(inst)
    end
end

--砍树圣手效果
function allachivcoin:chopmasterfn(inst)
    inst:ListenForEvent("working", function(inst, data)
        if self.chopmaster and data.target and data.target:HasTag("tree") then
            local workable = data.target.components.workable
            --if workable.workleft >= 1 then
            --    if workable.onfinish then
                    workable.workleft = 0
            --    end
            --end
        end
    end)
end

--烹调圣手获取
function allachivcoin:cookmastercoin(inst)
    if self.cookmaster ~= true and self.coinamount >= allachiv_coinuse["cookmaster"] then
        self.cookmaster = true
        self:coinDoDelta(-allachiv_coinuse["cookmaster"])
        self:ongetcoin(inst)
    end
end

--烹调圣手效果&煮食事件内置
function allachivcoin:cookmasterfn(inst)
    local COOK = ACTIONS.COOK
    local old_cook_fn = COOK.fn
    COOK.fn = function(act, ...)
        local result = old_cook_fn(act)
        local stewer = act.target.components.stewer
        local allachivcoin = act.doer.components.allachivcoin
        local allachivevent = act.doer.components.allachivevent
        if result and stewer ~= nil then
            if allachivevent.cookmaster ~= true then
                allachivevent.cookamount = allachivevent.cookamount + 1
                if allachivevent.cookamount >= allachiv_eventdata["cookmaster"] then
                    allachivevent.cookmaster = true
                    allachivevent:seffc(act.doer, "cookmaster")
                end
            end
            if allachivcoin.cookmaster then
                local fn = stewer.task.fn
                stewer.task:Cancel()
                fn(act.target, stewer)
            end
        end
    end
end

--节省材料获取
function allachivcoin:buildmastercoin(inst)
    if self.buildmaster ~= true and self.coinamount >= allachiv_coinuse["buildmaster"] then
        self.buildmaster = true
        inst.components.builder.ingredientmod = .5
        self:coinDoDelta(-allachiv_coinuse["buildmaster"])
        self:buildmasterfn(inst)
        inst.components.builder.ingredientmod = .5
        self:ongetcoin(inst)
    end
end

--节省材料效果
function allachivcoin:buildmasterfn(inst)
    if self.buildmaster then
        inst.components.builder.ingredientmod = .5
    end
    inst:ListenForEvent("equip", function(inst, data)
        if self.buildmaster and data.item and data.item.prefab == "greenamulet" then
            inst.components.builder.ingredientmod = .5
        end
    end)
    inst:ListenForEvent("unequip", function(inst, data)
        if self.buildmaster and data.item and data.item.prefab == "greenamulet" then
            inst.components.builder.ingredientmod = .5
        end
    end)
end

--携带反鲜获取
function allachivcoin:refreshcoin(inst)
    if self.refresh ~= true and self.coinamount >= allachiv_coinuse["refresh"] then
        self.refresh = true
        self:coinDoDelta(-allachiv_coinuse["refresh"])
        self:ongetcoin(inst)
    end
end

--携带反鲜效果
function allachivcoin:refreshfn(inst)
    inst:DoPeriodicTask(1, function()
        if self.refresh then
            --物品栏反鲜
            for k,v in pairs(inst.components.inventory.itemslots) do
                if v and v.components.perishable then
                    v.components.perishable:ReducePercent(-.01)
                end
            end
            --装备栏反鲜
            for k,v in pairs(inst.components.inventory.equipslots) do
                if v and v.components.perishable then
                    v.components.perishable:ReducePercent(-.01)
                end
            end
            --背包反鲜
            for k,v in pairs(inst.components.inventory.opencontainers) do
                if k and k:HasTag("backpack") and k.components.container then
                    for i,j in pairs(k.components.container.slots) do
                        if j and j.components.perishable then
                            j.components.perishable:ReducePercent(-.01)
                        end
                    end
                end
            end
        end
    end)
end

--低温免疫获取
function allachivcoin:icebodycoin(inst)
    if self.icebody ~= true and self.coinamount >= allachiv_coinuse["icebody"] then
        self.icebody = true
        self:coinDoDelta(-allachiv_coinuse["icebody"])
        self:icebodyfn(inst)
        self:ongetcoin(inst)
    end
end

--低温免疫效果
function allachivcoin:icebodyfn(inst)
    if self.icebody == true then
        inst.components.temperature.mintemp = 5
    end
end

--高温免疫获取
function allachivcoin:firebodycoin(inst)
    if self.firebody ~= true and self.coinamount >= allachiv_coinuse["firebody"] then
        self.firebody = true
        self:coinDoDelta(-allachiv_coinuse["firebody"])
        self:firebodyfn(inst)
        self:ongetcoin(inst)
    end
end

--高温免疫效果
function allachivcoin:firebodyfn(inst)
    if self.firebody == true then
        inst.components.temperature.maxtemp = 65
    end
end

--补给建造获取
function allachivcoin:supplycoin(inst)
    if self.supply ~= true and self.coinamount >= allachiv_coinuse["supply"] then
        self.supply = true
        self:coinDoDelta(-allachiv_coinuse["supply"])
        self:supplyfn(inst)
        local item1 = SpawnPrefab("redmooneye")
        inst.components.inventory:GiveItem(item1, nil, inst:GetPosition())
        local item2 = SpawnPrefab("bluemooneye")
        inst.components.inventory:GiveItem(item2, nil, inst:GetPosition())
        self:ongetcoin(inst)
    end
end

--补给建造效果
function allachivcoin:supplyfn(inst)
    if self.supply then
        inst:AddTag("achiveking")
    end
end

--书籍阅读获取
function allachivcoin:readercoin(inst)
    if self.reader ~= true and self.coinamount >= allachiv_coinuse["reader"] and inst.prefab ~= "wickerbottom" then
        self.reader = true
        self:coinDoDelta(-allachiv_coinuse["reader"])
        self:readerfn(inst)
        local item1 = SpawnPrefab("papyrus")
        item1.components.stackable:SetStackSize(6)
        inst.components.inventory:GiveItem(item1, nil, inst:GetPosition())
        self:ongetcoin(inst)
    end
end

--书籍阅读效果
function allachivcoin:readerfn(inst)
    if self.reader then
        inst:AddComponent("reader")
        inst:AddTag("achivbookbuilder")
    end
end

--重置奖励
function allachivcoin:removecoin(inst)
    local returncoin = 
    self.hungerupamount*allachiv_coinuse["hungerup"] +
    self.sanityupamount*allachiv_coinuse["sanityup"] +
    self.healthupamount*allachiv_coinuse["healthup"] +
    self.healthregenamount*allachiv_coinuse["healthregen"] +
    self.sanityregenamount*allachiv_coinuse["sanityregen"] +
    self.hungerrateupamount*allachiv_coinuse["hungerrateup"] +
    self.speedupamount*allachiv_coinuse["speedup"] +
    self.absorbupamount*allachiv_coinuse["absorbup"] +
    self.damageupamount*allachiv_coinuse["damageup"] +
    self.crit*allachiv_coinuse["crit"]

    if self.doubledrop then returncoin = returncoin + allachiv_coinuse["doubledrop"] end
    if self.fireflylight then returncoin = returncoin + allachiv_coinuse["fireflylight"] end
    if self.nomoist then returncoin = returncoin + allachiv_coinuse["nomoist"] end
    if self.goodman then returncoin = returncoin + allachiv_coinuse["goodman"] end
    if self.refresh then returncoin = returncoin + allachiv_coinuse["refresh"] end
    if self.fishmaster then returncoin = returncoin + allachiv_coinuse["fishmaster"] end
    if self.cookmaster then returncoin = returncoin + allachiv_coinuse["cookmaster"] end
    if self.chopmaster then returncoin = returncoin + allachiv_coinuse["chopmaster"] end
    if self.pickmaster then returncoin = returncoin + allachiv_coinuse["pickmaster"] end
    if self.buildmaster then returncoin = returncoin + allachiv_coinuse["buildmaster"] end
    if self.icebody then returncoin = returncoin + allachiv_coinuse["icebody"] end
    if self.firebody then returncoin = returncoin + allachiv_coinuse["firebody"] end
    if self.supply then returncoin = returncoin + allachiv_coinuse["supply"] end
    if self.reader then returncoin = returncoin + allachiv_coinuse["reader"] end

    self.coinamount = self.coinamount + math.ceil(returncoin*3/4)
    self:resetbuff(inst)

    self.hungerupamount = 0
    self.sanityupamount = 0
    self.healthupamount = 0
    self.healthregenamount = 0
    self.sanityregenamount = 0
    self.hungerrateupamount = 0
    self.speedupamount = 0
    self.absorbupamount = 0
    self.damageupamount = 0
    self.crit = 0

    self.doubledrop = false
    self.fireflylight = false
    self.nomoist = false
    self.goodman = false
    self.refresh = false
    self.fishmaster = false
    self.cookmaster = false
    self.chopmaster = false
    self.pickmaster = false
    self.buildmaster = false
    self.icebody = false
    self.firebody = false
    self.supply =  false
    self.reader = false

    if inst.components.health.currenthealth > 0 and not inst.components.rider:IsRiding() then
        inst.components.locomotor:Stop()
        inst.sg:GoToState("changeoutsidewardrobe")
    end
    SpawnPrefab("shadow_despawn").Transform:SetPosition(inst.Transform:GetWorldPosition())
    SpawnPrefab("statue_transition_2").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

--重置属性
function allachivcoin:resetbuff(inst)
    local hunger_percent = inst.components.hunger:GetPercent()
    inst.components.hunger:SetMax(inst.components.hunger.max - self.hungerupamount*allachiv_coindata["hungerup"])
    inst.components.hunger:SetPercent(hunger_percent)
    self.hungermax = inst.components.hunger.max

    local sanity_percent = inst.components.sanity:GetPercent()
    inst.components.sanity:SetMax(inst.components.sanity.max - self.sanityupamount*allachiv_coindata["sanityup"])
    inst.components.sanity:SetPercent(sanity_percent)
    self.sanitymax = inst.components.sanity.max

    local health_percent = inst.components.health:GetPercent()
    inst.components.health:SetMaxHealth(inst.components.health.maxhealth - self.healthupamount*allachiv_coindata["healthup"])
    inst.components.health:SetPercent(health_percent)
    self.healthmax = inst.components.health.maxhealth

    inst.components.hunger.hungerrate = inst.components.hunger.hungerrate + self.hungerrateupamount*allachiv_coindata["hungerrateup"]
    self.hungerrate = inst.components.hunger.hungerrate
    
    inst.components.locomotor.externalspeedmultiplier = inst.components.locomotor.externalspeedmultiplier - allachiv_coindata["speedup"]*self.speedupamount
    self.speedcheck = inst.components.locomotor.externalspeedmultiplier
    
    inst.components.health.absorb = inst.components.health.absorb - allachiv_coindata["absorbup"]*self.absorbupamount
    self.absorb = inst.components.health.absorb
    
    inst.components.combat.damagemultiplier = inst.components.combat.damagemultiplier - allachiv_coindata["damageup"]*self.damageupamount
    self.damagemul = inst.components.combat.damagemultiplier

    if self.fireflylight then inst._fireflylight:Remove() end

    inst.components.temperature.mintemp = TUNING.MIN_ENTITY_TEMP
    inst.components.temperature.maxtemp = TUNING.MAX_ENTITY_TEMP

    inst:RemoveTag("achiveking")

    if inst.prefab ~= "wickerbottom" then
        inst:RemoveComponent("reader")
        inst:RemoveTag("achivbookbuilder")
    end

    inst.components.moisture.maxMoistureRate = .75
    self.maxMoistureRate = inst.components.moisture.maxMoistureRate

    inst.components.builder.ingredientmod = 1
end

--预运行
function allachivcoin:Init(inst)
    inst:DoTaskInTime(.1, function()
        self:supplyfn(inst)
        self:firebodyfn(inst)
        self:icebodyfn(inst)
        self:refreshfn(inst)
        self:buildmasterfn(inst)
        self:cookmasterfn(inst)
        self:chopmasterfn(inst)
        self:pickmasterfn(inst)
        self:fishmasterfn(inst)
        self:goodmanfn(inst)
        self:doubledropfn(inst)
        self:fireflylightfn(inst)
        self:critfn(inst)
        self:sanityregenfn(inst)
        self:healthregenfn(inst)
        self:readerfn(inst)
    end)

    inst.components.combat.damagemultiplier = inst.components.combat.damagemultiplier or 1

    inst:DoPeriodicTask(.5, function() self:onupdate(inst) end)
end

--检测非由本mod改变的数据并实时更新，同时负责载入时将奖励生效
function allachivcoin:onupdate(inst)
    --饥饿上限
    if self.hungermax ~= inst.components.hunger.max then
        local hunger_percent = inst.components.hunger:GetPercent()
        inst.components.hunger:SetMax(inst.components.hunger.max + allachiv_coindata["hungerup"]*self.hungerupamount)
        inst.components.hunger:SetPercent(hunger_percent)
        self.hungermax = inst.components.hunger.max
    end
    --脑残上限
    if self.sanitymax ~= inst.components.sanity.max then
        local sanity_percent = inst.components.sanity:GetPercent()
        inst.components.sanity:SetMax(inst.components.sanity.max + allachiv_coindata["sanityup"]*self.sanityupamount)
        inst.components.sanity:SetPercent(sanity_percent)
        self.sanitymax = inst.components.sanity.max
    end
    --血量上限
    if self.healthmax ~= inst.components.health.maxhealth then
        local health_percent = inst.components.health:GetPercent()
        inst.components.health.maxhealth = inst.components.health.maxhealth + allachiv_coindata["healthup"]*self.healthupamount
        inst.components.health:SetPercent(health_percent)
        self.healthmax = inst.components.health.maxhealth
    end
    --延缓饥饿
    if self.hungerrate ~= inst.components.hunger.hungerrate then
        inst.components.hunger.hungerrate = inst.components.hunger.hungerrate - allachiv_coindata["hungerrateup"]*self.hungerrateupamount
        if inst.components.hunger.hungerrate <= .01 then
            inst.components.hunger.hungerrate = .01
        end
        self.hungerrate = inst.components.hunger.hungerrate
    end
    --移动速度
    if self.speedcheck ~= inst.components.locomotor.externalspeedmultiplier then
        inst.components.locomotor.externalspeedmultiplier = inst.components.locomotor.externalspeedmultiplier + allachiv_coindata["speedup"]*self.speedupamount
        self.speedcheck = inst.components.locomotor.externalspeedmultiplier
    end
    --防御力
    if self.absorb ~= inst.components.health.absorb then
        inst.components.health.absorb = inst.components.health.absorb + allachiv_coindata["absorbup"]*self.absorbupamount
        if inst.components.health.absorb >= .95 then inst.components.health.absorb = .95 end
        self.absorb = inst.components.health.absorb
    end
    --攻击力
    if self.damagemul ~= inst.components.combat.damagemultiplier then
        inst.components.combat.damagemultiplier = inst.components.combat.damagemultiplier + allachiv_coindata["damageup"]*self.damageupamount
        self.damagemul = inst.components.combat.damagemultiplier
    end
    --防水
    if self.maxMoistureRate ~= inst.components.moisture.maxMoistureRate then
        if self.nomoist then
            inst.components.moisture.maxMoistureRate = 0
        end
    end
end

return allachivcoin