-- table.insert(Assets, Asset("ATLAS", "images/ndnr_smallbird.xml"))
-- table.insert(Assets, Asset("IMAGE", "images/ndnr_smallbird.tex"))

AddPrefabPostInit("smallbird", function(inst)

    inst:AddTag("canbetrapped")

    MakeFeedableSmallLivestockPristine(inst)

    if not TheWorld.ismastersim then return inst end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.nobounce = true
    inst.components.inventoryitem.canbepickedup = false
    inst.components.inventoryitem.canbepickedupalive = true
    inst.components.inventoryitem:SetSinks(true)
    inst.components.inventoryitem.atlasname = "images/ndnr_smallbird.xml"
    inst.components.inventoryitem:ChangeImageName("ndnr_smallbird")
    -- .imagename = "ndnr_smallbird"

    MakeFeedableSmallLivestock(inst, TUNING.RABBIT_PERISH_TIME)

end)