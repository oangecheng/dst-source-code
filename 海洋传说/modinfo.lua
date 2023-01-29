-- 名称
name = "[DST]海洋传说（测试）"
-- 描述
description = 
[[
    "感谢订阅本mod！          [版本]0.5.5.8.4
    海上似乎传来了一些奇怪的声音，它们到底是什么？我曾试图去寻找它们，但是一无所获，它们似乎在刻意回避...
    
    *乘风破浪*
    尝试着那些对结果一无所知的冒险，我想这便是我一直盼望的勇气...

    *珍馐美馔*
    空虚如我，才会以美食标记人生...

    *精耕细作* 
    至今耕种地，一半作花园...
    
    [特别鸣谢]熊大，白饭，半夏微暖半夏凉，老弃，小洁，梧生"
    ]]
-- 作者
author = "鱼仔master"
-- 版本
version = "0.5.5.8.4"
-- klei官方论坛地址，为空则默认是工坊的地址
forumthread = ""
-- modicon 下一篇再介绍怎么创建的
icon_atlas = "modicon.xml"
icon = "modicon.tex"

dst_compatible = true
all_clients_require_mod = true
api_version = 10

-- mod的配置项，后面介绍
configuration_options = {
    {name = "", label = "乘风破浪", options = {{description = "", data = ""},}, default = "",},
    {
        name = "legend_lighting", 
        label = "雷雨交加",
        hover = "听得一声闷雷，淋得一场小雨",
        options =   {
                        {description = "开", data = true},
                        {description = "关", data = false},                     
                    },
        default = false,
    },
}