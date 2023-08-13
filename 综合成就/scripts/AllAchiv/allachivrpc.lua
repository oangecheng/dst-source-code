--SendModRPCToServer(MOD_RPC["DSTAchievement"]["healthup"])
--modname的名字不能有中文！！！

AddModRPCHandler("DSTAchievement", "hungerup", function(player)
	player.components.allachivcoin:hungerupcoin(player)
end)

AddModRPCHandler("DSTAchievement", "sanityup", function(player)
	player.components.allachivcoin:sanityupcoin(player)
end)

AddModRPCHandler("DSTAchievement", "healthup", function(player)
	player.components.allachivcoin:healthupcoin(player)
end)

AddModRPCHandler("DSTAchievement", "hungerrateup", function(player)
	player.components.allachivcoin:hungerrateupcoin(player)
end)

AddModRPCHandler("DSTAchievement", "healthregen", function(player)
	player.components.allachivcoin:healthregencoin(player)
end)

AddModRPCHandler("DSTAchievement", "sanityregen", function(player)
	player.components.allachivcoin:sanityregencoin(player)
end)

AddModRPCHandler("DSTAchievement", "speedup", function(player)
	player.components.allachivcoin:speedupcoin(player)
end)

AddModRPCHandler("DSTAchievement", "damageup", function(player)
	player.components.allachivcoin:damageupcoin(player)
end)

AddModRPCHandler("DSTAchievement", "absorbup", function(player)
	player.components.allachivcoin:absorbupcoin(player)
end)

AddModRPCHandler("DSTAchievement", "crit", function(player)
	player.components.allachivcoin:critcoin(player)
end)

AddModRPCHandler("DSTAchievement", "fireflylight", function(player)
	player.components.allachivcoin:fireflylightcoin(player)
end)

AddModRPCHandler("DSTAchievement", "nomoist", function(player)
	player.components.allachivcoin:nomoistcoin(player)
end)

AddModRPCHandler("DSTAchievement", "doubledrop", function(player)
	player.components.allachivcoin:doubledropcoin(player)
end)

AddModRPCHandler("DSTAchievement", "goodman", function(player)
	player.components.allachivcoin:goodmancoin(player)
end)

AddModRPCHandler("DSTAchievement", "fishmaster", function(player)
	player.components.allachivcoin:fishmastercoin(player)
end)

AddModRPCHandler("DSTAchievement", "pickmaster", function(player)
	player.components.allachivcoin:pickmastercoin(player)
end)

AddModRPCHandler("DSTAchievement", "chopmaster", function(player)
	player.components.allachivcoin:chopmastercoin(player)
end)

AddModRPCHandler("DSTAchievement", "cookmaster", function(player)
	player.components.allachivcoin:cookmastercoin(player)
end)

AddModRPCHandler("DSTAchievement", "buildmaster", function(player)
	player.components.allachivcoin:buildmastercoin(player)
end)

AddModRPCHandler("DSTAchievement", "refresh", function(player)
	player.components.allachivcoin:refreshcoin(player)
end)

AddModRPCHandler("DSTAchievement", "icebody", function(player)
	player.components.allachivcoin:icebodycoin(player)
end)

AddModRPCHandler("DSTAchievement", "firebody", function(player)
	player.components.allachivcoin:firebodycoin(player)
end)

AddModRPCHandler("DSTAchievement", "supply", function(player)
	player.components.allachivcoin:supplycoin(player)
end)

AddModRPCHandler("DSTAchievement", "reader", function(player)
	player.components.allachivcoin:readercoin(player)
end)

AddModRPCHandler("DSTAchievement", "removecoin", function(player)
	player.components.allachivcoin:removecoin(player)
end)