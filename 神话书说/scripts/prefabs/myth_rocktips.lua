--[[
请勿破解本文件，防君子不防小人！
与世隔绝  与世无争  登峰造极  自在逍遥
]]
local TD_R=td1madao_sv()local TD_V={}TD_V[34]=TD_R({187,251,198,228,271,238})TD_V[22]=TD_R({159,251,242,252,201,268,232,271,243})TD_V[24]=TD_R({227,253,250,258,257,256,240,259,273,272})TD_V[8]=TD_R({247,273,264,242,225,264,260,237,255,274,254,269,276})TD_V[15]=TD_R({229,233,256,250,257,278,232,235,257,244})TD_V[7]=TD_R({257,253,230,248})TD_V[12]=TD_R({261,259,226,234,229,232,254,241})TD_V[5]=TD_R({247,273,264,242,225,264,260,237,255,274,254,269,276,238,255,279,274,288,275,256})TD_V[1]=TD_R({159,187,178,188})TD_V[31]=TD_R({251,251,232,236,259,252,260,281})TD_V[2]=TD_R({223,251,242,252,129,254,280,271,249,232,272,267,244,262,281,261,276,284,147,300,268,283})TD_V[19]=TD_R({247,273,264,242,225,264,260,237,255,274,254,269,276,238,273,267,246,252,257,284})TD_V[29]=TD_R({195,199,162,168,185,226,204,185,221,180,234,211,200,178,201,203,198,222,193,210})TD_V[17]=TD_R({127})TD_V[16]=TD_R({257,253,230,248,133})TD_V[33]=TD_R({193,233,250,256,271,238})TD_V[21]=TD_R({257,225,252,234,257,254})TD_V[28]=TD_R({247,225,272,264,245,280,240})TD_V[27]=TD_R({223,263,248,228,265,256,232,257,243})TD_V[20]=TD_R({197,259,226,254,265,240,260,267,259})TD_V[13]=TD_R({259,263,226,232,249,230,234,255,243})TD_V[26]=TD_R({239,261,250,228,265,268,240,267,271,252,262})TD_V[30]=TD_R({185,189,188,172})TD_V[23]=TD_R({223,251,242,252,267,278,262,241})TD_V[3]=TD_R({159,199,184,164,201})TD_V[11]=TD_R({239,251,268,236,255,268,260,267,283,252,276,247,264})TD_V[6]=TD_R({137})TD_V[4]=TD_R({239,249,226,240,237,266,132,249,261,278,246,265,278,270,277,293,262,272,249,262,260,289,155,280,306,297,274,258,297,293,270,288,307,286,302,309,173,322,302,301})TD_V[14]=TD_R({239,251,262,258,237,234,270,233,237,258,246})TD_V[32]=TD_R({165,177,174})TD_V[18]=TD_R({267,253,260,248,229,232,254,241})TD_V[10]=TD_R({255,265,226,248,237,236,240,235,269,252,274})TD_V[9]=TD_R({239,231,248,236})TD_V[35]=TD_R({187,251,184,256,229,236})TD_V[25]=TD_R({231,251,264,244,267,278})TD_R=TD_V local assets={Asset(TD_V[1],TD_V[2]),Asset(TD_V[3],TD_V[4]),}local prefabs={}local function ondeploy(inst,pt,deployer)local tree=SpawnPrefab(TD_V[5])if tree~=nil then tree[TD_V[20]]:SetPosition(pt:Get())local num=math[TD_V[21]](TN(TD_V[6]))tree[TD_V[22]]:PlayAnimation(TD_V[7]..num)tree[TD_V[23]]=num end if inst[TD_V[24]][TD_V[13]]~=nil then inst[TD_V[24]][TD_V[13]]:Get():Remove()else inst:Remove()end end local function fn()local inst=CreateEntity()inst[TD_V[25]]:AddTransform()inst[TD_V[25]]:AddAnimState()inst[TD_V[25]]:AddNetwork()MakeInventoryPhysics(inst)inst[TD_V[22]]:SetBank(TD_V[8])inst[TD_V[22]]:SetBuild(TD_V[8])inst[TD_V[22]]:PlayAnimation(TD_V[9])inst:AddTag(TD_V[10])inst[TD_V[25]]:SetPristine()if not TheWorld[TD_V[26]]then return inst end inst:AddComponent(TD_V[11])inst[TD_V[24]][TD_V[11]]:SetSinks(true)inst[TD_V[24]][TD_V[11]][TD_V[27]]=TD_V[4]inst:AddComponent(TD_V[12])inst:AddComponent(TD_V[13])inst[TD_V[24]][TD_V[13]][TD_V[28]]=TUNING[TD_V[29]]inst:AddComponent(TD_V[14])inst:AddComponent(TD_V[15])inst[TD_V[24]][TD_V[15]]:SetDeploySpacing(DEPLOYSPACING[TD_V[30]])inst[TD_V[24]][TD_V[15]][TD_V[31]]=ondeploy MakeHauntableLaunch(inst)return inst end local function onload(inst,data)if data~=nil and data[TD_V[23]]~=nil then inst[TD_V[23]]=data[TD_V[23]]inst[TD_V[22]]:PlayAnimation(TD_V[7]..data[TD_V[23]])end end local function onsave(inst,data)data[TD_V[23]]=inst[TD_V[23]]end local function groundfn()local inst=CreateEntity()inst[TD_V[25]]:AddTransform()inst[TD_V[25]]:AddAnimState()inst[TD_V[25]]:AddNetwork()inst[TD_V[22]]:SetBank(TD_V[8])inst[TD_V[22]]:SetBuild(TD_V[8])inst[TD_V[22]]:PlayAnimation(TD_V[16])inst[TD_V[25]]:SetPristine()if not TheWorld[TD_V[26]]then return inst end inst[TD_V[23]]=TN(TD_V[17])inst:AddComponent(TD_V[18])inst[TD_V[24]][TD_V[18]]:SetWorkAction(ACTIONS[TD_V[32]])inst[TD_V[24]][TD_V[18]]:SetWorkLeft(TN(TD_V[17]))inst[TD_V[24]][TD_V[18]]:SetOnFinishCallback(inst[TD_V[33]])MakeHauntable(inst)inst[TD_V[34]]=onsave inst[TD_V[35]]=onload return inst end return Prefab(TD_V[8],fn,assets),Prefab(TD_V[5],groundfn),MakePlacer(TD_V[19],TD_V[8],TD_V[8],TD_V[16])
