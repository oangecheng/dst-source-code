return {
  version = "1.1",
  luaversion = "5.1",
  orientation = "orthogonal",
  width = 32,
  height = 32,
  tilewidth = 16,
  tileheight = 16,
  properties = {},
  tilesets = {
    {
      name = "tiles",
      firstgid = 1,
      tilewidth = 64,
      tileheight = 64,
      spacing = 0,
      margin = 0,
      image = "../../../../tools/tiled/dont_starve/tiles.png",
      imagewidth = 512,
      imageheight = 384,
      properties = {},
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "BG_TILES",
      x = 0,
      y = 0,
      width = 32,
      height = 32,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        2, 0, 0, 0, 3, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        2, 0, 0, 0, 3, 0, 0, 0, 7, 0, 0, 0, 7, 0, 0, 0, 7, 0, 0, 0, 7, 0, 0, 0, 7, 0, 0, 0, 2, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        2, 0, 0, 0, 2, 0, 0, 0, 7, 0, 0, 0, 7, 0, 0, 0, 7, 0, 0, 0, 7, 0, 0, 0, 7, 0, 0, 0, 2, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        3, 0, 0, 0, 7, 0, 0, 0, 7, 0, 0, 0, 7, 0, 0, 0, 7, 0, 0, 0, 7, 0, 0, 0, 2, 0, 0, 0, 7, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        3, 0, 0, 0, 7, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 3, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 3, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      name = "FG_OBJECTS",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        -- {
        --   name = "Bryce",
        --   type = "gravestone", --2/6
        --   shape = "rectangle",
        --   x = 416,
        --   y = 224,
        --   width = 0,
        --   height = 0,
        --   visible = true,
        --   properties = {
        --     ["data.setepitaph"] = "Bryce",
        --     ["scenario"] = "graveyard_ghosts"
        --   }
        -- },
        -- {
        --   name = "Kelly",
        --   type = "gravestone", --3/2
        --   shape = "rectangle",
        --   x = 160,
        --   y = 288,
        --   width = 0,
        --   height = 0,
        --   visible = true,
        --   properties = {
        --     ["data.setepitaph"] = "Kelly",
        --     ["scenario"] = "graveyard_ghosts"
        --   }
        -- },
        -- {
        --   name = "Sloth",
        --   type = "gravestone", --1/6
        --   shape = "rectangle",
        --   x = 416,
        --   y = 160,
        --   width = 0,
        --   height = 0,
        --   visible = true,
        --   properties = {
        --     ["data.setepitaph"] = "Sloth",
        --     ["scenario"] = "graveyard_ghosts"
        --   }
        -- },
        {
          name = "白饭",
          type = "gravestone", --1/2
          shape = "rectangle",
          x = 160,
          y = 160,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.setepitaph"] = "白饭不能酿成酒。\n            --白饭",
            ["scenario"] = "graveyard_ghosts"
          }
        },
        {
          name = "孟尝鬼鬼",
          type = "gravestone", --3/5
          shape = "rectangle",
          x = 352,
          y = 288,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.setepitaph"] = "梧大…我的文件…删……\n            --孟尝鬼鬼",
            ["scenario"] = "graveyard_ghosts"
          }
        },
        {
          name = "秦文铦",
          type = "gravestone", --3/4
          shape = "rectangle",
          x = 288,
          y = 288,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.setepitaph"] = "树枝料理派传人！\n            --秦文铦",
            ["scenario"] = "graveyard_ghosts"
          }
        },
        {
          name = "班花",
          type = "gravestone", --1/5
          shape = "rectangle",
          x = 352,
          y = 160,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.setepitaph"] = "是个憨憨吧！\n            --班花",
            ["scenario"] = "graveyard_ghosts"
          }
        },
        {
          name = "Hermit",
          type = "gravestone", --1/4
          shape = "rectangle",
          x = 288,
          y = 160,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.setepitaph"] = "好像很疼的样子，请不要…弄…疼…我…\n            --Hermit",
            ["scenario"] = "graveyard_ghosts"
          }
        },
        {
          name = "初晴",
          type = "gravestone", --2/3
          shape = "rectangle",
          x = 224,
          y = 224,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.setepitaph"] = "恭喜生于南遇于北加入永恒大陆，喜结连理。\n            --初晴",
            ["scenario"] = "graveyard_ghosts"
          }
        },
        {
          name = "羽中",
          type = "gravestone", --3/6
          shape = "rectangle",
          x = 416,
          y = 288,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.setepitaph"] = "他只是个破画画的，他懂个**神话书说。\n            --羽中",
            ["scenario"] = "graveyard_ghosts"
          }
        },
        -- {
        --   name = "Jeff",
        --   type = "gravestone", --3/3
        --   shape = "rectangle",
        --   x = 224,
        --   y = 288,
        --   width = 0,
        --   height = 0,
        --   visible = true,
        --   properties = {
        --     ["data.setepitaph"] = "Jeff",
        --     ["scenario"] = "graveyard_ghosts"
        --   }
        -- },
        -- {
        --   name = "Wade",
        --   type = "gravestone", --2/2
        --   shape = "rectangle",
        --   x = 160,
        --   y = 224,
        --   width = 0,
        --   height = 0,
        --   visible = true,
        --   properties = {
        --     ["data.setepitaph"] = "Wade",
        --     ["scenario"] = "graveyard_ghosts"
        --   }
        -- },
        {
          name = "女装墨宝",
          type = "gravestone", --1/3
          shape = "rectangle",
          x = 224,
          y = 160,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.setepitaph"] = "墨宝妈妈爱。\n            --女装墨宝",
            ["scenario"] = "graveyard_ghosts"
          }
        },
        {
          name = "阿难",
          type = "gravestone", --2/4
          shape = "rectangle",
          x = 288,
          y = 224,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.setepitaph"] = "有些人活着就已经死了。\n            --阿难",
            ["scenario"] = "graveyard_ghosts"
          }
        },
        {
          name = "Godfrey",
          type = "gravestone", --1/1
          shape = "rectangle",
          x = 96,
          y = 160,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.setepitaph"] = "我才是梧生被窝里的老大！\n            --Godfrey",
            ["scenario"] = "graveyard_ghosts"
          }
        },
        {
          name = "梧生",
          type = "gravestone", --2/1
          shape = "rectangle",
          x = 96,
          y = 224,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.setepitaph"] = "桐雀春深锁梧生。\n            --梧生"
          }
        },
        -- {
        --   name = "学院路陈伟霆",
        --   type = "gravestone", --3/1
        --   shape = "rectangle",
        --   x = 96,
        --   y = 288,
        --   width = 0,
        --   height = 0,
        --   visible = true,
        --   properties = {
        --     ["data.setepitaph"] = "宝，你咋这么傻！\n            --学院路陈伟霆"
        --   }
        -- },
        {
          name = "",
          type = "marsh_tree", --原本老麦雕像
          shape = "rectangle",
          x = 256,
          y = 416,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "marsh_tree",
          shape = "rectangle",
          x = 368,
          y = 464,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "marsh_bush", --原本大理石柱（左下）
          shape = "rectangle",
          x = 64,
          y = 320,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "marsh_tree",
          shape = "rectangle",
          x = 432,
          y = 32,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "scarecrow", --原本大理石柱（右上）
          shape = "rectangle",
          x = 448,
          y = 128,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "marsh_tree",
          shape = "rectangle",
          x = 128,
          y = 32,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower_evil", --原本大理石柱（右下）
          shape = "rectangle",
          x = 448,
          y = 320,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "marsh_tree",
          shape = "rectangle",
          x = 496,
          y = 416,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "marsh_tree",
          shape = "rectangle",
          x = 160,
          y = 480,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "marsh_tree",
          shape = "rectangle",
          x = 368,
          y = 16,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "marsh_tree", --原本大理石柱（左上）
          shape = "rectangle",
          x = 64,
          y = 128,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "reskin_tool",
          shape = "rectangle",
          x = 352,
          y = 432,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "livingtree", -- 原本老麦雕像（顶部）
          shape = "rectangle",
          x = 256,
          y = 32,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "mandrake_planted",
          shape = "rectangle",
          x = 304,
          y = 192,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "marsh_bush",
          shape = "rectangle",
          x = 230,
          y = 258,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "marsh_bush",
          shape = "rectangle",
          x = 128,
          y = 240,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower_evil",
          shape = "rectangle",
          x = 128,
          y = 160,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower_evil",
          shape = "rectangle",
          x = 384,
          y = 256,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower_evil",
          shape = "rectangle",
          x = 416,
          y = 192,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower_evil",
          shape = "rectangle",
          x = 368,
          y = 416,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower_evil",
          shape = "rectangle",
          x = 128,
          y = 448,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower_evil",
          shape = "rectangle",
          x = 352,
          y = 32,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "",
          type = "flower_evil",
          shape = "rectangle",
          x = 160,
          y = 32,
          width = 0,
          height = 0,
          visible = true,
          properties = {}
        },
        {
          name = "诀泣",
          type = "gravestone", --2/5
          shape = "rectangle",
          x = 352,
          y = 224,
          width = 0,
          height = 0,
          visible = true,
          properties = {
            ["data.setepitaph"] = "憋了俩月不知道写啥，想了三天凑两句废话，有字就行。\n            --诀泣",
            ["scenario"] = "graveyard_ghosts"
          }
        }
      }
    }
  }
}
