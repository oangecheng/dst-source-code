
local function getdate()
    return os.date("%Y%m%d")
end

local function festivalevent(self)
    local currenttime = GetTime()
    if self.isqingming == true and (not TheWorld.state.israining or not TheWorld.state.issnowing) then
        TheWorld:PushEvent("ndnr_chinese_festival_rain")
    end
    if self.isjingzhe == true and self.lastthundertime < currenttime - (TUNING.TOTAL_DAY_TIME + math.random(TUNING.TOTAL_DAY_TIME/2)) then
        self.lastthundertime = currenttime
        TheWorld:PushEvent("ndnr_chinese_festival_thunder")
    end
    if self.ischunjie == true and self.lastluckygoldnuggettime < currenttime - (TUNING.TOTAL_DAY_TIME + math.random(TUNING.TOTAL_DAY_TIME/2)) then
        self.lastluckygoldnuggettime = currenttime
        TheWorld:PushEvent("ndnr_lucky_goldnugget_rain")
    end

    if TheWorld.net.mod_ndnr == nil then TheWorld.net.mod_ndnr = {} end
    TheWorld.net.mod_ndnr.current_date = getdate()
    if self.isjingzhe == true then
        TheWorld.net.mod_ndnr.isjingzhe = true
    elseif self.isjingzhe == false then
        TheWorld.net.mod_ndnr.isjingzhe = false
    end
    if self.isqingming == true then
        TheWorld.net.mod_ndnr.isqingming = true
    elseif self.isqingming == false then
        TheWorld.net.mod_ndnr.isqingming = false
    end
    if self.isdongzhi == true then
        TheWorld.net.mod_ndnr.isdongzhi = true
    elseif self.isdongzhi == false then
        TheWorld.net.mod_ndnr.isdongzhi = false
    end
    if self.ischunjie == true then
        TheWorld.net.mod_ndnr.ischunjie = true
    elseif self.ischunjie == false then
        TheWorld.net.mod_ndnr.ischunjie = false
    end
    if self.isqixi == true then
        TheWorld.net.mod_ndnr.isqixi = true
    elseif self.isqixi == false then
        TheWorld.net.mod_ndnr.isqixi = false
    end
    if self.iszhongyuan == true then
        TheWorld.net.mod_ndnr.iszhongyuan = true
    elseif self.iszhongyuan == false then
        TheWorld.net.mod_ndnr.iszhongyuan = false
    end
end

local ChineseFestival = Class(function(self, inst)
    self.inst = inst
    self.festival = {
        jingzhe = {"20220305","20230306","20240305","20250305","20260305","20270306","20280305","20290305","20300305","20310306","20320305","20330305","20340305","20350306","20360305","20370305","20380305","20390306","20400305","20410305","20420305","20430306","20440305","20450305","20460305","20470306","20480305","20490305","20500305","20510305","20520305","20530305","20540305","20550305","20560305","20570305","20580305","20590305","20600305","20610305","20620305","20630305","20640305","20650305","20660305","20670305","20680305","20690305","20700305","20710305","20720305","20730305","20740305","20750305","20760305","20770305","20780305","20790305","20800305","20810305","20820305","20830305","20840304","20850305","20860305","20870305","20880304","20890305","20900305","20910305","20920304","20930305","20940305","20950305","20960304","20970305","20980305","20990305","21000305"},
        qingming = {"20220405","20230405","20240404","20250404","20260405","20270405","20280404","20290404","20300405","20310405","20320404","20330404","20340405","20350405","20360404","20370404","20380405","20390405","20400404","20410404","20420404","20430405","20440404","20450404","20460404","20470405","20480404","20490404","20500404","20510405","20520404","20530404","20540404","20550405","20560404","20570404","20580404","20590405","20600404","20610404","20620404","20630405","20640404","20650404","20660404","20670405","20680404","20690404","20700404","20710405","20720404","20730404","20740404","20750404","20760404","20770404","20780404","20790404","20800404","20810404","20820404","20830404","20840404","20850404","20860404","20870404","20880404","20890404","20900404","20910404","20920404","20930404","20940404","20950404","20960404","20970404","20980404","20990404","21000405"},
        qixi = {"20220804","20230822","20240810","20250829","20260819","20270808","20280826","20290816","20300805","20310824","20320812","20330801","20340820","20350810","20360828","20370817","20380807","20390826","20400814","20410803","20420822","20430811","20440731","20450819","20460808","20470827","20480816","20490805","20500823","20510812","20520801","20530820","20540810","20550829","20560817","20570806","20580825","20590814","20600802","20610821","20620811","20630801","20640819","20650808","20660827","20670816","20680804","20690823","20700812","20710802","20720820","20730810","20740828","20750818","20760806","20770824","20780814","20790803","20800821","20810811","20820731","20830819","20840808","20850826","20860815","20870805","20880823","20890812","20900802","20910821","20920809","20930828","20940817","20950806","20960824","20970813","20980803","20990822", "21000812"},
        zhongyuan = {"20220812","20230830","20240818","20250906","20260827","20270816","20280903","20290824","20300813","20310901","20320820","20330809","20340828","20350818","20360905","20370825","20380815","20390903","20400822","20410811","20420830","20430819","20440808","20450827","20460816","20470904","20480824","20490813","20500831","20510820","20520809","20530828","20540818","20550906","20560825","20570814","20580902","20590822","20600810","20610829","20620819","20630809","20640827","20650816","20660904","20670824","20680812","20690831","20700820","20710810","20720828","20730818","20740905","20750826","20760814","20770901","20780822","20790811","20800829","20810819","20820808","20830827","20840816","20850903","20860823","20870813","20880831","20890820","20900810","20910829","20920817","20930905","20940825","20950814","20960901","20970821","20980811","20990830","21000820"},
        dongzhi = {"20221222","20231222","20241221","20251221","20261222","20271222","20281221","20291221","20301222","20311222","20321221","20331221","20341222","20351222","20361221","20371221","20381222","20391222","20401221","20411221","20421222","20431222","20441221","20451221","20461222","20471222","20481221","20491221","20501222","20511222","20521221","20531221","20541222","20551222","20561221","20571221","20581221","20591222","20601221","20611221","20621221","20631222","20641221","20651221","20661221","20671222","20681221","20691221","20701221","20711222","20721221","20731221","20741221","20751222","20761221","20771221","20781221","20791222","20801221","20811221","20821221","20831222","20841221","20851221","20861221","20871222","20881221","20891221","20901221","20911221","20921221","20931221","20941221","20951221","20961221","20971221","20981221","20991221","21001222"},
        chunjie = {"20220201","20230122","20240210","20250129","20260217","20270206","20280126","20290213","20300203","20310123","20320211","20330131","20340219","20350208","20360128","20370215","20380204","20390124","20400212","20410201","20420122","20430210","20440130","20450217","20460206","20470126","20480214","20490202","20500123","20510211","20520201","20530219","20540208","20550128","20560215","20570204","20580124","20590212","20600202","20610121","20620209","20630129","20640217","20650205","20660126","20670214","20680203","20690123","20700211","20710131","20720219","20730207","20740127","20750215","20760205","20770124","20780212","20790202","20800122","20810209","20820129","20830217","20840206","20850126","20860214","20870203","20880124","20890210","20900130","20910218","20920207","20930127","20940215","20950205","20960125","20970212","20980201","20990121", "21000209"},
    }
    self.today = nil
    self.isjingzhe = false
    self.isqingming = false
    self.isdongzhi = false
    self.ischunjie = false
    self.isqixi = false
    self.iszhongyuan = false
    self.tmp = 0
    self.lastthundertime = math.random(TUNING.TOTAL_DAY_TIME/2, TUNING.TOTAL_DAY_TIME)
    self.lastluckygoldnuggettime = math.random(TUNING.TOTAL_DAY_TIME/2, TUNING.TOTAL_DAY_TIME)

    if TUNING.NDNR_CHINESEFESTIVAL then
        self.inst:StartUpdatingComponent(self)
    end
    -- self.inst:DoPeriodicTask(1, function(inst) updatetime(self) end)

    --listen player death to do something!
    --self.inst:ListenForEvent("ms_becameghost", function(inst)end)
end, nil, {})

function ChineseFestival:OnUpdate(dt)
    self.tmp = self.tmp + dt
    if self.tmp > 1 then
        self.tmp = 0
        local today = getdate()
        if self.today == nil or (self.today ~= nil and self.today ~= today) then
            self.today = today
            self.isjingzhe = table.contains(self.festival.jingzhe, self.today)
            self.qingming = table.contains(self.festival.qingming, self.today)
            self.dongzhi = table.contains(self.festival.dongzhi, self.today)
            self.chunjie = table.contains(self.festival.chunjie, self.today)
            self.qixi = table.contains(self.festival.qixi, self.today)
            self.zhongyuan = table.contains(self.festival.zhongyuan, self.today)
            -- self.isjingzhe = false
            -- self.isqingming = false
            -- self.isdongzhi = false
            -- self.ischunjie = false
            -- self.isqixi = false
            -- self.iszhongyuan = false
        end
        festivalevent(self)
    end
end

return ChineseFestival