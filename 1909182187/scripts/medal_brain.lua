--判断是否该逃跑
local function ShouldRunAway(guy)
	return guy:HasTag("character") and not guy:HasTag("notarget") and not guy.lightninggoat_friend
end
--修改羊的逃跑函数，不怕戴羊角帽的玩家
local function MakeLightninggoatClosePlayer(brain)
	local sequenceGroup=nil
	for i,node in ipairs(brain.bt.root.children) do
		-- print("\t"..node.name.." > "..(node.children and node.children[1].name or ""))
		if node.name == "Sequence" and node.children[1].name == "FaceEntity" then
			if node.children[2].name == "RunAway" then
				sequenceGroup=node
			end
			break
		end
	end
	if not sequenceGroup then
		-- print("没拿到逃跑函数")
		return
	end
	
	sequenceGroup.children[2].hunterfn=ShouldRunAway
end

AddBrainPostInit("lightninggoatbrain", MakeLightninggoatClosePlayer)