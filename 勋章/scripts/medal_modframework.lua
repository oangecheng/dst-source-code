local pcall = GLOBAL.pcall
local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

-------------------------------导入自定义配方----------------------------------
local recipes_status,recipes_data = pcall(require,"medal_defs/medal_recipes")
local difficulty_level=1--游戏难度，普通
if TUNING.IS_LOW_COST then
	difficulty_level=2--简易
end
if recipes_status then
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
			if not data.noatlas then
				atlas = data.atlas or ("images/"..(data.product or data.name)..".xml")
			end
			if not data.noimage then
				image = data.image or ((data.product or data.name)..".tex")
			end
            if not needHidden then
				local level=data.level
				if TUNING.MEDAL_TECH_LOCK and (level==TECH.SCIENCE_ONE or level==TECH.SCIENCE_TWO or level==TECH.SCIENCE_THREE or level==TECH.MAGIC_TWO or level==TECH.MAGIC_THREE) then
					level = TECH.NONE
				end
				
				AddRecipe2(data.name, data.ingredients[ingredientID],level,{
					min_spacing = data.min_spacing,
					nounlock = data.nounlock,
					numtogive = data.numtogive,
					builder_tag = data.builder_tag,
					atlas = atlas,
					image = image,
					testfn = data.testfn,
					product = data.product,
					build_mode = data.build_mode,
					build_distance = data.build_distance,

					placer=data.placer,
					filter=data.filter,
					description=data.description,
					canbuild=data.canbuild,
					sg_state=data.sg_state,
					no_deconstruction=data.no_deconstruction,
					require_special_event=data.require_special_event,
					dropitem=data.dropitem,
					actionstr=data.actionstr,
					manufactured=data.manufactured,
				},data.filters)
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
            AddStategraphActionHandler("wilson",GLOBAL.ActionHandler(action, act.state))
            AddStategraphActionHandler("wilson_client",GLOBAL.ActionHandler(action,act.state))
        end
    end
    -- 导入动作与组件的绑定
    if actions_data.component_actions then
        for _,v in pairs(actions_data.component_actions) do
            local testfn = function(...)
                local actions = GLOBAL.select (-2,...)
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
						sg.actionhandlers[action].deststate = function(inst, action)
							if testfn and testfn(inst,action) and act.state.deststate then
								return act.state.deststate(inst,action)
							end
							return old_handler(inst, action)
						end
					end)
					if act.state.client_testfn then
						testfn = act.state.client_testfn
					end
					AddStategraphPostInit("wilson_client", function(sg)
						local old_handler = sg.actionhandlers[action].deststate
						sg.actionhandlers[action].deststate = function(inst, action)
							if testfn and testfn(inst,action) and act.state.deststate then
								return act.state.deststate(inst,action)
							end
							return old_handler(inst, action)
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