--[[
适配showme高亮显示蟾蜍宝箱 [以下代码来自勋章]
]]
--------兼容show me的绿色索引，代码参考自风铃草大佬的穹妹--------
local ndnr_containers={--需要兼容的容器列表
	"ndnr_toadstoolchest",
}
--如果他优先级比我高 这一段生效
for k,mod in pairs(ModManager.mods) do      --遍历已开启的mod
	if mod and mod.SHOWME_STRINGS then      --因为showme的modmain的全局变量里有 SHOWME_STRINGS 所以有这个变量的应该就是showme
		if mod.postinitfns and mod.postinitfns.PrefabPostInit and mod.postinitfns.PrefabPostInit.treasurechest then     --是的 箱子的寻物已经加上去了
			for _, v in ipairs(ndnr_containers) do
				mod.postinitfns.PrefabPostInit[v] = mod.postinitfns.PrefabPostInit.treasurechest
			end
		end
	end
end
--如果他优先级比我低 那下面这一段生效
TUNING.MONITOR_CHESTS = TUNING.MONITOR_CHESTS or {}
for _, v in ipairs(ndnr_containers) do
	TUNING.MONITOR_CHESTS[v] = true
end
