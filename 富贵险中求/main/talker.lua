local addtalkerprefabs = {
    monster = {
        "nightmarebeak",
        "crawlingnightmare",
    },
    boss = {
        "shadow_rook",
        "shadow_knight",
        "shadow_bishop",
    }
}

for key, value in ipairs(addtalkerprefabs.monster) do
    AddPrefabPostInit(value, function(inst)
        if not inst.components.talker then inst:AddComponent("talker") end
    end)
end

for key, value in ipairs(addtalkerprefabs.boss) do
    AddPrefabPostInit(value, function(inst)
        if not inst.components.talker then inst:AddComponent("talker") end
        inst.components.talker.fontsize = 40
        inst.components.talker.font = TALKINGFONT
        inst.components.talker.colour = Vector3(238 / 255, 69 / 255, 105 / 255)
        inst.components.talker.offset = Vector3(0, -700, 0)
        inst.components.talker.symbol = "fossil_chest"
        inst.components.talker:MakeChatter()
    end)
end
