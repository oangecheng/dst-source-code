--------------------------------------------------添加勋章新sg---------------------------------------------
AddStategraphState('wilson',
    --摇铃铛动画
	State{
        name = "play_bell",
        tags = { "doing", "playing" },

        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("action_uniqueitem_pre")
            inst.AnimState:PushAnimation("bell", false)
			local bell=inst.bufferedaction ~= nil and inst.bufferedaction.invobject or nil
            inst.AnimState:OverrideSymbol("bell01", GetMedalSkinData(bell,"medal_naughtybell"), "bell01")
            inst.AnimState:Show("ARM_normal")
            inst.components.inventory:ReturnActiveActionItem(inst.bufferedaction ~= nil and inst.bufferedaction.invobject or nil)
        end,

        timeline =
        {
            TimeEvent(15 * GLOBAL.FRAMES, function(inst)
                inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/glommer_bell")
            end),

            TimeEvent(60 * GLOBAL.FRAMES, function(inst)
                inst:PerformBufferedAction()
            end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
            end),
        },

        onexit = function(inst)
            if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
                inst.AnimState:Show("ARM_carry")
                inst.AnimState:Hide("ARM_normal")
            end
        end
    }
)
AddStategraphState('wilson',
    --传送动画
	State{
        name = "medal_entertownportal",
        tags = { "doing", "busy", "nopredict", "nomorph", "nodangle" },

        onenter = function(inst, data)
            inst.sg.statemem.isphysicstoggle = true
			--暂时清除玩家的一些物理设置
			inst.Physics:ClearCollisionMask()
			inst.Physics:CollidesWith(COLLISION.GROUND)
            inst.Physics:Stop()
            inst.components.locomotor:Stop()

            inst.sg.statemem.teleporter = data.teleporter--传送塔
            inst.sg.statemem.target = data.target--目标传送塔
            inst.sg.statemem.teleportarrivestate = "exittownportal_pre"

            inst.AnimState:PlayAnimation("townportal_enter_pre")

            inst.sg.statemem.fx = SpawnPrefab("townportalsandcoffin_fx")
            inst.sg.statemem.fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        end,

        timeline =
        {
            TimeEvent(8 * FRAMES, function(inst)
                inst.sg.statemem.isteleporting = true
                inst.components.health:SetInvincible(true)
                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:Enable(false)
                end
                inst.DynamicShadow:Enable(false)
            end),
            TimeEvent(18 * FRAMES, function(inst)
                inst:Hide()
            end),
            TimeEvent(26 * FRAMES, function(inst)
                --传送塔和目标传送塔不为空则传送
				if inst.sg.statemem.teleporter ~= nil and inst.sg.statemem.target ~= nil and inst.sg.statemem.target:IsValid() then
                    if inst.sg.statemem.teleporter.components.medal_delivery then
						inst.sg.statemem.teleporter.components.medal_delivery:Activate(inst,inst.sg.statemem.target)
					end
					inst:Hide()
                    inst.sg.statemem.fx:KillFX()
                else
                    inst.sg:GoToState("exittownportal")
                end
            end),
        },

        onexit = function(inst)
            inst.sg.statemem.fx:KillFX()
			--恢复玩家物理设置
            if inst.sg.statemem.isphysicstoggle then
                inst.sg.statemem.isphysicstoggle = nil
				inst.Physics:ClearCollisionMask()
				inst.Physics:CollidesWith(COLLISION.WORLD)
				inst.Physics:CollidesWith(COLLISION.OBSTACLES)
				inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
				inst.Physics:CollidesWith(COLLISION.CHARACTERS)
				inst.Physics:CollidesWith(COLLISION.GIANTS)
            end

            if inst.sg.statemem.isteleporting then
                inst.components.health:SetInvincible(false)
                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:Enable(true)
                end
                inst:Show()
                inst.DynamicShadow:Enable(true)
            end
        end,
    }
)
--变身鱼人动画
AddStategraphState('wilson',
    --变身鱼人
	State{
        name = "medal_transform_merm",
        tags = { "busy", "pausepredict", "nodangle", "nomorph", "nointerrupt" },
        
        onenter = function(inst, dest)
            inst:ClearBufferedAction()
            
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
			
            inst.AnimState:PlayAnimation("transform_merm")
        
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:RemotePausePrediction()
				inst.components.playercontroller:Enable(false)--变身期间不可操作
            end
			
			inst.DynamicShadow:Enable(false)
			inst:ShowHUD(false)--隐藏hud
        end,
        
        timeline =
        {
            TimeEvent(FRAMES, function(inst)
                inst.sg:AddStateTag("noattack")
                inst.components.health:SetInvincible(true)--变身无敌
                inst.DynamicShadow:Enable(false)
            end),
        },
        
        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    -- inst.sg:GoToState("knockout")
                    -- inst.sg:GoToState("knockback")
                    inst.sg:GoToState("wakeup")
                end
            end),
        },
        
        onexit = function(inst)
			inst.components.health:SetInvincible(false)
			inst.DynamicShadow:Enable(true)
			inst:ShowHUD(true)
			local medal = SpawnPrefab("merm_certificate")
			medal.Transform:SetPosition(inst.Transform:GetWorldPosition())
			if medal.components.inventoryitem ~= nil then
				medal.components.inventoryitem:OnDropped(true, .5)
			end
        end,
    }
)

--强制卸下重物
local function ForceStopHeavyLifting(inst)
    if inst.components.inventory:IsHeavyLifting() then
        inst.components.inventory:DropItem(
            inst.components.inventory:Unequip(EQUIPSLOTS.BODY),
            true,
            true
        )
    end
end

--恐惧
AddStategraphState('wilson',
	State{
		name = "medal_spooked",
		tags = { "busy", "pausepredict" },
	
		onenter = function(inst)
			ForceStopHeavyLifting(inst)
			inst.components.locomotor:Stop()
			inst:ClearBufferedAction()
	
			inst.AnimState:PlayAnimation("spooked")
	
			if inst.components.playercontroller ~= nil then
				inst.components.playercontroller:RemotePausePrediction()
			end
		end,
	
		timeline =
		{
			TimeEvent(49 * FRAMES, function(inst)
				inst.sg:GoToState("idle", true)
			end),
		},
	
		events =
		{
			EventHandler("animover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
				end
			end),
			EventHandler("attacked", function(inst)
				if not (inst.components.health and inst.components.health:IsDead()) then
					inst.sg:GoToState("idle")
				end
			end),
		},
	}
)

--超长搓手动画(2,4秒)
AddStategraphState('wilson',
	State{
		name = "medal_dolongestaction",
		onenter = function(inst)
			local mult = HasOriginMedal(inst,"has_handy_medal") and .5 or 1--本源+巧手时间减半
			inst.sg:GoToState("dolongaction", math.random(2,4) * mult)
		end,
	}
)

--超长搓手动画(2,4秒)
AddStategraphState('wilson_client',
	State{
		name = "medal_dolongestaction",
		onenter = function(inst)
			inst.sg:GoToState("dolongaction")
		end,
	}
)

--掉入时空塌陷
AddStategraphState('wilson',
	State{
		name = "fall_into_black_hole",
		tags = { "busy", "nopredict", "nomorph", "drowning", "nointerrupt", "fallhole" },

		onenter = function(inst, posinfo)
			ForceStopHeavyLifting(inst)
			inst:ClearBufferedAction()

			inst.components.locomotor:Stop()
			inst.components.locomotor:Clear()

			inst.AnimState:PlayAnimation("sink")
			inst.AnimState:SetTime(60 * FRAMES)
			inst.AnimState:Hide("plank")
			inst.AnimState:Hide("float_front")
			inst.AnimState:Hide("float_back")
			inst.AnimState:Hide("fx_bubble")
			inst.AnimState:Hide("fx_splash")

			if inst.components.rider:IsRiding() then
				inst.sg:AddStateTag("dismounting")
			end

			inst.sg.statemem.posinfo=posinfo

			inst.DynamicShadow:Enable(false)
			inst:ShowHUD(false)
		end,
		timeline =
        {
            TimeEvent(14 * FRAMES, function(inst)
				inst.sg.statemem.snap_camera = true
				inst:ScreenFade(false, 0.2)
            end),
        },
		events =
		{
			EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    local posinfo = inst.sg.statemem.posinfo
					if posinfo ~= nil then
						local worldid=posinfo.worldid and tostring(posinfo.worldid) or nil
						if worldid ~= nil and worldid ~= TheShard:GetShardId() and Shard_IsWorldAvailable(worldid) then
							TheWorld:PushEvent("ms_playerdespawnandmigrate", { player = inst, portalid = nil, worldid = worldid, x = posinfo.pos.x, y = 0, z = posinfo.pos.z })
							return
						else
							inst.Transform:SetPosition(posinfo.pos.x,0,posinfo.pos.z)
						end
						--恢复保存的血量
						if posinfo.savehealth and inst.components.health then
							if inst.components.oldager then--旺达需要特殊回复血量,不过也就续个2岁了，趁着没死赶紧跑吧
								inst.components.oldager:StopDamageOverTime()
								inst.components.health.currenthealth = 2
								inst.components.oldager._taking_time_damage = true
								inst.components.health:DoDelta(0)
								inst.components.oldager._taking_time_damage = false
							else
								inst.components.health.currenthealth = posinfo.savehealth
								inst.components.health:DoDelta(0)
							end
							inst:AddDebuff("spawnprotectionbuff", "spawnprotectionbuff")
						end
					end
					--骑牛不播掉落动画了
					if inst.components.rider and inst.components.rider:IsRiding() then
						local x, y, z = inst.Transform:GetWorldPosition()
						local fx = SpawnPrefab("pocketwatch_portal_exit_fx")
						fx.Transform:SetPosition(x, 4, z)
						inst.sg:GoToState("mounted_idle")
					else
						inst.sg:GoToState("pocketwatch_portal_fallout")
					end
                end
            end),
		},

		onexit = function(inst)
			inst.AnimState:Show("plank")
			inst.AnimState:Show("float_front")
			inst.AnimState:Show("float_back")
			inst.AnimState:Show("fx_bubble")
			inst.AnimState:Show("fx_splash")
			inst.DynamicShadow:Enable(true)
			inst:ShowHUD(true)
			if inst.sg.statemem.snap_camera then
				inst:SnapCamera()
				inst:ScreenFade(true, 0.5)
			end
		end,
	}
)

--------------------------------------------------hook原版sg---------------------------------------------
--食人花sg
AddStategraphPostInit("lureplant", function(sg)
	if sg.states and sg.states.showbait then
		local oldonenter = sg.states.showbait.onenter
		sg.states.showbait.onenter = function(inst, ...)
			--诱饵是吞噬法杖的时候展示吞噬法杖
			if inst.lure and inst.lure.prefab=="devour_staff" then
                inst.AnimState:OverrideSymbol("swap_dried", "devour_staff", "showbait_devour_staff")
				inst.Physics:Stop()
                inst.AnimState:PlayAnimation("emerge")
			elseif oldonenter then
				oldonenter(inst, ...)
			end
		end
	end
end)

--坎普斯sg
AddStategraphPostInit("krampus", function(sg)
	if sg.states then
		--防止坎普斯、复仇坎普斯多倍掉落
		if sg.states.death then
			local oldonenter = sg.states.death.onenter
			sg.states.death.onenter = function(inst, ...)
				if not inst.died_once then
					if oldonenter then
						oldonenter(inst, ...)
					end
					inst.died_once = true
				end
			end
		end
		--防止坎普斯卡无敌
		if sg.states.idle and sg.states.idle.events then
			local oldanimover = sg.states.idle.events.animover and sg.states.idle.events.animover.fn
			if oldanimover ~= nil then
				sg.states.idle.events.animover.fn = function(inst, ...)
					if inst.components.health and inst.components.health:IsInvincible() then
						inst.sg:GoToState("exit")
					else
						oldanimover(inst, ...)
					end
				end
			end
		end
	end
end)

--暗影大触手sg
AddStategraphPostInit("bigshadowtentacle", function(sg)
	if sg.states then
		--本源触手勋章召唤的暗影大触手攻击后就直接移除了
		if sg.states.attack and sg.states.attack.events then
			local oldanimqueueover = sg.states.attack.events.animqueueover and sg.states.attack.events.animqueueover.fn
			if oldanimqueueover ~= nil then
				sg.states.attack.events.animqueueover.fn = function(inst, ...)
					if inst.from_tentaclemedal then
						inst.sg:GoToState("attack_post")
					else
						oldanimqueueover(inst, ...)
					end
				end
			end
		end
	end
end)

-- timeline[idx].fn(self.inst)
--曼德拉草,跟随佩戴了虫木勋章或植物勋章的玩家不会发出声音
AddStategraphPostInit("mandrake", function(sg)
	if sg.states and sg.states.idle and sg.states.idle.timeline then
		for k, v in pairs(sg.states.idle.timeline) do
			local oldfn = v and v.fn
			if oldfn ~= nil then
				v.fn = function(inst, ...)
					local leader = inst.components.follower and inst.components.follower:GetLeader()
					if leader and leader:HasTag("has_plant_medal") then return end
					oldfn(inst, ...)
				end
			end
		end
	end
end)

AddStategraphPostInit("wilson", function(sg)
    --玩家拥有免僵直标签时被攻击不会僵直
	if sg.events and sg.events.attacked then
		local oldattackedfn = sg.events.attacked.fn
		sg.events.attacked.fn = function(inst, ...)
            --这里顺便加个playerghost的判断，免得玩家濒死的时候又挨了一下揍报错
			if inst:HasTag("nostiff") or inst:HasTag("playerghost") then
				return
			elseif oldattackedfn then
				return oldattackedfn(inst, ...)
			end
            
        end
	end
	--吃了山力叶酱的玩家背东西速度增快
	if sg.states.run_start then
		local oldonenter = sg.states.run_start.onenter
		sg.states.run_start.onenter = function(inst, ...)
			if inst.components.inventory:IsHeavyLifting() and inst:HasTag("medal_strong") and not (inst.components.rider and inst.components.rider:IsRiding()) then
				inst.sg.statemem.heavy_fast=true
				inst.components.locomotor:RunForward()
				inst.AnimState:PlayAnimation("heavy_walk_fast_pre")
				inst.sg.mem.footsteps = 0--(inst.sg.statemem.goose or inst.sg.statemem.goosegroggy) and 4 or 0
			elseif oldonenter then
				oldonenter(inst, ...)
			end
		end
	end
	if sg.states.run then
		local oldonenter = sg.states.run.onenter
		sg.states.run.onenter = function(inst, ...)
			if inst.components.inventory:IsHeavyLifting() and inst:HasTag("medal_strong") and not (inst.components.rider and inst.components.rider:IsRiding()) then
				inst.sg.statemem.heavy_fast=true
				inst.components.locomotor:RunForward()
				if not inst.AnimState:IsCurrentAnimation("heavy_walk_fast") then
					inst.AnimState:PlayAnimation("heavy_walk_fast", true)
				end
				inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength() + .5 * FRAMES)
			elseif oldonenter then
				oldonenter(inst, ...)
			end
		end
	end
	if sg.states.run_stop then
		local oldonenter = sg.states.run_stop.onenter
		sg.states.run_stop.onenter = function(inst, ...)
			if inst.components.inventory:IsHeavyLifting() and inst:HasTag("medal_strong") and not (inst.components.rider and inst.components.rider:IsRiding()) then
				inst.sg.statemem.heavy_fast=true
				inst.components.locomotor:Stop()
				inst.AnimState:PlayAnimation("heavy_walk_fast_pst")
			elseif oldonenter then
				oldonenter(inst, ...)
			end
		end
	end
	--使用工具前切换暗影工具形态
	local tool_states = {
		"chop_start",--砍树
		"mine_start",--挖矿
		"dig_start",--铲
		"hammer_start",--锤
		"bugnet_start",--捕捉
	}
	for i, v in ipairs(tool_states) do
		if sg.states[v] then
			local oldonenter = sg.states[v].onenter
			sg.states[v].onenter = function(inst, ...)
				if inst.medal_multi_use_tool and inst.components.inventory then
					local handitem = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
					if handitem and handitem.prefab == "medal_shadow_tool" and handitem.ResetToolAnim then
						handitem:ResetToolAnim(i)
					end
				end
				if oldonenter then
					oldonenter(inst, ...)
				end
			end
		end
	end
	--童真射击加速
	if sg.states.slingshot_shoot then
		local oldonenter = sg.states.slingshot_shoot.onenter
		sg.states.slingshot_shoot.onenter = function(inst, ...)
			if oldonenter then
				oldonenter(inst, ...)
			end
			--戴了童真并且当前射速慢于5帧，则把射速设置成5帧
			local timeout = inst.sg.timeout
			if inst:HasTag("senior_childishness") and timeout ~= nil then
				--如果初始时间低于5帧，那就可以低于5帧
				timeout = timeout/FRAMES
				timeout = math.clamp(timeout-1, math.min(timeout,5), HasOriginMedal(inst,"senior_childishness") and 5 or 10)
				-- print("左键",timeout)
				inst.sg:SetTimeout(timeout* FRAMES)
			end
		end
	end
	--童真射击加速(右键射击)
	if sg.states.slingshot_special then
		local oldonenter = sg.states.slingshot_special.onenter
		sg.states.slingshot_special.onenter = function(inst, ...)
			if oldonenter then
				oldonenter(inst, ...)
			end
			local timeout = inst.sg.timeout
			if inst:HasTag("senior_childishness") and timeout ~= nil then
				--如果初始时间低于5帧，那就可以低于5帧
				timeout = timeout/FRAMES
				timeout = math.clamp(timeout-2, math.min(timeout,5), HasOriginMedal(inst,"senior_childishness") and 8 or 12)
				-- print("右键",timeout)
				inst.sg:SetTimeout(timeout*FRAMES)
			end
		end
	end
	--伐木抵抗
	if sg.states and sg.states.chop and sg.states.chop.timeline then
		local line1 = sg.states.chop.timeline[1]
		local oldfn = line1 and line1.fn
		if oldfn ~= nil then
			line1.fn = function(inst, ...)
				inst.sg.statemem.recoilstate = "mine_recoil"
				oldfn(inst, ...)
			end
		end
	end
	--挖掘抵抗
	if sg.states and sg.states.dig and sg.states.dig.timeline then
		local line1 = sg.states.dig.timeline[1]
		local oldfn = line1 and line1.fn
		if oldfn ~= nil then
			line1.fn = function(inst, ...)
				inst.sg.statemem.recoilstate = "mine_recoil"
				oldfn(inst, ...)
			end
		end
	end
end)

--客户端当然也要处理啦
AddStategraphPostInit("wilson_client", function(sg)
    --吃了山力叶酱的玩家背东西速度增快
	if sg.states.run_start then
		local oldonenter = sg.states.run_start.onenter
		sg.states.run_start.onenter = function(inst, ...)
			if inst.replica.inventory:IsHeavyLifting() and inst:HasTag("medal_strong") and not (inst.replica.rider ~= nil and inst.replica.rider:IsRiding()) then
				inst.sg.statemem.heavy_fast=true
				inst.components.locomotor:RunForward()
				inst.AnimState:PlayAnimation("heavy_walk_fast_pre")
				inst.sg.mem.footsteps = 0
			elseif oldonenter then
				oldonenter(inst, ...)
			end
		end
	end
	if sg.states.run then
		local oldonenter = sg.states.run.onenter
		sg.states.run.onenter = function(inst, ...)
			if inst.replica.inventory:IsHeavyLifting() and inst:HasTag("medal_strong") and not (inst.replica.rider ~= nil and inst.replica.rider:IsRiding()) then
				inst.sg.statemem.heavy_fast=true
				inst.components.locomotor:RunForward()
				if not inst.AnimState:IsCurrentAnimation("heavy_walk_fast") then
					inst.AnimState:PlayAnimation("heavy_walk_fast", true)
				end
				inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength() + .5 * FRAMES)
			elseif oldonenter then
				oldonenter(inst, ...)
			end
		end
	end
	if sg.states.run_stop then
		local oldonenter = sg.states.run_stop.onenter
		sg.states.run_stop.onenter = function(inst, ...)
			if inst.replica.inventory:IsHeavyLifting() and inst:HasTag("medal_strong") and not (inst.replica.rider ~= nil and inst.replica.rider:IsRiding()) then
				inst.sg.statemem.heavy_fast=true
				inst.components.locomotor:Stop()
				inst.AnimState:PlayAnimation("heavy_walk_fast_pst")
			elseif oldonenter then
				oldonenter(inst, ...)
			end
		end
	end
end)