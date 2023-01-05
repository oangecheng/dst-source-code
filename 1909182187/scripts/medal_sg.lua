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
				if inst.sg.statemem.teleporter ~= nil and inst.sg.statemem.target ~= nil then
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

--食人花诱饵动画
AddStategraphState('lureplant',
	State{
        name = "showbait",
        tags = { "busy" },

        onenter = function(inst, playanim)
            if inst.lure then
                if inst.lure.prefab=="devour_staff" then
					inst.AnimState:OverrideSymbol("swap_dried", "devour_staff", "showbait_devour_staff")
				elseif inst.lure.prefab=="immortal_staff" then
					inst.AnimState:OverrideSymbol("swap_dried", "immortal_staff", "showbait_immortal_staff")
				else
					inst.AnimState:OverrideSymbol("swap_dried", "meat_rack_food", inst.lure.prefab)
				end
                inst.Physics:Stop()
                inst.AnimState:PlayAnimation("emerge")
            else
                inst.sg:GoToState("idlein")
            end
        end,

        timeline =
        {
            TimeEvent(FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve/creatures/eyeplant/lure_open") end),
        },

        events =
        {
            EventHandler("animover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("taunt")
                end
            end),
        },
    }
)

--坎普斯嘲讽sg
AddStategraphState('krampus',
	State{
        name = "taunt",
        tags = { "busy" },

        onenter = function(inst, cb)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("taunt")
            inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/taunt")
			inst:PushEvent("krampustaunt")
        end,

        events=
        {
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    }
)
--防止坎普斯、暗夜坎普斯死亡多次掉落
AddStategraphState('krampus',
	State{
        name = "death",
		tags = {"busy"},
		onenter = function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/death")
			inst.AnimState:PlayAnimation("death")
			inst.components.locomotor:StopMoving()
			--死过一次的就别再死了
			if not inst.died_once then
				inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
				inst.died_once=true
				if inst.prefab=="medal_rage_krampus" then
					--生成雕像皮肤券
					local skin_coupon = SpawnPrefab("medal_skin_coupon")
					if skin_coupon then
						if skin_coupon.setSkinData then
							skin_coupon:setSkinData("medal_statue_marble_changeable",4)
						end
						inst.components.lootdropper:FlingItem(skin_coupon)
					end
				end
			end
		end,
    }
)
--坎普斯卡无敌了就跑路吧
AddStategraphState('krampus',
	State{
		name = "idle",
		tags = {"idle", "canrotate"},
		onenter = function(inst, playanim)
			if math.random() < .333 then inst.SoundEmitter:PlaySound("dontstarve/creatures/krampus/growlshort") end
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("idle", true)
		end,

		events=
		{
			EventHandler("animover", function(inst) 
				if inst.components.health and inst.components.health:IsInvincible() then
					inst.sg:GoToState("exit")
				elseif math.random() < .1 then
					inst.sg:GoToState("taunt")
				else
					inst.sg:GoToState("idle")
				end 
			end),
		},
	}
)

AddStategraphState('wilson',
    --快速射击动画
	State{
		name = "medal_slingshot_shoot",
		tags = { "attack" },
	
		onenter = function(inst)
			if inst.components.combat:InCooldown() then
				inst.sg:RemoveStateTag("abouttoattack")
				inst:ClearBufferedAction()
				inst.sg:GoToState("idle", true)
				return
			end
			local buffaction = inst:GetBufferedAction()
			local target = buffaction ~= nil and buffaction.target or nil
			if target ~= nil and target:IsValid() then
				inst:ForceFacePoint(target.Transform:GetWorldPosition())
				inst.sg.statemem.attacktarget = target -- this is to allow repeat shooting at the same target
			end
	
			inst.sg.statemem.abouttoattack = true
	
			-- inst.AnimState:PlayAnimation("slingshot_pre")
			inst.AnimState:PlayAnimation("sand_idle_pre")
			inst.AnimState:PushAnimation("slingshot", false)
	
			if inst.sg.laststate == inst.sg.currentstate then
				inst.sg.statemem.chained = true
				inst.AnimState:SetTime(3 * FRAMES)
			end
	
			inst.components.combat:StartAttack()
			inst.components.combat:SetTarget(target)
			inst.components.locomotor:Stop()
	
			inst.sg:SetTimeout((inst.sg.statemem.chained and 25 or 28) * FRAMES)
		end,
	
		timeline =
		{
			TimeEvent(1 * FRAMES, function(inst)
				if inst.sg.statemem.chained then
					local buffaction = inst:GetBufferedAction()
					local target = buffaction ~= nil and buffaction.target or nil
					if not (target ~= nil and target:IsValid() and inst.components.combat:CanTarget(target)) then
						inst:ClearBufferedAction()
						inst.sg:GoToState("idle")
					end
				end
			end),
	
			TimeEvent(2 * FRAMES, function(inst) -- start of slingshot
				if inst.sg.statemem.chained then
					inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/stretch")
				end
			end),
	
			TimeEvent(8 * FRAMES, function(inst)
				if inst.sg.statemem.chained then
					local buffaction = inst:GetBufferedAction()
					local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
					if equip ~= nil and equip.components.weapon ~= nil and equip.components.weapon.projectile ~= nil then
						local target = buffaction ~= nil and buffaction.target or nil
						if target ~= nil and target:IsValid() and inst.components.combat:CanTarget(target) then
							inst.sg.statemem.abouttoattack = false
							inst:PerformBufferedAction()
							inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/shoot")
						else
							inst:ClearBufferedAction()
							inst.sg:GoToState("idle")
						end
					else -- out of ammo
						inst:ClearBufferedAction()
						MedalSay(inst,STRINGS.MEDAL_SHOT_SPEECH.NOAMMO)
						inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/no_ammo")
					end
				end
			end),
	
			TimeEvent(4 * FRAMES, function(inst)
				if not inst.sg.statemem.chained then
					local buffaction = inst:GetBufferedAction()
					local target = buffaction ~= nil and buffaction.target or nil
					if not (target ~= nil and target:IsValid() and inst.components.combat:CanTarget(target)) then
						inst:ClearBufferedAction()
						inst.sg:GoToState("idle")
					end
				end
			end),
	
			TimeEvent(5 * FRAMES, function(inst) -- start of slingshot
				if not inst.sg.statemem.chained then
					inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/stretch")
				end
			end),
	
			TimeEvent(11 * FRAMES, function(inst)
				if not inst.sg.statemem.chained then
					local buffaction = inst:GetBufferedAction()
					local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
					if equip ~= nil and equip.components.weapon ~= nil and equip.components.weapon.projectile ~= nil then
						local target = buffaction ~= nil and buffaction.target or nil
						if target ~= nil and target:IsValid() and inst.components.combat:CanTarget(target) then
							inst.sg.statemem.abouttoattack = false
							inst:PerformBufferedAction()
							inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/shoot")
						else
							inst:ClearBufferedAction()
							inst.sg:GoToState("idle")
						end
					else -- out of ammo
						inst:ClearBufferedAction()
						MedalSay(inst,STRINGS.MEDAL_SHOT_SPEECH.NOAMMO)
						inst.SoundEmitter:PlaySound("dontstarve/characters/walter/slingshot/no_ammo")
					end
				end
			end),
		},
	
		ontimeout = function(inst)
			inst.sg:RemoveStateTag("attack")
			inst.sg:AddStateTag("idle")
		end,
	
		events =
		{
			EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
			EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
			EventHandler("animqueueover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
				end
			end),
		},
	
		onexit = function(inst)
			inst.components.combat:SetTarget(nil)
			if inst.sg.statemem.abouttoattack and inst.replica.combat ~= nil then
				inst.replica.combat:CancelAttack()
			end
		end,
	}
)

AddStategraphState('wilson_client',
    --快速射击动画
	State{
		name = "medal_slingshot_shoot",
		tags = { "attack" },
	
		onenter = function(inst)
			inst.components.locomotor:Stop()
			-- inst.AnimState:PlayAnimation("slingshot_pre")
			-- inst.AnimState:PushAnimation("slingshot_lag", true)
			inst.AnimState:PlayAnimation("sand_idle_pre")
			inst.AnimState:PushAnimation("slingshot", false)
	
			if inst.sg.laststate == inst.sg.currentstate then
				inst.sg.statemem.chained = true
				inst.AnimState:SetTime(3 * FRAMES)
			end
	
			local buffaction = inst:GetBufferedAction()
			if buffaction ~= nil then
				if buffaction.target ~= nil and buffaction.target:IsValid() then
					inst:ForceFacePoint(buffaction.target:GetPosition())
					inst.sg.statemem.attacktarget = buffaction.target -- this is to allow repeat shooting at the same target
				end
	
				inst:PerformPreviewBufferedAction()
			end
	
			inst.sg:SetTimeout(2)
		end,
	
		onupdate = function(inst)
			if inst.sg.timeinstate >= (inst.sg.statemem.chained and 27 or 30)*FRAMES and inst.sg.statemem.flattened_time == nil and inst:HasTag("attack") then
				if inst.entity:FlattenMovementPrediction() then
					inst.sg.statemem.flattened_time = inst.sg.timeinstate
					inst.sg:AddStateTag("idle")
					inst.sg:AddStateTag("canrotate")
					inst.entity:SetIsPredictingMovement(false) -- so the animation will come across
				end
			end
	
			if inst.bufferedaction == nil and inst.sg.statemem.flattened_time ~= nil and inst.sg.statemem.flattened_time < inst.sg.timeinstate then
				inst.sg.statemem.flattened_time = nil
				inst.entity:SetIsPredictingMovement(true)
				inst.sg:RemoveStateTag("attack")
				inst.sg:AddStateTag("idle")
			end
		end,
	
		ontimeout = function(inst)
			inst:ClearBufferedAction()
			inst.sg:GoToState("idle")
		end,
	
		events =
		{
			EventHandler("animqueueover", function(inst)
				if inst.AnimState:AnimDone() then
					inst.sg:GoToState("idle")
				end
			end),
		},
	
		onexit = function(inst)
			if inst.sg.statemem.flattened_time ~= nil then
				inst.entity:SetIsPredictingMovement(true)
			end
		end,
	}
)

--超长搓手动画(2,4秒)
AddStategraphState('wilson',
	State{
		name = "medal_dolongestaction",
		onenter = function(inst)
			inst.sg:GoToState("dolongaction", math.random(2,4))
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


AddStategraphPostInit("wilson", function(sg)
    --玩家拥有免僵直标签时被攻击不会僵直
	if sg.events and sg.events.attacked then
		local oldattackedfn = sg.events.attacked.fn
		sg.events.attacked.fn = function(inst, data)
            --这里顺便加个playerghost的判断，免得玩家濒死的时候又挨了一下揍报错
			if inst:HasTag("nostiff") or inst:HasTag("playerghost") then
				return
			elseif oldattackedfn then
				return oldattackedfn(inst, data)
			end
            
        end
	end
	--吃了山力叶酱的玩家背东西速度增快
	if sg.states.run_start then
		local oldonenter = sg.states.run_start.onenter
		sg.states.run_start.onenter = function(inst)
			if inst.components.inventory:IsHeavyLifting() and inst:HasTag("medal_strong") and not (inst.components.rider and inst.components.rider:IsRiding()) then
				inst.sg.statemem.heavy_fast=true
				inst.components.locomotor:RunForward()
				inst.AnimState:PlayAnimation("heavy_walk_fast_pre")
				inst.sg.mem.footsteps = 0--(inst.sg.statemem.goose or inst.sg.statemem.goosegroggy) and 4 or 0
			elseif oldonenter then
				oldonenter(inst)
			end
		end
	end
	if sg.states.run then
		local oldonenter = sg.states.run.onenter
		sg.states.run.onenter = function(inst)
			if inst.components.inventory:IsHeavyLifting() and inst:HasTag("medal_strong") and not (inst.components.rider and inst.components.rider:IsRiding()) then
				inst.sg.statemem.heavy_fast=true
				inst.components.locomotor:RunForward()
				if not inst.AnimState:IsCurrentAnimation("heavy_walk_fast") then
					inst.AnimState:PlayAnimation("heavy_walk_fast", true)
				end
				inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength() + .5 * FRAMES)
			elseif oldonenter then
				oldonenter(inst)
			end
		end
	end
	if sg.states.run_stop then
		local oldonenter = sg.states.run_stop.onenter
		sg.states.run_stop.onenter = function(inst)
			if inst.components.inventory:IsHeavyLifting() and inst:HasTag("medal_strong") and not (inst.components.rider and inst.components.rider:IsRiding()) then
				inst.sg.statemem.heavy_fast=true
				inst.components.locomotor:Stop()
				inst.AnimState:PlayAnimation("heavy_walk_fast_pst")
			elseif oldonenter then
				oldonenter(inst)
			end
		end
	end
end)
--客户端当然也要处理啦
AddStategraphPostInit("wilson_client", function(sg)
    --吃了山力叶酱的玩家背东西速度增快
	if sg.states.run_start then
		local oldonenter = sg.states.run_start.onenter
		sg.states.run_start.onenter = function(inst)
			if inst.replica.inventory:IsHeavyLifting() and inst:HasTag("medal_strong") and not (inst.replica.rider ~= nil and inst.replica.rider:IsRiding()) then
				inst.sg.statemem.heavy_fast=true
				inst.components.locomotor:RunForward()
				inst.AnimState:PlayAnimation("heavy_walk_fast_pre")
				inst.sg.mem.footsteps = 0
			elseif oldonenter then
				oldonenter(inst)
			end
		end
	end
	if sg.states.run then
		local oldonenter = sg.states.run.onenter
		sg.states.run.onenter = function(inst)
			if inst.replica.inventory:IsHeavyLifting() and inst:HasTag("medal_strong") and not (inst.replica.rider ~= nil and inst.replica.rider:IsRiding()) then
				inst.sg.statemem.heavy_fast=true
				inst.components.locomotor:RunForward()
				if not inst.AnimState:IsCurrentAnimation("heavy_walk_fast") then
					inst.AnimState:PlayAnimation("heavy_walk_fast", true)
				end
				inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength() + .5 * FRAMES)
			elseif oldonenter then
				oldonenter(inst)
			end
		end
	end
	if sg.states.run_stop then
		local oldonenter = sg.states.run_stop.onenter
		sg.states.run_stop.onenter = function(inst)
			if inst.replica.inventory:IsHeavyLifting() and inst:HasTag("medal_strong") and not (inst.replica.rider ~= nil and inst.replica.rider:IsRiding()) then
				inst.sg.statemem.heavy_fast=true
				inst.components.locomotor:Stop()
				inst.AnimState:PlayAnimation("heavy_walk_fast_pst")
			elseif oldonenter then
				oldonenter(inst)
			end
		end
	end
end)


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

--曼德拉草
AddStategraphState('mandrake',
	State{
        name = "idle",
        tags = { "idle", "canrotate" },

        onenter = function(inst, pushanim)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle_loop")
        end,

        timeline =
        {
            TimeEvent(3*FRAMES, function(inst)
				if inst.components.follower then--跟随佩戴了虫木勋章或植物勋章的玩家不会发出声音
					local leader = inst.components.follower:GetLeader()
					if leader and leader:HasTag("has_plant_medal") then return end
				end
				inst.SoundEmitter:PlaySound("dontstarve/creatures/mandrake/walk")
			end),
            TimeEvent(16*FRAMES, function(inst)
				if inst.components.follower then
					local leader = inst.components.follower:GetLeader()
					if leader and leader:HasTag("has_plant_medal") then return end
				end
				inst.SoundEmitter:PlaySound("dontstarve/creatures/mandrake/walk")
			end),
        },

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
        },
    }
)