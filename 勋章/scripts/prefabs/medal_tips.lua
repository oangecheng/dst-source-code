--提示类型
local tipsType={--最多只支持到31(32也行但是消耗得控制在767及以下)
	[1]={--伐木勋章
		text=STRINGS.MEDAL_TIPS.TIP1,
		color={r=70/255, g=139/255, b=101/255},
	},
	[2]={--矿工勋章
		text=STRINGS.MEDAL_TIPS.TIP2,
		color={r=194/255, g=186/255, b=132/255},
	},
	[3]={--巧手考验勋章
		text=STRINGS.MEDAL_TIPS.TIP3,
		color={r=125/255, g=114/255, b=83/255},
	},
	[4]={--虫木勋章
		text=STRINGS.MEDAL_TIPS.TIP4,
		color={r=124/255, g=162/255, b=80/255},
	},
	[5]={--蒙昧勋章
		text=STRINGS.MEDAL_TIPS.TIP5,
		color={r=190/255, g=166/255, b=174/255},
	},
	[6]={--逮捕勋章
		text=STRINGS.MEDAL_TIPS.TIP6,
		color={r=213/255, g=199/255, b=111/255},
	},
	[7]={--女武神的考验
		text=STRINGS.MEDAL_TIPS.TIP7,
		color={r=157/255, g=119/255, b=70/255},
	},
	[8]={--钓鱼勋章
		text=STRINGS.MEDAL_TIPS.TIP8,
		color={r=62/255, g=139/255, b=204/255},
	},
	[9]={--食人花手杖
		text=STRINGS.MEDAL_TIPS.TIP9,
		color={r=125/255, g=114/255, b=83/255},
	},
	[10]={--主厨勋章升级
		text=STRINGS.MEDAL_TIPS.TIP10,
		color={r=255/255, g=204/255, b=51/255},
	},
	[11]={--童心勋章
		text=STRINGS.MEDAL_TIPS.TIP11,
		color={r=255/255, g=204/255, b=51/255},
	},
	[12]={--友善勋章
		text=STRINGS.MEDAL_TIPS.TIP12,
		color={r=255/255, g=204/255, b=51/255},
	},
	[13]={--正义勋章
		text=STRINGS.MEDAL_TIPS.TIP13,
		color={r=213/255, g=199/255, b=111/255},
	},
	[14]={--触发保底掉落
		text=STRINGS.MEDAL_TIPS.TIP14,
		color={r=213/255, g=199/255, b=111/255},
		nonum=true,
	},
	[15]={--蒙昧勋章加耐久
		text=STRINGS.MEDAL_TIPS.TIP15,
		color={r=190/255, g=166/255, b=174/255},
	},
	[16]={--使命勋章
		text=STRINGS.MEDAL_TIPS.TIP16,
		color={r=170/255, g=237/255, b=132/255},
	},
	[17]={--天道酬勤
		text=STRINGS.MEDAL_TIPS.TIP17,
		color={r=170/255, g=237/255, b=132/255},
		nonum=true,
	},
}

local function SetMedalTips(inst)
	--4或5位数，后三位为具体消耗，前两位为类型
	local amount = inst.medal_d_value:value()
	local label=inst.Label
	local tiptype=math.floor(amount/1000)--类型
	if tipsType[tiptype] then
		label:SetText(tipsType[tiptype].text..(tipsType[tiptype].nonum and "" or math.fmod(amount,1000)))
		label:SetColour(tipsType[tiptype].color.r, tipsType[tiptype].color.g, tipsType[tiptype].color.b)
		label:Enable(true)
	end
end

local function UpdatePing(inst, t0, duration)
    local t = GetTime() - t0
    local k = 1 - math.max(0, t - 0.1) / duration
    k = 1 - k * k
    local s = Lerp(15, 30, k)--字体从15到30
	local y = Lerp(4, 5, k)--高度从4到5
    local label=inst.Label
	if label then
		label:SetFontSize(s)
		label:SetWorldOffset(0, y, 0)
	end
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddNetwork()
	inst.entity:SetCanSleep(false)
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	
	local label = inst.entity:AddLabel()
	label:SetFont(NUMBERFONT)
	label:SetFontSize(15)
	label:SetWorldOffset(0, 4, 0)
	label:SetColour(255/255, 204/255, 51/255)
	label:SetText("+0")
	label:Enable(false)

	inst.medal_d_value = net_shortint(inst.GUID, "medal_d_value", "medal_d_valuedirty")
	inst:ListenForEvent("medal_d_valuedirty", SetMedalTips)

	inst.entity:SetPristine()

	-- if not TheWorld.ismastersim then
	-- 	return inst
	-- end
	-- inst.medal_d_value:set(1)
	inst.persists = false
	local duration=0.8--持续时间
	inst:DoPeriodicTask(0, UpdatePing, nil, GetTime(), duration)
	inst:DoTaskInTime(duration, inst.Remove)

	return inst
end

return Prefab("medal_tips", fn)
