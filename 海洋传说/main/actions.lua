local REPAIR_LG = Action({ mount_valid=true })	
REPAIR_LG.id = "REPAIR_LG"
REPAIR_LG.str = STRINGS.REPAIR_LG
REPAIR_LG.fn = function(act)
    if act.target ~= nil and act.target.components.finiteuses ~= nil and act.invobject  then
		act.target.components.finiteuses:Use(act.target.components.finiteuses.repairnum or 0 )
		if act.invobject.components.stackable ~= nil then
			act.invobject.components.stackable:Get():Remove()
		else
			act.invobjectm:Remove()
		end
		return true
    end
end

AddAction(REPAIR_LG)
AddComponentAction("USEITEM", "repair_lg" , function(inst, doer, target, actions, right)
    if right then
        if target and target:HasTag("repairable_lg") then
			table.insert(actions, ACTIONS.REPAIR_LG)
        end
	end
end)
AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.REPAIR_LG, "dolongaction"))
AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.REPAIR_LG, "dolongaction"))