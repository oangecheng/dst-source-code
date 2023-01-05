--------------------------------------------------------------------------
--[[ TownPortalRegistry class definition ]]
--------------------------------------------------------------------------

return Class(function(self, inst)

assert(TheWorld.ismastersim, "TownPortalRegistry should not exist on client")

--------------------------------------------------------------------------
--[[ Member variables ]]
--------------------------------------------------------------------------

--Public
self.inst = inst--世界自身

--Private
local _townportals = {}--传送塔列表
local _hyperspacechests = {}--超时空容器列表


--------------------------------------------------------------------------
--[[ Private member functions ]]
--私有成员函数
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--[[ Private event handlers ]]
--私有事件处理程序
--------------------------------------------------------------------------

--传送塔被激活时
local function OnItemActivated(inst, item)
    if item.prefab=="medal_space_staff" then
        item:PushEvent("get_medal_hyperspacechests",_hyperspacechests)--推送给被摸的时空法杖
    else
        item:PushEvent("get_medal_townportals",_townportals)--推送给被摸的传送塔
    end
end
-------------------传送塔---------------------
--当传送塔被移除时
local function OnRemoveTownPortal(townportal)
    for i, v in ipairs(_townportals) do
        if v == townportal then
            table.remove(_townportals, i)--移除传送塔列表中对应的传送塔
            --取消对该传送塔的监听事件
			inst:RemoveEventCallback("onremove", OnRemoveTownPortal, townportal)
            break
        end
    end
end
--注册传送塔
local function OnRegisterTownPortal(inst, townportal)
    --遍历传送塔列表，如果已有该传送塔则返回
	for i, v in ipairs(_townportals) do
        if v == townportal then
            return
        end
    end
	--将新的传送塔插入到传送塔列表里
    table.insert(_townportals, townportal)
	--给这个传送塔安排监听事件，监听自己被移除
    inst:ListenForEvent("onremove", OnRemoveTownPortal, townportal)
end


-------------------超时空宝箱---------------------
--被移除时
local function OnRemoveHyperspaceChest(chest)
    for i, v in ipairs(_hyperspacechests) do
        if v == chest then
            table.remove(_hyperspacechests, i)
			inst:RemoveEventCallback("onremove", OnRemoveHyperspaceChest, chest)
			inst:RemoveEventCallback("removespacepos", OnRemoveHyperspaceChest, chest)
            break
        end
    end
end
--注册
local function OnRegisterHyperspaceChest(inst, chest)
    for i, v in ipairs(_hyperspacechests) do
        if v == chest then
            return
        end
    end
    table.insert(_hyperspacechests, chest)
    inst:ListenForEvent("onremove", OnRemoveHyperspaceChest, chest)
    inst:ListenForEvent("removespacepos", OnRemoveHyperspaceChest, chest)
end

--------------------------------------------------------------------------
--[[ Initialization ]]
--------------------------------------------------------------------------

--Register events
inst:ListenForEvent("ms_medal_registertownportal", OnRegisterTownPortal)--监听传送塔注册事件
inst:ListenForEvent("ms_medal_registerhyperspacechest", OnRegisterHyperspaceChest)--监听超时空宝箱注册事件
inst:ListenForEvent("medal_touchdelivery", OnItemActivated)--监听打开界面事件

--------------------------------------------------------------------------
--[[ Post initialization ]]
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--[[ Update ]]
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--[[ Public member functions ]]
--公共成员函数
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--[[ Save/Load ]]
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--[[ Debug ]]
--------------------------------------------------------------------------
--调试用
function self:GetDebugString()
	local s = "Town Portals: " .. tostring(#_townportals)
	return s
end

--------------------------------------------------------------------------
--[[ End ]]
--------------------------------------------------------------------------

end)
