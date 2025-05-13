local L = locale ~= "zh" and locale ~= "zhr" -- true 英文  false 中文

name = "给物品添加皮肤"
description = [[
可以在制作栏制作一个有一个皮肤的长矛武器
]]
author = "绯世行"
version = "1.1.1"

forumthread = ""

api_version = 10

priority = 0

dst_compatible = true
all_clients_require_mod = true

dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {
    "character",
}

configuration_options = {
}
