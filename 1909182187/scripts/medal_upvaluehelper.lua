--[[作者:风铃
版本:v0.2
需要的自提
]]
--调用示例 获取upvalue
--[[
	local upvaluehelper = require "utils/upvaluehelp"
	local containers = require "containers"
	local params = upvaluehelper.Get(containers.widgetsetup,"params")  --获取containers.widgetsetup的名为 params的upvalue 必须在containers.widgetsetup 或者他调用的程序里使用到了 params 
	if params then
		params.cookpot.itemtestfn = function() ... end					--因为返回值是表 可以直接操作 否则需要使用Set
	end
]]--
local visit = {}    --保存已经访问的 防止有嵌套
local visitnum = 0
local function TryToClose(name,value,level)
    if name  or value then      --一旦有返回值了 代表找到了 
        visit = {}
        visitnum = 0
        return value
    end
    if level == 1 then          --只有没找到才会执行到这儿
        visit = {}
        visitnum = 0
    end
end
local function Get(fn,name,file)	
    local level = visitnum + 1
	if type(fn) ~= "function" then TryToClose(nil,nil,level) return end
    if visit[fn] then TryToClose(nil,nil,level) return end      --已访问过就返回
    visit[fn] = 1
    visitnum = visitnum + 1
    local i = 1
	while true do
		local upname,upvalue = debug.getupvalue(fn,i)
        if not upname then break end    --已经没了 跳出
		if upname and upname == name then
			if file and type(file) == "string" then			--限定文件 防止被别人提前hook导致取错
				local fninfo = debug.getinfo(fn)
				if fninfo.source and fninfo.source:match(file) then
					return TryToClose(upname,upvalue,level)
				end
			else
				return TryToClose(upname,upvalue,level)
			end
		end
		if upvalue and type(upvalue) == "function" and not visit[upvalue] then  --没有访问过的
			local upupvalue  = Get(upvalue,name,file) --找不到就递归查找
			if upupvalue then return TryToClose(name,upupvalue,level) end
		end
        i = i + 1
	end
    TryToClose(nil,nil,level)   --都没找到也要清除缓存
end

--调用示例 设置upvalue
--[[
local upvaluehelper = require "utils/upvaluehelp"
	local containers = require "containers"
	local newtable = {}
	local params = upvaluehelper.Set(containers.widgetsetup,"params",newtable)  --获取containers.widgetsetup的名为 params的upvalue 

]]--

local function Set(fn,name,set,file)
    local level = visitnum + 1
    if type(fn) ~= "function" then TryToClose(nil,nil,level) return end
    if visit[fn] then TryToClose(nil,nil,level) return end      --已访问过就返回
    visit[fn] = 1
    visitnum = visitnum + 1
    local i = 1
	while true do
		local upname,upvalue = debug.getupvalue(fn,i)
        if not upname then break end    --已经没了 退出
		if upname and upname == name then
			if file and type(file) == "string" then			--限定文件 防止被别人提前hook导致取错
				local fninfo = debug.getinfo(fn)
				if fninfo.source and fninfo.source:match(file) then
					return TryToClose(debug.setupvalue(fn,i,set),nil,level)
				end
			else
				return TryToClose(debug.setupvalue(fn,i,set),nil,level)
			end
		end
		if upvalue and type(upvalue) == "function" and not visit[upvalue] then
			local upupvalue  = Set(upvalue,name,set,file) --找不到就递归查找
			if upupvalue then return TryToClose(upupvalue,nil,level) end
		end
        i = i + 1
	end
    TryToClose(nil,nil,level)   --都没找到也要清除缓存
end

local function FunctionTest(fn,file,test,source,listener)
	if fn and type(fn) ~= "function" then return false end
	local data = debug.getinfo(fn)
	if file and type(file) == "string" then		--文件名判定
		local matchstr = "/"..file..".lua" 
		if not data.source or not data.source:match(matchstr) then
			return false
		end
	end
	if test and type(test) == "function" and  not test(data,source,listener) then return false end	--测试通过
	return true
end

--调用示例 获取指定事件的函数 并移除
--[[
	local upvaluehelper = require "utils/upvaluehelp"
	local fn = upvaluehelper.GetEventHandle(TheWorld,"ms_lightwildfireforplayer","components/wildfires")
	
	
	if fn then
		TheWorld:RemoveEventCallback("ms_lightwildfireforplayer",fn)
	end
	
]]--

local function GetEventHandle(inst,event,file,test)
	if type(inst) == "table" then
		if inst.event_listening and inst.event_listening[event] then		--遍历他在监听的事件 我在监听谁
			local listenings = inst.event_listening[event]
			for listening,fns in pairs(listenings) do		--遍历被监听者
				if fns and type(fns)=="table" then
					for _,fn in pairs(fns) do
						if FunctionTest(fn,file,test,listening,inst) then	--寻找成功就返回
							return fn
						end
					end
				end
			end
		end
	
	
		if inst.event_listeners and inst.event_listeners[event] then	--遍历监听他的事件的	谁在监听我
			local listeners = inst.event_listeners[event]
			for listener,fns in pairs(listeners) do		--遍历监听者
				if fns and type(fns)=="table" then
					for _,fn in pairs(fns) do
						if FunctionTest(fn,file,test,inst,listener) then	--寻找成功就返回
							return fn
						end
					end
				end
			end
		end
	end
end


return {
	Get = Get,
	Set = Set,
	GetEventHandle = GetEventHandle,
}