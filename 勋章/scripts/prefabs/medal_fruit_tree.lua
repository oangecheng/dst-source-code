local assets =
{
    Asset("ANIM", "anim/medal_fruit_tree_carrot.zip"),
    Asset("MINIMAP_IMAGE", "cave_banana_tree_stump"),
    Asset("MINIMAP_IMAGE", "cave_banana_tree_burnt"),
}
local prefabs_stump =
{
    "ash",
}

local prefabs_burnt =
{
    "charcoal",
}
----------------------------------------果树部分--------------------------------------------
--再生(生成果实并播放成长动画)
local function onregenfn(inst)
    inst.AnimState:PlayAnimation("grow")
	inst.AnimState:PushAnimation("idle_result", true)
end
--填充果实
local function makefullfn(inst)
	inst.AnimState:PlayAnimation("idle_result", true)
end
--采摘函数
local function onpickedfn(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
    inst.AnimState:PlayAnimation("pick")
	inst.AnimState:PushAnimation("idle",true)
end
--置空(隐藏果实贴图)
local function makeemptyfn(inst)
	inst.AnimState:PlayAnimation("idle",true)
end
--变成树桩
local function setupstump(inst)
    SpawnPrefab("medal_fruit_tree_stump").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end

--被砍时
local function tree_chop(inst, worker)
    --根据是否可采摘播放不同动画
	if inst.components.pickable ~= nil and inst.components.pickable.canbepicked then
		inst.AnimState:PlayAnimation("chop_result")
		inst.AnimState:PushAnimation("idle_result", true)
	else
		inst.AnimState:PlayAnimation("chop")
		inst.AnimState:PushAnimation("idle", true)
	end
    if not (worker ~= nil and worker:HasTag("playerghost")) then
        inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
    end
end
--开始燃烧
local function tree_startburn(inst)
    if inst.components.pickable ~= nil then
        inst.components.pickable.caninteractwith = false
    end
end
--燃烧殆尽
local function tree_burnt(inst)
	local burnt_tree = SpawnPrefab("medal_fruit_tree_burnt")
	burnt_tree.Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end
--熄灭
local function tree_extinguish(inst)
	if inst.components.pickable ~= nil then
	    inst.components.pickable.caninteractwith = true
	end
end
--存储果树是否被烧过、是否可采摘的数据
local function tree_onsave(inst, data)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        data.burnt = true
        data.no_fruit = inst.components.pickable == nil or not inst.components.pickable.canbepicked
    end
end
--加载存储数据
local function tree_onload(inst, data)
    if data ~= nil then
        if data.burnt then
            if data.no_fruit and inst.components.pickable ~= nil then
                inst.components.pickable.canbepicked = false
            end
            tree_burnt(inst)
        end
    end
end
--切换是否能正常结果的状态
local function TogglePickable(inst, season)
    local pickable=inst.components.pickable
	if pickable then
		if season and inst.seasonlist and not inst.seasonlist[season] then
			pickable:Pause()
		else
			pickable:Resume()
		end
	end
end

--哪些季节停止生长
local function MakeNoGrowWithSeason(inst)
	-- inst.components.pickable:WatchWorldState("iswinter", TogglePickable)
	inst:WatchWorldState("season", TogglePickable)
	if inst.seasonlist then
		TogglePickable(inst,TheWorld.state.season)
	end
end

--定义果树
local function MakeFruitTree(def)
	local fruit_tree_assets =
	{
	    Asset("ANIM", "anim/"..def.build..".zip"),
		Asset("ATLAS", "minimap/medal_fruit_tree.xml" ),
	}
	local prefabs_tree =
	{
	    def.produt,
	    "log",
	    "twigs",
	    "medal_fruit_tree_stump",
	    "medal_fruit_tree_burnt",
	}
	--被砍倒后
	local function tree_chopped(inst, worker)
	    if not (worker ~= nil and worker:HasTag("playerghost")) then
	        inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
	    end
	
	    inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")
	
	    if inst.components.pickable ~= nil and inst.components.pickable.canbepicked and inst.fruit_tree_def ~= nil then
	    	--掉落对应果实
			local num = weighted_random_choice(inst.fruit_tree_def.productlist)
			for i = 1, num do
				inst.components.lootdropper:SpawnLootPrefab(inst.fruit_tree_def.product)
			end
	    end
	    inst.components.lootdropper:SpawnLootPrefab(def.name.."_scion")--掉落对应接穗
	    inst.components.pickable.caninteractwith = false
	    inst.components.workable:SetWorkable(false)
	    inst.AnimState:PlayAnimation("fall")
	    inst:ListenForEvent("animover", setupstump)
	end
	--采摘
	local function PickFn(inst, picker)--, loot)
		onpickedfn(inst)
		if inst.fruit_tree_def and inst.fruit_tree_def.productlist then
			local item = SpawnPrefab(inst.fruit_tree_def.product)
            if item ~= nil then
				local num = weighted_random_choice(inst.fruit_tree_def.productlist)--获取收获数量
				if HasOriginMedal(picker,"medal_fastpicker") then--本源丰收加成
					num = num + 1
				end
				local pt = inst:GetPosition()
                --继承潮湿度
				if item.components.inventoryitem ~= nil then
					item.components.inventoryitem:InheritWorldWetnessAtTarget(inst)
                end
				--堆叠
                if num > 1 and item.components.stackable ~= nil then
                    item.components.stackable:SetStackSize(num)
                end
				if picker and picker.components.inventory then
                    picker:PushEvent("picksomething", { object = inst, loot = item })
				end
				if picker and picker.components.inventory and item.components.inventoryitem then
					picker.components.inventory:GiveItem(item, nil, pt)
				else
                    item.Transform:SetPosition(pt:Get())
                end
            end
		end
	end
	--主函数
	local function tree_fn()
	    local inst = CreateEntity()
	
	    inst.entity:AddTransform()
	    inst.entity:AddAnimState()
	    inst.entity:AddSoundEmitter()
	    inst.entity:AddMiniMapEntity()
	    inst.entity:AddNetwork()
	
	    MakeObstaclePhysics(inst, .25)
	
	    -- inst.MiniMapEntity:SetIcon("cave_banana_tree.png")
	    inst.MiniMapEntity:SetIcon(def.name..".tex")
	
	    inst:AddTag("plant")
		inst:AddTag("medal_fruit_tree")
		inst:AddTag("event_trigger")--防止被暗影仆从霍霍了
		-- inst:AddTag("tree")
		if def.skinable then
			inst:AddTag("medal_skinable")--可换皮肤
		end
	
	    inst.AnimState:SetBank(def.bank or def.build)
		-- inst.AnimState:SetBank("medal_fruit_tree_carrot")
	    inst.AnimState:SetBuild(def.build)
	    inst.AnimState:PlayAnimation("idle_result", true)
		
		inst.displaynamefn = function(inst)
			return subfmt(STRINGS.NAMES["MEDAL_FRUIT_TREE"], { product = STRINGS.NAMES[string.upper(def.product)] })
		end
		
		inst.fruit_tree_def=def--果树信息
	
	    inst.entity:SetPristine()
	
	    if not TheWorld.ismastersim then
	        return inst
	    end
	
	    inst.AnimState:SetTime(math.random() * 2)
	
	    inst.seasonlist=def.seasonlist--可生长季节列表
		inst:AddComponent("pickable")
	    inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
	    -- inst.components.pickable:SetUp(def.product, def.growtime,def.productnum)
	    inst.components.pickable:SetUp(nil,def.growtime)
		-- inst.components.pickable.use_lootdropper_for_product = true
	    inst.components.pickable.onregenfn = onregenfn
	    inst.components.pickable.onpickedfn = PickFn--onpickedfn
	    inst.components.pickable.makeemptyfn = makeemptyfn
	    inst.components.pickable.makefullfn = makefullfn
	    inst.components.pickable.nomagic = def.nomagic--禁止催熟
	
	    inst:AddComponent("workable")
	    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	    inst.components.workable:SetWorkLeft(5)
	    inst.components.workable:SetOnFinishCallback(tree_chopped)
	    inst.components.workable:SetOnWorkCallback(tree_chop)
	
	    inst:AddComponent("lootdropper")
	    inst:AddComponent("inspectable")
	
	    if not def.noburnt then
			MakeMediumBurnable(inst)
			MakeSmallPropagator(inst)
			inst.components.burnable:SetOnIgniteFn(tree_startburn)
			inst.components.burnable:SetOnBurntFn(tree_burnt)
			inst.components.burnable:SetOnExtinguishFn(tree_extinguish)
		end

		if not def.growinwinter then
	    	MakeNoGrowInWinter(inst)--冬季不长
		end
		-- MakeNoGrowWithSeason(inst)--非应季不生长
	
	    inst.OnSave = tree_onsave
	    inst.OnLoad = tree_onload

		if def.skinable then
			inst:AddComponent("medal_skinable")
		end
	
	    return inst
	end
	
	return Prefab(def.name, tree_fn, fruit_tree_assets, prefabs_tree)
end
--------------------------------------接穗部分--------------------------------------------
--定义接穗
local function MakeScion(def)
	local scion_assets =
	{
	    -- Asset("ANIM", "anim/"..def.build..".zip"),
		Asset("ANIM", "anim/medal_fruit_tree_scion.zip"),
		Asset("ATLAS", "images/medal_fruit_tree_scion.xml"),
		Asset("ATLAS_BUILD", "images/medal_fruit_tree_scion.xml",256),
	}
	--主函数
	local function scion_fn()
	    local inst = CreateEntity()
	
	    inst.entity:AddTransform()
	    inst.entity:AddAnimState()
	    inst.entity:AddSoundEmitter()
	    inst.entity:AddNetwork()
	
	    MakeInventoryPhysics(inst)
	
	    inst:AddTag("graftingscion")--可嫁接
	
	    inst.AnimState:SetBank("medal_fruit_tree_scion")
	    inst.AnimState:SetBuild("medal_fruit_tree_scion")
	    inst.AnimState:PlayAnimation("medal_fruit_tree_scion")
		
		inst.displaynamefn = function(inst)
			return subfmt(STRINGS.NAMES["MEDAL_FRUIT_TREE_SCION"], { product = STRINGS.NAMES[string.upper(def.product)] })
		end
		
		MakeInventoryFloatable(inst, "large", 0.1, 0.55)
		
		inst.entity:SetPristine()
		
		if not TheWorld.ismastersim then
		    return inst
		end
		
		inst:AddComponent("stackable")
		
		inst:AddComponent("inspectable")
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = def.name.."_scion"--"medal_fruit_tree_scion"
		inst.components.inventoryitem.atlasname = "images/medal_fruit_tree_scion.xml"
		
		inst:AddComponent("fuel")
		inst.components.fuel.fuelvalue = TUNING.MED_FUEL
		
		inst.treename=def.name--对应的嫁接树
		
		MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
		MakeSmallPropagator(inst)
		MakeHauntableLaunch(inst)
	
	    return inst
	end
	
	return Prefab(def.name.."_scion", scion_fn, scion_assets)
end

------------------------------------烧焦部分,这部分可以共用，烧焦了都叫烧焦果树-------------------------------------
--砍掉烧焦的树
local function burnt_chopped(inst)
    inst.components.workable:SetWorkable(false)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")
    inst.AnimState:PlayAnimation("chop_burnt")
    inst.components.lootdropper:SpawnLootPrefab("charcoal")
    inst.persists = false
    inst:DoTaskInTime(50 * FRAMES, inst.Remove)
end
--定义烧焦果树
local function burnt_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .25)

    inst.MiniMapEntity:SetIcon("cave_banana_tree_burnt.png")

    inst:AddTag("plant")

    inst.AnimState:SetBank("medal_fruit_tree_carrot")
    inst.AnimState:SetBuild("medal_fruit_tree_carrot")
    inst.AnimState:PlayAnimation("burnt")

    -- inst:SetPrefabNameOverride("cave_banana_tree")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(burnt_chopped)

    MakeHauntableWorkAndIgnite(inst)

    return inst
end

------------------------------树桩部分，这块可以共用，因为所有果树砍了都是同一种树桩---------------------------------
--开始燃烧(这里用空函数覆盖，意义不明，后面若没用直接删除)
local function stump_startburn(inst)
    --blank fn to override default one since we do not
    --want to add "tree" tag but we still want to save
end
--燃烧殆尽
local function stump_burnt(inst)
    SpawnPrefab("ash").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end
--挖掘
local function stump_dug(inst)
    inst.components.lootdropper:SpawnLootPrefab("medaldug_fruit_tree_stump")
    inst:Remove()
end
--燃烧状态保存
local function stump_onsave(inst, data)
    data.burnt = inst.components.burnable ~= nil and inst.components.burnable:IsBurning() or nil
end

local function stump_onload(inst, data)
    if data ~= nil and data.burnt then
        stump_burnt(inst)
    end
end

local function stump_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.MiniMapEntity:SetIcon("cave_banana_tree_stump.png")

    inst:AddTag("plant")
	inst:AddTag("event_trigger")--防止被暗影仆从霍霍了

    inst.AnimState:SetBank("medal_fruit_tree_carrot")
    inst.AnimState:SetBuild("medal_fruit_tree_carrot")
    inst.AnimState:PlayAnimation("idle_stump")

    -- inst:SetPrefabNameOverride("cave_banana_tree")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnWorkCallback(stump_dug)

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    inst.components.burnable:SetOnIgniteFn(stump_startburn)
    inst.components.burnable:SetOnBurntFn(stump_burnt)

    inst.OnSave = stump_onsave
    inst.OnLoad = stump_onload

    return inst
end

--获取果树数据
local MEDAL_FRUIT_TREE_DEFS = require("medal_defs/medal_fruit_tree_defs").MEDAL_FRUIT_TREE_DEFS

local fruit_trees={}
for i, v in pairs(MEDAL_FRUIT_TREE_DEFS) do
    if v.switch then
		table.insert(fruit_trees, MakeFruitTree(v))
		table.insert(fruit_trees, MakeScion(v))
	end
end
table.insert(fruit_trees, Prefab("medal_fruit_tree_burnt", burnt_fn, assets, prefabs_burnt))
table.insert(fruit_trees, Prefab("medal_fruit_tree_stump", stump_fn, assets, prefabs_stump))
return unpack(fruit_trees)
