local assets = {
    Asset("ANIM", "anim/godtoken.zip"),
    Asset("IMAGE", "images/ndnr_godtoken.tex"),
    Asset("ATLAS", "images/ndnr_godtoken.xml"),
    Asset("ATLAS_BUILD", "images/ndnr_godtoken.xml", 256),
}

function GetGender(prefab)
    for gender, characters in pairs(CHARACTER_GENDERS) do
        for index, value in ipairs(characters) do
            if value == prefab then return gender end
        end
    end
    return "NEUTRAL"
end

--[[
    洞穴月岛地形id：MoonCaveForest:0:MoonMushForest_entrance
    档案馆地形id：ArchiveMaze:2:ArchiveMazeRooms
    月岛主岛地形id：MoonIsland_Mine:1:MoonIsland_Mine
    月岛小岛地形id：MoonIsland_IslandShards:4:MoonIsland_IslandShard
--]]
local function OnProtect(inst)
    local owner = inst.components.inventoryitem.owner
    if owner and owner:HasTag("player") and not owner:HasTag("playerghost") 
        and not (owner.components.sanity and owner.components.sanity:IsLunacyMode()) 
    then
        local boat_x, boat_y, boat_z = owner.Transform:GetWorldPosition()
        local items = TheSim:FindEntities(boat_x, boat_y, boat_z, 16, {"nightmarecreature"}, {"shadowcreature"})
        if items == nil or #items < 3 then
            local boat_x, boat_y, boat_z = owner.Transform:GetWorldPosition()
            local angle = math.random() * 2 * PI
            local offset = (owner.components.walkableplatform ~= nil and
                               owner.components.walkableplatform.platform_radius or 4) + 3 + math.random() * 8
            local spawn_x = boat_x + offset * math.cos(angle)
            local spawn_z = boat_z - offset * math.sin(angle)

            local ent = SpawnPrefab(math.random() < TUNING.TERRORBEAK_SPAWN_CHANCE and "nightmarebeak" or "crawlingnightmare")
            ent:DoTaskInTime(FRAMES, function(inst)
                if inst.components.talker then
                    local gender = GetGender(owner.prefab)
                    inst.components.talker:Say(string.format(TUNING.NDNR_GODTOKEN_CARRIER, gender == "FEMALE" and TUNING.NDNR_CHARACTER_HER or gender == "MALE" and TUNING.NDNR_CHARACTER_HIM or TUNING.NDNR_CHARACTER_IT))
                end
            end)
            ent.Transform:SetPosition(spawn_x, 0, spawn_z)
            ent.components.combat:SetTarget(owner)
        end
    end
end

local function _ondropped(inst)
    inst.components.ndnr_godtoken:StopProtect()
end

local function _onputininventory(inst, owner)
    inst.components.ndnr_godtoken:StartProtect()
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBuild("godtoken")
    inst.AnimState:SetBank("godtoken")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("godprotected")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()
    --------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------------------------
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")

    inst.components.inventoryitem.atlasname = "images/ndnr_godtoken.xml"

    inst:AddComponent("ndnr_godtoken")
    inst.components.ndnr_godtoken:OnProtect(OnProtect)
    inst.components.ndnr_godtoken:StartProtect()

    inst:AddComponent("tradable")

    inst:ListenForEvent("ondropped", _ondropped)
    inst:ListenForEvent("onputininventory", _onputininventory)

    MakeHauntableLaunch(inst)

    return inst
end
return Prefab("ndnr_godtoken", fn, assets, prefabs)
