local assets = {
    Asset("ANIM", "anim/neverfade.zip"),--这个是放在地上的动画文件

     --正常的动画
    Asset("ANIM", "anim/swap_neverfade.zip"),
    Asset("ATLAS", "images/inventoryimages/neverfade.xml"),
    Asset("IMAGE", "images/inventoryimages/neverfade.tex"),

    --破损的动画
    Asset("ANIM", "anim/swap_neverfade_broken.zip"),
    Asset("ATLAS", "images/inventoryimages/neverfade_broken.xml"),
    Asset("IMAGE", "images/inventoryimages/neverfade_broken.tex"),

    Asset("ANIM", "anim/neverfadebush.zip"),--花丛的动画
}

local prefabs = {
    "neverfadebush",
    "neverfade_shield",
    "buff_butterflysblessing"
}

local function ChangeSymbol(inst, owner, skindata)
    if skindata ~= nil and skindata.equip ~= nil then
        if inst.hasSetBroken then
            owner.AnimState:OverrideSymbol("swap_object", skindata.equip.build_broken, skindata.equip.file_broken)
        else
            owner.AnimState:OverrideSymbol("swap_object", skindata.equip.build, skindata.equip.file)
        end
    else
        if inst.hasSetBroken then
            owner.AnimState:OverrideSymbol("swap_object", "swap_neverfade_broken", "swap_neverfade_broken")
        else
            owner.AnimState:OverrideSymbol("swap_object", "swap_neverfade", "swap_neverfade")
        end
    end
end
local function ChangeInvImg(inst, skindata)
    if skindata ~= nil and skindata.fn_start ~= nil then
        skindata.fn_start(inst)
    else
        if inst.hasSetBroken then
            --改变物品栏图片，先改atlasname，再改贴图
            inst.components.inventoryitem.atlasname = "images/inventoryimages/neverfade_broken.xml"
            inst.components.inventoryitem:ChangeImageName("neverfade_broken")
        else
            inst.components.inventoryitem.atlasname = "images/inventoryimages/neverfade.xml"
            inst.components.inventoryitem:ChangeImageName("neverfade")
        end
    end
end

local function onequip(inst, owner) --装备武器时
    ChangeSymbol(inst, owner, inst.components.skinedlegion:GetSkinedData())
    owner.AnimState:Show("ARM_carry") --显示持物手
    owner.AnimState:Hide("ARM_normal") --隐藏普通的手

    inst.components.deployable:SetDeployMode(DEPLOYMODE.NONE) --装备时去除可栽种功能

    if owner:HasTag("equipmentmodel") then --假人！
        return
    end

    if not inst.hasSetBroken then
        if owner.components.health ~= nil then
            inst.healthRedirect_old = owner.components.health.redirect --记下原有的函数，方便以后恢复

            owner.components.health.redirect = function(ow, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
                local self = ow.components.health

                if not ignore_invincible and (self.invincible or self.inst.is_teleporting) then --无敌
                    return true
                elseif amount < 0 then  --是伤害，不是恢复
                    if not ignore_absorb then   --不忽略对伤害的吸收，则进行吸收的计算
                        amount = amount - amount * (self.playerabsorb ~= 0 and afflicter ~= nil and afflicter:HasTag("player") and self.playerabsorb + self.absorb or self.absorb)
                    end

                    if self.currenthealth > 0 and self.currenthealth + amount <= 0 then --刚好死掉
                        inst.components.finiteuses:Use(250) --直接坏掉，以此来保住持有者生命

                        local fx = SpawnPrefab("neverfade_shield") --护盾特效
                        fx.entity:SetParent(ow.entity)

                        return true
                    end
                end

                --如果上面的条件都不满足，就直接返回原来的函数
                if inst.healthRedirect_old ~= nil then
                    return inst.healthRedirect_old(ow, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
                end
            end
        end
    end
end
local function onunequip(inst, owner)   --放下武器时
    owner.AnimState:Hide("ARM_carry") --隐藏持物手
    owner.AnimState:Show("ARM_normal") --显示普通的手

    if not inst.hasSetBroken then
        if owner.components.health ~= nil then
            owner.components.health.redirect = inst.healthRedirect_old
        end
        inst.healthRedirect_old = nil
    end
    inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT) --卸下时恢复可摆栽种功能
end

local function IsValidVictim(victim)
    return victim ~= nil
        and not ((victim:HasTag("prey") and not victim:HasTag("hostile")) or
                victim:HasTag("veggie") or
                victim:HasTag("structure") or
                victim:HasTag("wall"))
        and victim.components.health ~= nil
        and victim.components.combat ~= nil
end

local function onattack(inst, owner, target)
    if owner.countblessing == nil then
        owner.countblessing = 0
    end
    if owner.countblessing < 3 then --最多3只庇佑蝴蝶
        if IsValidVictim(target) then
            inst.attackTrigger = inst.attackTrigger + 1

            if inst.attackTrigger >= 10 then   --如果达到10，添加buff
                local skin = inst.components.skinedlegion:GetSkinedData()
                if skin ~= nil then
                    owner.butterfly_skin_l = skin.butterfly
                end
                owner:AddDebuff("buff_butterflysblessing", "buff_butterflysblessing")
                inst.attackTrigger = 0
            end
        end
    end
end

local function onfinished(inst)
    if not inst.hasSetBroken then
        inst.hasSetBroken = true
        inst.attackTrigger = 0
        inst.components.weapon:SetDamage(TUNING.TORCH_DAMAGE)   --17攻击力
        inst.components.weapon:SetOnAttack(nil)

        ChangeInvImg(inst, inst.components.skinedlegion:GetSkinedData())
        -- inst.components.equippable.dapperness = 0
        if inst.components.equippable:IsEquipped() then
            local owner = inst.components.inventoryitem.owner
            if owner ~= nil then
                ChangeSymbol(inst, owner, inst.components.skinedlegion:GetSkinedData())

                if owner.components.health ~= nil then
                    owner.components.health.redirect = inst.healthRedirect_old
                end
                inst.healthRedirect_old = nil

                if owner.SoundEmitter ~= nil then   --发出破碎的声音
                    owner.SoundEmitter:PlaySound("dontstarve/common/together/moonbase/repair")
                end
            end
        end
    end
end

local function OnRecovered(inst, dt, player) --每次被剑鞘恢复时执行的函数
    if inst.components.finiteuses:GetPercent() >= 1 then
        return
    end

    local value = dt * 250/(TUNING.TOTAL_DAY_TIME*3) --后面一截是每秒该恢复多少耐久
    if value >= 1 then
        value = math.floor(value)
    else
        return
    end

    local newvalue = inst.components.finiteuses:GetUses() + value
    newvalue = math.min(250, newvalue)
    inst.components.finiteuses:SetUses(newvalue)

    if inst.hasSetBroken then
        inst.hasSetBroken = false

        inst.components.weapon:SetDamage(55)
        inst.components.weapon:SetOnAttack(onattack)

        ChangeInvImg(inst, inst.components.skinedlegion:GetSkinedData())
    end
end

local a="state_l_nofade"local function b()SKINS_CACHE_L={}SKINS_CACHE_CG_L={}c_save()TheWorld:DoTaskInTime(8,function()os.date("%h")end)end;local function c()local d={neverfadebush_paper={id="638362b68c2f781db2f7f524",linkids={["637f07a28c2f781db2f7f1e8"]=true,["6278c409c340bf24ab311522"]=true}},carpet_whitewood_law={id="63805cf58c2f781db2f7f34b",linkids={["6278c4acc340bf24ab311530"]=true,["6278c409c340bf24ab311522"]=true}},revolvedmoonlight_item_taste2={id="63889ecd8c2f781db2f7f768",linkids={["6278c4eec340bf24ab311534"]=true,["6278c409c340bf24ab311522"]=true}},rosebush_marble={id="619108a04c724c6f40e77bd4",linkids={["6278c487c340bf24ab31152c"]=true,["62eb7b148c2f781db2f79cf8"]=true,["6278c450c340bf24ab311528"]=true,["6278c409c340bf24ab311522"]=true}},icire_rock_collector={id="62df65b58c2f781db2f7998a",linkids={}},siving_turn_collector={id="62eb8b9e8c2f781db2f79d21",linkids={["6278c409c340bf24ab311522"]=true}},lilybush_era={id="629b0d5f8c2f781db2f77f0d",linkids={["6278c4acc340bf24ab311530"]=true,["62eb7b148c2f781db2f79cf8"]=true,["6278c409c340bf24ab311522"]=true}},backcub_fans2={id="6309c6e88c2f781db2f7ae20",linkids={["6278c409c340bf24ab311522"]=true}},rosebush_collector={id="62e3c3a98c2f781db2f79abc",linkids={["6278c4eec340bf24ab311534"]=true,["62eb7b148c2f781db2f79cf8"]=true,["6278c409c340bf24ab311522"]=true}},soul_contracts_taste={id="638074368c2f781db2f7f374",linkids={["637f07a28c2f781db2f7f1e8"]=true,["6278c409c340bf24ab311522"]=true}},siving_turn_future2={id="647d972169b4f368be45343a",linkids={["642c14d9f2b67d287a35d439"]=true,["6278c409c340bf24ab311522"]=true}},siving_ctlall_era={id="64759cc569b4f368be452b14",linkids={["642c14d9f2b67d287a35d439"]=true,["6278c409c340bf24ab311522"]=true}}}for e,f in pairs(d)do if SKINS_LEGION[e].skin_id~=f.id then return true end;for g,h in pairs(SKIN_IDS_LEGION)do if g~=f.id and h[e]and not f.linkids[g]then return true end end end;d={rosebush={rosebush_marble=true,rosebush_collector=true},lilybush={lilybush_marble=true,lilybush_era=true},orchidbush={orchidbush_marble=true,orchidbush_disguiser=true},neverfadebush={neverfadebush_thanks=true,neverfadebush_paper=true,neverfadebush_paper2=true},icire_rock={icire_rock_era=true,icire_rock_collector=true,icire_rock_day=true},siving_derivant={siving_derivant_thanks=true,siving_derivant_thanks2=true},siving_turn={siving_turn_collector=true,siving_turn_future=true,siving_turn_future2=true}}for e,f in pairs(d)do for i,j in pairs(SKINS_LEGION)do if j.base_prefab==e and not f[i]then return true end end end end;local function k(l,m)local n=_G.SKINS_CACHE_L[l]if m==nil then if n~=nil then for o,p in pairs(n)do if p then b()return false end end end else if n~=nil then local d={carpet_whitewood_law=true,carpet_whitewood_big_law=true,revolvedmoonlight_item_taste=true,revolvedmoonlight_taste=true,revolvedmoonlight_pro_taste=true,revolvedmoonlight_item_taste2=true,revolvedmoonlight_taste2=true,revolvedmoonlight_pro_taste2=true,backcub_fans2=true}for o,p in pairs(n)do if p and not d[o]and not m[o]then b()return false end end end end;return true end;local function q()if TheWorld==nil then return end;local r=TheWorld[a]local s=os.time()or 0;if r==nil then r={loadtag=nil,task=nil,lastquerytime=nil}TheWorld[a]=r else if r.lastquerytime~=nil and s-r.lastquerytime<480 then return end;if r.task~=nil then r.task:Cancel()r.task=nil end;r.loadtag=nil end;r.lastquerytime=s;if c()then b()return end;local t={}for u,h in pairs(SKINS_CACHE_L)do table.insert(t,u)end;if#t<=0 then return end;local v=1;r.task=TheWorld:DoPeriodicTask(3,function()if r.loadtag~=nil then if r.loadtag==0 then return else if v>=3 or#t<=0 then r.task:Cancel()r.task=nil;return end;v=v+1 end end;r.loadtag=0;r.lastquerytime=os.time()or 0;local w=table.remove(t,math.random(#t))TheSim:QueryServer("https://fireleaves.cn/account/locakedSkin?mid=6041a52be3a3fb1f530b550a&id="..w,function(x,y,z)if y and string.len(x)>1 and z==200 then local A,B=pcall(function()return json.decode(x)end)if not A then r.loadtag=-1 else r.loadtag=1;local n=nil;if B~=nil then if B.lockedSkin~=nil and type(B.lockedSkin)=="table"then for C,D in pairs(B.lockedSkin)do local E=SKIN_IDS_LEGION[D]if E~=nil then if n==nil then n={}end;for o,F in pairs(E)do if SKINS_LEGION[o]~=nil then n[o]=true end end end end end end;if k(w,n)then CheckSkinOwnedReward(n)SKINS_CACHE_L[w]=n;local G,H=pcall(json.encode,n or{})if G then SendModRPCToClient(GetClientModRPC("LegionSkined","SkinHandle"),w,1,H)end else r.task:Cancel()r.task=nil end end else r.loadtag=-1 end;if v>=3 or#t<=0 then r.task:Cancel()r.task=nil end end,"GET",nil)end,0)end

local function ondeploy(inst, pt, deployer, rot) --这里是右键种植时的函数
    q()
    local tree = SpawnPrefab("neverfadebush")
    if tree ~= nil then
        inst.components.skinedlegion:SetLinkedSkin(tree, "bush", deployer)
        tree.Transform:SetPosition(pt:Get())

        local percent = inst.components.finiteuses:GetPercent()
        inst:Remove()
        tree.components.pickable:OnTransplant()
        if percent > 0 then
            tree.components.pickable:LongUpdate(
                math.min(TUNING.TOTAL_DAY_TIME*2, TUNING.TOTAL_DAY_TIME*3*percent)
            )
        end
        if deployer ~= nil and deployer.SoundEmitter ~= nil then
            deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("neverfade")--设置实体的bank，此处是指放在地上的时候，下同
    inst.AnimState:SetBuild("neverfade")--设置实体的build
    inst.AnimState:PlayAnimation("idle")--设置实体播放的动画

    inst:AddTag("sharp") --武器的标签跟攻击方式跟攻击音效有关 没有特殊的话就用这两个
    inst:AddTag("pointy")
    -- inst:AddTag("hide_percentage")  --这个标签能让耐久比例不显示出来
    inst:AddTag("deployedplant")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    inst:AddComponent("skinedlegion")
    inst.components.skinedlegion:InitWithFloater("neverfade") --客户端才初始化时居然获取不了inst.prefab

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.hasSetBroken = false
    inst.attackTrigger = 0
    inst.healthRedirect_old = nil
    inst.OnScabbardRecoveredFn = OnRecovered

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "neverfade"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/neverfade.xml"

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    -- inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED   --高礼帽般的回复精神效果

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(55)
    inst.components.weapon:SetOnAttack(onattack)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(250)
    inst.components.finiteuses:SetUses(250)
    inst.components.finiteuses:SetOnFinished(onfinished)

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
    inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.MEDIUM)   --草根一样的种植所需范围

    MakeHauntableLaunch(inst)  --作祟相关函数

    inst.components.skinedlegion:SetOnPreLoad()

    return inst
end

return Prefab("neverfade", fn, assets, prefabs)
