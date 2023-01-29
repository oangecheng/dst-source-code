AddClassPostConstruct("widgets/hoverer", function(self)
    local old_SetString = self.text.SetString
    self.text.SetString = function(text, str)
        local target = TheInput:GetHUDEntityUnderMouse()
        if target ~= nil then
            target = target.widget ~= nil and target.widget.parent ~= nil and target.widget.parent.item
        else
            target = TheInput:GetWorldEntityUnderMouse()
        end
        if target and target.entity ~= nil then
            if target.prefab ~= nil then
                if target.prefab == "ndnr_bounty" and target.replica.ndnr_bountytask then
                    local content = target.replica.ndnr_bountytask:GetContent()
                    if content then
                        str = str .. "\n" .. NDNR_BOUNTY_CONTENT .. content
                    end
                elseif target.prefab == "gravestone" and target.replica.ndnr_hoverer then
                    local content = target.replica.ndnr_hoverer:GetContent()
                    if content then
                        str = str .. "\n" .. content
                    end
                end
            end
        end
        return old_SetString(text, str)
    end
end)
