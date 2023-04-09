local SwordScabbard = Class(function(self, inst)
    self.inst = inst
    self.sworddata = nil
    self.origin = nil
    self.time = nil --{ start = nil, now = nil }
end)

function SwordScabbard:SetAnim(sword)
    local skindata = sword.components.skinedlegion ~= nil and sword.components.skinedlegion:GetSkinedData() or nil
    if skindata ~= nil and skindata.scabbard ~= nil then
        self.inst.components.inventoryitem.atlasname = skindata.scabbard.atlas
        self.inst.components.inventoryitem:ChangeImageName(skindata.scabbard.image)
        self.inst.AnimState:SetBank(skindata.scabbard.bank)
        self.inst.AnimState:SetBuild(skindata.scabbard.build)
        self.inst.AnimState:PlayAnimation(skindata.scabbard.anim, skindata.scabbard.isloop)
    elseif sword.foliageath_data ~= nil then --兼容其他mod
        self.inst.components.inventoryitem.atlasname = sword.foliageath_data.atlas
        self.inst.components.inventoryitem:ChangeImageName(sword.foliageath_data.image)
        self.inst.AnimState:SetBank(sword.foliageath_data.bank)
        self.inst.AnimState:SetBuild(sword.foliageath_data.build)
        self.inst.AnimState:PlayAnimation(sword.foliageath_data.anim, sword.foliageath_data.isloop)
    else
        self.inst.components.inventoryitem.atlasname = "images/inventoryimages/foliageath_"..sword.prefab..".xml"
        self.inst.components.inventoryitem:ChangeImageName("foliageath_"..sword.prefab)
        self.inst.AnimState:PlayAnimation(sword.prefab)
    end
end

function SwordScabbard:Merge(sword)
    self.origin = TheWorld.meta.session_identifier
    self.sworddata = sword:GetSaveRecord()

    self:SetAnim(sword)

    if
        ( sword.foliageath_data ~= nil and sword.foliageath_data.fn_recover ~= nil ) or --兼容其他mod
        (
            sword.prefab == "neverfade" and --能恢复永不凋零的耐久
            sword.components.finiteuses ~= nil and sword.components.finiteuses:GetPercent() < 1
        )
    then
        self.time = { start = GetTime(), now = 0 }
    end

    sword:Remove()
end

function SwordScabbard:BeTogether(beforeinst, sword)
    self:Merge(sword)

    local container = beforeinst.components.inventoryitem:GetContainer()
    if container ~= nil then
        local slot = beforeinst.components.inventoryitem:GetSlotNum()
        beforeinst:Remove() --把青枝绿叶删除
        container:GiveItem(self.inst, slot)
    else
        local x, y, z = beforeinst.Transform:GetWorldPosition()
        beforeinst:Remove()
        self.inst.Transform:SetPosition(x, y, z)
    end
    self.inst.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")
end

function SwordScabbard:BreakUp(player)
    if player == nil or player.components.inventory == nil then
        return false
    end

    ------生成剑
    local sword = nil
    if self.sworddata == nil then
        sword = SpawnPrefab("hambat")
        if sword ~= nil then
            sword.Transform:SetPosition(player.Transform:GetWorldPosition())
        end
    else
        local creator = self.origin ~= nil and TheWorld.meta.session_identifier ~= self.origin
                            and { sessionid = self.origin } or nil
        sword = SpawnPrefab(self.sworddata.prefab, self.sworddata.skinname, self.sworddata.skin_id, creator)
        if sword ~= nil and sword:IsValid() then
            sword.Transform:SetPosition(player.Transform:GetWorldPosition())
            sword:SetPersistData(self.sworddata.data)

            ------新鲜度恢复
            if self.time ~= nil then
                local dt = self.time.now or 0
                if self.time.start ~= nil then
                    dt = dt + (GetTime() - self.time.start)
                end
                if dt > 0 then
                    if sword.foliageath_data ~= nil and sword.foliageath_data.fn_recover ~= nil then
                        sword.foliageath_data.fn_recover(sword, dt, player)
                    elseif sword.OnScabbardRecoveredFn ~= nil then
                        sword.OnScabbardRecoveredFn(sword, dt, player)
                    end
                end
                self.time = nil
            end
        else
            sword = nil
        end
    end

    -----将剑直接装在手上
    if sword ~= nil then
        if
            sword.components.equippable ~= nil and player:HasTag("player")
        then
            if not player.components.inventory:Equip(sword) then
                player.components.inventory:GiveItem(sword)
            end
        else
            player.components.inventory:GiveItem(sword)
        end
    end

    ------归还剑鞘
    local foliageath = SpawnPrefab("foliageath")
    if foliageath ~= nil then
        local owner = self.inst.components.inventoryitem ~= nil and self.inst.components.inventoryitem.owner or nil
        local holder = owner ~= nil and (owner.components.inventory or owner.components.container) or nil
        if holder ~= nil then
            local slot = holder:GetItemSlot(self.inst)
            self.inst:Remove()
            holder:GiveItem(foliageath, slot)
        else
            foliageath.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
            self.inst:Remove()
        end
    end
end

function SwordScabbard:OnSave()
    if self.sworddata ~= nil then
        local data = {
            sworddata = self.sworddata,
            origin = self.origin
        }
        if self.time ~= nil then
            local dt = self.time.now or 0
            if self.time.start ~= nil then
                dt = dt + (GetTime() - self.time.start)
            end
            if dt > 0 then
                data.time = math.min(dt, 30*TUNING.TOTAL_DAY_TIME)
            end
        end
        return data
    end
end

function SwordScabbard:OnLoad(data, newents)
    if data ~= nil then
        if data.sworddata ~= nil then
            self.sworddata = data.sworddata
            self.origin = data.origin
            if data.time ~= nil then
                self.time = { start = GetTime(), now = data.time }
            end
        else --兼容以前的数据模式
            self.sworddata = data.child
        end

        if self.sworddata ~= nil then
            local creator = self.origin ~= nil and TheWorld.meta.session_identifier ~= self.origin
                            and { sessionid = self.origin } or nil
            local sword = SpawnPrefab(self.sworddata.prefab, self.sworddata.skinname, self.sworddata.skin_id, creator)
            if sword ~= nil and sword:IsValid() then
                sword:SetPersistData(self.sworddata.data)
                self:SetAnim(sword)

                --检查一下是否还需要自动计时功能
                if self.time ~= nil then
                    if
                        ( sword.foliageath_data ~= nil and sword.foliageath_data.fn_recover ~= nil ) or --兼容其他mod
                        (
                            sword.prefab == "neverfade" and
                            sword.components.finiteuses ~= nil and sword.components.finiteuses:GetPercent() < 1
                        )
                    then
                        --nothing
                    else
                        self.time = nil
                    end
                end

                --为了动态兼容性更新自身的动画情况，每次重载时都生成一个暂时的实体来使用，用完就删
                sword:Remove()
            end
        end
    end
end

return SwordScabbard
