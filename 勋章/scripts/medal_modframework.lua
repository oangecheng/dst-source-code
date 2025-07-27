-------------------------------导入自定义配方----------------------------------
local recipes_status,recipes_data = pcall(require,"medal_defs/medal_recipes")
local difficulty_level = TUNING.IS_LOW_COST and 2 or 1--游戏难度,1普通,2简易

if recipes_status then
    if recipes_data.RecipeFilters then
		for _,data in pairs(recipes_data.RecipeFilters) do
			if data.needshow then
				AddRecipeFilter(data)
			end
		end
	end
	
	if recipes_data.Recipes then
        for _,data in pairs(recipes_data.Recipes) do
			local ingredientID=nil--配方编号
			local needHidden=false--是否隐藏
			local atlas=nil--图集文件
			local image=nil--贴图文件
			if #data.ingredients<difficulty_level then
				ingredientID=1
			else
				ingredientID=difficulty_level
			end
			if difficulty_level>1 then
				needHidden=data.needHidden or false
			end
			
            if not needHidden then
				local level=data.level
				if TUNING.MEDAL_TECH_LOCK and (level==TECH.SCIENCE_ONE or level==TECH.SCIENCE_TWO or level==TECH.SCIENCE_THREE or level==TECH.MAGIC_TWO or level==TECH.MAGIC_THREE) then
					level = TECH.NONE
				end
				if not data.noatlas then
					atlas = data.atlas or ("images/"..(data.product or data.name)..".xml")
				end
				if not data.noimage then
					image = data.image or ((data.product or data.name)..".tex")
				end
				local more_data = data.more_data or {}
				more_data.atlas = atlas
				more_data.image = image
				if recipes_data.MoreDataKeys then
					for i, key in ipairs(recipes_data.MoreDataKeys) do
						if data[key] ~= nil then
							more_data[key] = data[key]
						end
					end
				end
				
				AddRecipe2(data.name, data.ingredients[ingredientID],level,more_data,data.filters)
			end 
        end
    end

	if recipes_data.DeconstructRecipes then
		for _,data in pairs(recipes_data.DeconstructRecipes) do
			AddDeconstructRecipe(data.name,data.ingredients)
		end
	end
end

-----------------------------------动作相关---------------------------------
local queueractlist={}--可兼容排队论的动作
local actions_status,actions_data = pcall(require,"medal_defs/medal_actions")
if actions_status then
    -- 导入自定义动作
    if actions_data.actions then
        for _,act in pairs(actions_data.actions) do
            local action = AddAction(act.id,act.str,act.fn)
            if act.actiondata then
                for k,data in pairs(act.actiondata) do
                    action[k] = data
                end
            end
			--兼容排队论
			if act.canqueuer then
				queueractlist[act.id]=act.canqueuer
				-- table.insert(queueractlist,act.id)
			end
			if not act.nobind then
				AddStategraphActionHandler("wilson",GLOBAL.ActionHandler(action, act.state))
            	AddStategraphActionHandler("wilson_client",GLOBAL.ActionHandler(action,act.state))
			end
        end
    end
    -- 导入动作与组件的绑定
    if actions_data.component_actions then
        for _,v in pairs(actions_data.component_actions) do
            local testfn = function(...)
                local rank = v.type=="POINT" and -3 or -2
				local actions = GLOBAL.select (rank,...)
                for _,data in pairs(v.tests) do
                    if data and data.testfn and data.testfn(...) then
                        data.action = string.upper( data.action )
                        table.insert( actions, GLOBAL.ACTIONS[data.action] )
                    end
                end
            end
            AddComponentAction(v.type, v.component, testfn)
        end
    end
	--修改老动作
	if actions_data.old_actions then
        for _,act in pairs(actions_data.old_actions) do
			if act.switch then 
				local action = GLOBAL.ACTIONS[act.id]
				if act.actiondata then
					for k,data in pairs(act.actiondata) do
						action[k] = data
					end
				end
				if act.state then
					local testfn = act.state.testfn
					AddStategraphPostInit("wilson", function(sg)
						local old_handler = sg.actionhandlers[action].deststate
						sg.actionhandlers[action].deststate = function(inst, action, ...)
							if testfn and testfn(inst,action) and act.state.deststate then
								return act.state.deststate(inst,action)
							end
							return old_handler(inst, action, ...)
						end
					end)
					if act.state.client_testfn then
						testfn = act.state.client_testfn
					end
					AddStategraphPostInit("wilson_client", function(sg)
						local old_handler = sg.actionhandlers[action].deststate
						sg.actionhandlers[action].deststate = function(inst, action, ...)
							if testfn and testfn(inst,action) and act.state.deststate then
								return act.state.deststate(inst,action)
							end
							return old_handler(inst, action, ...)
						end
					end)
				end
			end
        end
    end
end

--动作兼容行为排队论
local actionqueuer_status,actionqueuer_data = pcall(require,"components/actionqueuer")
if actionqueuer_status then
	if AddActionQueuerAction and next(queueractlist) then
    	for k,v in pairs(queueractlist) do
    		AddActionQueuerAction(v,k,true)
    	end
    end
end