local prefabs =
{
    "medal_gift_fruit",
    "medal_gift_fruit_seed",
}

local assets =
{
    Asset("ANIM", "anim/dragonfly_chest.zip"),
	Asset("ANIM", "anim/medal_pay_tribute_box.zip"),
	Asset("ATLAS", "minimap/medal_pay_tribute_box.xml"),
}


--锤爆
local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    inst.components.lootdropper:SpawnLootPrefab("medal_gift_fruit")
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

--锤
local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("closed", false)
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
        inst.components.container:Close()
    end
end

local function onopen(inst)
    inst.AnimState:PlayAnimation("open")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
end

local function onclose(inst)
    inst.AnimState:PlayAnimation("closed")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
end

--价值换算
local function matrixingValue(giftValue)
    giftValue = giftValue or 1
    return math.floor(giftValue/4),giftValue%4--种子数量、果实数量
end

--计算价值(智慧勋章预测)
local function countValue(player,giftValue)
    if player and player:HasTag("wisdombuilder") then
        local consume = TUNING_MEDAL.WISDOM_MEDAL.COUNT_USE
        local medal = player.components.inventory:EquipMedalWithName("wisdom_certificate")--获取玩家的智慧勋章
        if medal and medal.components.finiteuses and medal.components.finiteuses:GetUses() >= consume then
            medal.components.finiteuses:Use(consume)--消耗智慧值
            local seedNum,fruitNum = matrixingValue(giftValue)
            MedalSay(player,STRINGS.WISDOM_MEDAL_SPEECH.COUNTVALUE..STRINGS.NAMES.KNOWN_MEDAL_GIFT_FRUIT_SEED.."*"..seedNum.."+"..STRINGS.NAMES.MEDAL_GIFT_FRUIT.."*"..fruitNum)
            return true
        end
    end
end

--掉落奖励(inst,包裹价值)
local function DropGifts(inst,giftValue)
    local seedNum,fruitNum = matrixingValue(giftValue)
    if seedNum>0 then
        local seed = SpawnPrefab("medal_gift_fruit_seed")
        if seed then
            if seed.components.stackable then
                seed.components.stackable:SetStackSize(seedNum)
            end
            inst.components.lootdropper:FlingItem(seed)
        end
    end

    if fruitNum>0 then
        local fruit = SpawnPrefab("medal_gift_fruit")
        if fruit then
            if fruit.components.stackable then
                fruit.components.stackable:SetStackSize(fruitNum)
            end
            inst.components.lootdropper:FlingItem(fruit)
        end
    end

    inst.components.container:DestroyContents()--销毁里面的物品
	inst.components.container:Close()--关闭容器
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

--统计猜测结果
local function GetResult(_answer,guess)
	local both = 0--位置颜色都对
	local color = 0--颜色对但是位置不对
    local answer = shallowcopy(_answer)

    for k,v in ipairs(guess) do
		if v == answer[k] or v==15 then--不朽果实可以替代任何蔬果
			both = both + 1
			answer[k] = 0
		end
	end
	for k,v in ipairs(guess) do
		if answer[k] ~= 0 then
			for k1,v1 in ipairs(answer) do
				if v==v1 then
					color = color + 1
					answer[k1] = answer[k1] * -1
					break
				end
			end
		end
	end
	return both,color
end

--获取答案
local function GetAnswer(inst)
    local strs={}
    if inst.tribute_answer ~= nil then
        for i, v in ipairs(inst.tribute_answer) do
            strs["veg"..i] = STRINGS.NAMES[string.upper(GetPayTributeData(v))]
        end
    end
    return strs
end

--是否为有效的预言水晶球
local function IsCrystalball(item)
    return item.prefab == "medal_spacetime_crystalball" 
        and item.components.finiteuses ~=nil 
        and item.components.finiteuses:GetUses()>TUNING_MEDAL.MEDAL_SPACETIME_CRYSTALBALL_USE1
end
--使用玩家身上的预言水晶球
local function UseCrystalball(inst,doer)
    local crystalball =  doer and doer.components.inventory:FindItem(IsCrystalball)--获取玩家身上灵魂
    if crystalball ~= nil then
        crystalball.components.finiteuses:Use(TUNING_MEDAL.MEDAL_SPACETIME_CRYSTALBALL_USE1)
        return true
    end
end

--彩蛋掉落表
local easter_eggs_drop_loot = {
    medaldug_fruit_tree_stump=1,--砧木桩
    monster_book=1,--怪物图鉴
    trinket_17=1,--弯曲的叉子
    medal_chum=1,--特制鱼食
}

--奉纳
local function PayTribute(inst,doer)
    if inst.tribute_answer ~= nil then
        local itemlist = inst.components.container:GetAllItems()
        local guess_list = {}
        for k, v in ipairs(itemlist) do
            guess_list[k] = v and GetPayTributeData(v.prefab) or 0--蔬果名转化为数字
        end
        -- print(inst.tribute_answer[1],inst.tribute_answer[2],inst.tribute_answer[3],inst.tribute_answer[4])
        -- print(guess_list[1],guess_list[2],guess_list[3],guess_list[4])
        local both, color = GetResult(inst.tribute_answer,guess_list)--统计猜测结果
        if inst.tribute_data then
            local size = #inst.tribute_data
            if both >= 4 then--答对了，直接掉礼物
                local gift_value = 15 - size - (inst.isprophesied or 0) + (inst.ball_times or 0)--礼物价值
                --彩蛋
                if inst.components.lootdropper and gift_value>=13 and inst.isprophesied == nil and inst.ball_times == nil then
                    local easter_egg_chance = 1 - .5 * (14 - gift_value)
                    if math.random() < easter_egg_chance then
                        if TheWorld and TheWorld.components.medal_infosave and TheWorld.components.medal_infosave:TriggerEasterEggs(doer) then
                            inst.components.lootdropper:SpawnLootPrefab(weighted_random_choice(easter_eggs_drop_loot))
                        end
                    end
                end
                DropGifts(inst, math.min(gift_value,12))--掉落礼物
            elseif size <= 6 then--答题次数小于7，记录
                if UseCrystalball(inst,doer) then--身上有预言水晶球的话，失败能消耗耐久抵消猜测次数
                    inst.ball_times = (inst.ball_times or 0) + 1
                end
                inst.tribute_data[size + 1] = {}
                for i, v in ipairs(guess_list) do
                    inst.tribute_data[size + 1][i] = v
                end
                inst.tribute_data[size + 1][5] = both
                inst.tribute_data[size + 1][6] = color
                --给客户端同步猜测记录
                if inst.medal_tribute_str then
                    local info_str=json.encode(inst.tribute_data)
                    inst.medal_tribute_str:set(info_str)
                end
            else--第7次没答对直接发安慰奖了
                DropGifts(inst,3)
                --失败提示，直接告知答案了
                MedalSay(doer,subfmt(STRINGS.Medal_PAY_TRIBUTE_SPEECH.FAIL, GetAnswer(inst)))
            end
        end
    end
end

--预言
local function ProphesyFn(inst,doer)
    inst.isprophesied = 3--被预言过的要扣3点包果值
    MedalSay(doer,subfmt(STRINGS.Medal_PAY_TRIBUTE_SPEECH.PROPHESY, GetAnswer(inst)))
end

--初始化备选蔬果池
local SIZE = 10--最大14,只取前10个不那么常用的蔬果
local function InitVeggies(tb)
    local a={}
    for i = 1, SIZE do a[i]=i end
    for i = 1, 6 do
        tb[i] = table.remove(a,math.random(SIZE + 1 - i))
    end
end

--蔬果奉纳数据初始化
local function InitTributeData(inst)
    -- inst.tribute_answer = {1,3,5,9}--答案格式
    -- inst.tribute_data = {--结果列表
    --     {1,3,5,8,9,13},--备选蔬果
    --     {1,5,9,9,2,1},--第1条猜测,前4位为蔬果ID,第5位全对数量,第6位仅种类数量
    -- }
    
    --初始化备选蔬果池
    if inst.tribute_data == nil then
        inst.tribute_data = {{}}
        InitVeggies(inst.tribute_data[1])
    end
    --确定答案
    if inst.tribute_answer == nil then
        inst.tribute_answer = {}
        for i = 1, 4 do
            inst.tribute_answer[i] = inst.tribute_data[1][math.random(6)]
        end
    end
    
    --给客户端同步猜测记录
    if inst.tribute_data and inst.medal_tribute_str then
        local info_str=json.encode(inst.tribute_data)
        inst.medal_tribute_str:set(info_str)
    end
end

local function onsave(inst, data)
    --猜测记录
    if inst.tribute_data ~= nil then
        data.tribute_data = deepcopy(inst.tribute_data)
    end
    --答案
    if inst.tribute_answer ~= nil then
        data.tribute_answer = shallowcopy(inst.tribute_answer)
    end
end

local function onload(inst, data)
    if data then
        --猜测记录
        if data.tribute_data ~= nil then
            inst.tribute_data = deepcopy(data.tribute_data)
        end
        --答案
        if data.tribute_answer ~= nil then
            inst.tribute_answer = shallowcopy(data.tribute_answer)
        end
        InitTributeData(inst)
    end
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 0.5)

    inst.MiniMapEntity:SetIcon("medal_pay_tribute_box.tex")

    inst.AnimState:SetBank("dragonfly_chest")--用龙鳞箱的bank
    inst.AnimState:SetBuild("medal_pay_tribute_box")
    inst.AnimState:PlayAnimation("closed",true)

    inst:AddTag("structure")
    inst:AddTag("medal_predictable")--可被预言

    inst.medal_tribute_str = net_string(inst.GUID, "medal_tribute_str")--蔬果奉纳数据

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -------------------------
    inst:AddComponent("lootdropper")

    inst:AddComponent("container")
	inst.components.container:WidgetSetup("medal_pay_tribute_box")
	inst.components.container.onopenfn = onopen
	inst.components.container.onclosefn = onclose

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(5)--需要锤多少下
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)
	
    MakeLargeBurnable(inst)
    MakeMediumPropagator(inst)
    MakeSnowCovered(inst)
	
    inst:AddComponent("inspectable")

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_MEDIUM)

    inst.PayTribute = PayTribute--奉纳
    inst.ProphesyFn = ProphesyFn--预言
    inst.GetAnswer = GetAnswer

    -- inst.OnSave = onsave
	-- inst.OnLoad = onload

    inst:DoTaskInTime(0,function(inst)
        InitTributeData(inst)
    end)

    return inst
end

return Prefab("medal_pay_tribute_box", fn, assets, prefabs)
