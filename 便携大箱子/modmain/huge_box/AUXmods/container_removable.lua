---
--- @author zsh in 2023/1/8 18:42
---

-- 202301082039 暂用


local uiloot = {} --存储 UI 列表
local dragpos = {} --存储拖拽坐标

--更新同步拖拽坐标
local LoadDragPos = function()
    TheSim:GetPersistentString(
            "mone_container_removable",
            function(load_success, data)
                if load_success and data ~= nil then
                    local success, allpos = RunInSandbox(data)
                    if success and allpos then
                        for k, v in pairs(allpos) do
                            if dragpos[k] == nil then
                                dragpos[k] = Vector3(v.x or 0, v.y or 0, v.z or 0)
                            end
                        end
                    end
                end
            end
    )
end

--存储拖拽后坐标
local SaveDragPos = function(dragtype, pos)
    if next(dragpos) then
        local str = DataDumper(dragpos, nil, true)
        TheSim:SetPersistentString("mone_container_removable", str, false)
    end
end

--获取拖拽坐标
local GetDragPos = function(dragtype)
    if dragpos[dragtype] == nil then
        LoadDragPos()
    end
    return dragpos[dragtype]
end

--设置 UI 可拖拽
local MakeDragableUI = function(self, dragtarget, dragtype, dragdata)
    self.acb_candrag = true

    uiloot[self] = self:GetPosition() --存储默认坐标

    --给拖拽目标添加拖拽提示
    if dragtarget then
        dragtarget:SetTooltip("按住右键即可拖拽，键盘 home 键复原")

        local old_OnControl = dragtarget.OnControl
        dragtarget.OnControl = function(self, control, down)
            local parentwidget = self:GetParent()

            if parentwidget and parentwidget.Passive_OnControl then
                --按下鼠标右键可拖动
                parentwidget:Passive_OnControl(control, down)
            end
            return old_OnControl and old_OnControl(self, control, down)
        end
    end

    --被控制(控制状态，是否按下)
    function self:Passive_OnControl(control, down)
        if self.focus and control == CONTROL_SECONDARY then
            if down then
                self:StartDrag()
            else
                self:EndDrag()
            end
        end
    end

    --设置拖拽坐标
    function self:SetDragPosition(x, y, z)
        local pos = nil
        if type(x) == "number" then
            pos = Vector3(x, y, z)
        else
            pos = x
        end

        if pos then
            local self_scale = self:GetScale()
            local offset = dragdata and dragdata.drag_offset or 1 --偏移修正(容器是0.6)
            local newpos = self.p_startpos + (pos - self.m_startpos) / (self_scale.x / offset) --修正偏移值

            self:SetPosition(newpos) --设定新坐标
        end
    end

    --开始拖动
    function self:StartDrag()
        if not self.followhandler then
            local mousepos = TheInput:GetScreenPosition()

            self.m_startpos = mousepos --鼠标初始坐标
            self.p_startpos = self:GetPosition() --面板初始坐标

            self.followhandler = TheInput:AddMoveHandler(
                    function(x, y)
                        self:SetDragPosition(x, y, 0)
                        if not Input:IsMouseDown(MOUSEBUTTON_RIGHT) then
                            self:EndDrag()
                        end
                    end
            )

            self:SetDragPosition(mousepos)
        end
    end

    --停止拖动
    function self:EndDrag()
        if self.followhandler then
            self.followhandler:Remove()
        end
        self.followhandler = nil
        self.m_startpos = nil
        self.p_startpos = nil
        local newpos = self:GetPosition()
        if dragtype then
            dragpos[dragtype] = newpos --记录拖拽后坐标
        end
        SaveDragPos() --存储坐标
    end
end

--重置拖拽坐标
local ResetUIPos = function()
    dragpos = {}
    TheSim:SetPersistentString("mone_container_removable", "", false)
    for k, v in pairs(uiloot) do
        if k.inst and k.inst:IsValid() then
            k:SetPosition(v) --重置坐标
        else
            uiloot[k] = nil
        end
    end
end

AddClassPostConstruct(
        "widgets/containerwidget",
        function(self)
            if TUNING.FUNCTIONAL_MEDAL_IS_OPEN then
                return
            end

            if TUNING.MORE_ITEMS_ON then
                return ;
            end

            local old_Open = self.Open
            self.Open = function(self, ...)
                if old_Open then
                    old_Open(self, ...)
                end

                if self.container and self.container.replica and self.container.replica.container then
                    local widget = self.container.replica.container:GetWidget()

                    if widget == nil then
                        return
                    else
                        local dragname = self.container and self.container.prefab

                        if dragname then
                            --设置容器可拖拽
                            if not self.acb_candrag then
                                MakeDragableUI(self, self.bganim, dragname, { drag_offset = 0.6 })
                            end

                            --设置容器坐标
                            local newpos = GetDragPos(dragname)
                            if newpos then
                                if self.container:HasTag("_equippable") and not self.container.isopended then
                                    self.container:DoTaskInTime(
                                            0,
                                            function()
                                                self:SetPosition(newpos)
                                            end
                                    )
                                    self.container.isopended = true
                                else
                                    self:SetPosition(newpos)
                                end
                            end
                        end
                    end
                end
            end
        end
)
--[[
    KEY_F1 = 282
    KEY_F2 = 283
    KEY_F3 = 284
    KEY_F4 = 285
    KEY_F5 = 286
    KEY_F6 = 287
    KEY_F7 = 288
    KEY_F8 = 289
    KEY_F9 = 290
    KEY_F10 = 291
    KEY_F11 = 292
    KEY_F12 = 293
]]
--添加重置热键
TheInput:AddKeyHandler(function(key, down)
    if down then
        -- print(key)
        if key == 278 then
            --home键
            ResetUIPos()
        end
    end
end)


