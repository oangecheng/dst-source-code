name = "富贵险中求(No Danger No Rich)"
version = "1.0.0.11"
-- version_compatible = "4.1.0"
description = "version: " .. version .. "\n\n当鼠标上出现了什么奇怪的动作时，此时危险离你已经很近了，也意味着机遇的来临\n\nWhen something strange happens on the mouse, the danger is very close to you, which also means the arrival of opportunity.\n\n" .. "交流群：701291170"
author = "朋也  某幻想家"
forumthread = ""

api_version = 10

icon_atlas = "images/modicon.xml"
icon = "modicon.tex"

all_clients_require_mod = true
client_only_mod = false
dst_compatible = true
priority = -9999 --优先级，值越大越先加载 默认0

server_filter_tags = {"ndnr", "富贵险中求"}

configuration_options = {{
    name = "language",
    label = "语言/Language",
    hover = "",
    options = {{
        description = "中文",
        data = "zhs",
        hover = ""
    }, {
        description = "English",
        data = "en",
        hover = ""
    }},
    default = "zhs"
}}
