local function checkintogame(self,intogame) local c = 0 if intogame then c=1 end self.inst.checkintogame:set(c) end
local function checkfirsteat(self,firsteat) local c = 0 if firsteat then c=1 end self.inst.checkfirsteat:set(c) end
local function checksupereat(self,supereat) local c = 0 if supereat then c=1 end self.inst.checksupereat:set(c) end
local function checkdanding(self,danding) local c = 0 if danding then c=1 end self.inst.checkdanding:set(c) end
local function checkmessiah(self,messiah) local c = 0 if messiah then c=1 end self.inst.checkmessiah:set(c) end
local function checkwalkalot(self,walkalot) local c = 0 if walkalot then c=1 end self.inst.checkwalkalot:set(c) end
local function checkstopalot(self,stopalot) local c = 0 if stopalot then c=1 end self.inst.checkstopalot:set(c) end
local function checktooyoung(self,tooyoung) local c = 0 if tooyoung then c=1 end self.inst.checktooyoung:set(c) end
local function checkevil(self,evil) local c = 0 if evil then c=1 end self.inst.checkevil:set(c) end
local function checksnake(self,snake) local c = 0 if snake then c=1 end self.inst.checksnake:set(c) end
local function checkdeathalot(self,deathalot) local c = 0 if deathalot then c=1 end self.inst.checkdeathalot:set(c) end
local function checknosanity(self,nosanity) local c = 0 if nosanity then c=1 end self.inst.checknosanity:set(c) end
local function checksick(self,sick) local c = 0 if sick then c=1 end self.inst.checksick:set(c) end
local function checkcoldblood(self,coldblood) local c = 0 if coldblood then c=1 end self.inst.checkcoldblood:set(c) end
local function checkburn(self,burn) local c = 0 if burn then c=1 end self.inst.checkburn:set(c) end
local function checkfreeze(self,freeze) local c = 0 if freeze then c=1 end self.inst.checkfreeze:set(c) end
local function checkgoodman(self,goodman) local c = 0 if goodman then c=1 end self.inst.checkgoodman:set(c) end
local function checkbrother(self,brother) local c = 0 if brother then c=1 end self.inst.checkbrother:set(c) end
local function checkfishmaster(self,fishmaster) local c = 0 if fishmaster then c=1 end self.inst.checkfishmaster:set(c) end
local function checkpickmaster(self,pickmaster) local c = 0 if pickmaster then c=1 end self.inst.checkpickmaster:set(c) end
local function checkchopmaster(self,chopmaster) local c = 0 if chopmaster then c=1 end self.inst.checkchopmaster:set(c) end
local function checknoob(self,noob) local c = 0 if noob then c=1 end self.inst.checknoob:set(c) end
local function checkcookmaster(self,cookmaster) local c = 0 if cookmaster then c=1 end self.inst.checkcookmaster:set(c) end
local function checklongage(self,longage) local c = 0 if longage then c=1 end self.inst.checklongage:set(c) end
local function checkluck(self,luck) local c = 0 if luck then c=1 end self.inst.checkluck:set(c) end
local function checkblack(self,black) local c = 0 if black then c=1 end self.inst.checkblack:set(c) end
local function checkbuildmaster(self,buildmaster) local c = 0 if buildmaster then c=1 end self.inst.checkbuildmaster:set(c) end
local function checktank(self,tank) local c = 0 if tank then c=1 end self.inst.checktank:set(c) end
local function checkangry(self,angry) local c = 0 if angry then c=1 end self.inst.checkangry:set(c) end
local function checkicebody(self,icebody) local c = 0 if icebody then c=1 end self.inst.checkicebody:set(c) end
local function checkfirebody(self,firebody) local c = 0 if firebody then c=1 end self.inst.checkfirebody:set(c) end
local function checkrigid(self,rigid) local c = 0 if rigid then c=1 end self.inst.checkrigid:set(c) end
local function checkancient(self,ancient) local c = 0 if ancient then c=1 end self.inst.checkancient:set(c) end
local function checkqueen(self,queen) local c = 0 if queen then c=1 end self.inst.checkqueen:set(c) end
local function checkking(self,king) local c = 0 if king then c=1 end self.inst.checkking:set(c) end
local function checkmoistbody(self,moistbody) local c = 0 if moistbody then c=1 end self.inst.checkmoistbody:set(c) end
local function checkall(self,all) local c = 0 if all then c=1 end self.inst.checkall:set(c) end

local function currenteatamount(self,eatamount) self.inst.currenteatamount:set(eatamount) end
local function currenteatmonsterlasagna(self,eatmonsterlasagna) self.inst.currenteatmonsterlasagna:set(eatmonsterlasagna) end
local function currentrespawnamount(self,respawnamount) self.inst.currentrespawnamount:set(respawnamount) end
local function currentwalktime(self,walktime) self.inst.currentwalktime:set(walktime) end
local function currentstoptime(self,stoptime) self.inst.currentstoptime:set(stoptime) end
local function currentevilamount(self,evilamount) self.inst.currentevilamount:set(evilamount) end
local function currentdeathamouth(self,deathamouth) self.inst.currentdeathamouth:set(deathamouth) end
local function currentnosanitytime(self,nosanitytime) self.inst.currentnosanitytime:set(nosanitytime) end
local function currentsnakeamount(self,snakeamount) self.inst.currentsnakeamount:set(snakeamount) end
local function currentfriendpig(self,friendpig) self.inst.currentfriendpig:set(friendpig) end
local function currentfriendbunny(self,friendbunny) self.inst.currentfriendbunny:set(friendbunny) end
local function currentfishamount(self,fishamount) self.inst.currentfishamount:set(fishamount) end
local function currentpickamount(self,pickamount) self.inst.currentpickamount:set(pickamount) end
local function currentchopamount(self,chopamount) self.inst.currentchopamount:set(chopamount) end
local function currentcookamount(self,cookamount) self.inst.currentcookamount:set(cookamount) end
local function currentbuildamount(self,buildamount) self.inst.currentbuildamount:set(buildamount) end
local function currentattackeddamage(self,attackeddamage) self.inst.currentattackeddamage:set(attackeddamage) end
local function currentonhitdamage(self,onhitdamage) self.inst.currentonhitdamage:set(onhitdamage) end
local function currenticetime(self,icetime) self.inst.currenticetime:set(icetime) end
local function currentfiretime(self,firetime) self.inst.currentfiretime:set(firetime) end
local function currentmoisttime(self,moisttime) self.inst.currentmoisttime:set(moisttime) end
local function currentage(self,age) self.inst.currentage:set(age) end

local function checkbosswinter(self,bosswinter) local c = 0 if bosswinter then c=1 end self.inst.checkbosswinter:set(c) end
local function checkbossspring(self,bossspring) local c = 0 if bossspring then c=1 end self.inst.checkbossspring:set(c) end
local function checkbossdragonfly(self,bossdragonfly) local c = 0 if bossdragonfly then c=1 end self.inst.checkbossdragonfly:set(c) end
local function checkbossautumn(self,bossautumn) local c = 0 if bossautumn then c=1 end self.inst.checkbossautumn:set(c) end

local allachivevent = Class(function(self, inst)
    self.inst = inst
    self.intogame = false
    self.firsteat = false
    self.supereat = false
    self.eatamount = 0
    self.danding = false
    self.eatmonsterlasagna = 0
    self.messiah = false
    self.respawnamount = 0
    self.walktime = 0
    self.stoptime = 0
    self.walkalot = false
    self.stopalot = false
    self.tooyoung = false
    self.evil = false
    self.evilamount = 0
    self.snake = false
    self.deathalot = false
    self.deathamouth = 0
    self.nosanity = false
    self.nosanitytime = 0
    self.sick = false
    self.coldblood = false
    self.snakeamount = 0
    self.burn = false
    self.freeze = false
    self.goodman = false
    self.brother = false
    self.friendpig = 0
    self.friendbunny = 0
    self.fishmaster = false
    self.fishamount = 0
    self.pickmaster = false
    self.pickamount = 0
    self.chopmaster = false
    self.chopamount = 0
    self.noob = false
    self.cookmaster = false
    self.cookamount = 0
    self.longage = false
    self.age = 1
    self.luck = false
    self.black = false
    self.buildmaster = false
    self.buildamount = 0
    self.tank = false
    self.angry = false
    self.attackeddamage = 0
    self.onhitdamage = 0
    self.icebody = false
    self.firebody = false
    self.moistbody = false
    self.icetime = 0
    self.firetime = 0
    self.moisttime = 0
    self.rigid = false
    self.ancient = false
    self.queen = false
    self.bosswinter = false
    self.bossspring = false
    self.bossdragonfly = false
    self.bossautumn = false
    self.king = false
    self.all = false
end,
nil,
{
    intogame = checkintogame,
    firsteat = checkfirsteat,
    supereat = checksupereat,
    danding = checkdanding,
    messiah = checkmessiah,
    walkalot = checkwalkalot,
    stopalot = checkstopalot,
    tooyoung = checktooyoung,
    evil = checkevil,
    snake = checksnake,
    deathalot = checkdeathalot,
    nosanity = checknosanity,
    sick = checksick,
    coldblood = checkcoldblood,
    burn = checkburn,
    freeze = checkfreeze,
    goodman = checkgoodman,
    brother = checkbrother,
    fishmaster = checkfishmaster,
    pickmaster = checkpickmaster,
    chopmaster = checkchopmaster,
    noob = checknoob,
    cookmaster = checkcookmaster,
    longage = checklongage,
    luck = checkluck,
    black = checkblack,
    buildmaster = checkbuildmaster,
    tank = checktank,
    angry = checkangry,
    icebody = checkicebody,
    firebody = checkfirebody,
    rigid = checkrigid,
    ancient = checkancient,
    queen = checkqueen,
    king = checkking,
    moistbody = checkmoistbody,
    all = checkall,

    eatamount = currenteatamount,
    eatmonsterlasagna = currenteatmonsterlasagna,
    respawnamount = currentrespawnamount,
    walktime = currentwalktime,
    stoptime = currentstoptime,
    evilamount = currentevilamount,
    deathamouth = currentdeathamouth,
    nosanitytime = currentnosanitytime,
    snakeamount = currentsnakeamount,
    friendpig = currentfriendpig,
    friendbunny = currentfriendbunny,
    fishamount = currentfishamount,
    pickamount = currentpickamount,
    chopamount = currentchopamount,
    cookamount = currentcookamount,
    buildamount = currentbuildamount,
    attackeddamage = currentattackeddamage,
    onhitdamage = currentonhitdamage,
    icetime = currenticetime,
    firetime = currentfiretime,
    moisttime = currentmoisttime,
    age = currentage,

    bosswinter = checkbosswinter,
    bossspring = checkbossspring,
    bossdragonfly = checkbossdragonfly,
    bossautumn = checkbossautumn,
})

--保存
function allachivevent:OnSave()
    local data = {
        intogame = self.intogame,
        firsteat = self.firsteat,
        supereat = self.supereat,
        eatamount = self.eatamount,
        danding = self.danding,
        eatmonsterlasagna = self.eatmonsterlasagna,
        messiah = self.messiah,
        respawnamount = self.respawnamount,
        walktime = self.walktime,
        stoptime = self.stoptime,
        walkalot = self.walkalot,
        stopalot = self.stopalot,
        tooyoung = self.tooyoung,
        evil = self.evil,
        evilamount = self.evilamount,
        snake = self.snake,
        deathalot = self.deathalot,
        deathamouth = self.deathamouth,
        nosanity = self.nosanity,
        nosanitytime = self.nosanitytime,
        sick = self.sick,
        coldblood = self.coldblood,
        snakeamount = self.snakeamount,
        burn = self.burn,
        freeze = self.freeze,
        goodman = self.goodman,
        brother = self.brother,
        friendpig = self.friendpig,
        friendbunny = self.friendbunny,
        fishmaster = self.fishmaster,
        fishamount = self.fishamount,
        pickmaster = self.pickmaster,
        pickamount = self.pickamount,
        chopmaster = self.chopmaster,
        chopamount = self.chopamount,
        noob = self.noob,
        cookmaster = self.cookmaster,
        cookamount = self.cookamount,
        longage = self.longage,
        luck = self.luck,
        black = self.black,
        buildmaster = self.buildmaster,
        buildamount = self.buildamount,
        tank = self.tank,
        angry = self.angry,
        attackeddamage = self.attackeddamage,
        onhitdamage = self.onhitdamage,
        icebody = self.icebody,
        firebody = self.firebody,
        moistbody = self.moistbody,
        icetime = self.icetime,
        firetime = self.firetime,
        moisttime = self.moisttime,
        rigid = self.rigid,
        ancient = self.ancient,
        queen = self.queen,
        bosswinter = self.bosswinter,
        bossspring = self.bossspring,
        bossdragonfly = self.bossdragonfly,
        bossautumn = self.bossautumn,
        king = self.king,
        all = self.all,
    }
    return data
end

--载入
function allachivevent:OnLoad(data)
    self.intogame = data.intogame or false
    self.firsteat = data.firsteat or false
    self.supereat = data.supereat or false
    self.eatamount = data.eatamount or 0
    self.danding = data.danding or false
    self.eatmonsterlasagna = data.eatmonsterlasagna or 0
    self.messiah = data.messiah or false
    self.respawnamount = data.respawnamount or 0
    self.walktime = data.walktime or 0
    self.stoptime = data.stoptime or 0
    self.walkalot = data.walkalot or false
    self.stopalot = data.stopalot or false
    self.tooyoung = data.tooyoung or false
    self.evil = data.evil or false
    self.evilamount = data.evilamount or 0
    self.snake = data.snake or false
    self.deathalot = data.deathalot or false
    self.deathamouth = data.deathamouth or 0
    self.nosanity = data.nosanity or false
    self.nosanitytime = data.nosanitytime or 0
    self.sick = data.sick or false
    self.coldblood = data.coldblood or false
    self.snakeamount = data.snakeamount or 0
    self.burn = data.burn or false
    self.freeze = data.freeze or false
    self.goodman = data.goodman or false
    self.brother = data.brother or false
    self.friendpig = data.friendpig or 0
    self.friendbunny = data.friendbunny or 0
    self.fishmaster = data.fishmaster or false
    self.fishamount = data.fishamount or 0
    self.pickmaster = data.pickmaster or false
    self.pickamount = data.pickamount or 0
    self.chopmaster = data.chopmaster or false
    self.chopamount = data.chopamount or 0
    self.noob = data.noob or false
    self.cookmaster = data.cookmaster or false
    self.cookamount = data.cookamount or 0
    self.longage = data.longage or false
    self.luck = data.luck or false
    self.black = data.black or false
    self.buildmaster = data.buildmaster or false
    self.buildamount = data.buildamount or 0
    self.tank = data.tank or false
    self.angry = data.angry or false
    self.attackeddamage = data.attackeddamage or 0
    self.onhitdamage = data.onhitdamage or 0
    self.icebody = data.icebody or false
    self.firebody = data.firebody or false
    self.moistbody = data.moistbody or false
    self.icetime = data.icetime or 0
    self.firetime = data.firetime or 0
    self.moisttime = data.moisttime or 0
    self.rigid = data.rigid or false
    self.ancient = data.ancient or false
    self.queen = data.queen or false
    self.bosswinter = data.bosswinter or false
    self.bossspring = data.bossspring or false
    self.bossdragonfly = data.bossdragonfly or false
    self.bossautumn = data.bossautumn or false
    self.king = data.king or false
    self.all = data.all or false
end

--通用效果器
function allachivevent:seffc(inst, tag)
    SpawnPrefab("seffc").entity:SetParent(inst.entity)
    local str0 = STRINGS.ALLACHIVCURRENCY
    local strname = STRINGS.ALLACHIVNAME
    local strinfo = STRINGS.ALLACHIVINFO
    local strcoin = STRINGS.ALLACHIVCOIN
    if tag == "intogame" and self.all == true then
        TheNet:Announce(inst:GetDisplayName().."   "..strinfo["intogameafterall"]..str0[3]..str0[1]..strname[tag]..str0[2])
    elseif tag == "black" and self.blacktile == "spat" then
        TheNet:Announce(inst:GetDisplayName().."   "..strinfo["blackspat"]..str0[3]..str0[1]..strname[tag]..str0[2])
    else
        TheNet:Announce(inst:GetDisplayName().."   "..strinfo[tag]..str0[3]..str0[1]..strname[tag]..str0[2])
    end
    inst.components.talker:Say(str0[6]..strname[tag]..str0[2].."\n"..str0[4]..allachiv_coinget[tag]..str0[5])
    inst.components.allachivcoin:coinDoDelta(allachiv_coinget[tag])
end

--新的开始
function allachivevent:intogamefn(inst)
    inst:DoTaskInTime(3, function()
        if self.intogame ~= true then
            self.intogame = true
            self:seffc(inst, "intogame")

            if self.all ~= true then
                inst:DoTaskInTime(2, function()
                    local item3 = SpawnPrefab("spear")
                    inst.components.inventory:GiveItem(item3, nil, inst:GetPosition())
                    local item4 = SpawnPrefab("armorwood")
                    inst.components.inventory:GiveItem(item4, nil, inst:GetPosition())
                    local item1 = SpawnPrefab("goldnugget")
                    item1.components.stackable:SetStackSize(2)
                    inst.components.inventory:GiveItem(item1, nil, inst:GetPosition())
                end)
            end
        end
    end)
end

--吃东西
function allachivevent:eatfn(inst)
    inst:DoTaskInTime(1, function()
        local oldeatfn = inst.components.eater.oneatfn
        function inst.components.eater.oneatfn(inst, food)
            --第一口饭
            if self.firsteat ~= true then
                self.firsteat = true
                self:seffc(inst, "firsteat")
            end

            --美食家
            if self.supereat ~= true then
                self.eatamount = self.eatamount + 1
                if self.eatamount >= allachiv_eventdata["supereat"] then
                    self.supereat = true
                    self:seffc(inst, "supereat")
                end
            end

            --我的内心毫无波动
            if self.danding ~= true and food.prefab == "monsterlasagna" then
                self.eatmonsterlasagna = self.eatmonsterlasagna + 1
                if self.eatmonsterlasagna >= allachiv_eventdata["danding"] then
                    self.danding = true
                    self:seffc(inst, "danding")
                end
            end
            if oldeatfn ~= nil then
                oldeatfn(inst, food)
            end
        end
    end)
end

--行走
function allachivevent:onwalkfn(inst)
    inst:DoPeriodicTask(1, function()
        if inst:HasTag("playerghost") then return end
        if inst.components.locomotor.wantstomoveforward then
            --香港记者
            if self.walkalot ~= true then
                self.walktime = self.walktime + 1
                if self.walktime >= allachiv_eventdata["walkalot"] then
                    self.walkalot = true
                    self:seffc(inst, "walkalot")
                end
            end
        else
            --咸鱼
            if self.stopalot ~= true then
                self.stoptime = self.stoptime + 1
                if self.stoptime >= allachiv_eventdata["stopalot"] then
                    self.stopalot = true
                    self:seffc(inst, "stopalot")
                end
            end
        end
    end)
end

--被击杀
function allachivevent:onkilled(inst)
    inst:ListenForEvent("death", function(inst, data)
        local attacker = inst.components.combat.lastattacker
        --你对力量一无所知
        if attacker and attacker.prefab and attacker:IsValid() and self.tooyoung ~= true then
            if attacker.prefab == "flint"
            or attacker.prefab == "rocks"
            or attacker.prefab == "redgem"
            or attacker.prefab == "bluegem"
            or attacker.prefab == "goldnugget"
            or attacker.prefab == "nitre"
            or attacker.prefab == "marble" then
                inst:DoTaskInTime(2, function()
                    self.tooyoung = true
                    self:seffc(inst, "tooyoung")
                end)
            end
        end
        --超鬼
        if self.deathalot ~= true then
            self.deathamouth = self.deathamouth + 1
            if self.deathamouth >= allachiv_eventdata["deathalot"] then
                inst:DoTaskInTime(2, function()
                    self.deathalot = true
                    self:seffc(inst, "deathalot")
                end)
            end
        end
        --死于黑暗
        if data and data.cause and data.cause == "NIL" and self.noob ~= true then
            inst:DoTaskInTime(2, function()
                self.noob = true
                self:seffc(inst, "noob")
            end)
        end
        --死于闪电
        if data and data.cause and data.cause == "lightning" and self.black ~= true then
            inst:DoTaskInTime(2, function()
                self.black = true
                self.blacktile = "thunder"
                self:seffc(inst, "black")
            end)
        end
    end)
end

--人工智障
function allachivevent:sanitycheck(inst)
    inst:DoPeriodicTask(1, function()
        if inst.components.sanity.current < 1 and self.nosanity ~= true and inst.components.health.currenthealth > 0 then
            self.nosanitytime = self.nosanitytime + 1
            if self.nosanitytime >= allachiv_eventdata["nosanity"] then
                self.nosanity = true
                self:seffc(inst, "nosanity")
            end
        end
    end)
end

--击杀单位
function allachivevent:onkilledother(inst)
    inst:ListenForEvent("killed", function(inst, data)
        local victim = data.victim
        --击杀格罗姆
        if victim and victim.prefab == "glommer" and self.sick ~= true then
            self.sick = true
            self:seffc(inst, "sick")
        end
        --击杀小切
        if victim and victim.prefab == "chester" and self.coldblood ~= true then
            self.coldblood = true
            self:seffc(inst, "coldblood")
        end
        --击杀触手
        if victim and victim.prefab == "tentacle" and self.snake ~= true then
            self.snakeamount = self.snakeamount + 1
            if self.snakeamount >= allachiv_eventdata["snake"] then
                self.snake = true
                self:seffc(inst, "snake")
            end
        end
        --击杀小偷掉落小偷包
        if victim and victim.prefab == "krampus" then
            local pos = Vector3(victim.Transform:GetWorldPosition())
            inst:DoTaskInTime(.1, function()
                local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 3)
                for k,v in pairs(ents) do
                    if v.prefab == "krampus_sack"
                    and v.components.inventoryitem.owner == nil
                    and v.components.ksmark.mark == false then
                        v.components.ksmark.mark = true
                        if self.luck ~= true then
                            self.luck = true
                            self:seffc(inst, "luck")
                        end
                    end
                end
            end)
        end
        --单杀钢羊
        if victim and victim.prefab == "spat" and self.black ~= true then
            local single = true
            local pos = Vector3(victim.Transform:GetWorldPosition())
            local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 40)
            for k,v in pairs(ents) do
                if v:HasTag("player") and v ~= inst then
                    single = false
                end
            end
            if single == true then
                self.black = true
                self.blacktile = "spat"
                self:seffc(inst, "black")
            end
        end
        --击杀暗黑毒蕈
        if victim and victim.prefab == "toadstool_dark" and self.rigid ~= true then
            self.rigid = true
            self:seffc(inst, "rigid")
        end
        --击杀远古骨魔
        if victim and victim.prefab == "stalker_atrium" and self.ancient ~= true then
            self.ancient = true
            self:seffc(inst, "ancient")
        end
        --击杀女王蜂
        if victim and victim.prefab == "beequeen" and self.queen ~= true then
            self.queen = true
            self:seffc(inst, "queen")
        end
        --击杀四季boss
        if self.king ~= true then
            if victim and victim.prefab == "deerclops" and self.bosswinter ~= true then
                self.bosswinter = true
            end
            if victim and victim.prefab == "moose" and self.bossspring ~= true then
                self.bossspring = true
            end
            if victim and victim.prefab == "dragonfly" and self.dragonfly ~= true then
                self.bossdragonfly = true
            end
            if victim and victim.prefab == "bearger" and self.bossautumn ~= true then
                self.bossautumn = true
            end
            if self.bosswinter and self.bossspring and self.bossdragonfly and self.bossautumn then
                self.king = true
                self:seffc(inst, "king")
            end
        end
    end)
end

--着火冰冻
function allachivevent:burnorfreeze(inst)
    inst:ListenForEvent("onignite", function(inst)
        if self.burn ~= true then
            self.burn = true
            self:seffc(inst, "burn")
        end
    end)
    inst:ListenForEvent("freeze", function(inst)
        if self.freeze ~= true then
            self.freeze = true
            self:seffc(inst, "freeze")
        end
    end)
end

--交朋友
function allachivevent:makefriend(inst)
    function inst.components.leader:AddFollower(follower)
        if self.followers[follower] == nil and follower.components.follower ~= nil then
            local achiv = inst.components.allachivevent
            if follower.prefab == "pigman" and achiv.goodman ~= true then
                achiv.friendpig = achiv.friendpig + 1
                if achiv.friendpig >= allachiv_eventdata["goodman"] then
                    achiv.goodman = true
                    achiv:seffc(inst, "goodman")
                end
            end
            if follower.prefab == "bunnyman" and achiv.brother ~= true then
                achiv.friendbunny = achiv.friendbunny + 1
                if achiv.friendbunny >= allachiv_eventdata["brother"] then
                    achiv.brother = true
                    achiv:seffc(inst, "brother")
                end
            end
            if follower.prefab == "mandrake_active" and achiv.evil ~= true and not TheWorld.components.worldstate.data.isday then
                achiv.evilamount = achiv.evilamount + 1
                if achiv.evilamount >= allachiv_eventdata["evil"] then
                    achiv.evil = true
                    achiv:seffc(inst, "evil")
                end
            end

            self.followers[follower] = true
            self.numfollowers = self.numfollowers + 1
            follower.components.follower:SetLeader(self.inst)
            follower:PushEvent("startfollowing", { leader = self.inst })

            if not follower.components.follower.keepdeadleader then
                self.inst:ListenForEvent("death", self._onfollowerdied, follower)
            end

            self.inst:ListenForEvent("onremove", self._onfollowerremoved, follower)

            if self.inst:HasTag("player") and follower.prefab ~= nil then
                ProfileStatsAdd("befriend_"..follower.prefab)
            end
        end
    end
end

--钓鱼达人
function allachivevent:onhook(inst)
    inst:ListenForEvent("fishingstrain", function()
        if self.fishmaster ~= true then
            self.fishamount = self.fishamount + 1
            if self.fishamount >= allachiv_eventdata["fishmaster"] then
                self.fishmaster = true
                self:seffc(inst, "fishmaster")
            end
        end
    end)
end

--拾荒者
function allachivevent:onpick(inst)
    inst:ListenForEvent("picksomething", function(inst, data)
        if data.object and data.object.components.pickable and not data.object.components.trader then
            if self.pickmaster ~= true then
                self.pickamount = self.pickamount + 1
                if self.pickamount >= allachiv_eventdata["pickmaster"] then
                    self.pickmaster = true
                    self:seffc(inst, "pickmaster")
                end
            end
        end
    end)
end

--超级砍树
function allachivevent:chopper(inst)
    inst:ListenForEvent("finishedwork", function(inst, data)
        if data.target and data.target:HasTag("tree") then
            if self.chopmaster ~= true then
                self.chopamount = self.chopamount + 1
                if self.chopamount >= allachiv_eventdata["chopmaster"] then
                    self.chopmaster = true
                    self:seffc(inst, "chopmaster")
                end
            end
        end
    end)
end

--救活
function allachivevent:respawn(inst)
    inst:ListenForEvent("respawnfromghost", function(inst, data)
        if data and data.user and data.user.components.allachivevent then
            local allachivevent = data.user.components.allachivevent
            if allachivevent.messiah ~= true then
                allachivevent.respawnamount = allachivevent.respawnamount + 1
                if allachivevent.respawnamount >= allachiv_eventdata["messiah"] then
                    allachivevent.messiah = true
                    allachivevent:seffc(data.user, "messiah")
                end
            end
        end
    end)
end

--光阴似箭
function allachivevent:ontimepass(inst)
    inst:DoPeriodicTask(5, function(inst)
        if self.longage ~= true then
            if self.all ~= true then
                self.age = math.ceil(inst.components.age:GetAge() / TUNING.TOTAL_DAY_TIME)
            else
                self.age = math.ceil(inst.components.age:GetAge() / TUNING.TOTAL_DAY_TIME) - allachiv_eventdata["longage"] + 1
            end
            if self.age >= allachiv_eventdata["longage"] then
                self.longage = true
                self:seffc(inst, "longage")
            end
        end
    end)
end

--巧夺天工
function allachivevent:onbuild(inst)
    inst:ListenForEvent("consumeingredients", function(inst)
        if self.buildmaster ~= true then
            self.buildamount = self.buildamount + 1
            if self.buildamount >= allachiv_eventdata["buildmaster"] then
                self.buildmaster = true
                self:seffc(inst, "buildmaster")
            end
        end
    end)
end

--人形坦克
function allachivevent:onattacked(inst)
    inst:ListenForEvent("attacked", function(inst, data)
        if self.tank ~= true then
            if data.damage and data.damage >= 0 then
                self.attackeddamage = math.ceil(self.attackeddamage + data.damage)
	            if self.attackeddamage >= allachiv_eventdata["tank"] then
                    self.attackeddamage = allachiv_eventdata["tank"]
	                self.tank = true
	                self:seffc(inst, "tank")
	            end
	        end
        end
    end)
end

--超凶
function allachivevent:hitother(inst)
    inst:ListenForEvent("onhitother", function(inst, data)
        if self.angry ~= true then
            if data.damage and data.damage >= 0 then
                self.onhitdamage = math.ceil(self.onhitdamage + data.damage)
            end
            if self.onhitdamage >= allachiv_eventdata["angry"] then
                self.onhitdamage = allachiv_eventdata["angry"]
                self.angry = true
                self:seffc(inst, "angry")
            end
        end
    end)
end

--冰霜/熔岩体质
function allachivevent:ontemperature(inst)
    inst:DoPeriodicTask(1, function()
        if inst.components.temperature.current <= 0
        and self.icebody ~= true
        and inst.components.health.currenthealth > 0 then
            self.icetime = self.icetime + 1
            if self.icetime >= allachiv_eventdata["icebody"] then
                self.icebody = true
                self:seffc(inst, "icebody")
            end
        end
    end)
    inst:DoPeriodicTask(1, function()
        if inst.components.temperature.current >= 70
        and self.firebody ~= true
        and inst.components.health.currenthealth > 0 then
            self.firetime = self.firetime + 1
            if self.firetime >= allachiv_eventdata["firebody"] then
                self.firebody = true
                self:seffc(inst, "firebody")
            end
        end
    end)
end

--湿身
function allachivevent:moist(inst)
	inst:DoPeriodicTask(1, function()
		if self.moistbody ~= true and inst.components.moisture.moisture == 100 then
			self.moisttime = self.moisttime + 1
			if self.moisttime >= allachiv_eventdata["moistbody"] then
				self.moistbody = true
				self:seffc(inst, "moistbody")
			end
		end
	end)
end

--预运行
function allachivevent:Init(inst)
    inst:DoTaskInTime(.1, function()
    self:intogamefn(inst)
    self:eatfn(inst)
    self:onwalkfn(inst)
    self:onkilled(inst)
    self:onkilledother(inst)
    self:burnorfreeze(inst)
    self:makefriend(inst)
    self:onhook(inst)
    self:onpick(inst)
    self:chopper(inst)
    self:respawn(inst)
    self:ontimepass(inst)
    self:onbuild(inst)
    self:onattacked(inst)
    self:hitother(inst)
    self:sanitycheck(inst)
    self:ontemperature(inst)
    self:moist(inst)
    self:allget(inst)
    end)

    inst.components.combat.damagemultiplier = inst.components.combat.damagemultiplier or 1
end

--检测是否完成所有成就
function allachivevent:allget(inst)
    if self.all ~= true then
        inst:DoPeriodicTask(1, function()
            if self.all ~= true then
                if self.intogame
                and self.firsteat
                and self.supereat
                and self.danding
                and self.messiah
                and self.walkalot
                and self.stopalot
                and self.tooyoung
                and self.evil
                and self.snake
                and self.deathalot
                and self.nosanity
                and self.sick
                and self.coldblood
                and self.burn
                and self.freeze
                and self.goodman
                and self.brother
                and self.fishmaster
                and self.pickmaster
                and self.chopmaster
                and self.noob
                and self.cookmaster
                and self.longage
                and self.luck
                and self.black
                and self.buildmaster
                and self.tank
                and self.angry
                and self.icebody
                and self.firebody
                and self.rigid
                and self.ancient
                and self.queen
                and self.moistbody
                and self.king
                then
                    self.all = true
                    inst:DoTaskInTime(2.5, function()
                        self:seffc(inst, "all")
                        inst:DoTaskInTime(.3, function()
                            inst.sg:GoToState("mime")
                            if not inst.components.locomotor.wantstomoveforward then inst.sg:AddStateTag("busy") end
                            for i=1, 25 do
                                inst:DoTaskInTime(i/25*3, function()
                                    local pos = Vector3(inst.Transform:GetWorldPosition())
                                    SpawnPrefab("explode_firecrackers").Transform:SetPosition(pos.x+math.random(-3,3), pos.y, pos.z+math.random(-3,3))
                                end)
                            end
                        end)

                        self.intogame = false
                        self.firsteat = false
                        self.supereat = false
                        self.eatamount = 0
                        self.danding = false
                        self.eatmonsterlasagna = 0
                        self.messiah = false
                        self.respawnamount = 0
                        self.walktime = 0
                        self.stoptime = 0
                        self.walkalot = false
                        self.stopalot = false
                        self.tooyoung = false
                        self.evil = false
                        self.evilamount = 0
                        self.snake = false
                        self.deathalot = false
                        self.deathamouth = 0
                        self.nosanity = false
                        self.nosanitytime = 0
                        self.sick = false
                        self.coldblood = false
                        self.snakeamount = 0
                        self.burn = false
                        self.freeze = false
                        self.goodman = false
                        self.brother = false
                        self.friendpig = 0
                        self.friendbunny = 0
                        self.fishmaster = false
                        self.fishamount = 0
                        self.pickmaster = false
                        self.pickamount = 0
                        self.chopmaster = false
                        self.chopamount = 0
                        self.noob = false
                        self.cookmaster = false
                        self.cookamount = 0
                        self.longage = false
                        self.age = 1
                        self.luck = false
                        self.black = false
                        self.buildmaster = false
                        self.buildamount = 0
                        self.tank = false
                        self.angry = false
                        self.attackeddamage = 0
                        self.onhitdamage = 0
                        self.icebody = false
                        self.firebody = false
                        self.moistbody = false
                        self.icetime = 0
                        self.firetime = 0
                        self.moisttime = 0
                        self.rigid = false
                        self.ancient = false
                        self.queen = false
                        self.bosswinter = false
                        self.bossspring = false
                        self.bossdragonfly = false
                        self.bossautumn = false
                        self.king = false

                        self:intogamefn(inst)
                    end)
                end
            end
        end)
    end
end

return allachivevent