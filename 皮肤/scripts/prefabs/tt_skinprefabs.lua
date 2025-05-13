local prefs = {}

local PRE = debug.getinfo(1, 'S').source:match("([^/]+)_skinprefabs%.lua$") --当前文件前缀
local SkinUtils = require(PRE .. "_skinutils")

for prefab, skins in pairs(SkinUtils.GetAllSkins()) do
    for name, d in pairs(skins) do
        d.base_prefab = prefab
        table.insert(prefs, CreatePrefabSkin(name, d))
    end
end

return unpack(prefs)
