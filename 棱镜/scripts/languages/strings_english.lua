local _G = GLOBAL
local STRINGS = _G.STRINGS

local S_NAMES = STRINGS.NAMES                   --各种对象的名字
local S_RECIPE_DESC = STRINGS.RECIPE_DESC       --科技栏里的描述
local S______GENERIC = STRINGS.CHARACTERS.GENERIC      --威尔逊的台词（如果其他角色没有台词则会默认使用威尔逊的）
local S_______WILLOW = STRINGS.CHARACTERS.WILLOW       --薇洛的台词
local S_____WOLFGANG = STRINGS.CHARACTERS.WOLFGANG     --沃尔夫冈的台词
local S________WENDY = STRINGS.CHARACTERS.WENDY        --温蒂的台词
local S_________WX78 = STRINGS.CHARACTERS.WX78         --WX78的台词
local S_WICKERBOTTOM = STRINGS.CHARACTERS.WICKERBOTTOM --维克伯顿的台词
local S_______WOODIE = STRINGS.CHARACTERS.WOODIE       --伍迪的台词
local S______WAXWELL = STRINGS.CHARACTERS.WAXWELL      --麦克斯韦的台词
local S___WATHGRITHR = STRINGS.CHARACTERS.WATHGRITHR   --瓦丝格蕾的台词
local S_______WEBBER = STRINGS.CHARACTERS.WEBBER       --韦伯的台词
local S_______WINONA = STRINGS.CHARACTERS.WINONA       --薇诺娜的台词
local S________WARLY = STRINGS.CHARACTERS.WARLY        --沃利的台词
local S_______WORTOX = STRINGS.CHARACTERS.WORTOX       --沃托克斯的台词
local S_____WORMWOOD = STRINGS.CHARACTERS.WORMWOOD     --沃姆伍德的台词
local S_________WURT = STRINGS.CHARACTERS.WURT         --沃特的台词
local S_______WALTER = STRINGS.CHARACTERS.WALTER       --沃尔特的台词
local S________WANDA = STRINGS.CHARACTERS.WANDA        --旺达的台词

_G.CONFIGS_LEGION.LANGUAGES = "english"

--------------------------------------------------------------------------
--[[ the little star in the cave ]]--[[ 洞穴里的星光点点 ]]
--------------------------------------------------------------------------

S_NAMES.HAT_LICHEN = "Lichen Hairpin"
S_RECIPE_DESC.HAT_LICHEN = "I have an \"idea\"! Just like in cartoons."
S______GENERIC.DESCRIBE.HAT_LICHEN = "An idea that's taken form!"
S_______WILLOW.DESCRIBE.HAT_LICHEN = "You can't really LIGHT it."
S_____WOLFGANG.DESCRIBE.HAT_LICHEN = "Glowy little gadget."
S________WENDY.DESCRIBE.HAT_LICHEN = "Abigail used to wear a hairpin like this on Sundays..."
S_________WX78.DESCRIBE.HAT_LICHEN = "TEMPORARY ORGANIC SOURCE OF LIGHT."
S_WICKERBOTTOM.DESCRIBE.HAT_LICHEN = "Literally radiant... Pun intended."
S_______WOODIE.DESCRIBE.HAT_LICHEN = "Doesn't really suit me."
S______WAXWELL.DESCRIBE.HAT_LICHEN = "That's such a disgrace!"
--S___WATHGRITHR.DESCRIBE.HAT_LICHEN = ""
S_______WEBBER.DESCRIBE.HAT_LICHEN = "Wendy! Come see our new hairpin!"
S_______WINONA.DESCRIBE.HAT_LICHEN = "For illumination, I'd better put it on for now."
S_____WORMWOOD.DESCRIBE.HAT_LICHEN = "I'dah put a glowy buddy on my head!"
S_________WURT.DESCRIBE.HAT_LICHEN = "Not pretty, so why not eat it?"

--------------------------------------------------------------------------
--[[ the power of flowers ]]--[[ 花香四溢 ]]
--------------------------------------------------------------------------

S_NAMES.ROSORNS = "Rosorns"
S______GENERIC.DESCRIBE.ROSORNS = "I am so defenseless in front of love."
--S_______WILLOW.DESCRIBE.ROSORNS = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.ROSORNS = "Wolfgang can eat in one bite!"
S________WENDY.DESCRIBE.ROSORNS = "I am so vulnerable in front of love."
--S_________WX78.DESCRIBE.ROSORNS = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.ROSORNS = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.ROSORNS = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.ROSORNS = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.ROSORNS = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.ROSORNS = "Yaaay! Popsicle, popsicle!"
S_______WINONA.DESCRIBE.ROSORNS = "A rose's fragrance always strikes me deep in my heart..."

S_NAMES.LILEAVES = "Lileaves"
S______GENERIC.DESCRIBE.LILEAVES = "Love's poison makes me helpless."
--S_______WILLOW.DESCRIBE.LILEAVES = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.LILEAVES = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.LILEAVES = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.LILEAVES = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.LILEAVES = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.LILEAVES = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.LILEAVES = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.LILEAVES = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.LILEAVES = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.LILEAVES = "Great to cool off after some hard physical labor."

S_NAMES.ORCHITWIGS = "Orchitwigs"
S______GENERIC.DESCRIBE.ORCHITWIGS = "It's not striking, but I just like it."
--S_______WILLOW.DESCRIBE.ORCHITWIGS = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.ORCHITWIGS = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.ORCHITWIGS = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.ORCHITWIGS = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.ORCHITWIGS = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.ORCHITWIGS = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.ORCHITWIGS = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.ORCHITWIGS = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.ORCHITWIGS = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.ORCHITWIGS = "Great to cool off after some hard physical labor."

S_NAMES.ROSEBUSH = "Rose Bush"
S______GENERIC.DESCRIBE.ROSEBUSH = {
    BARREN = "She can't get through this on her own.",
    WITHERED = "Her beauty shrinks with her under the blazing sunlight.",
    GENERIC = "Beautiful, but spikey.",
    PICKED = "No one knows her beauty.",
    -- DISEASED = "Is weak. Sickly!",    --不会生病
    -- DISEASING = "Is looking shrivelly.",
    BURNING = "It's beauty is going up in smoke!",
}

S_NAMES.DUG_ROSEBUSH = "Rose Bush"
S______GENERIC.DESCRIBE.DUG_ROSEBUSH = "Although a rose is beautiful, it still has thorns."
--S_______WILLOW.DESCRIBE.DUG_ROSEBUSH = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DUG_ROSEBUSH = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DUG_ROSEBUSH = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DUG_ROSEBUSH = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DUG_ROSEBUSH = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DUG_ROSEBUSH = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DUG_ROSEBUSH = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DUG_ROSEBUSH = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.DUG_ROSEBUSH = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.DUG_ROSEBUSH = "Great to cool off after some hard physical labor."

S_NAMES.CUTTED_ROSEBUSH = "Rose Twigs"
S______GENERIC.DESCRIBE.CUTTED_ROSEBUSH = "This is a very common way of propagating plants."
--S_______WILLOW.DESCRIBE.CUTTED_ROSEBUSH = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.CUTTED_ROSEBUSH = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.CUTTED_ROSEBUSH = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.CUTTED_ROSEBUSH = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.CUTTED_ROSEBUSH = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.CUTTED_ROSEBUSH = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.CUTTED_ROSEBUSH = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.CUTTED_ROSEBUSH = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.CUTTED_ROSEBUSH = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.CUTTED_ROSEBUSH = "Great to cool off after some hard physical labor."

S_NAMES.LILYBUSH = "Lily Bush"
S______GENERIC.DESCRIBE.LILYBUSH = {
    BARREN = "It can't recover without my help.",
    WITHERED = "She is no longer beauteous.",
    GENERIC = "She's so different!",
    PICKED = "No one knows her beauty.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "It's beauty is going up in smoke!",
}

S_NAMES.DUG_LILYBUSH = "Lily Bush"
S______GENERIC.DESCRIBE.DUG_LILYBUSH = "I can't wait to see it bloom once again."
--S_______WILLOW.DESCRIBE.DUG_LILYBUSH = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DUG_LILYBUSH = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DUG_LILYBUSH = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DUG_LILYBUSH = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DUG_LILYBUSH = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DUG_LILYBUSH = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DUG_LILYBUSH = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DUG_LILYBUSH = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.DUG_LILYBUSH = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.DUG_LILYBUSH = "Great to cool off after some hard physical labor."

S_NAMES.CUTTED_LILYBUSH = "Lily Sprout"
S______GENERIC.DESCRIBE.CUTTED_LILYBUSH = "This is a very common way of propagating plants."
--S_______WILLOW.DESCRIBE.CUTTED_LILYBUSH = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.CUTTED_LILYBUSH = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.CUTTED_LILYBUSH = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.CUTTED_LILYBUSH = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.CUTTED_LILYBUSH = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.CUTTED_LILYBUSH = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.CUTTED_LILYBUSH = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.CUTTED_LILYBUSH = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.CUTTED_LILYBUSH = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.CUTTED_LILYBUSH = "Great to cool off after some hard physical labor."

S_NAMES.ORCHIDBUSH = "Orchid Bush"
S______GENERIC.DESCRIBE.ORCHIDBUSH = {
    BARREN = "It can't recover without my help.",
    WITHERED = "She is no longer beauteous.",
    GENERIC = "She's so different!",
    PICKED = "No one knows her beauty.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    BURNING = "It's beauty is going up in smoke!",
}

S_NAMES.DUG_ORCHIDBUSH = "Orchid Bush"
S______GENERIC.DESCRIBE.DUG_ORCHIDBUSH = "How dainty."
--S_______WILLOW.DESCRIBE.DUG_ORCHIDBUSH = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DUG_ORCHIDBUSH = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DUG_ORCHIDBUSH = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DUG_ORCHIDBUSH = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DUG_ORCHIDBUSH = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DUG_ORCHIDBUSH = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DUG_ORCHIDBUSH = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DUG_ORCHIDBUSH = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.DUG_ORCHIDBUSH = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.DUG_ORCHIDBUSH = "Great to cool off after some hard physical labor."

S_NAMES.CUTTED_ORCHIDBUSH = "Orchid Seeds"
S______GENERIC.DESCRIBE.CUTTED_ORCHIDBUSH = "This is a very common way of propagating plants."
--S_______WILLOW.DESCRIBE.CUTTED_ORCHIDBUSH = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.CUTTED_ORCHIDBUSH = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.CUTTED_ORCHIDBUSH = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.CUTTED_ORCHIDBUSH = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.CUTTED_ORCHIDBUSH = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.CUTTED_ORCHIDBUSH = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.CUTTED_ORCHIDBUSH = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.CUTTED_ORCHIDBUSH = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.CUTTED_ORCHIDBUSH = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.CUTTED_ORCHIDBUSH = "Great to cool off after some hard physical labor."

S_NAMES.NEVERFADEBUSH = "Neverfade Bush"
S______GENERIC.DESCRIBE.NEVERFADEBUSH = {
    --BARREN = "It can't recover without my help.",
    --WITHERED = "She is no longer beauteous.",
    GENERIC = "I knew it would never fade!",
    PICKED = "It's regaining the grace of nature.",
    --DISEASED = "Is weak. Sickly!",    --不会生病
    --DISEASING = "Is looking shrivelly.",
    --BURNING = "It's beauty is going up in smoke!",
}

S_NAMES.NEVERFADE = "Neverfade"    --永不凋零
S_RECIPE_DESC.NEVERFADE = "The power of flowers!"
S______GENERIC.DESCRIBE.NEVERFADE = "Divity... purity... and power!"
--S_______WILLOW.DESCRIBE.NEVERFADE = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.NEVERFADE = "Wolfgang can eat in one bite!"
S________WENDY.DESCRIBE.NEVERFADE = "It's not love, but it still is eternal..."
--S_________WX78.DESCRIBE.NEVERFADE = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.NEVERFADE = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.NEVERFADE = "I'd prefer maple taffy..."
S______WAXWELL.DESCRIBE.NEVERFADE = "Hm... this is something created by another force in the world."
--S___WATHGRITHR.DESCRIBE.NEVERFADE = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.NEVERFADE = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.NEVERFADE = "Great to cool off after some hard physical labor."
S_____WORMWOOD.DESCRIBE.NEVERFADE = "Strong friend."

S_NAMES.SACHET = "Sachet"    --香包
S_RECIPE_DESC.SACHET = "Hides your scent."
S______GENERIC.DESCRIBE.SACHET = "Should I smell like flowers?"
--S_______WILLOW.DESCRIBE.SACHET = "This is the opposite of burning."
S_____WOLFGANG.DESCRIBE.SACHET = "To be honest, this is too feminine..."
--S________WENDY.DESCRIBE.SACHET = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.SACHET = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.SACHET = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.SACHET = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.SACHET = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.SACHET = "I've somehow found a way to make it even LESS appealing!"
S_______WEBBER.DESCRIBE.SACHET = "Great! We smell sweet!"
--S_______WINONA.DESCRIBE.SACHET = "Great to cool off after some hard physical labor."
S_____WORMWOOD.DESCRIBE.SACHET = "Friend inside?"

S______GENERIC.ANNOUNCE_PICK_ROSEBUSH = "I wish I could help you."
-- S_______WILLOW.ANNOUNCE_PICK_ROSEBUSH = ""
-- S_____WOLFGANG.ANNOUNCE_PICK_ROSEBUSH = ""
-- S________WENDY.ANNOUNCE_PICK_ROSEBUSH = ""
S_________WX78.ANNOUNCE_PICK_ROSEBUSH = "A DAMAGING PLANT..."
-- S_WICKERBOTTOM.ANNOUNCE_PICK_ROSEBUSH = ""
-- S_______WOODIE.ANNOUNCE_PICK_ROSEBUSH = ""
S______WAXWELL.ANNOUNCE_PICK_ROSEBUSH = "You switched to this body?"
-- S___WATHGRITHR.ANNOUNCE_PICK_ROSEBUSH = ""
-- S_______WEBBER.ANNOUNCE_PICK_ROSEBUSH = ""
S_______WINONA.ANNOUNCE_PICK_ROSEBUSH = "One day I will be with you."
-- S_______WORTOX.ANNOUNCE_PICK_ROSEBUSH = ""
-- S________WARLY.ANNOUNCE_PICK_ROSEBUSH = ""

S_NAMES.FOLIAGEATH = "Foliageath" --青枝绿叶
-- S_RECIPE_DESC.FOLIAGEATH = "Silent foliage, guard fragrance."
S______GENERIC.DESCRIBE.FOLIAGEATH =
{
    MERGED = "Seems like I found it's purpose.",
    GENERIC = "Who or what is it waiting for?",
}
-- S_______WILLOW.DESCRIBE.FOLIAGEATH = ""
-- S_____WOLFGANG.DESCRIBE.FOLIAGEATH = ""
-- S________WENDY.DESCRIBE.FOLIAGEATH = ""
-- S_________WX78.DESCRIBE.FOLIAGEATH = ""
-- S_WICKERBOTTOM.DESCRIBE.FOLIAGEATH = ""
-- S_______WOODIE.DESCRIBE.FOLIAGEATH = ""
-- S______WAXWELL.DESCRIBE.FOLIAGEATH = ""
-- S___WATHGRITHR.DESCRIBE.FOLIAGEATH = ""
-- S_______WEBBER.DESCRIBE.FOLIAGEATH = ""
-- S_______WINONA.DESCRIBE.FOLIAGEATH = ""
-- S________WARLY.DESCRIBE.FOLIAGEATH = ""
-- S_______WORTOX.DESCRIBE.FOLIAGEATH = ""
-- S_____WORMWOOD.DESCRIBE.FOLIAGEATH =
-- S_________WURT.DESCRIBE.FOLIAGEATH = ""

--入鞘失败的台词
S______GENERIC.ACTIONFAIL.GIVE.WRONGSWORD = "This is not what it expected!"
-- S_______WILLOW.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- S_____WOLFGANG.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- S________WENDY.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- S_________WX78.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- S_WICKERBOTTOM.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- S_______WOODIE.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- S______WAXWELL.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- S___WATHGRITHR.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- S_______WEBBER.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- S_______WINONA.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- S________WARLY.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- S_______WORTOX.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- S_____WORMWOOD.ACTIONFAIL.GIVE.WRONGSWORD = ""
-- S_________WURT.ACTIONFAIL.GIVE.WRONGSWORD = ""

S_NAMES.FOLIAGEATH_MYLOVE = "Ciao Changqing"
S______GENERIC.DESCRIBE.FOLIAGEATH_MYLOVE = "Pity, you just want to run away."
-- S_______WILLOW.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- S_____WOLFGANG.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- S________WENDY.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- S_________WX78.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- S_WICKERBOTTOM.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- S_______WOODIE.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- S______WAXWELL.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- S___WATHGRITHR.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- S_______WEBBER.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- S_______WINONA.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- S________WARLY.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- S_______WORTOX.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- S_____WORMWOOD.DESCRIBE.FOLIAGEATH_MYLOVE = ""
-- S_________WURT.DESCRIBE.FOLIAGEATH_MYLOVE = ""

-- 合成青锋剑时的台词
S______GENERIC.ANNOUNCE_HIS_LOVE_WISH = "Wish it could last forever but sometimes..." --Wish love lasts forever!
-- S_______WILLOW.ANNOUNCE_HIS_LOVE_WISH = ""
-- S_____WOLFGANG.ANNOUNCE_HIS_LOVE_WISH = ""
-- S________WENDY.ANNOUNCE_HIS_LOVE_WISH = ""
-- S_________WX78.ANNOUNCE_HIS_LOVE_WISH = ""
-- S_WICKERBOTTOM.ANNOUNCE_HIS_LOVE_WISH = ""
-- S_______WOODIE.ANNOUNCE_HIS_LOVE_WISH = ""
-- S______WAXWELL.ANNOUNCE_HIS_LOVE_WISH = ""
-- S___WATHGRITHR.ANNOUNCE_HIS_LOVE_WISH = ""
-- S_______WEBBER.ANNOUNCE_HIS_LOVE_WISH = ""
-- S_______WINONA.ANNOUNCE_HIS_LOVE_WISH = ""
-- S________WARLY.ANNOUNCE_HIS_LOVE_WISH = ""
-- S_______WORTOX.ANNOUNCE_HIS_LOVE_WISH = ""
-- S_____WORMWOOD.ANNOUNCE_HIS_LOVE_WISH = ""
-- S_________WURT.ANNOUNCE_HIS_LOVE_WISH = ""

S______GENERIC.ACTIONFAIL.INTOSHEATH_L = S______GENERIC.ACTIONFAIL.GIVE
S_______WILLOW.ACTIONFAIL.INTOSHEATH_L = S_______WILLOW.ACTIONFAIL.GIVE
S_____WOLFGANG.ACTIONFAIL.INTOSHEATH_L = S_____WOLFGANG.ACTIONFAIL.GIVE
S________WENDY.ACTIONFAIL.INTOSHEATH_L = S________WENDY.ACTIONFAIL.GIVE
S_________WX78.ACTIONFAIL.INTOSHEATH_L = S_________WX78.ACTIONFAIL.GIVE
S_WICKERBOTTOM.ACTIONFAIL.INTOSHEATH_L = S_WICKERBOTTOM.ACTIONFAIL.GIVE
S_______WOODIE.ACTIONFAIL.INTOSHEATH_L = S_______WOODIE.ACTIONFAIL.GIVE
S______WAXWELL.ACTIONFAIL.INTOSHEATH_L = S______WAXWELL.ACTIONFAIL.GIVE
S___WATHGRITHR.ACTIONFAIL.INTOSHEATH_L = S___WATHGRITHR.ACTIONFAIL.GIVE
S_______WEBBER.ACTIONFAIL.INTOSHEATH_L = S_______WEBBER.ACTIONFAIL.GIVE
S_______WINONA.ACTIONFAIL.INTOSHEATH_L = S_______WINONA.ACTIONFAIL.GIVE
S_______WORTOX.ACTIONFAIL.INTOSHEATH_L = S_______WORTOX.ACTIONFAIL.GIVE
S_____WORMWOOD.ACTIONFAIL.INTOSHEATH_L = S_____WORMWOOD.ACTIONFAIL.GIVE
S________WARLY.ACTIONFAIL.INTOSHEATH_L = S________WARLY.ACTIONFAIL.GIVE
S_________WURT.ACTIONFAIL.INTOSHEATH_L = S_________WURT.ACTIONFAIL.GIVE
S_______WALTER.ACTIONFAIL.INTOSHEATH_L = S_______WALTER.ACTIONFAIL.GIVE
S________WANDA.ACTIONFAIL.INTOSHEATH_L = S________WANDA.ACTIONFAIL.GIVE

--------------------------------------------------------------------------
--[[ superb cuisine ]]--[[ 美味佳肴 ]]
--------------------------------------------------------------------------

S_NAMES.PETALS_ROSE = "Rose Petals"
S______GENERIC.DESCRIBE.PETALS_ROSE = "A rose is a rose, and it blooms for no one but itself."
--S_______WILLOW.DESCRIBE.PETALS_ROSE = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.PETALS_ROSE = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.PETALS_ROSE = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.PETALS_ROSE = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.PETALS_ROSE = "Well, isn't that refreshing?"
S_______WOODIE.DESCRIBE.PETALS_ROSE = "Feeling the grass between our toes, and Lucy's smile."
S______WAXWELL.DESCRIBE.PETALS_ROSE = "Wise men don’t believe in roses."
--S___WATHGRITHR.DESCRIBE.PETALS_ROSE = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.PETALS_ROSE = "Yaaay! Popsicle, popsicle!"
S_______WINONA.DESCRIBE.PETALS_ROSE = "A rose is a rose, Just like everybody knows."

S_NAMES.PETALS_LILY = "Lily Petals"
S______GENERIC.DESCRIBE.PETALS_LILY = "A lily is a lily, and the soul of the deceased being restored to innocence."
S_______WILLOW.DESCRIBE.PETALS_LILY = "If the ground below us turned to dust, Would he come to me?"
--S_____WOLFGANG.DESCRIBE.PETALS_LILY = "Wolfgang can eat in one bite!"
S________WENDY.DESCRIBE.PETALS_LILY = "I'd like it if he say it's a nice gift."
--S_________WX78.DESCRIBE.PETALS_LILY = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.PETALS_LILY = "Well, isn't that refreshing?"
S_______WOODIE.DESCRIBE.PETALS_LILY = "I see a lily on thy brow, with anguish moist and fever dew."
--S______WAXWELL.DESCRIBE.PETALS_LILY = "Hm... I don't know what I was expecting."
S___WATHGRITHR.DESCRIBE.PETALS_LILY = "A white lie, to make up my bravado."
S_______WEBBER.DESCRIBE.PETALS_LILY = "If we were to bring her some flowers, would it be a surprise?"
--S_______WINONA.DESCRIBE.PETALS_LILY = "Great to cool off after some hard physical labor."

S_NAMES.PETALS_ORCHID = "Orchid Petals"
S______GENERIC.DESCRIBE.PETALS_ORCHID = "An orchid is an orchid, and the love of the soul of the deceased."
--S_______WILLOW.DESCRIBE.PETALS_ORCHID = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.PETALS_ORCHID = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.PETALS_ORCHID = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.PETALS_ORCHID = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.PETALS_ORCHID = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.PETALS_ORCHID = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.PETALS_ORCHID = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.PETALS_ORCHID = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.PETALS_ORCHID = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.PETALS_ORCHID = "Great to cool off after some hard physical labor."

S_NAMES.DISH_CHILLEDROSEJUICE = "Chilled Rose Juice"    --蔷薇冰果汁
STRINGS.UI.COOKBOOK.DISH_CHILLEDROSEJUICE = "Plants flower at random"
S______GENERIC.DESCRIBE.DISH_CHILLEDROSEJUICE = "Gives a flowery feeling."
--S_______WILLOW.DESCRIBE.DISH_CHILLEDROSEJUICE = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DISH_CHILLEDROSEJUICE = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DISH_CHILLEDROSEJUICE = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DISH_CHILLEDROSEJUICE = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DISH_CHILLEDROSEJUICE = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DISH_CHILLEDROSEJUICE = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DISH_CHILLEDROSEJUICE = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DISH_CHILLEDROSEJUICE = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.DISH_CHILLEDROSEJUICE = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.DISH_CHILLEDROSEJUICE = "Great to cool off after some hard physical labor."

S_NAMES.DISH_TWISTEDROLLLILY = "Twisted Lily Roll"    --蹄莲花卷
STRINGS.UI.COOKBOOK.DISH_TWISTEDROLLLILY = "Calls a butterfly at random"
S______GENERIC.DESCRIBE.DISH_TWISTEDROLLLILY = "To be a butterfly, fluttering and dancing in the breeze."
--S_______WILLOW.DESCRIBE.DISH_TWISTEDROLLLILY = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DISH_TWISTEDROLLLILY = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DISH_TWISTEDROLLLILY = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DISH_TWISTEDROLLLILY = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DISH_TWISTEDROLLLILY = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DISH_TWISTEDROLLLILY = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DISH_TWISTEDROLLLILY = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DISH_TWISTEDROLLLILY = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.DISH_TWISTEDROLLLILY = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.DISH_TWISTEDROLLLILY = "Great to cool off after some hard physical labor."

S_NAMES.DISH_ORCHIDCAKE = "Orchid Cake"    --兰花糕
STRINGS.UI.COOKBOOK.DISH_ORCHIDCAKE = "Produces a comfortable temperature"
S______GENERIC.DESCRIBE.DISH_ORCHIDCAKE = "I seemed to hear a quiet voice that calmed me."
--S_______WILLOW.DESCRIBE.DISH_ORCHIDCAKE = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DISH_ORCHIDCAKE = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DISH_ORCHIDCAKE = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DISH_ORCHIDCAKE = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DISH_ORCHIDCAKE = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DISH_ORCHIDCAKE = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DISH_ORCHIDCAKE = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DISH_ORCHIDCAKE = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.DISH_ORCHIDCAKE = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.DISH_ORCHIDCAKE = "Great to cool off after some hard physical labor."

S_NAMES.DISH_FLESHNAPOLEON = "Flesh Napoleon"    --真果拿破仑
STRINGS.UI.COOKBOOK.DISH_FLESHNAPOLEON = "Glowing skin"
S______GENERIC.DESCRIBE.DISH_FLESHNAPOLEON = "The brightest star in the night sky is coming!"
--S_______WILLOW.DESCRIBE.DISH_FLESHNAPOLEON = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DISH_FLESHNAPOLEON = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DISH_FLESHNAPOLEON = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DISH_FLESHNAPOLEON = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DISH_FLESHNAPOLEON = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DISH_FLESHNAPOLEON = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DISH_FLESHNAPOLEON = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DISH_FLESHNAPOLEON = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.DISH_FLESHNAPOLEON = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.DISH_FLESHNAPOLEON = "Great to cool off after some hard physical labor."

S_NAMES.DISH_BEGGINGMEAT = "Begging Meat"    --叫花焖肉
STRINGS.UI.COOKBOOK.DISH_BEGGINGMEAT = "Extra hunger in an emergency"
S______GENERIC.DESCRIBE.DISH_BEGGINGMEAT = "For the moment, at least I don't have to beg for survival."
--S_______WILLOW.DESCRIBE.DISH_BEGGINGMEAT = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DISH_BEGGINGMEAT = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DISH_BEGGINGMEAT = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DISH_BEGGINGMEAT = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DISH_BEGGINGMEAT = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DISH_BEGGINGMEAT = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DISH_BEGGINGMEAT = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DISH_BEGGINGMEAT = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.DISH_BEGGINGMEAT = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.DISH_BEGGINGMEAT = "Great to cool off after some hard physical labor."

S_NAMES.DISH_FRENCHSNAILSBAKED = "French Snails Baked"    --法式焗蜗牛
STRINGS.UI.COOKBOOK.DISH_FRENCHSNAILSBAKED = "Gives it a spark and it'll explode"
S______GENERIC.DESCRIBE.DISH_FRENCHSNAILSBAKED = "I hope there's no fire in my stomach!"
--S_______WILLOW.DESCRIBE.DISH_FRENCHSNAILSBAKED = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DISH_FRENCHSNAILSBAKED = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DISH_FRENCHSNAILSBAKED = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DISH_FRENCHSNAILSBAKED = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DISH_FRENCHSNAILSBAKED = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DISH_FRENCHSNAILSBAKED = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DISH_FRENCHSNAILSBAKED = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DISH_FRENCHSNAILSBAKED = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.DISH_FRENCHSNAILSBAKED = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.DISH_FRENCHSNAILSBAKED = "Great to cool off after some hard physical labor."

S_NAMES.DISH_NEWORLEANSWINGS = "New Orleans Wings"    --新奥尔良烤翅
STRINGS.UI.COOKBOOK.DISH_NEWORLEANSWINGS = "Absorb vibrations"
S______GENERIC.DESCRIBE.DISH_NEWORLEANSWINGS = "Why did I suddenly think of a man in a bat suit?"
--S_______WILLOW.DESCRIBE.DISH_NEWORLEANSWINGS = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DISH_NEWORLEANSWINGS = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DISH_NEWORLEANSWINGS = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DISH_NEWORLEANSWINGS = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DISH_NEWORLEANSWINGS = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DISH_NEWORLEANSWINGS = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DISH_NEWORLEANSWINGS = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DISH_NEWORLEANSWINGS = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.DISH_NEWORLEANSWINGS = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.DISH_NEWORLEANSWINGS = "Great to cool off after some hard physical labor."

S_NAMES.DISH_FISHJOYRAMEN = "Fishjoy Ramen"    --鱼乐拉面
STRINGS.UI.COOKBOOK.DISH_FISHJOYRAMEN = "Accidentally inhale something"
S______GENERIC.DESCRIBE.DISH_FISHJOYRAMEN = "Don't slurp your soup, be polite!"
--S_______WILLOW.DESCRIBE.DISH_FISHJOYRAMEN = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DISH_FISHJOYRAMEN = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DISH_FISHJOYRAMEN = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DISH_FISHJOYRAMEN = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DISH_FISHJOYRAMEN = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DISH_FISHJOYRAMEN = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DISH_FISHJOYRAMEN = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DISH_FISHJOYRAMEN = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.DISH_FISHJOYRAMEN = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.DISH_FISHJOYRAMEN = "Great to cool off after some hard physical labor."

S_NAMES.DISH_ROASTEDMARSHMALLOWS = "Roasted Marshmallows"    --烤棉花糖
S______GENERIC.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "It reminds me of my old days camping with my friends."
--S_______WILLOW.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "Wolfgang can eat in one bite!"
S________WENDY.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "Reminding me of my childhood camping with Abigail."
S_________WX78.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "IT REMINDED ME OF PYRO!"
--S_WICKERBOTTOM.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "Well, isn't that refreshing?"
S_______WOODIE.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "I almost forgot, the time I spent camping with Lucy."
--S______WAXWELL.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "I've somehow found a way to make it even LESS appealing!"
S_______WEBBER.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "It reminds us of our childhood camping with our family."
--S_______WINONA.DESCRIBE.DISH_ROASTEDMARSHMALLOWS = "Great to cool off after some hard physical labor."

S_NAMES.DISH_POMEGRANATEJELLY = "Pomegranate Jelly"    --石榴子果冻
S______GENERIC.DESCRIBE.DISH_POMEGRANATEJELLY = "It's children's stuff, I'm not naive any more."
--S_______WILLOW.DESCRIBE.DISH_POMEGRANATEJELLY = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DISH_POMEGRANATEJELLY = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DISH_POMEGRANATEJELLY = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DISH_POMEGRANATEJELLY = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DISH_POMEGRANATEJELLY = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DISH_POMEGRANATEJELLY = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DISH_POMEGRANATEJELLY = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DISH_POMEGRANATEJELLY = "I've somehow found a way to make it even LESS appealing!"
S_______WEBBER.DESCRIBE.DISH_POMEGRANATEJELLY = "We like Jellys!"
--S_______WINONA.DESCRIBE.DISH_POMEGRANATEJELLY = "Great to cool off after some hard physical labor."

S_NAMES.DISH_MEDICINALLIQUOR = "Medicinal Liquor"    --药酒
STRINGS.UI.COOKBOOK.DISH_MEDICINALLIQUOR = "Boost morale"
S______GENERIC.DESCRIBE.DISH_MEDICINALLIQUOR = {
    GENERIC = "Maybe you can get drunk after drinking.",
    DRUNK = "I'm not drunk!",
}
S_______WILLOW.DESCRIBE.DISH_MEDICINALLIQUOR = {
    GENERIC = "This can add fire to my strength.",
    DRUNK = "That's it?",
}
S_____WOLFGANG.DESCRIBE.DISH_MEDICINALLIQUOR = {
    GENERIC = "Wolfgang loves drinking.",
    DRUNK = "Wolfgang won't get drunk.",
}
S________WENDY.DESCRIBE.DISH_MEDICINALLIQUOR = {
    GENERIC = "I don't want to drink this.",
    DRUNK = "I shouldn't have drunk this.",
}
-- S_________WX78.DESCRIBE.DISH_MEDICINALLIQUOR =
--S_WICKERBOTTOM.DESCRIBE.DISH_MEDICINALLIQUOR =
--S_______WOODIE.DESCRIBE.DISH_MEDICINALLIQUOR =
--S______WAXWELL.DESCRIBE.DISH_MEDICINALLIQUOR =
S___WATHGRITHR.DESCRIBE.DISH_MEDICINALLIQUOR = {
    GENERIC = "Feel no pain! Fight to the death!",
    DRUNK = "Oh, just water!",
}
S_______WEBBER.DESCRIBE.DISH_MEDICINALLIQUOR = {
    GENERIC = "My mom warned me not to drink before.",
    DRUNK = "Mom, We are so sleeeeee...",
}
-- S_______WINONA.DESCRIBE.DISH_MEDICINALLIQUOR =
-- S_______WORTOX.DESCRIBE.DISH_MEDICINALLIQUOR =
-- S_____WORMWOOD.DESCRIBE.DISH_MEDICINALLIQUOR =
-- S________WARLY.DESCRIBE.DISH_MEDICINALLIQUOR =
-- S_________WURT.DESCRIBE.DISH_MEDICINALLIQUOR =
-- S_______WALTER.DESCRIBE.DISH_MEDICINALLIQUOR =
-- S________WANDA.DESCRIBE.DISH_MEDICINALLIQUOR =

S_NAMES.DISH_BANANAMOUSSE = "Banana Mousse"    --香蕉慕斯
STRINGS.UI.COOKBOOK.DISH_BANANAMOUSSE = "Stops picky eating"
S______GENERIC.DESCRIBE.DISH_BANANAMOUSSE = "An appetizing dessert. Yummy..."
--S_______WILLOW.DESCRIBE.DISH_BANANAMOUSSE = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DISH_BANANAMOUSSE = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DISH_BANANAMOUSSE = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DISH_BANANAMOUSSE = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DISH_BANANAMOUSSE = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DISH_BANANAMOUSSE = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DISH_BANANAMOUSSE = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DISH_BANANAMOUSSE = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.DISH_BANANAMOUSSE = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.DISH_BANANAMOUSSE = "Great to cool off after some hard physical labor."

S_NAMES.DISH_RICEDUMPLING = "Rice Dumpling"    --金黄香粽
STRINGS.UI.COOKBOOK.DISH_RICEDUMPLING = "Fills your stomach, you'll like it"
S______GENERIC.DESCRIBE.DISH_RICEDUMPLING = "It has a natural smell."
--S_______WILLOW.DESCRIBE.DISH_RICEDUMPLING = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DISH_RICEDUMPLING = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DISH_RICEDUMPLING = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DISH_RICEDUMPLING = "STICK ADDON INSTALLED"
S_WICKERBOTTOM.DESCRIBE.DISH_RICEDUMPLING = "Maybe I should throw it into the river to feed the fish."
--S_______WOODIE.DESCRIBE.DISH_RICEDUMPLING = "I'd prefer maple taffy..."
S______WAXWELL.DESCRIBE.DISH_RICEDUMPLING = "My stomach doesn't feel well when I see this."
--S___WATHGRITHR.DESCRIBE.DISH_RICEDUMPLING = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.DISH_RICEDUMPLING = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.DISH_RICEDUMPLING = "Great to cool off after some hard physical labor."

S_NAMES.DISH_DURIANTARTARE = "Durian Tartare"    --怪味鞑靼
STRINGS.UI.COOKBOOK.DISH_DURIANTARTARE = "Gives monsters extra recovery"
S______GENERIC.DESCRIBE.DISH_DURIANTARTARE = "Brutal, bloody and yucky..."
S_______WILLOW.DESCRIBE.DISH_DURIANTARTARE = "What a mess! Needs a fire!"
--S_____WOLFGANG.DESCRIBE.DISH_DURIANTARTARE = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.DISH_DURIANTARTARE = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DISH_DURIANTARTARE = "STICK ADDON INSTALLED"
S_WICKERBOTTOM.DESCRIBE.DISH_DURIANTARTARE = "Umm... the meat is still raw, and it stinks."
--S_______WOODIE.DESCRIBE.DISH_DURIANTARTARE = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DISH_DURIANTARTARE = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DISH_DURIANTARTARE = "I've somehow found a way to make it even LESS appealing!"
S_______WEBBER.DESCRIBE.DISH_DURIANTARTARE = "A lump of raw meat, cool!"
--S_______WINONA.DESCRIBE.DISH_DURIANTARTARE = "Great to cool off after some hard physical labor."
S_______WORTOX.DESCRIBE.DISH_DURIANTARTARE = "Whose flesh is this, a yummy little remnant of it's soul remains."

S_NAMES.DISH_MERRYCHRISTMASSALAD = "\"Merry Christmas\" Salad"    --“圣诞快乐”沙拉
STRINGS.UI.COOKBOOK.DISH_MERRYCHRISTMASSALAD = "Produces a gift"
S______GENERIC.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "Look at the Christmas tree, now eat the christmas tree."
-- S_______WILLOW.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "Mess! needs a fire!"
S_____WOLFGANG.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "Wolfgang wants a gift Santa Claus, please."
--S________WENDY.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "STICK ADDON INSTALLED"
-- S_WICKERBOTTOM.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "Umm... the meat is still raw, and it stinks."
S_______WOODIE.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "Now I'm not the only one who can eat trees."
--S______WAXWELL.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "I've somehow found a way to make it even LESS appealing!"
S_______WEBBER.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "Should I eat from the star or from the trunk?"
S_______WINONA.DESCRIBE.DISH_MERRYCHRISTMASSALAD = "Merry Christmas! Hah."

S_NAMES.DISH_MURMURANANAS = "Murmur Ananas"    --松萝咕咾肉
S______GENERIC.DESCRIBE.DISH_MURMURANANAS = "Sour and sweet meat, I like it!"
-- S_______WILLOW.DESCRIBE.DISH_MURMURANANAS = "This is the opposite of burning."
S_____WOLFGANG.DESCRIBE.DISH_MURMURANANAS = "Wolfgang loves it so much that he wants to eat it again!"
-- S________WENDY.DESCRIBE.DISH_MURMURANANAS = "I used to eat these with Abigail..."
-- S_________WX78.DESCRIBE.DISH_MURMURANANAS = "STICK ADDON INSTALLED"
-- S_WICKERBOTTOM.DESCRIBE.DISH_MURMURANANAS = "Well, isn't that refreshing?"
-- S_______WOODIE.DESCRIBE.DISH_MURMURANANAS = "I'd prefer maple taffy..."
S______WAXWELL.DESCRIBE.DISH_MURMURANANAS = "This cuisine will never disappear on the menu of Chinatown restaurants."
-- S___WATHGRITHR.DESCRIBE.DISH_MURMURANANAS = "I've somehow found a way to make it even LESS appealing!"
-- S_______WEBBER.DESCRIBE.DISH_MURMURANANAS = "Yaaay! Popsicle, popsicle!"
-- S_______WINONA.DESCRIBE.DISH_MURMURANANAS = "Great to cool off after some hard physical labor."
-- S_______WORTOX.DESCRIBE.DISH_MURMURANANAS = "Whose flesh is this, with a little yummy soul remained."

S_NAMES.DISH_SHYERRYJAM = "Shyerry Jam"    --颤栗果酱
STRINGS.UI.COOKBOOK.DISH_SHYERRYJAM = "Self-healing in moderation"
S______GENERIC.DESCRIBE.DISH_SHYERRYJAM = "I'd love to pour it over scones or make a pie with it."
-- S_______WILLOW.DESCRIBE.DISH_SHYERRYJAM = "This is the opposite of burning."
-- S_____WOLFGANG.DESCRIBE.DISH_SHYERRYJAM = "Wolfgang loves it so much that he wants to eat it again!"
-- S________WENDY.DESCRIBE.DISH_SHYERRYJAM = "I used to eat these with Abigail..."
S_________WX78.DESCRIBE.DISH_SHYERRYJAM = "NO DESSERT, JUST EAT IT DIRECTLY."
-- S_WICKERBOTTOM.DESCRIBE.DISH_SHYERRYJAM = "Well, isn't that refreshing?"
-- S_______WOODIE.DESCRIBE.DISH_SHYERRYJAM = "I'd prefer maple taffy..."
-- S______WAXWELL.DESCRIBE.DISH_SHYERRYJAM = "This "
-- S___WATHGRITHR.DESCRIBE.DISH_SHYERRYJAM = "I've somehow found a way to make it even LESS appealing!"
-- S_______WEBBER.DESCRIBE.DISH_SHYERRYJAM = "Yaaay! Popsicle, popsicle!"
-- S_______WINONA.DESCRIBE.DISH_SHYERRYJAM = "Great to cool off after some hard physical labor."
-- S_______WORTOX.DESCRIBE.DISH_SHYERRYJAM = "Whose flesh is this, with a little yummy soul remained."

S_NAMES.DISH_SUGARLESSTRICKMAKERCUPCAKES = "Sugarless Trickster Cupcakes"   --无糖捣蛋鬼纸杯蛋糕
STRINGS.UI.COOKBOOK.DISH_SUGARLESSTRICKMAKERCUPCAKES = "Naughty elves will help you"
S______GENERIC.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "Trick or treat!",
    TRICKED = "Scared me silly.",
    TREAT = "Here's your candy.",
}
-- S_______WILLOW.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES = ""
S_____WOLFGANG.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "Wolfgang only wants sugar, not to play tricks.",
    TRICKED = "It scared Wolfgang too much.",
    TREAT = "Wolfgang will share the happiness.",
}
S________WENDY.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "Maybe I'm too mature to ask for sugar.",
    TRICKED = "Scared me silly.",
    TREAT = "Would Abigail want candy, too?",
}
S_________WX78.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "MY BODY CRAVES DEOXYRIBOSE.",
    TRICKED = "SUDDEN WARNING!",
    TREAT = "I'LL JUST GIVE YOU SOMTHING I DON'T WANT.",
}
S_WICKERBOTTOM.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "I believe it's a trick.",
    TRICKED = "That's not allowed in a library!",
    TREAT = "Here's your candy.",
}
-- S_______WOODIE.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES = ""
-- S______WAXWELL.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES = ""
-- S___WATHGRITHR.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES = ""
S_______WEBBER.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "We just want sweety sugar and candy!",
    TRICKED = "You made everyone laugh.",
    TREAT = "We're the ones who want the sugar.",
}
-- S_______WINONA.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES = ""
S_______WORTOX.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "Hey, don't steal my thunder!!!",
    TRICKED = "Hah, small trick.",
    TREAT = "What if I don't give sugar.",
}
S_____WORMWOOD.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "Nectar, please?",
    TRICKED = "It made my leaves tremble.",
    TREAT = "Is today the pollination day?",
}
S________WARLY.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES =
{
    GENERIC = "What a timely snack!",
    TRICKED = "It made my pot shake.",
    TREAT = "This chef is going to treat the guests well.",
}
-- S_________WURT.DESCRIBE.DISH_SUGARLESSTRICKMAKERCUPCAKES = ""

S_NAMES.DISH_FLOWERMOONCAKE = "Flower Mooncake"    --鲜花月饼
STRINGS.UI.COOKBOOK.DISH_FLOWERMOONCAKE = "Obtain power from longing"
S______GENERIC.DESCRIBE.DISH_FLOWERMOONCAKE =
{
    GENERIC = "The scent of yearning.",
    HAPPY = "I will always have someone important on my mind.",
    LONELY = "Lonely and sad.",
}
-- S_______WILLOW.DESCRIBE.DISH_FLOWERMOONCAKE = ""
-- S_____WOLFGANG.DESCRIBE.DISH_FLOWERMOONCAKE = ""
S________WENDY.DESCRIBE.DISH_FLOWERMOONCAKE =
{
    GENERIC = "Come, Abigail, enjoy the moon with me!",
    HAPPY = "So nostalgic for the day we had a picnic.",
    LONELY = "Unprecedented loneliness is eroding me.",
}
S_________WX78.DESCRIBE.DISH_FLOWERMOONCAKE =
{
    GENERIC = "LOW VALUE FUEL.",
    HAPPY = "UNKNOWN INTRUDER IS TRYING TO REPAIR THE EMOTION MODULE.",
    LONELY = "STILL WRONG, THE EMOTIONAL MODULE IS NOT RESPONDING.",
}
-- S_WICKERBOTTOM.DESCRIBE.DISH_FLOWERMOONCAKE = ""
-- S_______WOODIE.DESCRIBE.DISH_FLOWERMOONCAKE = ""
S______WAXWELL.DESCRIBE.DISH_FLOWERMOONCAKE =
{
    GENERIC = "It's not decent to get your suit dirty.",
    HAPPY = "I just want to make it all right, Charlie.",
    LONELY = "I deserve it.",
}
-- S___WATHGRITHR.DESCRIBE.DISH_FLOWERMOONCAKE = ""
-- S_______WEBBER.DESCRIBE.DISH_FLOWERMOONCAKE = ""
-- S_______WINONA.DESCRIBE.DISH_FLOWERMOONCAKE = ""
-- S_______WORTOX.DESCRIBE.DISH_FLOWERMOONCAKE = ""
S_____WORMWOOD.DESCRIBE.DISH_FLOWERMOONCAKE =
{
    GENERIC = "The sustenance of friends miss.",
    HAPPY = "So nice to have friends around!",
    LONELY = "It's so lonely without a friend.",
}
S________WARLY.DESCRIBE.DISH_FLOWERMOONCAKE =
{
    GENERIC = "While eating and enjoying the moon, memories come to mind.",
    HAPPY = "Grandma, I miss you.",
    LONELY = "Alas, what's the use of cooking!",
}
-- S_________WURT.DESCRIBE.DISH_FLOWERMOONCAKE = ""
-- S_______WALTER.DESCRIBE.DISH_FLOWERMOONCAKE = ""

S_NAMES.DISH_FAREWELLCUPCAKE = "Farewell Cupcake" --临别的纸杯蛋糕
STRINGS.UI.COOKBOOK.DISH_FLOWERMOONCAKE = "Say goodbye to my life"
S______GENERIC.DESCRIBE.DISH_FAREWELLCUPCAKE = "So easy to be careless, but takes courage to care."
-- S_______WILLOW.DESCRIBE.DISH_FAREWELLCUPCAKE = ""
-- S_____WOLFGANG.DESCRIBE.DISH_FAREWELLCUPCAKE = ""
S________WENDY.DESCRIBE.DISH_FAREWELLCUPCAKE = "Failures, let everyone down, including ourselves."
-- S_________WX78.DESCRIBE.DISH_FAREWELLCUPCAKE = ""
S_WICKERBOTTOM.DESCRIBE.DISH_FAREWELLCUPCAKE = "Unfortunately, some lack the self-awareness to not make this decision."
S_______WOODIE.DESCRIBE.DISH_FAREWELLCUPCAKE = "People are alienated from each other with a broken heart."
S______WAXWELL.DESCRIBE.DISH_FAREWELLCUPCAKE = "My life is not worth mentioning."
S___WATHGRITHR.DESCRIBE.DISH_FAREWELLCUPCAKE = "Don't you have enough?"
S_______WEBBER.DESCRIBE.DISH_FAREWELLCUPCAKE = "It's not my decision to make, we have to decide together."
-- S_______WINONA.DESCRIBE.DISH_FAREWELLCUPCAKE = ""
S_______WORTOX.DESCRIBE.DISH_FAREWELLCUPCAKE = "Sorry, it may be painful to be alive but I'm not done yet."
-- S_____WORMWOOD.DESCRIBE.DISH_FAREWELLCUPCAKE = ""
-- S________WARLY.DESCRIBE.DISH_FAREWELLCUPCAKE = ""
S_________WURT.DESCRIBE.DISH_FAREWELLCUPCAKE = "To deliberately believe in lies while knowing their false."
-- S_______WALTER.DESCRIBE.DISH_FAREWELLCUPCAKE = ""

S_NAMES.DISH_BRAISEDMEATWITHFOLIAGES = "Braised Meat With Foliages" --蕨叶扣肉
S______GENERIC.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = "Looks so greasy, just one piece of meat, please."
-- S_______WILLOW.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
S_____WOLFGANG.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = "Wolfgang loves it!"
-- S________WENDY.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- S_________WX78.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- S_WICKERBOTTOM.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
S_______WOODIE.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = "It goes well with rice."
-- S______WAXWELL.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- S___WATHGRITHR.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- S_______WEBBER.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- S_______WINONA.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- S_______WORTOX.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- S_____WORMWOOD.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
S________WARLY.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = "It's not easy to make fat meat not greasy."
-- S_________WURT.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""
-- S_______WALTER.DESCRIBE.DISH_BRAISEDMEATWITHFOLIAGES = ""

S_NAMES.DISH_WRAPPEDSHRIMPPASTE = "Wrapped Mushrimp" --白菇虾滑卷
STRINGS.UI.COOKBOOK.DISH_WRAPPEDSHRIMPPASTE = "Enhances resistance"
S______GENERIC.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = "Great! The outer layer locks well the shrimp essence."
-- S_______WILLOW.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
-- S_____WOLFGANG.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
-- S________WENDY.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
-- S_________WX78.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
-- S_WICKERBOTTOM.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
S_______WOODIE.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = "So delicious. Can I have the wooden dish, too?"
-- S______WAXWELL.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
-- S___WATHGRITHR.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
-- S_______WEBBER.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
S_______WINONA.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = "A smooth and delicate taste, it's just not me."
-- S_______WORTOX.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""
S_____WORMWOOD.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = "Beautiful friend, making a beautiful meal."
S________WARLY.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = "Ah, the mushroom, the shrimp, my life has reached the peak!"
S_________WURT.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = "It's cruel, glort."
-- S_______WALTER.DESCRIBE.DISH_WRAPPEDSHRIMPPASTE = ""

S_NAMES.DISH_SOSWEETJARKFRUIT = "So Sweet Jarkfruit" --甜到裂开的松萝蜜
S______GENERIC.DESCRIBE.DISH_SOSWEETJARKFRUIT = "It was so sweet that I got flustered."
S_______WILLOW.DESCRIBE.DISH_SOSWEETJARKFRUIT = "Too sweet, chef."
-- S_____WOLFGANG.DESCRIBE.DISH_SOSWEETJARKFRUIT = ""
S________WENDY.DESCRIBE.DISH_SOSWEETJARKFRUIT = "There's two of them, one for me and one for Abigail."
S_________WX78.DESCRIBE.DISH_SOSWEETJARKFRUIT = "FUEL DETECTION: EXCESSIVE HEAT."
S_WICKERBOTTOM.DESCRIBE.DISH_SOSWEETJARKFRUIT = "I shouldn't eat such unhealthy food."
-- S_______WOODIE.DESCRIBE.DISH_SOSWEETJARKFRUIT = ""
-- S______WAXWELL.DESCRIBE.DISH_SOSWEETJARKFRUIT = ""
-- S___WATHGRITHR.DESCRIBE.DISH_SOSWEETJARKFRUIT = ""
S_______WEBBER.DESCRIBE.DISH_SOSWEETJARKFRUIT = "So sweet, I'm in heaven!"
S_______WINONA.DESCRIBE.DISH_SOSWEETJARKFRUIT = "Did no one notice a crack in the bottle?"
S_______WORTOX.DESCRIBE.DISH_SOSWEETJARKFRUIT = "Love is to sugar, as sweet is to sadness."
S_____WORMWOOD.DESCRIBE.DISH_SOSWEETJARKFRUIT = "Crack!"
S________WARLY.DESCRIBE.DISH_SOSWEETJARKFRUIT = "I have an appointment with a sweet lady."
-- S_________WURT.DESCRIBE.DISH_SOSWEETJARKFRUIT = ""
S_______WALTER.DESCRIBE.DISH_SOSWEETJARKFRUIT = "Not a perfect dish because it's cracked."

S_NAMES.DISH_FRIEDFISHWITHPUREE = "Fried Fish With Puree" --果泥香煎鱼
STRINGS.UI.COOKBOOK.DISH_FRIEDFISHWITHPUREE = "Can't stop the flow"
S______GENERIC.DESCRIBE.DISH_FRIEDFISHWITHPUREE = "So crisp, so luscious, so nice!"
S_______WILLOW.DESCRIBE.DISH_FRIEDFISHWITHPUREE = "The flame makes it look good."
S_____WOLFGANG.DESCRIBE.DISH_FRIEDFISHWITHPUREE = "Delicious is best."
-- S________WENDY.DESCRIBE.DISH_FRIEDFISHWITHPUREE = ""
-- S_________WX78.DESCRIBE.DISH_FRIEDFISHWITHPUREE = ""
S_WICKERBOTTOM.DESCRIBE.DISH_FRIEDFISHWITHPUREE = "Honestly, the fish looks suspicious."
S_______WOODIE.DESCRIBE.DISH_FRIEDFISHWITHPUREE = "I want to finish it quickly, I have work to do."
-- S______WAXWELL.DESCRIBE.DISH_FRIEDFISHWITHPUREE = ""
S___WATHGRITHR.DESCRIBE.DISH_FRIEDFISHWITHPUREE = "Why not try it."
-- S_______WEBBER.DESCRIBE.DISH_FRIEDFISHWITHPUREE = ""
-- S_______WINONA.DESCRIBE.DISH_FRIEDFISHWITHPUREE = ""
S_______WORTOX.DESCRIBE.DISH_FRIEDFISHWITHPUREE = "Hmm, this seems like a trick. Kind of funny."
-- S_____WORMWOOD.DESCRIBE.DISH_FRIEDFISHWITHPUREE = ""
S________WARLY.DESCRIBE.DISH_FRIEDFISHWITHPUREE = "With years of cooking experience, I emplore you to not eat it!"
S_________WURT.DESCRIBE.DISH_FRIEDFISHWITHPUREE = "Those who eat fish will be punished by it."
-- S_______WALTER.DESCRIBE.DISH_FRIEDFISHWITHPUREE = ""
S________WANDA.DESCRIBE.DISH_FRIEDFISHWITHPUREE = "Haha, not only your time is passing."

-----

--蝙蝠伪装buff
S______GENERIC.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = "I seem to be wearing an invisible bat suit."
-- S_______WILLOW.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- S_____WOLFGANG.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- S________WENDY.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- S_________WX78.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- S_WICKERBOTTOM.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- S_______WOODIE.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- S______WAXWELL.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- S___WATHGRITHR.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- S_______WEBBER.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- S_______WINONA.ANNOUNCE_ATTACH_BUFF_BATDISGUISE = ""
-- S_______WORTOX.ANNOUNCE_ATTACH_BUFF_BATDISGUISE =
-- S_____WORMWOOD.ANNOUNCE_ATTACH_BUFF_BATDISGUISE =
-- S________WARLY.ANNOUNCE_ATTACH_BUFF_BATDISGUISE =
-- S_________WURT.ANNOUNCE_ATTACH_BUFF_BATDISGUISE =
-- S_______WALTER.ANNOUNCE_ATTACH_BUFF_BATDISGUISE =
-- S________WANDA.ANNOUNCE_ATTACH_BUFF_BATDISGUISE =
--
S______GENERIC.ANNOUNCE_DETACH_BUFF_BATDISGUISE = "Well, I'm not a bat."
-- S_______WILLOW.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- S_____WOLFGANG.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- S________WENDY.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- S_________WX78.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- S_WICKERBOTTOM.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- S_______WOODIE.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- S______WAXWELL.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- S___WATHGRITHR.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- S_______WEBBER.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- S_______WINONA.ANNOUNCE_DETACH_BUFF_BATDISGUISE = ""
-- S_______WORTOX.ANNOUNCE_DETACH_BUFF_BATDISGUISE =
-- S_____WORMWOOD.ANNOUNCE_DETACH_BUFF_BATDISGUISE =
-- S________WARLY.ANNOUNCE_DETACH_BUFF_BATDISGUISE =
-- S_________WURT.ANNOUNCE_DETACH_BUFF_BATDISGUISE =
-- S_______WALTER.ANNOUNCE_DETACH_BUFF_BATDISGUISE =
-- S________WANDA.ANNOUNCE_DETACH_BUFF_BATDISGUISE =

--最佳胃口buff
S______GENERIC.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = "Suddenly, I want to have a big meal."
-- S_______WILLOW.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- S_____WOLFGANG.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- S________WENDY.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- S_________WX78.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- S_WICKERBOTTOM.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- S_______WOODIE.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- S______WAXWELL.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- S___WATHGRITHR.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- S_______WEBBER.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- S_______WINONA.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- S_______WORTOX.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE = ""
-- S_____WORMWOOD.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE =
-- S________WARLY.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE =
-- S_________WURT.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE =
-- S_______WALTER.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE =
-- S________WANDA.ANNOUNCE_ATTACH_BUFF_BESTAPPETITE =
--
S______GENERIC.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = "My appetite has returned to normal."
-- S_______WILLOW.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- S_____WOLFGANG.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- S________WENDY.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- S_________WX78.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- S_WICKERBOTTOM.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- S_______WOODIE.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- S______WAXWELL.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- S___WATHGRITHR.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- S_______WEBBER.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- S_______WINONA.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- S_______WORTOX.ANNOUNCE_DETACH_BUFF_BESTAPPETITE = ""
-- S_____WORMWOOD.ANNOUNCE_DETACH_BUFF_BESTAPPETITE =
-- S________WARLY.ANNOUNCE_DETACH_BUFF_BESTAPPETITE =
-- S_________WURT.ANNOUNCE_DETACH_BUFF_BESTAPPETITE =
-- S_______WALTER.ANNOUNCE_DETACH_BUFF_BESTAPPETITE =
-- S________WANDA.ANNOUNCE_DETACH_BUFF_BESTAPPETITE =

--胃梗塞buff
S______GENERIC.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = "No appetite at all."
-- S_______WILLOW.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
-- S_____WOLFGANG.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
-- S________WENDY.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
-- S_________WX78.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
S_WICKERBOTTOM.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = "This food boosts my satiety."
-- S_______WOODIE.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
S______WAXWELL.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = "Not good for my old stomach."
-- S___WATHGRITHR.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
-- S_______WEBBER.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
S_______WINONA.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = "The less hungry you are, the better you can work."
-- S_______WORTOX.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER = ""
-- S_____WORMWOOD.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER =
-- S________WARLY.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER =
-- S_________WURT.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER =
-- S_______WALTER.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER =
-- S________WANDA.ANNOUNCE_ATTACH_BUFF_HUNGERRETARDER =
--
S______GENERIC.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = "Good luck comes when you have an appetite."
-- S_______WILLOW.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
-- S_____WOLFGANG.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
-- S________WENDY.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
-- S_________WX78.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
S_WICKERBOTTOM.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = "Hunger returns to normal."
-- S_______WOODIE.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
S______WAXWELL.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = "My stomach feels better at last."
-- S___WATHGRITHR.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
-- S_______WEBBER.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
S_______WINONA.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = "Even if you're hungry, you have to keep working."
-- S_______WORTOX.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER = ""
-- S_____WORMWOOD.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER =
-- S________WARLY.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER =
-- S_________WURT.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER =
-- S_______WALTER.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER =
-- S________WANDA.ANNOUNCE_DETACH_BUFF_HUNGERRETARDER =

--力量增幅buff
-- S______GENERIC.ANNOUNCE_ATTACH_BUFF_STRENGTHENHANCER = "" --属于药酒的buff，但是药酒已经会让玩家说话了，所以这里不再重复说
--
S______GENERIC.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = "The power enhancement effect has faded."
S_______WILLOW.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = "The burning of muscles is over."
S_____WOLFGANG.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = "Wolfgang felt the disappearance of brute force."
-- S________WENDY.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
S_________WX78.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = "OVERLOAD OPERATION IS OVER."
S_WICKERBOTTOM.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = "The power gained by a shortcut doesn't last long after all."
-- S_______WOODIE.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- S______WAXWELL.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
S___WATHGRITHR.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = "This power dissipated after all."
S_______WEBBER.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = "Our little hands have become weak again."
-- S_______WINONA.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
S_______WORTOX.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = "I wish my strength could've lasted 10000 years."
-- S_____WORMWOOD.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
S________WARLY.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = "Extra power has been completely digested."
-- S_________WURT.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
-- S_______WALTER.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = ""
S________WANDA.ANNOUNCE_DETACH_BUFF_STRENGTHENHANCER = "I should go back and regain my strength."

--腹得流油buff
S______GENERIC.ANNOUNCE_ATTACH_BUFF_OILFLOW = "Seems nothing happened."
-- S_______WILLOW.ANNOUNCE_ATTACH_BUFF_OILFLOW = ""
S_____WOLFGANG.ANNOUNCE_ATTACH_BUFF_OILFLOW = "Wolfgang want to go to the bathroom."
-- S________WENDY.ANNOUNCE_ATTACH_BUFF_OILFLOW = ""
S_________WX78.ANNOUNCE_ATTACH_BUFF_OILFLOW = "UNKNOWN LEAK IN FUEL SYSTEM!"
S_WICKERBOTTOM.ANNOUNCE_ATTACH_BUFF_OILFLOW = "I think I'll need adult diapers."
-- S_______WOODIE.ANNOUNCE_ATTACH_BUFF_OILFLOW = ""
S______WAXWELL.ANNOUNCE_ATTACH_BUFF_OILFLOW = "I have a bad feeling in my stomach."
-- S___WATHGRITHR.ANNOUNCE_ATTACH_BUFF_OILFLOW = ""
S_______WEBBER.ANNOUNCE_ATTACH_BUFF_OILFLOW = "Stomach is going to cry, but we can't cry."
-- S_______WINONA.ANNOUNCE_ATTACH_BUFF_OILFLOW = ""
S_______WORTOX.ANNOUNCE_ATTACH_BUFF_OILFLOW = "A self mischief is coming."
S_____WORMWOOD.ANNOUNCE_ATTACH_BUFF_OILFLOW = "Come on!"
S________WARLY.ANNOUNCE_ATTACH_BUFF_OILFLOW = "Is that how curious I am?"
-- S_________WURT.ANNOUNCE_ATTACH_BUFF_OILFLOW = ""
S_______WALTER.ANNOUNCE_ATTACH_BUFF_OILFLOW = "Walter has to be adventurous."
S________WANDA.ANNOUNCE_ATTACH_BUFF_OILFLOW = "There is no going back!"
--
S______GENERIC.ANNOUNCE_DETACH_BUFF_OILFLOW = "Oh, finally, now I just want to find a hole to hide in."
S_______WILLOW.ANNOUNCE_DETACH_BUFF_OILFLOW = "I don't want to talk to anyone right now!"
S_____WOLFGANG.ANNOUNCE_DETACH_BUFF_OILFLOW = "Wolfgang is finished."
S________WENDY.ANNOUNCE_DETACH_BUFF_OILFLOW = "Do you think this will happen to me?"
S_________WX78.ANNOUNCE_DETACH_BUFF_OILFLOW = "FUEL SYSTEM HAS BEEN REPAIRED."
S_WICKERBOTTOM.ANNOUNCE_DETACH_BUFF_OILFLOW = "Fortunately, no one saw it. There's no shame."
S_______WOODIE.ANNOUNCE_DETACH_BUFF_OILFLOW = "It should be used. We can't waste it."
S______WAXWELL.ANNOUNCE_DETACH_BUFF_OILFLOW = "Where is my dignity?!"
S___WATHGRITHR.ANNOUNCE_DETACH_BUFF_OILFLOW = "This has nothing to do with the glory of fighter."
S_______WEBBER.ANNOUNCE_DETACH_BUFF_OILFLOW = "Oh, that's too bad. I'll be scolded by mom."
S_______WINONA.ANNOUNCE_DETACH_BUFF_OILFLOW = "It's over. There's a lot to clean up."
S_______WORTOX.ANNOUNCE_DETACH_BUFF_OILFLOW = "Amazing, I feel like my soul was about to be pulled out."
S_____WORMWOOD.ANNOUNCE_DETACH_BUFF_OILFLOW = "A wonderful experience."
S________WARLY.ANNOUNCE_DETACH_BUFF_OILFLOW = "Curiosity killed the cat."
S_________WURT.ANNOUNCE_DETACH_BUFF_OILFLOW = "So funny, I used to have beefalos that did this."
S_______WALTER.ANNOUNCE_DETACH_BUFF_OILFLOW = "This will be a stain on my life."
S________WANDA.ANNOUNCE_DETACH_BUFF_OILFLOW = "I regret it, truely."
--
S______GENERIC.BUFF_OILFLOW = {
    "OMG...", "...", "... ...", "......", "This is embarrassing.", "Don't look at me.", "Oh, no!",
    "When does it stop?", "Am I having a nightmare?", "Crazy...", "Stop!", "No...", "Where is the toilet?!",
    "I just want to die.", "No.", "Stop, stop, stop!", "This...", "I'm collapsing.", "No!", "...!",
    "I'm so sorry.", "Sorry...", "Sorry!", "Ah...",
}
-- S_______WILLOW.BUFF_OILFLOW = ""
-- S_____WOLFGANG.BUFF_OILFLOW = ""
-- S________WENDY.BUFF_OILFLOW = ""
-- S_________WX78.BUFF_OILFLOW = ""
S_WICKERBOTTOM.BUFF_OILFLOW = {
    "I knew it.", "Something was wrong with that dish.", "Where's the bathroom.", "No!", "...!", "...", "... ...",
    "No...", "This...", "Don't look at me, don't look at me...", "Learn from my mistakes.", "I can't bear it.", "......",
    "I'm not old enough for this to be happening to me.", "Nature calls...", "Maybe we can look at this like medicine...", "I think I know why...",
    "Chill, lady!", "It's no big deal.", "Why do I have to suffer so much?", "This moment is devoid of elegance.",
}
-- S_______WOODIE.BUFF_OILFLOW = ""
S______WAXWELL.BUFF_OILFLOW = {
    "I knew it.", "Something was wrong with that food.", "There's no bathroom.", "No!", "...!", "...", "... ...",
    "No...", "This...", "Don't look at me, don't look at me...", "Learn from my mistakes.", "I can't bear it.", "......",
    "I'm not old enough for this to be happening to me.", "Nature calls...", "What can I do?!", "I think I know why...",
    "Calm down!", "It's no big deal.", "What a disgrace!", "Why do I have to suffer so much?",
    "This moment is devoid of class.",
}
-- S___WATHGRITHR.BUFF_OILFLOW = ""
-- S_______WEBBER.BUFF_OILFLOW = ""
-- S_______WINONA.BUFF_OILFLOW = ""
S_______WORTOX.BUFF_OILFLOW = {
    "Hello, little thing. Heh.", "Oh well.", "What are you looking at?!", "Hello!", "...!", "...", "... ...", "......",
    "No...", "This...", "Hi...", "Hmm.", "Well...", "Well.", "What a vulgar prank!", "Funny!",
    "Not funny at all.", "Haha, haha, so embarrassing.", "Embarrassing.", "Excuse me, where is the bathroom?",
    "Hmm...", "I'm doing good for the lawn.", "Hey! There's nothing.", "A careless person would be sad.",
    "I should slip away.", "Sorry...", "Go away! Haven't you seen a demon poop?",
}
S_____WORMWOOD.BUFF_OILFLOW = {
    "Strange.", "But it's good.", "Not bad for me.", "Can't stop?", "...", "... ...", "......", "Haha.", "This...",
    "Now my friends have something good.", "Great.", "I'm getting hungry.", "Ah...", "Not bad.", "Interesting.",
}
-- S________WARLY.BUFF_OILFLOW = ""
-- S_________WURT.BUFF_OILFLOW = ""
-- S_______WALTER.BUFF_OILFLOW = ""
-- S________WANDA.BUFF_OILFLOW = ""

S_NAMES.DISH_TOMAHAWKSTEAK = "Steak Tomahawk" --牛排战斧
STRINGS.UI.COOKBOOK.DISH_TOMAHAWKSTEAK = "Favorite axe of the king of one-upmanship"
S______GENERIC.DESCRIBE.DISH_TOMAHAWKSTEAK = {
    GENERIC = "Would anyone like a steak that was fried hard and brown?",
    CHOP = "Cut it down!",
    ATK = "Come and fight!",
}
S_______WILLOW.DESCRIBE.DISH_TOMAHAWKSTEAK = {
    GENERIC = "What kind of idiot wastes food to make such things!",
    CHOP = "Take my hits!",
    ATK = "One-on-one is the real deal!",
}
S_____WOLFGANG.DESCRIBE.DISH_TOMAHAWKSTEAK = {
    GENERIC = "It's not edible, unfortunately.",
    CHOP = "The force of Wolfgang's axe is great!",
    ATK = "Wolfgang is an undefeated one-on-one legend!",
}
-- S________WENDY.DESCRIBE.DISH_TOMAHAWKSTEAK = ""
-- S_________WX78.DESCRIBE.DISH_TOMAHAWKSTEAK = ""
S_WICKERBOTTOM.DESCRIBE.DISH_TOMAHAWKSTEAK = {
    GENERIC = "A special fragrance and perhaps a surprising function.",
    CHOP = "Just cut at the perfect angle.",
    ATK = "We can have a battle of wits!",
}
S_______WOODIE.DESCRIBE.DISH_TOMAHAWKSTEAK = {
    GENERIC = "Nature's favorite, meat-scented axe.",
    CHOP = "A treeless world is about to be reached.",
    ATK = "Other troublemakers leave me be!",
}
-- S______WAXWELL.DESCRIBE.DISH_TOMAHAWKSTEAK = ""
S___WATHGRITHR.DESCRIBE.DISH_TOMAHAWKSTEAK = {
    GENERIC = "I already expected the enemy to fight me with drooling mouths.",
    CHOP = "I am invincible, er, in terms of chopping.",
    ATK = "A showdown that's all about you and me!",
}
-- S_______WEBBER.DESCRIBE.DISH_TOMAHAWKSTEAK = ""
S_______WINONA.DESCRIBE.DISH_TOMAHAWKSTEAK = {
    GENERIC = "An axe that cannot be used as a gourmet food is not a good weapon.",
    CHOP = "Not bad for meat!",
    ATK = "How about a fair match?",
}
S_______WORTOX.DESCRIBE.DISH_TOMAHAWKSTEAK = {
    GENERIC = "The allure of food.",
    CHOP = "No matter how thick the trunk it will fall to my crispy axe!",
    ATK = "I have unilaterally issued a challenge to you!",
}
S_____WORMWOOD.DESCRIBE.DISH_TOMAHAWKSTEAK = {
    GENERIC = "Fragrance, ah no, bad bad!",
    CHOP = "Gently, without pain.",
    ATK = "Come, come, come!",
}
S________WARLY.DESCRIBE.DISH_TOMAHAWKSTEAK = {
    GENERIC = "A challenge to the natural taste buds.",
    CHOP = "As easy as chopping vegetables.",
    ATK = "Have you eaten? If not, eat my axe!",
}
-- S_________WURT.DESCRIBE.DISH_TOMAHAWKSTEAK = ""
-- S_______WALTER.DESCRIBE.DISH_TOMAHAWKSTEAK = ""
-- S________WANDA.DESCRIBE.DISH_TOMAHAWKSTEAK = ""

S_NAMES.DISH_LOVINGROSECAKE = "Loving Rose Shortcake" --倾心玫瑰酥
STRINGS.UI.COOKBOOK.DISH_LOVINGROSECAKE = "Build love with heart"
S______GENERIC.DESCRIBE.DISH_LOVINGROSECAKE = "Be sure to let someone I love taste it in person!"
S_______WILLOW.DESCRIBE.DISH_LOVINGROSECAKE = "Fire is not the only thing that gets me."
-- S_____WOLFGANG.DESCRIBE.DISH_LOVINGROSECAKE = ""
S________WENDY.DESCRIBE.DISH_LOVINGROSECAKE = "Inexplicable feelings, who will take it away?"
-- S_________WX78.DESCRIBE.DISH_LOVINGROSECAKE = ""
S_WICKERBOTTOM.DESCRIBE.DISH_LOVINGROSECAKE = "There is something to do, to love, to expect."
S_______WOODIE.DESCRIBE.DISH_LOVINGROSECAKE = "I would give it to Lucy, but she only eats wood."
S______WAXWELL.DESCRIBE.DISH_LOVINGROSECAKE = "A love trick for children."
-- S___WATHGRITHR.DESCRIBE.DISH_LOVINGROSECAKE = ""
S_______WEBBER.DESCRIBE.DISH_LOVINGROSECAKE = "It would be great to have someone play with me."
-- S_______WINONA.DESCRIBE.DISH_LOVINGROSECAKE = ""
S_______WORTOX.DESCRIBE.DISH_LOVINGROSECAKE = "Where there is love, theres always wishes."
S_____WORMWOOD.DESCRIBE.DISH_LOVINGROSECAKE = "I don't understand it, but it's delicious!"
S________WARLY.DESCRIBE.DISH_LOVINGROSECAKE = "It's better to share it with your lover rather than eat it yourself."
-- S_________WURT.DESCRIBE.DISH_LOVINGROSECAKE = ""
-- S_______WALTER.DESCRIBE.DISH_LOVINGROSECAKE = ""
S________WANDA.DESCRIBE.DISH_LOVINGROSECAKE = "I don't have the time so I can only enjoy myself."

--------------------------------------------------------------------------
--[[ the sacrifice of rain ]]--[[ 祈雨祭 ]]
--------------------------------------------------------------------------

S_NAMES.RAINDONATE = "Raindonate"    --雨蝇
S______GENERIC.DESCRIBE.RAINDONATE = {
    GENERIC = "Elders said that the killing of it would cause rain.",
    HELD = "Look, a blue winged insect!",
}
S_______WILLOW.DESCRIBE.RAINDONATE = {
    GENERIC = "A little bug named rain. I want to see if it can be ignited.",
    HELD = "Watching you curl up, I decided not to burn you.",
}
S_____WOLFGANG.DESCRIBE.RAINDONATE = {
    GENERIC = "Thin arms and legs. You must train like me!",
    HELD = "Eat more eggs and exercise your legs, little bug.",
}
S________WENDY.DESCRIBE.RAINDONATE = {
    GENERIC = "You're always in fields and ponds...",
    HELD = "I shouldn't have caught you, you always let me fall into sad memories.",
}
-- S_________WX78.DESCRIBE.RAINDONATE = ""
-- S_WICKERBOTTOM.DESCRIBE.RAINDONATE = ""
-- S_______WOODIE.DESCRIBE.RAINDONATE = ""
-- S______WAXWELL.DESCRIBE.RAINDONATE = ""
-- S___WATHGRITHR.DESCRIBE.RAINDONATE = ""
S_______WEBBER.DESCRIBE.RAINDONATE = {
    GENERIC = "Hey, fly to our hands!",
    HELD = "See! A piece of cake.",
}
-- S_______WINONA.DESCRIBE.RAINDONATE = ""
-- S_______WORTOX.DESCRIBE.RAINDONATE = ""
-- S_____WORMWOOD.DESCRIBE.RAINDONATE = ""
-- S________WARLY.DESCRIBE.RAINDONATE = ""
-- S_________WURT.DESCRIBE.RAINDONATE = ""
-- S_______WALTER.DESCRIBE.RAINDONATE = ""
S________WANDA.DESCRIBE.RAINDONATE = {
    GENERIC = "Don't fly away. I'm not interested in you.",
    HELD = "Let me take a moment to think about whether to let you go.",
}

S_NAMES.MONSTRAIN = "Monstrain"   --雨竹
S______GENERIC.DESCRIBE.MONSTRAIN = {
    SUMMER = "The water at the bottom fled.",
    WINTER = "The water at the bottom solidified.",
    GENERIC = "Careful! Don't touch the juice of it!",
    PICKED = "I'll just take a look.",
}
S_____WORMWOOD.DESCRIBE.MONSTRAIN = {
    SUMMER = "Hot! She's asleep.",
    WINTER = "Cold! She's asleep.",
    GENERIC = "Friend likes water very much.",
    PICKED = "Should I comfort her?",
}

S_NAMES.MONSTRAIN_WIZEN = "Monstrain Tuber" --雨竹块茎
S______GENERIC.DESCRIBE.MONSTRAIN_WIZEN = "Water, water, help!"
S_______WILLOW.DESCRIBE.MONSTRAIN_WIZEN = "More water? It's so troublesome. Just burn it."
-- S_____WOLFGANG.DESCRIBE.MONSTRAIN_WIZEN = ""
-- S________WENDY.DESCRIBE.MONSTRAIN_WIZEN = ""
S_________WX78.DESCRIBE.MONSTRAIN_WIZEN = "WATER IS NECESSARY FOR LIFE."
S_WICKERBOTTOM.DESCRIBE.MONSTRAIN_WIZEN = "This plant is extremely dependent on water."
S_______WOODIE.DESCRIBE.MONSTRAIN_WIZEN = "It's strange that it doesn't want poop."
-- S______WAXWELL.DESCRIBE.MONSTRAIN_WIZEN = ""
-- S___WATHGRITHR.DESCRIBE.MONSTRAIN_WIZEN = ""
S_______WEBBER.DESCRIBE.MONSTRAIN_WIZEN = "Water it!"
-- S_______WINONA.DESCRIBE.MONSTRAIN_WIZEN = ""
S_______WORTOX.DESCRIBE.MONSTRAIN_WIZEN = "If I don't water it, it will die in front of me."
S_____WORMWOOD.DESCRIBE.MONSTRAIN_WIZEN = "Water my friend right now!"
-- S________WARLY.DESCRIBE.MONSTRAIN_WIZEN = ""
-- S_________WURT.DESCRIBE.MONSTRAIN_WIZEN = ""
-- S_______WALTER.DESCRIBE.MONSTRAIN_WIZEN = ""
-- S________WANDA.DESCRIBE.MONSTRAIN_WIZEN = ""

S_NAMES.DUG_MONSTRAIN = "Monstrain Tuber" --雨竹块茎
S______GENERIC.DESCRIBE.DUG_MONSTRAIN = "So easy to dig? Why couldn't I dig it before?"
-- S_______WILLOW.DESCRIBE.DUG_MONSTRAIN = ""
S_____WOLFGANG.DESCRIBE.DUG_MONSTRAIN = "A poisonous taro. Wolfgang won't eat it."
-- S________WENDY.DESCRIBE.DUG_MONSTRAIN = ""
-- S_________WX78.DESCRIBE.DUG_MONSTRAIN = ""
S_WICKERBOTTOM.DESCRIBE.DUG_MONSTRAIN = "Look at the eggs at the root of it. It's a wonderful symbiosis."
-- S_______WOODIE.DESCRIBE.DUG_MONSTRAIN = ""
-- S______WAXWELL.DESCRIBE.DUG_MONSTRAIN = ""
-- S___WATHGRITHR.DESCRIBE.DUG_MONSTRAIN = ""
-- S_______WEBBER.DESCRIBE.DUG_MONSTRAIN = ""
-- S_______WINONA.DESCRIBE.DUG_MONSTRAIN = ""
S_______WORTOX.DESCRIBE.DUG_MONSTRAIN = "Toxic. Why do I know? I observed it from my friends."
S_____WORMWOOD.DESCRIBE.DUG_MONSTRAIN = "A water friend."
S________WARLY.DESCRIBE.DUG_MONSTRAIN = "Maybe I can make it into konjac."
-- S_________WURT.DESCRIBE.DUG_MONSTRAIN = ""
-- S_______WALTER.DESCRIBE.DUG_MONSTRAIN = ""
S________WANDA.DESCRIBE.DUG_MONSTRAIN = "I have seen many people poisoned by it."

S_NAMES.SQUAMOUSFRUIT = "Squamous Fruit"    --鳞果
S______GENERIC.DESCRIBE.SQUAMOUSFRUIT = "Wow, an edible pinecone."
-- S_______WILLOW.DESCRIBE.SQUAMOUSFRUIT = ""
-- S_____WOLFGANG.DESCRIBE.SQUAMOUSFRUIT = ""
-- S________WENDY.DESCRIBE.SQUAMOUSFRUIT = ""
-- S_________WX78.DESCRIBE.SQUAMOUSFRUIT = ""
-- S_WICKERBOTTOM.DESCRIBE.SQUAMOUSFRUIT = ""
S_______WOODIE.DESCRIBE.SQUAMOUSFRUIT = "A pinecone that can't grow up."
-- S______WAXWELL.DESCRIBE.SQUAMOUSFRUIT = ""
-- S___WATHGRITHR.DESCRIBE.SQUAMOUSFRUIT = ""
S_______WEBBER.DESCRIBE.SQUAMOUSFRUIT = "Wow, a pinecone with our favorite color."
-- S_______WINONA.DESCRIBE.SQUAMOUSFRUIT = ""
-- S_______WORTOX.DESCRIBE.SQUAMOUSFRUIT = ""
-- S_____WORMWOOD.DESCRIBE.SQUAMOUSFRUIT = ""
S________WARLY.DESCRIBE.SQUAMOUSFRUIT = "You wouldn't imagine that it can be eaten."
-- S_________WURT.DESCRIBE.SQUAMOUSFRUIT = ""
-- S_______WALTER.DESCRIBE.SQUAMOUSFRUIT = ""
-- S________WANDA.DESCRIBE.SQUAMOUSFRUIT = ""

S_NAMES.MONSTRAIN_LEAF = "Monstrain Leaf"    --雨竹叶
S______GENERIC.DESCRIBE.MONSTRAIN_LEAF = "When I eat it, it eats me."
-- S_______WILLOW.DESCRIBE.MONSTRAIN_LEAF = ""
S_____WOLFGANG.DESCRIBE.MONSTRAIN_LEAF = "Wolfgang doesn't eat strange leaves."
-- S________WENDY.DESCRIBE.MONSTRAIN_LEAF = ""
-- S_________WX78.DESCRIBE.MONSTRAIN_LEAF = ""
S_WICKERBOTTOM.DESCRIBE.MONSTRAIN_LEAF = "High temperature heating can eliminate its toxicity."
-- S_______WOODIE.DESCRIBE.MONSTRAIN_LEAF = ""
-- S______WAXWELL.DESCRIBE.MONSTRAIN_LEAF = ""
-- S___WATHGRITHR.DESCRIBE.MONSTRAIN_LEAF = ""
-- S_______WEBBER.DESCRIBE.MONSTRAIN_LEAF = ""
-- S_______WINONA.DESCRIBE.MONSTRAIN_LEAF = ""
-- S_______WORTOX.DESCRIBE.MONSTRAIN_LEAF = ""
-- S_____WORMWOOD.DESCRIBE.MONSTRAIN_LEAF = ""
S________WARLY.DESCRIBE.MONSTRAIN_LEAF = "More cooking can eliminate the toxicity."
S_________WURT.DESCRIBE.MONSTRAIN_LEAF = "The books lady told me not to eat it, but it smells delicious."
-- S_______WALTER.DESCRIBE.MONSTRAIN_LEAF = ""
-- S________WANDA.DESCRIBE.MONSTRAIN_LEAF = ""

S_NAMES.BOOK_WEATHER = "Changing Clouds"    --多变的云
S_RECIPE_DESC.BOOK_WEATHER = "Stir the clouds with your heart."
S______GENERIC.DESCRIBE.BOOK_WEATHER = "When clouds cover the sun... when sunlight penetrates the clouds..."
--S_______WILLOW.DESCRIBE.BOOK_WEATHER = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.BOOK_WEATHER = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.BOOK_WEATHER = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.BOOK_WEATHER = "STICK ADDON INSTALLED"
S_WICKERBOTTOM.DESCRIBE.BOOK_WEATHER = "Well, I can forecast the weather correctly now."
--S_______WOODIE.DESCRIBE.BOOK_WEATHER = "I'd prefer maple taffy..."
S______WAXWELL.DESCRIBE.BOOK_WEATHER = "Hm... I can forecast the weather correctly now."
--S___WATHGRITHR.DESCRIBE.BOOK_WEATHER = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.BOOK_WEATHER = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.BOOK_WEATHER = "Great to cool off after some hard physical labor."
--
S______GENERIC.ANNOUNCE_READ_BOOK.BOOK_WEATHER = "Wait, isn't it just Wurt who reads?"
-- S_______WILLOW.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- S_____WOLFGANG.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- S________WENDY.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- S_________WX78.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- S_WICKERBOTTOM.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- S_______WOODIE.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- S______WAXWELL.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- S___WATHGRITHR.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- S_______WEBBER.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- S_______WINONA.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- S_______WORTOX.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- S_____WORMWOOD.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
-- S________WARLY.ANNOUNCE_READ_BOOK.BOOK_WEATHER = ""
S_________WURT.ANNOUNCE_READ_BOOK.BOOK_WEATHER_SUNNY = "Arid, dry, waterless, blablabla..."
S_________WURT.ANNOUNCE_READ_BOOK.BOOK_WEATHER_RAINY = "Drizzle, sprinkle, downpour, that's sweet."

S_NAMES.MERM_SCALES = "Drippy Scales"  --鱼鳞
S______GENERIC.DESCRIBE.MERM_SCALES = "Ewwwwwwww, such smell a strong fish smell."
--S_______WILLOW.DESCRIBE.MERM_SCALES = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.MERM_SCALES = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.MERM_SCALES = "Contrary to Ms Squid's magic."
--S_________WX78.DESCRIBE.MERM_SCALES = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.MERM_SCALES = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.MERM_SCALES = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.MERM_SCALES = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.MERM_SCALES = "I've somehow found a way to make it even LESS appealing!"
S_______WEBBER.DESCRIBE.MERM_SCALES = "And how about the one with the drippy nose?"
--S_______WINONA.DESCRIBE.MERM_SCALES = "Great to cool off after some hard physical labor."

S_NAMES.HAT_MERMBREATHING = "Breathing Gills"  --鱼之息
S_RECIPE_DESC.HAT_MERMBREATHING = "Breathing like a merm."
S______GENERIC.DESCRIBE.HAT_MERMBREATHING = "I hope I won't jump into the sea and disappear."
--S_______WILLOW.DESCRIBE.HAT_MERMBREATHING = ""
--S_____WOLFGANG.DESCRIBE.HAT_MERMBREATHING = ""
S________WENDY.DESCRIBE.HAT_MERMBREATHING = "Contrary to Ms Squid's magic."
--S_________WX78.DESCRIBE.HAT_MERMBREATHING = ""
--S_WICKERBOTTOM.DESCRIBE.HAT_MERMBREATHING = ""
--S_______WOODIE.DESCRIBE.HAT_MERMBREATHING = ""
--S______WAXWELL.DESCRIBE.HAT_MERMBREATHING = ""
--S___WATHGRITHR.DESCRIBE.HAT_MERMBREATHING = ""
S_______WEBBER.DESCRIBE.HAT_MERMBREATHING = "I can swim freely! er... nevermind I need a fish tail."
--S_______WINONA.DESCRIBE.HAT_MERMBREATHING = ""

S_NAMES.AGRONSSWORD = "Agron's Sword"  --艾力冈的剑
S______GENERIC.DESCRIBE.AGRONSSWORD = "I'll fight to be a free man!"
S_______WILLOW.DESCRIBE.AGRONSSWORD = "A single faith can start a freedom fire."
S_____WOLFGANG.DESCRIBE.AGRONSSWORD = "It fills Wolfgang with courage!"
S________WENDY.DESCRIBE.AGRONSSWORD = "If I leave here, Abigail will leave me."
S_________WX78.DESCRIBE.AGRONSSWORD = "YEARN FOR HUMAN NATURE BUT... FEAR TO POSSESS IT."
S_WICKERBOTTOM.DESCRIBE.AGRONSSWORD = "Do not shed tears."
S_______WOODIE.DESCRIBE.AGRONSSWORD = "Lucy comforts me, so I believe I can escape from here one day."
S______WAXWELL.DESCRIBE.AGRONSSWORD = "There is no greater victory than to fall from this world as a free man."
S___WATHGRITHR.DESCRIBE.AGRONSSWORD = "When the Bringer of Rain died, even Valhalla was moved."
S_______WEBBER.DESCRIBE.AGRONSSWORD = "If I could, I would be out of this world with my legion!"
S_______WINONA.DESCRIBE.AGRONSSWORD = "I am a laborer, not a slave, I'm my own!"

S_NAMES.GIANTSFOOT = "Giant's Foot"  --巨人之脚
S_RECIPE_DESC.GIANTSFOOT = "Let giants rule your stuff."
S______GENERIC.DESCRIBE.GIANTSFOOT = "Giants stand on the shoulders of me."
--S_______WILLOW.DESCRIBE.GIANTSFOOT = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.GIANTSFOOT = "Wolfgang can eat in one bite!"
S________WENDY.DESCRIBE.GIANTSFOOT = "Er... Have I seen it somewhere?"
--S_________WX78.DESCRIBE.GIANTSFOOT = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.GIANTSFOOT = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.GIANTSFOOT = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.GIANTSFOOT = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.GIANTSFOOT = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.GIANTSFOOT = "I can swim freely! er... need a fish tail."
--S_______WINONA.DESCRIBE.GIANTSFOOT = "Great to cool off after some hard physical labor."

S_NAMES.REFRACTEDMOONLIGHT = "Refracted Moonlight"  --月折宝剑
S______GENERIC.DESCRIBE.REFRACTEDMOONLIGHT = "Oh my glob! A powerful sword from the Land of Ooo?"
-- S_______WILLOW.DESCRIBE.REFRACTEDMOONLIGHT = ""
-- S_____WOLFGANG.DESCRIBE.REFRACTEDMOONLIGHT = ""
S________WENDY.DESCRIBE.REFRACTEDMOONLIGHT = "No amount of power can save the past."
-- S_________WX78.DESCRIBE.REFRACTEDMOONLIGHT = ""
S_WICKERBOTTOM.DESCRIBE.REFRACTEDMOONLIGHT = "Only a person of integrity can control its power."
-- S_______WOODIE.DESCRIBE.REFRACTEDMOONLIGHT = ""
S______WAXWELL.DESCRIBE.REFRACTEDMOONLIGHT = "Only those who are healthy can wield its power."
-- S___WATHGRITHR.DESCRIBE.REFRACTEDMOONLIGHT = ""
S_______WEBBER.DESCRIBE.REFRACTEDMOONLIGHT = "Do aliens also use such simple weapons?"
S_______WINONA.DESCRIBE.REFRACTEDMOONLIGHT = "A treasure on the moon?"
-- S_______WORTOX.DESCRIBE.REFRACTEDMOONLIGHT = ""
S_____WORMWOOD.DESCRIBE.REFRACTEDMOONLIGHT = "Big sword!"
S________WARLY.DESCRIBE.REFRACTEDMOONLIGHT = "Have you eaten? Eat my sword!"
-- S_________WURT.DESCRIBE.REFRACTEDMOONLIGHT = ""
-- S_______WALTER.DESCRIBE.REFRACTEDMOONLIGHT = ""
-- S________WANDA.DESCRIBE.REFRACTEDMOONLIGHT = ""

S_NAMES.MOONDUNGEON = "Moon Oubliette" --月的地下城
S______GENERIC.DESCRIBE.MOONDUNGEON = {
    SLEEP = "Is that a fossilized... fossil?",
    GENERIC = "Someone burned up their whole life and built it into this."
}
S_______WILLOW.DESCRIBE.MOONDUNGEON = {
    SLEEP = "Open the door! I know there's something in it!",
    GENERIC = "Fire attack doesn't work here."
}
S______WAXWELL.DESCRIBE.MOONDUNGEON = {
    SLEEP = "The old shadow King arrived, why did no one go out to greet him?!",
    GENERIC = "I didn't recognize it as a trap castle."
}
S___WATHGRITHR.DESCRIBE.MOONDUNGEON = {
    SLEEP = "An old palace.",
    GENERIC = "It's totally different from the palace style of Pandia."
}

S_NAMES.HIDDENMOONLIGHT = "Hidden Moonlight" --月藏宝匣
S______GENERIC.DESCRIBE.HIDDENMOONLIGHT = "As empty as the Milky way."
-- S_______WILLOW.DESCRIBE.HIDDENMOONLIGHT = ""
S_____WOLFGANG.DESCRIBE.HIDDENMOONLIGHT = "Look! There are stars blinking at Wolfgang."
S________WENDY.DESCRIBE.HIDDENMOONLIGHT = "Light moonlight, somewhere in my heart."
-- S_________WX78.DESCRIBE.HIDDENMOONLIGHT = ""
S_WICKERBOTTOM.DESCRIBE.HIDDENMOONLIGHT = "The flow of time in this box is slower than on the outside."
-- S_______WOODIE.DESCRIBE.HIDDENMOONLIGHT = ""
S______WAXWELL.DESCRIBE.HIDDENMOONLIGHT = "Such a waste to use it like that."
-- S___WATHGRITHR.DESCRIBE.HIDDENMOONLIGHT = ""
S_______WEBBER.DESCRIBE.HIDDENMOONLIGHT = "Yeah! Reach in and grab anything you want."
-- S_______WINONA.DESCRIBE.HIDDENMOONLIGHT = ""
-- S_______WORTOX.DESCRIBE.HIDDENMOONLIGHT = ""
S_____WORMWOOD.DESCRIBE.HIDDENMOONLIGHT = "Hollow, like me."
S________WARLY.DESCRIBE.HIDDENMOONLIGHT = "Save my ingredients better!"
S_________WURT.DESCRIBE.HIDDENMOONLIGHT = "Why is there no sound of waves coming out, florp?"
-- S_______WALTER.DESCRIBE.HIDDENMOONLIGHT = ""
S________WANDA.DESCRIBE.HIDDENMOONLIGHT = "I won't bring yesterday's food to today."

S_NAMES.HIDDENMOONLIGHT_ITEM = "Hidden Moonlight Kit" --月藏宝匣套件
S_RECIPE_DESC.HIDDENMOONLIGHT_ITEM = "Hiding dainties between moon and stars."
S______GENERIC.DESCRIBE.HIDDENMOONLIGHT_ITEM = "Seems to be an upgrade kit for food storage."
-- S_______WILLOW.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
S_____WOLFGANG.DESCRIBE.HIDDENMOONLIGHT_ITEM = "Was this also a secret fridge in ancient times?"
-- S________WENDY.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
-- S_________WX78.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
-- S_WICKERBOTTOM.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
-- S_______WOODIE.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
S______WAXWELL.DESCRIBE.HIDDENMOONLIGHT_ITEM = "A box powered by moonlight."
S___WATHGRITHR.DESCRIBE.HIDDENMOONLIGHT_ITEM = "Hope it's not Pandora's box."
-- S_______WEBBER.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
S_______WINONA.DESCRIBE.HIDDENMOONLIGHT_ITEM = "The inspiration of moon!"
S_______WORTOX.DESCRIBE.HIDDENMOONLIGHT_ITEM = "I can feel it calling for food."
-- S_____WORMWOOD.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
S________WARLY.DESCRIBE.HIDDENMOONLIGHT_ITEM = "Great, I'm still short of this."
-- S_________WURT.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
-- S_______WALTER.DESCRIBE.HIDDENMOONLIGHT_ITEM = ""
S________WANDA.DESCRIBE.HIDDENMOONLIGHT_ITEM = "Its function is just ordinary to me."

S_NAMES.REVOLVEDMOONLIGHT = "Revolved Moonlight" --月轮宝盘
S______GENERIC.DESCRIBE.REVOLVEDMOONLIGHT = "The inside is as soft as the moonlight."
-- S_______WILLOW.DESCRIBE.REVOLVEDMOONLIGHT = ""
S_____WOLFGANG.DESCRIBE.REVOLVEDMOONLIGHT = "Nevermind, I figured it out."
S________WENDY.DESCRIBE.REVOLVEDMOONLIGHT = "Soft moonlight, no trace of temperature."
-- S_________WX78.DESCRIBE.REVOLVEDMOONLIGHT = ""
S_WICKERBOTTOM.DESCRIBE.REVOLVEDMOONLIGHT = "Add more yellow gems and you can use it as a night light."
-- S_______WOODIE.DESCRIBE.REVOLVEDMOONLIGHT = ""
S______WAXWELL.DESCRIBE.REVOLVEDMOONLIGHT = "What a waste of Moonlight."
-- S___WATHGRITHR.DESCRIBE.REVOLVEDMOONLIGHT = ""
S_______WEBBER.DESCRIBE.REVOLVEDMOONLIGHT = "Beautiful shiny little toy!"
S_______WINONA.DESCRIBE.REVOLVEDMOONLIGHT = "It can also be loaded with yellow gems to improve it's brightness."
-- S_______WORTOX.DESCRIBE.REVOLVEDMOONLIGHT = ""
-- S_____WORMWOOD.DESCRIBE.REVOLVEDMOONLIGHT = ""
-- S________WARLY.DESCRIBE.REVOLVEDMOONLIGHT = ""
-- S_________WURT.DESCRIBE.REVOLVEDMOONLIGHT = ""
S_______WALTER.DESCRIBE.REVOLVEDMOONLIGHT = "Shining like a badge."
S________WANDA.DESCRIBE.REVOLVEDMOONLIGHT = "It's really a waste of moon magic to do this."

S_NAMES.REVOLVEDMOONLIGHT_ITEM = "Revolved Moonlight Kit" --月轮宝盘套件
S_RECIPE_DESC.REVOLVEDMOONLIGHT_ITEM = "Moon and shadow revolve and the afterglow leaks."
S______GENERIC.DESCRIBE.REVOLVEDMOONLIGHT_ITEM = "Seems to be an upgrade kit for certain backpacks."
-- S_______WILLOW.DESCRIBE.REVOLVEDMOONLIGHT_ITEM = ""
S_____WOLFGANG.DESCRIBE.REVOLVEDMOONLIGHT_ITEM = "Can anyone tell Wolfgang how to use it?"
-- S________WENDY.DESCRIBE.REVOLVEDMOONLIGHT_ITEM = ""
S_________WX78.DESCRIBE.REVOLVEDMOONLIGHT_ITEM = "BACKPACK UPDATER."
S_WICKERBOTTOM.DESCRIBE.REVOLVEDMOONLIGHT_ITEM = "It fits perfectly with some backpacks."
-- S_______WOODIE.DESCRIBE.REVOLVEDMOONLIGHT_ITEM = ""
S______WAXWELL.DESCRIBE.REVOLVEDMOONLIGHT_ITEM = "I don't want to judge this stuff anymore."
-- S___WATHGRITHR.DESCRIBE.REVOLVEDMOONLIGHT_ITEM = ""
S_______WEBBER.DESCRIBE.REVOLVEDMOONLIGHT_ITEM = "It should be able to shine."
S_______WINONA.DESCRIBE.REVOLVEDMOONLIGHT_ITEM = "Based on my experience, It is for certain backpacks."
-- S_______WORTOX.DESCRIBE.REVOLVEDMOONLIGHT_ITEM = ""
-- S_____WORMWOOD.DESCRIBE.REVOLVEDMOONLIGHT_ITEM = ""
-- S________WARLY.DESCRIBE.REVOLVEDMOONLIGHT_ITEM = ""
-- S_________WURT.DESCRIBE.REVOLVEDMOONLIGHT_ITEM = ""
S_______WALTER.DESCRIBE.REVOLVEDMOONLIGHT_ITEM = "Maybe I can use it to play Frisbee game with Woby."
-- S________WANDA.DESCRIBE.REVOLVEDMOONLIGHT_ITEM = ""

--------------------------------------------------------------------------
--[[ legends of the fall ]]--[[ 丰饶传说 ]]
--------------------------------------------------------------------------

S_NAMES.PINEANANAS = "Pineananas"    --松萝
S______GENERIC.DESCRIBE.PINEANANAS = "Eating it raw may numb my mouth."
-- S_______WILLOW.DESCRIBE.PINEANANAS = ""
-- S_____WOLFGANG.DESCRIBE.PINEANANAS = ""
-- S________WENDY.DESCRIBE.PINEANANAS = ""
-- S_________WX78.DESCRIBE.PINEANANAS = ""
-- S_WICKERBOTTOM.DESCRIBE.PINEANANAS = ""
-- S_______WOODIE.DESCRIBE.PINEANANAS = ""
-- S______WAXWELL.DESCRIBE.PINEANANAS = ""
-- S___WATHGRITHR.DESCRIBE.PINEANANAS = ""
-- S_______WEBBER.DESCRIBE.PINEANANAS = ""
-- S_______WINONA.DESCRIBE.PINEANANAS = ""
-- S_______WORTOX.DESCRIBE.PINEANANAS = ""
-- S_____WORMWOOD.DESCRIBE.PINEANANAS = ""
-- S________WARLY.DESCRIBE.PINEANANAS = ""
-- S_________WURT.DESCRIBE.PINEANANAS = ""
-- S_______WALTER.DESCRIBE.PINEANANAS = ""

S_NAMES.PINEANANAS_COOKED = "Roasted Pineananas"    --烤松萝
S______GENERIC.DESCRIBE.PINEANANAS_COOKED = "It tastes much better after roasted."
-- S_______WILLOW.DESCRIBE.PINEANANAS_COOKED = ""
-- S_____WOLFGANG.DESCRIBE.PINEANANAS_COOKED = ""
-- S________WENDY.DESCRIBE.PINEANANAS_COOKED = ""
-- S_________WX78.DESCRIBE.PINEANANAS_COOKED = ""
-- S_WICKERBOTTOM.DESCRIBE.PINEANANAS_COOKED = ""
-- S_______WOODIE.DESCRIBE.PINEANANAS_COOKED = ""
-- S______WAXWELL.DESCRIBE.PINEANANAS_COOKED = ""
-- S___WATHGRITHR.DESCRIBE.PINEANANAS_COOKED = ""
-- S_______WEBBER.DESCRIBE.PINEANANAS_COOKED = ""
-- S_______WINONA.DESCRIBE.PINEANANAS_COOKED = ""
-- S_______WORTOX.DESCRIBE.PINEANANAS_COOKED = ""
-- S_____WORMWOOD.DESCRIBE.PINEANANAS_COOKED = ""
-- S________WARLY.DESCRIBE.PINEANANAS_COOKED = ""
-- S_________WURT.DESCRIBE.PINEANANAS_COOKED = ""
-- S_______WALTER.DESCRIBE.PINEANANAS_COOKED = ""

S_NAMES.PINEANANAS_SEEDS = "Chimeric Seeds"    --嵌合种子
S______GENERIC.DESCRIBE.PINEANANAS_SEEDS = "I'm not sure if it should be a pinecone or pineapple seed."
-- S_______WILLOW.DESCRIBE.PINEANANAS_SEEDS = ""
-- S_____WOLFGANG.DESCRIBE.PINEANANAS_SEEDS = ""
-- S________WENDY.DESCRIBE.PINEANANAS_SEEDS = ""
-- S_________WX78.DESCRIBE.PINEANANAS_SEEDS = ""
-- S_WICKERBOTTOM.DESCRIBE.PINEANANAS_SEEDS = ""
-- S_______WOODIE.DESCRIBE.PINEANANAS_SEEDS = ""
-- S______WAXWELL.DESCRIBE.PINEANANAS_SEEDS = ""
-- S___WATHGRITHR.DESCRIBE.PINEANANAS_SEEDS = ""
-- S_______WEBBER.DESCRIBE.PINEANANAS_SEEDS = ""
-- S_______WINONA.DESCRIBE.PINEANANAS_SEEDS = ""
-- S_______WORTOX.DESCRIBE.PINEANANAS_SEEDS = ""
-- S_____WORMWOOD.DESCRIBE.PINEANANAS_SEEDS = ""
-- S________WARLY.DESCRIBE.PINEANANAS_SEEDS = ""
-- S_________WURT.DESCRIBE.PINEANANAS_SEEDS = ""
-- S_______WALTER.DESCRIBE.PINEANANAS_SEEDS = ""

S_NAMES.PINEANANAS_OVERSIZED = "Giant Pineananas"
S______GENERIC.DESCRIBE.PINEANANAS_OVERSIZED = "What a big orange pinecone!"
-- S_______WILLOW.DESCRIBE.PINEANANAS_OVERSIZED = ""
-- S_____WOLFGANG.DESCRIBE.PINEANANAS_OVERSIZED = ""
-- S________WENDY.DESCRIBE.PINEANANAS_OVERSIZED = ""
-- S_________WX78.DESCRIBE.PINEANANAS_OVERSIZED = ""
-- S_WICKERBOTTOM.DESCRIBE.PINEANANAS_OVERSIZED = ""
-- S_______WOODIE.DESCRIBE.PINEANANAS_OVERSIZED = ""
-- S______WAXWELL.DESCRIBE.PINEANANAS_OVERSIZED = ""
-- S___WATHGRITHR.DESCRIBE.PINEANANAS_OVERSIZED = ""
-- S_______WEBBER.DESCRIBE.PINEANANAS_OVERSIZED = ""
-- S_______WINONA.DESCRIBE.PINEANANAS_OVERSIZED = ""
-- S_______WORTOX.DESCRIBE.PINEANANAS_OVERSIZED = ""
-- S_____WORMWOOD.DESCRIBE.PINEANANAS_OVERSIZED = ""
S________WARLY.DESCRIBE.PINEANANAS_OVERSIZED = "I think of many sweet memori... err, dishes!"
-- S_________WURT.DESCRIBE.PINEANANAS_OVERSIZED = ""
-- S_______WALTER.DESCRIBE.PINEANANAS_OVERSIZED = ""

S_NAMES.PINEANANAS_OVERSIZED_ROTTEN = "Giant Rotting Pineananas"
S_NAMES.FARM_PLANT_PINEANANAS = "Pineananas Tree"
S_NAMES.KNOWN_PINEANANAS_SEEDS = "Pineananas Seeds"
STRINGS.UI.PLANTREGISTRY.DESCRIPTIONS.PINEANANAS = "A straight foot is not afraid of a crooked shoe. -W"

-----

S_NAMES.CROPGNAT = "Pest Swarm"    --植害虫群
S______GENERIC.DESCRIBE.CROPGNAT = "Hey, stay away from my crops, you pests!"
S_______WILLOW.DESCRIBE.CROPGNAT = "Do they like fire, too?"
S_____WOLFGANG.DESCRIBE.CROPGNAT = "Fortunately, they don't bite Wolfgang."
-- S________WENDY.DESCRIBE.CROPGNAT = ""
-- S_________WX78.DESCRIBE.CROPGNAT = ""
S_WICKERBOTTOM.DESCRIBE.CROPGNAT = "Find ways to kill them early, or we'll get nothing!"
-- S_______WOODIE.DESCRIBE.CROPGNAT = ""
-- S______WAXWELL.DESCRIBE.CROPGNAT = ""
-- S___WATHGRITHR.DESCRIBE.CROPGNAT = ""
S_______WEBBER.DESCRIBE.CROPGNAT = "I broke my neighbours neighbor's window before and they called me a pest."
-- S_______WINONA.DESCRIBE.CROPGNAT = ""
-- S_______WORTOX.DESCRIBE.CROPGNAT = ""
S_____WORMWOOD.DESCRIBE.CROPGNAT = "Some friends who would hurt a plant friend."
-- S________WARLY.DESCRIBE.CROPGNAT = ""
-- S_________WURT.DESCRIBE.CROPGNAT = ""
-- S_______WALTER.DESCRIBE.CROPGNAT = ""
-- S________WANDA.DESCRIBE.CROPGNAT = ""

S_NAMES.CROPGNAT_INFESTER = "Gnat Swarm"    --叮咬虫群
S______GENERIC.DESCRIBE.CROPGNAT_INFESTER = "Be careful, these bugs bite."
S_______WILLOW.DESCRIBE.CROPGNAT_INFESTER = "Stupid bugs will be attracted by my fire."
S_____WOLFGANG.DESCRIBE.CROPGNAT_INFESTER = "Ouch! these little monsters bite!"
-- S________WENDY.DESCRIBE.CROPGNAT_INFESTER = ""
S_________WX78.DESCRIBE.CROPGNAT_INFESTER = "THEY EVEN BITE IRON?"
S_WICKERBOTTOM.DESCRIBE.CROPGNAT_INFESTER = "Aggressive and can be attracted by light."
-- S_______WOODIE.DESCRIBE.CROPGNAT_INFESTER = ""
-- S______WAXWELL.DESCRIBE.CROPGNAT_INFESTER = ""
-- S___WATHGRITHR.DESCRIBE.CROPGNAT_INFESTER = ""
-- S_______WEBBER.DESCRIBE.CROPGNAT_INFESTER = ""
S_______WINONA.DESCRIBE.CROPGNAT_INFESTER = "Oh my, the noise is terrible."
S_______WORTOX.DESCRIBE.CROPGNAT_INFESTER = "Hah, you have to get used to this in the wild."
S_____WORMWOOD.DESCRIBE.CROPGNAT_INFESTER = "Some friends who would bite a friend."
-- S________WARLY.DESCRIBE.CROPGNAT_INFESTER = ""
-- S_________WURT.DESCRIBE.CROPGNAT_INFESTER = ""
-- S_______WALTER.DESCRIBE.CROPGNAT_INFESTER = ""
-- S________WANDA.DESCRIBE.CROPGNAT_INFESTER = ""

S_NAMES.AHANDFULOFWINGS = "Broken Insect Wings" --虫翅碎片
S______GENERIC.DESCRIBE.AHANDFULOFWINGS = "I wonder what kind of bug wings these are."
S_______WILLOW.DESCRIBE.AHANDFULOFWINGS = "Cruel and disgusting."
-- S_____WOLFGANG.DESCRIBE.AHANDFULOFWINGS = ""
-- S________WENDY.DESCRIBE.AHANDFULOFWINGS = ""
S_________WX78.DESCRIBE.AHANDFULOFWINGS = "THE WING PART OF SOME INSECT'S REMAINS."
S_WICKERBOTTOM.DESCRIBE.AHANDFULOFWINGS = "Why pull the wings of insects off?"
-- S_______WOODIE.DESCRIBE.AHANDFULOFWINGS = ""
-- S______WAXWELL.DESCRIBE.AHANDFULOFWINGS = ""
S___WATHGRITHR.DESCRIBE.AHANDFULOFWINGS = "It's easy to sort them out."
-- S_______WEBBER.DESCRIBE.AHANDFULOFWINGS = ""
-- S_______WINONA.DESCRIBE.AHANDFULOFWINGS = ""
S_______WORTOX.DESCRIBE.AHANDFULOFWINGS = "Even these little ones have souls."
-- S_____WORMWOOD.DESCRIBE.AHANDFULOFWINGS = ""
-- S________WARLY.DESCRIBE.AHANDFULOFWINGS = ""
-- S_________WURT.DESCRIBE.AHANDFULOFWINGS = ""
-- S_______WALTER.DESCRIBE.AHANDFULOFWINGS = ""
-- S________WANDA.DESCRIBE.AHANDFULOFWINGS = ""

S_NAMES.INSECTSHELL_L = "Broken Insect Shells" --虫甲碎片
S______GENERIC.DESCRIBE.INSECTSHELL_L = "I wonder what kind of bug shells these are."
-- S_______WILLOW.DESCRIBE.INSECTSHELL_L = ""
-- S_____WOLFGANG.DESCRIBE.INSECTSHELL_L = ""
-- S________WENDY.DESCRIBE.INSECTSHELL_L = ""
S_________WX78.DESCRIBE.INSECTSHELL_L = "THE EXOSKELETON OF SOME INSECT'S REMAINS."
S_WICKERBOTTOM.DESCRIBE.INSECTSHELL_L = "Why collect insect shells separately?"
-- S_______WOODIE.DESCRIBE.INSECTSHELL_L = ""
-- S______WAXWELL.DESCRIBE.INSECTSHELL_L = ""
S___WATHGRITHR.DESCRIBE.INSECTSHELL_L = "It's easy to sort them out."
-- S_______WEBBER.DESCRIBE.INSECTSHELL_L = ""
-- S_______WINONA.DESCRIBE.INSECTSHELL_L = ""
S_______WORTOX.DESCRIBE.INSECTSHELL_L = "Even these small ones have souls."
-- S_____WORMWOOD.DESCRIBE.INSECTSHELL_L = ""
-- S________WARLY.DESCRIBE.INSECTSHELL_L = ""
-- S_________WURT.DESCRIBE.INSECTSHELL_L = ""
-- S_______WALTER.DESCRIBE.INSECTSHELL_L = ""
-- S________WANDA.DESCRIBE.INSECTSHELL_L = ""

S_NAMES.BOLTWINGOUT = "Boltwing-out"    --脱壳之翅
S_RECIPE_DESC.BOLTWINGOUT = "Make a bolt for it."
S______GENERIC.DESCRIBE.BOLTWINGOUT = "Bolt out of threats."
-- S_______WILLOW.DESCRIBE.BOLTWINGOUT = ""
-- S_____WOLFGANG.DESCRIBE.BOLTWINGOUT = ""
-- S________WENDY.DESCRIBE.BOLTWINGOUT = ""
-- S_________WX78.DESCRIBE.BOLTWINGOUT = ""
-- S_WICKERBOTTOM.DESCRIBE.BOLTWINGOUT = ""
-- S_______WOODIE.DESCRIBE.BOLTWINGOUT = ""
S______WAXWELL.DESCRIBE.BOLTWINGOUT = "Learning the way of insect survival."
S___WATHGRITHR.DESCRIBE.BOLTWINGOUT = "Tsk-tsk! A real warrior never runs away!"
-- S_______WEBBER.DESCRIBE.BOLTWINGOUT = ""
S_______WINONA.DESCRIBE.BOLTWINGOUT = "I just wanna run and hide away!"
S_______WORTOX.DESCRIBE.BOLTWINGOUT = "Meh, I can do the same thing with souls."
-- S_____WORMWOOD.DESCRIBE.BOLTWINGOUT = ""
-- S________WARLY.DESCRIBE.BOLTWINGOUT = ""
-- S_________WURT.DESCRIBE.BOLTWINGOUT = ""
-- S_______WALTER.DESCRIBE.BOLTWINGOUT = ""
-- S________WANDA.DESCRIBE.BOLTWINGOUT = ""

S_NAMES.BOLTWINGOUT_SHUCK = "Post-Eclosion Shuck"  --羽化后的壳
S______GENERIC.DESCRIBE.BOLTWINGOUT_SHUCK = "Hah! Most creatures don't know it's just a shuck."
S_______WILLOW.DESCRIBE.BOLTWINGOUT_SHUCK = "What a big fake bug, I can burn it!"
-- S_____WOLFGANG.DESCRIBE.BOLTWINGOUT_SHUCK = ""
-- S________WENDY.DESCRIBE.BOLTWINGOUT_SHUCK = ""
S_________WX78.DESCRIBE.BOLTWINGOUT_SHUCK = "A CRAFTY BUG!"
-- S_WICKERBOTTOM.DESCRIBE.BOLTWINGOUT_SHUCK = ""
-- S_______WOODIE.DESCRIBE.BOLTWINGOUT_SHUCK = ""
S______WAXWELL.DESCRIBE.BOLTWINGOUT_SHUCK = "For the weak, escape is the best policy."
-- S___WATHGRITHR.DESCRIBE.BOLTWINGOUT_SHUCK = ""
S_______WEBBER.DESCRIBE.BOLTWINGOUT_SHUCK = "We'll not want our old skin after molting."
S_______WINONA.DESCRIBE.BOLTWINGOUT_SHUCK = "The shuck is not a shuck."
-- S_______WORTOX.DESCRIBE.BOLTWINGOUT_SHUCK = ""
S_____WORMWOOD.DESCRIBE.BOLTWINGOUT_SHUCK = "Hey friend, are you still here?"
-- S________WARLY.DESCRIBE.BOLTWINGOUT_SHUCK = ""
-- S_________WURT.DESCRIBE.BOLTWINGOUT_SHUCK = ""
-- S_______WALTER.DESCRIBE.BOLTWINGOUT_SHUCK = ""
-- S________WANDA.DESCRIBE.BOLTWINGOUT_SHUCK = ""

S_NAMES.MINT_L = "Catmint" --猫薄荷
S______GENERIC.DESCRIBE.MINT_L = "It smells clean and natural."
-- S_______WILLOW.DESCRIBE.MINT_L = ""
S_____WOLFGANG.DESCRIBE.MINT_L = "Wolfgang misses chewing gum."
-- S________WENDY.DESCRIBE.MINT_L = ""
S_________WX78.DESCRIBE.MINT_L = "JUST SOME COMMON WEED LEAVES."
S_WICKERBOTTOM.DESCRIBE.MINT_L = "Seriously, mint is not the same plant as catmint."
-- S_______WOODIE.DESCRIBE.MINT_L = ""
-- S______WAXWELL.DESCRIBE.MINT_L = ""
-- S___WATHGRITHR.DESCRIBE.MINT_L = ""
S_______WEBBER.DESCRIBE.MINT_L = "How about feeding it to catcoons in the forest?"
-- S_______WINONA.DESCRIBE.MINT_L = ""
S_______WORTOX.DESCRIBE.MINT_L = "Nah, I don't like it."
S_____WORMWOOD.DESCRIBE.MINT_L = "Hello, fragrant friend."
S________WARLY.DESCRIBE.MINT_L = "I wish I could use it as a spice."
S_________WURT.DESCRIBE.MINT_L = "Good for vegetarianism, good for me."
-- S_______WALTER.DESCRIBE.MINT_L = ""
-- S________WANDA.DESCRIBE.MINT_L = ""

S_NAMES.CATTENBALL = "Cat Wool Ball"   --猫线球
S______GENERIC.DESCRIBE.CATTENBALL = "Although it was vomited up, it's lovely."
-- S_______WILLOW.DESCRIBE.CATTENBALL = ""
-- S_____WOLFGANG.DESCRIBE.CATTENBALL = ""
-- S________WENDY.DESCRIBE.CATTENBALL = ""
S_________WX78.DESCRIBE.CATTENBALL = "SMELLS LIKE A CAT."
-- S_WICKERBOTTOM.DESCRIBE.CATTENBALL = ""
-- S_______WOODIE.DESCRIBE.CATTENBALL = ""
-- S______WAXWELL.DESCRIBE.CATTENBALL = ""
-- S___WATHGRITHR.DESCRIBE.CATTENBALL = ""
S_______WEBBER.DESCRIBE.CATTENBALL = "We must have a toy show!"
S_______WINONA.DESCRIBE.CATTENBALL = "Maybe it can be used to knit sweaters."
S_______WORTOX.DESCRIBE.CATTENBALL = "Look! The same lovable color as me."
-- S_____WORMWOOD.DESCRIBE.CATTENBALL = ""
-- S________WARLY.DESCRIBE.CATTENBALL = ""
S_________WURT.DESCRIBE.CATTENBALL = "A witch living in the desert mirage would love this!"
-- S_______WALTER.DESCRIBE.CATTENBALL = ""
-- S________WANDA.DESCRIBE.CATTENBALL = ""

S_NAMES.SIVING_ROCKS = "Siving Stone"   --子圭石
S______GENERIC.DESCRIBE.SIVING_ROCKS = "A lively power is roaming inside."
S_______WILLOW.DESCRIBE.SIVING_ROCKS = "Weird, I don't want to burn it at all."
S_____WOLFGANG.DESCRIBE.SIVING_ROCKS = "Pretty little stone."
S________WENDY.DESCRIBE.SIVING_ROCKS = "I'm wasting my time, I got nothing to do."
S_________WX78.DESCRIBE.SIVING_ROCKS = "LIKE ME, NON-CARBON BASED LIFE."
S_WICKERBOTTOM.DESCRIBE.SIVING_ROCKS = "I'm shocked that this ore has life activity!"
S_______WOODIE.DESCRIBE.SIVING_ROCKS = "It looks like a leaf."
S______WAXWELL.DESCRIBE.SIVING_ROCKS = "Is this the legendary..."
S___WATHGRITHR.DESCRIBE.SIVING_ROCKS = "Is it fallen leaves of the world tree?!"
S_______WEBBER.DESCRIBE.SIVING_ROCKS = "Hee hee, our rare stones collection has increased!"
S_______WINONA.DESCRIBE.SIVING_ROCKS = "I feel like it's looking back at me."
S_______WORTOX.DESCRIBE.SIVING_ROCKS = "Really unusual for this to be in this world."
S_____WORMWOOD.DESCRIBE.SIVING_ROCKS = "Part of a stone friend."
S________WARLY.DESCRIBE.SIVING_ROCKS = "If it doesn't involve my field, I won't say more."
S_________WURT.DESCRIBE.SIVING_ROCKS = "I've seen this in my hometown."
S_______WALTER.DESCRIBE.SIVING_ROCKS = "Aha, species discovery!"
S________WANDA.DESCRIBE.SIVING_ROCKS = "It's dazzling in the sun."

S_NAMES.SIVING_DERIVANT_ITEM = "Siving Derivant"  --未种下的子圭一型岩
S______GENERIC.DESCRIBE.SIVING_DERIVANT_ITEM = "I'd like to see what it'll look like."
-- S_______WILLOW.DESCRIBE.SIVING_DERIVANT_ITEM = ""
-- S_____WOLFGANG.DESCRIBE.SIVING_DERIVANT_ITEM = ""
-- S________WENDY.DESCRIBE.SIVING_DERIVANT_ITEM = ""
-- S_________WX78.DESCRIBE.SIVING_DERIVANT_ITEM = ""
S_WICKERBOTTOM.DESCRIBE.SIVING_DERIVANT_ITEM = "It's worth studying after planting."
-- S_______WOODIE.DESCRIBE.SIVING_DERIVANT_ITEM = ""
S______WAXWELL.DESCRIBE.SIVING_DERIVANT_ITEM = "It's rare. Don't let me down."
S___WATHGRITHR.DESCRIBE.SIVING_DERIVANT_ITEM = "Is it a derivant of the world tree?!"
-- S_______WEBBER.DESCRIBE.SIVING_DERIVANT_ITEM = ""
-- S_______WINONA.DESCRIBE.SIVING_DERIVANT_ITEM = ""
-- S_______WORTOX.DESCRIBE.SIVING_DERIVANT_ITEM = ""
S_____WORMWOOD.DESCRIBE.SIVING_DERIVANT_ITEM = "Stone friend's child is still sleeping."
-- S________WARLY.DESCRIBE.SIVING_DERIVANT_ITEM = ""
S_________WURT.DESCRIBE.SIVING_DERIVANT_ITEM = "This is it's seed, which needs to be planted in the soil."
-- S_______WALTER.DESCRIBE.SIVING_DERIVANT_ITEM = ""
-- S________WANDA.DESCRIBE.SIVING_DERIVANT_ITEM = ""

S_NAMES.SIVING_DERIVANT_LVL0 = "Siving Derivant"    --子圭一型岩
S________WANDA.DESCRIBE.SIVING_DERIVANT_LVL0 = "It's going to take some time."
-- S_______WILLOW.DESCRIBE.SIVING_DERIVANT_LVL0 = ""
-- S_____WOLFGANG.DESCRIBE.SIVING_DERIVANT_LVL0 = ""
-- S________WENDY.DESCRIBE.SIVING_DERIVANT_LVL0 = ""
-- S_________WX78.DESCRIBE.SIVING_DERIVANT_LVL0 = ""
S_WICKERBOTTOM.DESCRIBE.SIVING_DERIVANT_LVL0 = "It's worth studying."
-- S_______WOODIE.DESCRIBE.SIVING_DERIVANT_LVL0 = ""
-- S______WAXWELL.DESCRIBE.SIVING_DERIVANT_LVL0 = ""
S___WATHGRITHR.DESCRIBE.SIVING_DERIVANT_LVL0 = "I hope it can grow into a world tree."
-- S_______WEBBER.DESCRIBE.SIVING_DERIVANT_LVL0 = ""
-- S_______WINONA.DESCRIBE.SIVING_DERIVANT_LVL0 = ""
-- S_______WORTOX.DESCRIBE.SIVING_DERIVANT_LVL0 = ""
S_____WORMWOOD.DESCRIBE.SIVING_DERIVANT_LVL0 = "Stone friend's child wakes up."
-- S________WARLY.DESCRIBE.SIVING_DERIVANT_LVL0 = ""
S_________WURT.DESCRIBE.SIVING_DERIVANT_LVL0 = "Just wait for it, glorp."
-- S_______WALTER.DESCRIBE.SIVING_DERIVANT_LVL0 = ""
S________WANDA.DESCRIBE.SIVING_DERIVANT_LVL0 = "It takes more than a little time."

S_NAMES.SIVING_DERIVANT_LVL1 = "Siving Derivant"    --子圭木型岩
S______GENERIC.DESCRIBE.SIVING_DERIVANT_LVL1 = "Great, it's finally grown up a little."
-- S_______WILLOW.DESCRIBE.SIVING_DERIVANT_LVL1 = ""
-- S_____WOLFGANG.DESCRIBE.SIVING_DERIVANT_LVL1 = ""
S________WENDY.DESCRIBE.SIVING_DERIVANT_LVL1 = "Full of hope."
-- S_________WX78.DESCRIBE.SIVING_DERIVANT_LVL1 = ""
S_WICKERBOTTOM.DESCRIBE.SIVING_DERIVANT_LVL1 = "Worth watching for sure."
-- S_______WOODIE.DESCRIBE.SIVING_DERIVANT_LVL1 = ""
-- S______WAXWELL.DESCRIBE.SIVING_DERIVANT_LVL1 = ""
-- S___WATHGRITHR.DESCRIBE.SIVING_DERIVANT_LVL1 = ""
-- S_______WEBBER.DESCRIBE.SIVING_DERIVANT_LVL1 = ""
-- S_______WINONA.DESCRIBE.SIVING_DERIVANT_LVL1 = ""
-- S_______WORTOX.DESCRIBE.SIVING_DERIVANT_LVL1 = ""
S_____WORMWOOD.DESCRIBE.SIVING_DERIVANT_LVL1 = "Growing steadily."
-- S________WARLY.DESCRIBE.SIVING_DERIVANT_LVL1 = ""
-- S_________WURT.DESCRIBE.SIVING_DERIVANT_LVL1 = ""
-- S_______WALTER.DESCRIBE.SIVING_DERIVANT_LVL1 = ""
S________WANDA.DESCRIBE.SIVING_DERIVANT_LVL1 = "It needs more than just a little more time to grow."

S_NAMES.SIVING_DERIVANT_LVL2 = "Siving Derivant"    --子圭林型岩
S______GENERIC.DESCRIBE.SIVING_DERIVANT_LVL2 = "That's great, it looks good."
-- S_______WILLOW.DESCRIBE.SIVING_DERIVANT_LVL2 = ""
-- S_____WOLFGANG.DESCRIBE.SIVING_DERIVANT_LVL2 = ""
-- S________WENDY.DESCRIBE.SIVING_DERIVANT_LVL2 = ""
-- S_________WX78.DESCRIBE.SIVING_DERIVANT_LVL2 = ""
S_WICKERBOTTOM.DESCRIBE.SIVING_DERIVANT_LVL2 = "I will continue to study it."
-- S_______WOODIE.DESCRIBE.SIVING_DERIVANT_LVL2 = ""
-- S______WAXWELL.DESCRIBE.SIVING_DERIVANT_LVL2 = ""
-- S___WATHGRITHR.DESCRIBE.SIVING_DERIVANT_LVL2 = ""
-- S_______WEBBER.DESCRIBE.SIVING_DERIVANT_LVL2 = ""
-- S_______WINONA.DESCRIBE.SIVING_DERIVANT_LVL2 = ""
-- S_______WORTOX.DESCRIBE.SIVING_DERIVANT_LVL2 = ""
S_____WORMWOOD.DESCRIBE.SIVING_DERIVANT_LVL2 = "It's taller than me!"
-- S________WARLY.DESCRIBE.SIVING_DERIVANT_LVL2 = ""
S_________WURT.DESCRIBE.SIVING_DERIVANT_LVL2 = "I've never planted it alive, florpt!"
-- S_______WALTER.DESCRIBE.SIVING_DERIVANT_LVL2 = ""
S________WANDA.DESCRIBE.SIVING_DERIVANT_LVL2 = "Almost time no time at all for me."

S_NAMES.SIVING_DERIVANT_LVL3 = "Siving Derivant"  --子圭森型岩
S______GENERIC.DESCRIBE.SIVING_DERIVANT_LVL3 = "The stone grows luxuriantly."
S_______WILLOW.DESCRIBE.SIVING_DERIVANT_LVL3 = "Doesn't burn. I don't like it."
-- S_____WOLFGANG.DESCRIBE.SIVING_DERIVANT_LVL3 = ""
-- S________WENDY.DESCRIBE.SIVING_DERIVANT_LVL3 = ""
-- S_________WX78.DESCRIBE.SIVING_DERIVANT_LVL3 = ""
S_WICKERBOTTOM.DESCRIBE.SIVING_DERIVANT_LVL3 = "Should be its final form."
S_______WOODIE.DESCRIBE.SIVING_DERIVANT_LVL3 = "Axes don't seem to do anything to it."
-- S______WAXWELL.DESCRIBE.SIVING_DERIVANT_LVL3 = ""
-- S___WATHGRITHR.DESCRIBE.SIVING_DERIVANT_LVL3 = ""
-- S_______WEBBER.DESCRIBE.SIVING_DERIVANT_LVL3 = ""
-- S_______WINONA.DESCRIBE.SIVING_DERIVANT_LVL3 = ""
S_______WORTOX.DESCRIBE.SIVING_DERIVANT_LVL3 = "No matter how good it looks, it has no soul."
S_____WORMWOOD.DESCRIBE.SIVING_DERIVANT_LVL3 = "Mature stone friends."
S________WARLY.DESCRIBE.SIVING_DERIVANT_LVL3 = "Strange."
S_________WURT.DESCRIBE.SIVING_DERIVANT_LVL3 = "Deep in the forest of my hometown there's lots of these."
-- S_______WALTER.DESCRIBE.SIVING_DERIVANT_LVL3 = ""
S________WANDA.DESCRIBE.SIVING_DERIVANT_LVL3 = "It's amazing, but I'm also not surprised."

S_NAMES.SIVING_THETREE = "Siving Alpha" --子圭神木岩
S______GENERIC.DESCRIBE.SIVING_THETREE = {
    GENERIC = "My life bows to its mysterious majesty.",
    NEEDALL = "It says it needs yellowgem products and Telltale Hearts.",
    NEEDLIGHT = "It says it still needs yellowgem products.",
    NEEDHEALTH = "It says it still needs Telltale Hearts.",
    NONEED = "It seems that everything is ready.",
    NOTTHIS = "It doesn't want this."
}
S_______WILLOW.DESCRIBE.SIVING_THETREE = {
    GENERIC = "It cannot burn, but it can burn the fire of life.",
    NEEDALL = "Hum, it unexpectedly asked me for yellowgem products and Telltale Hearts.",
    NEEDLIGHT = "It even needs such precious yellowgem products.",
    NEEDHEALTH = "My hand hurts for Telltale Hearts, but it still needs it?!",
    NONEED = "Girl's mission is finally over.",
    NOTTHIS = "Forget it."
}
S_____WOLFGANG.DESCRIBE.SIVING_THETREE = {
    GENERIC = "Wolfgang shouldn't be so close to Kryptonite.",
    NEEDALL = "It wants Wolfgang's yellowgem products and Telltale Hearts.",
    NEEDLIGHT = "It still wants Wolfgang's yellowgem products.",
    NEEDHEALTH = "It still wants Wolfgang's Telltale Hearts.",
    NONEED = "It no longer needs Wolfgang.",
    NOTTHIS = "Does it despise Wolfgang's items?"
}
S________WENDY.DESCRIBE.SIVING_THETREE = {
    GENERIC = "Leading me to death peacefully, what a relief.",
    NEEDALL = "The sacrificial ceremony needs yellowgem products and Telltale Hearts.",
    NEEDLIGHT = "Yellowgem products are also needed in the sacrifice process.",
    NEEDHEALTH = "Telltale Hearts are also needed in the sacrifice process.",
    NONEED = "Everything is ready. Let's start the ceremony.",
    NOTTHIS = "This is a useless sacrifice."
}
S_________WX78.DESCRIBE.SIVING_THETREE = {
    GENERIC = "EAGER TO TAKE LIFE.",
    NEEDALL = "WHY DOES IT WANT YELLOWGEM PRODUCTS AND TELLTALE HEARTS?",
    NEEDLIGHT = "YELLOWGEM PRODUCTS. WHY SHOULD I GIVE IT THIS.",
    NEEDHEALTH = "TELLTALE HEARTS. WHY SHOULD I GIVE IT THIS.",
    NONEED = "I HOPE IT CAN GIVE ME MORE POWERFUL CHIPS.",
    NOTTHIS = "USELESS."
}
S_WICKERBOTTOM.DESCRIBE.SIVING_THETREE = {
    GENERIC = "DANGER! It has a life attraction like a black hole.",
    NEEDALL = "Yellowgem products and Telltale Hearts, it can actually telepathize with me.",
    NEEDLIGHT = "It also needs yellowgem products. I don't understand the intention of this alien.",
    NEEDHEALTH = "It also needs Telltale Hearts. I don't understand the intention of this alien.",
    NONEED = "That's it. I hope what follows is a feast of knowledge.",
    NOTTHIS = "I don't need this."
}
S_______WOODIE.DESCRIBE.SIVING_THETREE = {
    GENERIC = "Lucy, don't try to chop it down.",
    NEEDALL = "Yellowgem products and Telltale Hearts, should I follow the instructions, Lucy?",
    NEEDLIGHT = "It's really demanding. It still needs yellowgem products.",
    NEEDHEALTH = "It's really demanding. It still needs Telltale Hearts.",
    NONEED = "Finished. Will it create a forest for me to chop?",
    NOTTHIS = "It doesn't want this."
}
S______WAXWELL.DESCRIBE.SIVING_THETREE = {
    GENERIC = "It doesn't look like Charlie's work.",
    NEEDALL = "The mysterious tree needs yellowgem products and Telltale Hearts. It's really suspicious.",
    NEEDLIGHT = "Suspicious tree also need yellowgem products.",
    NEEDHEALTH = "Suspicious tree also need Telltale Hearts.",
    NONEED = "It's over.",
    NOTTHIS = "Not this one."
}
S___WATHGRITHR.DESCRIBE.SIVING_THETREE = {
    GENERIC = "Ode to Yggdrasill!",
    NEEDALL = "Yggdrasil wants yellowgem products and Telltale Hearts. I'll find it right away.",
    NEEDLIGHT = "Yggdrasil also needs yellowgem products.",
    NEEDHEALTH = "Yggdrasil also needs Telltale Hearts.",
    NONEED = "I'm ready to accept the gift of Yggdrasil!",
    NOTTHIS = "The requirements of Yggdrasil are very clear."
}
S_______WEBBER.DESCRIBE.SIVING_THETREE = {
    GENERIC = "We really want to climb up and play.",
    NEEDALL = "Yellowgem toys and telltell hearts, what are these two?",
    NEEDLIGHT = "Yellowgem toys are hard to find. Want more?",
    NEEDHEALTH = "It's hard to make telltell hearts. Want more?",
    NONEED = "It's done. We'll have a nice adventure time!",
    NOTTHIS = "Can't we use other items?"
}
S_______WINONA.DESCRIBE.SIVING_THETREE = {
    GENERIC = "What beautiful lines.",
    NEEDALL = "Yellowgem products and Telltale Hearts. It has its own requirements?!",
    NEEDLIGHT = "It still wants to absorb yellowgem products.",
    NEEDHEALTH = "It still wants to absorb Telltale Hearts.",
    NONEED = "What will happen after the transformation?",
    NOTTHIS = "It won't want it."
}
S_______WORTOX.DESCRIBE.SIVING_THETREE = {
    GENERIC = "This thing wants my life, but my soul is too strong for it.",
    NEEDALL = "This thing told me that it wants yellowgem products and Telltale Hearts.",
    NEEDLIGHT = "This thing said it also wanted yellowgem products.",
    NEEDHEALTH = "This thing said it also wanted Telltale Hearts.",
    NONEED = "I was deceived. I've got to run away!",
    NOTTHIS = "Dear, this is wrong."
}
S_____WORMWOOD.DESCRIBE.SIVING_THETREE = {
    GENERIC = "Is this still a friend?",
    NEEDALL = "It wants yellow glitter and hearts.",
    NEEDLIGHT = "It wants yellow glitter.",
    NEEDHEALTH = "It wants hearts",
    NONEED = "Done.",
    NOTTHIS = "No."
}
S________WARLY.DESCRIBE.SIVING_THETREE = {
    GENERIC = "My life is as delicious as my cooking.",
    NEEDALL = "It said that yellowgem products and Telltale Hearts are the secret recipe of luxury feast.",
    NEEDLIGHT = "The luxury feast also needs yellowgem products.",
    NEEDHEALTH = "The luxury feast also needs Telltale Hearts.",
    NONEED = "What will the luxury feast look like? I'm so curious!",
    NOTTHIS = "I'm not here to make trouble."
}
S_________WURT.DESCRIBE.SIVING_THETREE = {
    GENERIC = "Why isn't it as safe as home, glorp?",
    NEEDALL = "I should have seen yellowgem products and Telltale Hearts somewhere.",
    NEEDLIGHT = "It's asking me for yellowgem products, glort.",
    NEEDHEALTH = "It's asking me for Telltale Hearts, glort.",
    NONEED = "It says to show me the greatness of life, flort.",
    NOTTHIS = "Grrr, it's wrong."
}
S_______WALTER.DESCRIBE.SIVING_THETREE = {
    GENERIC = "The closer to the truth, the more dangerous it is.",
    NEEDALL = "It needs yellowgem products and Telltale Hearts. Is it giving me orders?",
    NEEDLIGHT = "It said it needed yellowgem products to save it.",
    NEEDHEALTH = "It said it needed Telltale Hearts to save it.",
    NONEED = "I saved you. Remember to send me a medal.",
    NOTTHIS = "I shouldn't have made such a mistake."
}
S________WANDA.DESCRIBE.SIVING_THETREE = {
    GENERIC = "As soon as I got close to it, I felt that my time was speeding up.",
    NEEDALL = "I know what it wants, yellowgem products and Telltale Hearts!",
    NEEDLIGHT = "Yellowgem products. I'll make the same mistake again.",
    NEEDHEALTH = "Telltale Hearts. I just want to try another ending.",
    NONEED = "I have been ready many times.",
    NOTTHIS = "I don't think so."
}

S_NAMES.SIVING_SOIL_ITEM = "Siving-Sols"   --未放置的子圭·垄
S_RECIPE_DESC.SIVING_SOIL_ITEM = "An unusual soil bursting with life energy."
S______GENERIC.DESCRIBE.SIVING_SOIL_ITEM = "Put it down, and plant a seed."
-- S_______WILLOW.DESCRIBE.SIVING_SOIL_ITEM = ""
-- S_____WOLFGANG.DESCRIBE.SIVING_SOIL_ITEM = ""
S________WENDY.DESCRIBE.SIVING_SOIL_ITEM = "Traps seeds souls in the cage of life."
-- S_________WX78.DESCRIBE.SIVING_SOIL_ITEM = ""
S_WICKERBOTTOM.DESCRIBE.SIVING_SOIL_ITEM = "It can provide an environment for plant regeneration."
-- S_______WOODIE.DESCRIBE.SIVING_SOIL_ITEM = ""
-- S______WAXWELL.DESCRIBE.SIVING_SOIL_ITEM = ""
S___WATHGRITHR.DESCRIBE.SIVING_SOIL_ITEM = "I don't really need this, but my friends do."
-- S_______WEBBER.DESCRIBE.SIVING_SOIL_ITEM = ""
-- S_______WINONA.DESCRIBE.SIVING_SOIL_ITEM = ""
S_______WORTOX.DESCRIBE.SIVING_SOIL_ITEM = "Living soil, how unusual."
-- S_____WORMWOOD.DESCRIBE.SIVING_SOIL_ITEM = ""
S________WARLY.DESCRIBE.SIVING_SOIL_ITEM = "Fresh ingredients grower."
S_________WURT.DESCRIBE.SIVING_SOIL_ITEM = "I'm interested, florp."
-- S_______WALTER.DESCRIBE.SIVING_SOIL_ITEM = ""
-- S________WANDA.DESCRIBE.SIVING_SOIL_ITEM = ""

S_NAMES.SIVING_SOIL = "Siving-Sols"    --子圭·垄
S______GENERIC.DESCRIBE.SIVING_SOIL = "First step of planting, one big step of being stuffed."
S_______WILLOW.DESCRIBE.SIVING_SOIL = "Sow, germinate, mature, burn!"
S_____WOLFGANG.DESCRIBE.SIVING_SOIL = "My industrious hands are ready."
S________WENDY.DESCRIBE.SIVING_SOIL = "I'm still considering whether to continue."
S_________WX78.DESCRIBE.SIVING_SOIL = "THIS CAN BE A SOURCE OF CLEAN FUEL."
S_WICKERBOTTOM.DESCRIBE.SIVING_SOIL = "The regeneration environment has been placed."
S_______WOODIE.DESCRIBE.SIVING_SOIL = "Who remembers when I was just an ordinary lumberjack..."
S______WAXWELL.DESCRIBE.SIVING_SOIL = "Even if I have to do this, I have to be a decent farmer."
S___WATHGRITHR.DESCRIBE.SIVING_SOIL = "I prefer a wonderful battle."
S_______WEBBER.DESCRIBE.SIVING_SOIL = "What time is it? It's Cultivation time!"
S_______WINONA.DESCRIBE.SIVING_SOIL = "Nothing to say about sowing."
S_______WORTOX.DESCRIBE.SIVING_SOIL = "You must reap what you have sown."
S_____WORMWOOD.DESCRIBE.SIVING_SOIL = "Baby's cradle, advanced edition!"
S________WARLY.DESCRIBE.SIVING_SOIL = "Now you just need to sow some seeds."
S_________WURT.DESCRIBE.SIVING_SOIL = "I'm so excited. What should I plant."
S_______WALTER.DESCRIBE.SIVING_SOIL = "This will get me the planting medal."
S________WANDA.DESCRIBE.SIVING_SOIL = "Will the crops fall into the cycle of time?"

S_NAMES.SIVING_CTLWATER_ITEM = "Siving-Eau" --未放置的子圭·利川
S_RECIPE_DESC.SIVING_CTLWATER_ITEM = "It can control moisture after being placed."
S______GENERIC.DESCRIBE.SIVING_CTLWATER_ITEM = "It can control moisture after being placed."
-- S_______WILLOW.DESCRIBE.SIVING_CTLWATER_ITEM = ""
-- S_____WOLFGANG.DESCRIBE.SIVING_CTLWATER_ITEM = ""
-- S________WENDY.DESCRIBE.SIVING_CTLWATER_ITEM = ""
-- S_________WX78.DESCRIBE.SIVING_CTLWATER_ITEM = ""
-- S_WICKERBOTTOM.DESCRIBE.SIVING_CTLWATER_ITEM = ""
-- S_______WOODIE.DESCRIBE.SIVING_CTLWATER_ITEM = ""
-- S______WAXWELL.DESCRIBE.SIVING_CTLWATER_ITEM = ""
-- S___WATHGRITHR.DESCRIBE.SIVING_CTLWATER_ITEM = ""
-- S_______WEBBER.DESCRIBE.SIVING_CTLWATER_ITEM = ""
-- S_______WINONA.DESCRIBE.SIVING_CTLWATER_ITEM = ""
-- S_______WORTOX.DESCRIBE.SIVING_CTLWATER_ITEM = ""
-- S_____WORMWOOD.DESCRIBE.SIVING_CTLWATER_ITEM = ""
-- S________WARLY.DESCRIBE.SIVING_CTLWATER_ITEM = ""
-- S_________WURT.DESCRIBE.SIVING_CTLWATER_ITEM = ""
-- S_______WALTER.DESCRIBE.SIVING_CTLWATER_ITEM = ""
-- S________WANDA.DESCRIBE.SIVING_CTLWATER_ITEM = ""

S_NAMES.SIVING_CTLWATER = "Siving-Eau" --子圭·利川
S______GENERIC.DESCRIBE.SIVING_CTLWATER = {
    GENERIC = "It can transport water to the surrounding soil.",
    ISFULL = "It's full.",
    REFUSE = "That's not something it can control.",
}
-- S_______WILLOW.DESCRIBE.SIVING_CTLWATER = ""
-- S_____WOLFGANG.DESCRIBE.SIVING_CTLWATER = ""
-- S________WENDY.DESCRIBE.SIVING_CTLWATER = ""
-- S_________WX78.DESCRIBE.SIVING_CTLWATER = ""
-- S_WICKERBOTTOM.DESCRIBE.SIVING_CTLWATER = ""
-- S_______WOODIE.DESCRIBE.SIVING_CTLWATER = ""
-- S______WAXWELL.DESCRIBE.SIVING_CTLWATER = ""
-- S___WATHGRITHR.DESCRIBE.SIVING_CTLWATER = ""
-- S_______WEBBER.DESCRIBE.SIVING_CTLWATER = ""
-- S_______WINONA.DESCRIBE.SIVING_CTLWATER = ""
-- S_______WORTOX.DESCRIBE.SIVING_CTLWATER = ""
-- S_____WORMWOOD.DESCRIBE.SIVING_CTLWATER = ""
-- S________WARLY.DESCRIBE.SIVING_CTLWATER = ""
-- S_________WURT.DESCRIBE.SIVING_CTLWATER = ""
-- S_______WALTER.DESCRIBE.SIVING_CTLWATER = ""
-- S________WANDA.DESCRIBE.SIVING_CTLWATER = ""

S_NAMES.SIVING_CTLDIRT_ITEM = "Siving-Alim" --未放置的子圭·益矩
S_RECIPE_DESC.SIVING_CTLDIRT_ITEM = "It can control nutrients in the soil after being placed."
S______GENERIC.DESCRIBE.SIVING_CTLDIRT_ITEM = "It can control nutrients after being placed."
-- S_______WILLOW.DESCRIBE.SIVING_CTLDIRT_ITEM = ""
-- S_____WOLFGANG.DESCRIBE.SIVING_CTLDIRT_ITEM = ""
-- S________WENDY.DESCRIBE.SIVING_CTLDIRT_ITEM = ""
-- S_________WX78.DESCRIBE.SIVING_CTLDIRT_ITEM = ""
-- S_WICKERBOTTOM.DESCRIBE.SIVING_CTLDIRT_ITEM = ""
-- S_______WOODIE.DESCRIBE.SIVING_CTLDIRT_ITEM = ""
-- S______WAXWELL.DESCRIBE.SIVING_CTLDIRT_ITEM = ""
-- S___WATHGRITHR.DESCRIBE.SIVING_CTLDIRT_ITEM = ""
-- S_______WEBBER.DESCRIBE.SIVING_CTLDIRT_ITEM = ""
-- S_______WINONA.DESCRIBE.SIVING_CTLDIRT_ITEM = ""
-- S_______WORTOX.DESCRIBE.SIVING_CTLDIRT_ITEM = ""
-- S_____WORMWOOD.DESCRIBE.SIVING_CTLDIRT_ITEM = ""
-- S________WARLY.DESCRIBE.SIVING_CTLDIRT_ITEM = ""
-- S_________WURT.DESCRIBE.SIVING_CTLDIRT_ITEM = ""
-- S_______WALTER.DESCRIBE.SIVING_CTLDIRT_ITEM = ""
-- S________WANDA.DESCRIBE.SIVING_CTLDIRT_ITEM = ""

S_NAMES.SIVING_CTLDIRT = "Siving-Alim" --子圭·益矩
S______GENERIC.DESCRIBE.SIVING_CTLDIRT = {
    GENERIC = "It can transport nutrients to the surrounding soil.",
    ISFULL = "It's full.",
    REFUSE = "That's not something it can control.",
}
-- S_______WILLOW.DESCRIBE.SIVING_CTLDIRT = ""
-- S_____WOLFGANG.DESCRIBE.SIVING_CTLDIRT = ""
-- S________WENDY.DESCRIBE.SIVING_CTLDIRT = ""
-- S_________WX78.DESCRIBE.SIVING_CTLDIRT = ""
-- S_WICKERBOTTOM.DESCRIBE.SIVING_CTLDIRT = ""
-- S_______WOODIE.DESCRIBE.SIVING_CTLDIRT = ""
-- S______WAXWELL.DESCRIBE.SIVING_CTLDIRT = ""
-- S___WATHGRITHR.DESCRIBE.SIVING_CTLDIRT = ""
-- S_______WEBBER.DESCRIBE.SIVING_CTLDIRT = ""
-- S_______WINONA.DESCRIBE.SIVING_CTLDIRT = ""
-- S_______WORTOX.DESCRIBE.SIVING_CTLDIRT = ""
-- S_____WORMWOOD.DESCRIBE.SIVING_CTLDIRT = ""
-- S________WARLY.DESCRIBE.SIVING_CTLDIRT = ""
-- S_________WURT.DESCRIBE.SIVING_CTLDIRT = ""
-- S_______WALTER.DESCRIBE.SIVING_CTLDIRT = ""
-- S________WANDA.DESCRIBE.SIVING_CTLDIRT = ""

S_NAMES.SIVING_CTLALL_ITEM = "Siving-Ridge" --未放置的子圭·崇溟
S_RECIPE_DESC.SIVING_CTLALL_ITEM = "It can control moisture and nutrients in the soil after being placed."
S______GENERIC.DESCRIBE.SIVING_CTLALL_ITEM = "It can control moisture and nutrients after being placed."
-- S_______WILLOW.DESCRIBE.SIVING_CTLALL_ITEM = ""
-- S_____WOLFGANG.DESCRIBE.SIVING_CTLALL_ITEM = ""
-- S________WENDY.DESCRIBE.SIVING_CTLALL_ITEM = ""
-- S_________WX78.DESCRIBE.SIVING_CTLALL_ITEM = ""
-- S_WICKERBOTTOM.DESCRIBE.SIVING_CTLALL_ITEM = ""
-- S_______WOODIE.DESCRIBE.SIVING_CTLALL_ITEM = ""
-- S______WAXWELL.DESCRIBE.SIVING_CTLALL_ITEM = ""
-- S___WATHGRITHR.DESCRIBE.SIVING_CTLALL_ITEM = ""
-- S_______WEBBER.DESCRIBE.SIVING_CTLALL_ITEM = ""
-- S_______WINONA.DESCRIBE.SIVING_CTLALL_ITEM = ""
-- S_______WORTOX.DESCRIBE.SIVING_CTLALL_ITEM = ""
-- S_____WORMWOOD.DESCRIBE.SIVING_CTLALL_ITEM = ""
-- S________WARLY.DESCRIBE.SIVING_CTLALL_ITEM = ""
-- S_________WURT.DESCRIBE.SIVING_CTLALL_ITEM = ""
-- S_______WALTER.DESCRIBE.SIVING_CTLALL_ITEM = ""
-- S________WANDA.DESCRIBE.SIVING_CTLALL_ITEM = ""

S_NAMES.SIVING_CTLALL = "Siving-Ridge" --子圭·崇溟
S______GENERIC.DESCRIBE.SIVING_CTLALL = {
    GENERIC = "It can transport water and nutrients to the surrounding soil.",
    ISFULL = "It's full.",
    REFUSE = "That's not something it can control.",
}
-- S_______WILLOW.DESCRIBE.SIVING_CTLALL = ""
-- S_____WOLFGANG.DESCRIBE.SIVING_CTLALL = ""
-- S________WENDY.DESCRIBE.SIVING_CTLALL = ""
-- S_________WX78.DESCRIBE.SIVING_CTLALL = ""
-- S_WICKERBOTTOM.DESCRIBE.SIVING_CTLALL = ""
-- S_______WOODIE.DESCRIBE.SIVING_CTLALL = ""
-- S______WAXWELL.DESCRIBE.SIVING_CTLALL = ""
-- S___WATHGRITHR.DESCRIBE.SIVING_CTLALL = ""
-- S_______WEBBER.DESCRIBE.SIVING_CTLALL = ""
-- S_______WINONA.DESCRIBE.SIVING_CTLALL = ""
-- S_______WORTOX.DESCRIBE.SIVING_CTLALL = ""
-- S_____WORMWOOD.DESCRIBE.SIVING_CTLALL = ""
-- S________WARLY.DESCRIBE.SIVING_CTLALL = ""
-- S_________WURT.DESCRIBE.SIVING_CTLALL = ""
-- S_______WALTER.DESCRIBE.SIVING_CTLALL = ""
-- S________WANDA.DESCRIBE.SIVING_CTLALL = ""

S_NAMES.FISHHOMINGTOOL_NORMAL = "Fish-Homing Bait Maker" --简易打窝饵制作器
S_RECIPE_DESC.FISHHOMINGTOOL_NORMAL = "Disposable aquatic animal bait maker."
S______GENERIC.DESCRIBE.FISHHOMINGTOOL_NORMAL = "It's said that every good angler has their own unique recipe."
-- S_______WILLOW.DESCRIBE.FISHHOMINGTOOL_NORMAL = ""
-- S_____WOLFGANG.DESCRIBE.FISHHOMINGTOOL_NORMAL = ""
-- S________WENDY.DESCRIBE.FISHHOMINGTOOL_NORMAL = ""
-- S_________WX78.DESCRIBE.FISHHOMINGTOOL_NORMAL = ""
-- S_WICKERBOTTOM.DESCRIBE.FISHHOMINGTOOL_NORMAL = ""
-- S_______WOODIE.DESCRIBE.FISHHOMINGTOOL_NORMAL = ""
-- S______WAXWELL.DESCRIBE.FISHHOMINGTOOL_NORMAL = ""
-- S___WATHGRITHR.DESCRIBE.FISHHOMINGTOOL_NORMAL = ""
-- S_______WEBBER.DESCRIBE.FISHHOMINGTOOL_NORMAL = ""
S_______WINONA.DESCRIBE.FISHHOMINGTOOL_NORMAL = "Shoddy craftsmanship."
-- S_______WORTOX.DESCRIBE.FISHHOMINGTOOL_NORMAL = ""
-- S_____WORMWOOD.DESCRIBE.FISHHOMINGTOOL_NORMAL = ""
S________WARLY.DESCRIBE.FISHHOMINGTOOL_NORMAL = "Even as a fish cook, I'm the best!"
S_________WURT.DESCRIBE.FISHHOMINGTOOL_NORMAL = "Find their preferences for each fish, flurph!"
-- S_______WALTER.DESCRIBE.FISHHOMINGTOOL_NORMAL = ""
-- S________WANDA.DESCRIBE.FISHHOMINGTOOL_NORMAL = ""

S_NAMES.FISHHOMINGTOOL_AWESOME = "Pro Fish-Homing Bait Maker" --专业打窝饵制作器
S_RECIPE_DESC.FISHHOMINGTOOL_AWESOME = "Professional aquatic animal bait maker."
S______GENERIC.DESCRIBE.FISHHOMINGTOOL_AWESOME = "It's said that every good angler has their own unique recipe."
-- S_______WILLOW.DESCRIBE.FISHHOMINGTOOL_AWESOME = ""
-- S_____WOLFGANG.DESCRIBE.FISHHOMINGTOOL_AWESOME = ""
-- S________WENDY.DESCRIBE.FISHHOMINGTOOL_AWESOME = ""
-- S_________WX78.DESCRIBE.FISHHOMINGTOOL_AWESOME = ""
-- S_WICKERBOTTOM.DESCRIBE.FISHHOMINGTOOL_AWESOME = ""
-- S_______WOODIE.DESCRIBE.FISHHOMINGTOOL_AWESOME = ""
-- S______WAXWELL.DESCRIBE.FISHHOMINGTOOL_AWESOME = ""
-- S___WATHGRITHR.DESCRIBE.FISHHOMINGTOOL_AWESOME = ""
-- S_______WEBBER.DESCRIBE.FISHHOMINGTOOL_AWESOME = ""
S_______WINONA.DESCRIBE.FISHHOMINGTOOL_AWESOME = "Amazing craftsmanship."
-- S_______WORTOX.DESCRIBE.FISHHOMINGTOOL_AWESOME = ""
-- S_____WORMWOOD.DESCRIBE.FISHHOMINGTOOL_AWESOME = ""
S________WARLY.DESCRIBE.FISHHOMINGTOOL_AWESOME = "I won't just cook fish, I'll cook the entire ocean."
S_________WURT.DESCRIBE.FISHHOMINGTOOL_AWESOME = "A tool to find the preferences of my sea friends, flurph!"
-- S_______WALTER.DESCRIBE.FISHHOMINGTOOL_AWESOME = ""
S________WANDA.DESCRIBE.FISHHOMINGTOOL_AWESOME = "It's better to build a fishing net directly."

STRINGS.FISHHOMING1_LEGION = {
    HARDY = "Hardy ",
    PASTY = "Pasty ",
    DUSTY = "Powdery "
}
STRINGS.FISHHOMING2_LEGION = {
    MEAT = "Meat ",
    VEGGIE = "Veggie ",
    MONSTER = "Weird "
}
STRINGS.FISHHOMING3_LEGION = {
    LUCKY = "Lucky ", --金锦鲤、花锦鲤
    FROZEN = "Frozen ", --冰鲷鱼
    HOT = "Hot ", --炽热太阳鱼
    STICKY = "Sticky ", --甜味鱼
    SLIPPERY = "Slippery ", --口水鱼
    FRAGRANT = "Fragrant ", --花朵金枪鱼
    WRINKLED = "Wrinkled ", --落叶比目鱼
    COMICAL = "Comical ", --爆米花鱼、玉米鳕鱼
    SHINY = "Shiny ", --鱿鱼
    BLOODY = "Bloody ", --岩石大白鲨
    WHISPERING = "Whispering ", --一角鲸
    ROTTEN = "Rotten ", --龙虾
    RUSTY = "Rusty ", --月光龙虾
    SHAKING = "Shaking ", --海黾
    GRASSY = "Grassy ", --草鳄鱼
    EVIL = "Evil ", --邪天翁
    FRIZZY = "Frizzy ", --海鹦鹉
    SALTY = "Briny ", --饼干切割机
}

S_NAMES.FISHHOMINGBAIT = "Fish-Homing Bait" --打窝饵
S______GENERIC.DESCRIBE.FISHHOMINGBAIT = "Throw it into water to attract fish."
-- S_______WILLOW.DESCRIBE.FISHHOMINGBAIT = ""
-- S_____WOLFGANG.DESCRIBE.FISHHOMINGBAIT = ""
-- S________WENDY.DESCRIBE.FISHHOMINGBAIT = ""
S_________WX78.DESCRIBE.FISHHOMINGBAIT = "STUPID AQUATIC CREATURES!"
S_WICKERBOTTOM.DESCRIBE.FISHHOMINGBAIT = "Suits the appetite of aquatic organisms."
-- S_______WOODIE.DESCRIBE.FISHHOMINGBAIT = ""
-- S______WAXWELL.DESCRIBE.FISHHOMINGBAIT = ""
-- S___WATHGRITHR.DESCRIBE.FISHHOMINGBAIT = ""
-- S_______WEBBER.DESCRIBE.FISHHOMINGBAIT = ""
-- S_______WINONA.DESCRIBE.FISHHOMINGBAIT = ""
-- S_______WORTOX.DESCRIBE.FISHHOMINGBAIT = ""
S_____WORMWOOD.DESCRIBE.FISHHOMINGBAIT = "Fish, food, mermmerm..."
S________WARLY.DESCRIBE.FISHHOMINGBAIT = "Hey fishies, here comes food!"
S_________WURT.DESCRIBE.FISHHOMINGBAIT = "Flurph, which lovely fish will be attracted by it today?"
S_______WALTER.DESCRIBE.FISHHOMINGBAIT = "I remember a man who said he went fishing but never opened his bait bag."
S________WANDA.DESCRIBE.FISHHOMINGBAIT = "Well, someone just wants to waste time fishing, right?"

STRINGS.PLANT_CROP_L = {
    WITHERED = "Withered ",
    BLUE = "Blue ",
    DRY = "Dry ",
    FEEBLE = "Feeble ",
    PREPOSITION = "",
    FLORESCENCE = "Blooming ",
    SEEDS = " Xeeds",
    DIGEST = "[{doer}] fed {items} to the {eater}.",
    DIGESTSELF = "{eater} digested {items}."
}
S_NAMES.PLANT_CARROT_L = "Carrot Cluster"
S_NAMES.PLANT_CORN_L = "Corn Straw"
S_NAMES.PLANT_PUMPKIN_L = "Pumpkin Rack"
S_NAMES.PLANT_EGGPLANT_L = "Eggplant Nest"
S_NAMES.PLANT_DURIAN_L = "Durian Willow"
S_NAMES.PLANT_POMEGRANATE_L = "Pomegranate Tree"
S_NAMES.PLANT_DRAGONFRUIT_L = "Dragon Fruit Tree"
S_NAMES.PLANT_WATERMELON_L = "Watermelon Grass"
S_NAMES.PLANT_PINEANANAS_L = "Pineananas Tree"
S_NAMES.PLANT_ONION_L = "Onion Ring"
S_NAMES.PLANT_PEPPER_L = "Pepper Mint"
S_NAMES.PLANT_POTATO_L = "Tripotato"
S_NAMES.PLANT_GARLIC_L = "Feather Garlic"
S_NAMES.PLANT_TOMATO_L = "Thormato"
S_NAMES.PLANT_ASPARAGUS_L = "Asparagus Clump"
S_NAMES.PLANT_MANDRAKE_L = "Planted Mandrake"
S_NAMES.PLANT_GOURD_L = "Gourd Vine"
S_NAMES.PLANT_CACTUS_MEAT_L = "Cactaceae"
S_NAMES.PLANT_PLANTMEAT_L = "Vase Herb"

S______GENERIC.DESCRIBE.PLANT_CROP_L = {
    WITHERED = "It will be born again when spring breeze blows...",
    SPROUT = "What will it look like next...",
    GROWING = "I will wait until the day when the horn of harvest blows...",
    FLORESCENCE = "Flowering is a good time to attract bees and butterflies...",
    READY = "Thank nature for its generous gifts!",
}

S______GENERIC.DESCRIBE.SEEDS_CROP_L = "After special environmental catalysis, it has mutated."
-- S_______WILLOW.DESCRIBE.SEEDS_CROP_L = ""
-- S_____WOLFGANG.DESCRIBE.SEEDS_CROP_L = ""
-- S________WENDY.DESCRIBE.SEEDS_CROP_L = ""
-- S_________WX78.DESCRIBE.SEEDS_CROP_L = ""
S_WICKERBOTTOM.DESCRIBE.SEEDS_CROP_L = "Variation makes it more inorganic."
-- S_______WOODIE.DESCRIBE.SEEDS_CROP_L = ""
-- S______WAXWELL.DESCRIBE.SEEDS_CROP_L = ""
-- S___WATHGRITHR.DESCRIBE.SEEDS_CROP_L = ""
S_______WEBBER.DESCRIBE.SEEDS_CROP_L = "Don't worry, we won't look at it differently."
-- S_______WINONA.DESCRIBE.SEEDS_CROP_L = ""
-- S_______WORTOX.DESCRIBE.SEEDS_CROP_L = ""
S_____WORMWOOD.DESCRIBE.SEEDS_CROP_L = "Baby, different."
-- S________WARLY.DESCRIBE.SEEDS_CROP_L = ""
-- S_________WURT.DESCRIBE.SEEDS_CROP_L = ""
-- S_______WALTER.DESCRIBE.SEEDS_CROP_L = ""
-- S________WANDA.DESCRIBE.SEEDS_CROP_L = ""

S_NAMES.SIVING_TURN = "Siving-Trans" --子圭·育
S_RECIPE_DESC.SIVING_TURN = "An odd thing that transforms giant crops. Yesterday a giant crop flourishing and tomorrow full of wonder."
S______GENERIC.DESCRIBE.SIVING_TURN = {
    GENERIC = "Is this the time shuttle?",
    DONE = "The transformation is finished. I can take it down now.",
    DOING = "It's wrapped in unidentified fragments.",
    NOENERGY = "It's out of energy. I need to recharge it."
}
-- S_______WILLOW.DESCRIBE.SIVING_TURN = ""
-- S_____WOLFGANG.DESCRIBE.SIVING_TURN = ""
-- S________WENDY.DESCRIBE.SIVING_TURN = ""
-- S_________WX78.DESCRIBE.SIVING_TURN = ""
S_WICKERBOTTOM.DESCRIBE.SIVING_TURN = {
    GENERIC = "Contains a gravitational device, which seems to be able to hold some objects.",
    DONE = "Transformation is finished. It kinda looks like a cocoon.",
    DOING = "It is carrying out some special gene transformation.",
    NOENERGY = "It's energy is exhausted, but it's composition is it's energy."
}
-- S_______WOODIE.DESCRIBE.SIVING_TURN = ""
-- S______WAXWELL.DESCRIBE.SIVING_TURN = ""
-- S___WATHGRITHR.DESCRIBE.SIVING_TURN = ""
-- S_______WEBBER.DESCRIBE.SIVING_TURN = ""
-- S_______WINONA.DESCRIBE.SIVING_TURN = ""
-- S_______WORTOX.DESCRIBE.SIVING_TURN = ""
S_____WORMWOOD.DESCRIBE.SIVING_TURN = {
    GENERIC = "Wheel wheel?",
    DONE = "Strange baby, inside!",
    DOING = "Spinning...",
    NOENERGY = "It's hungry."
}
-- S________WARLY.DESCRIBE.SIVING_TURN = ""
-- S_________WURT.DESCRIBE.SIVING_TURN = ""
-- S_______WALTER.DESCRIBE.SIVING_TURN = ""
-- S________WANDA.DESCRIBE.SIVING_TURN = ""

S_NAMES.SIVING_FEATHER_REAL = "Siving-Plume" --子圭·翰
S_RECIPE_DESC.SIVING_FEATHER_REAL = "Sharp feather after thoroughly tempered."
S______GENERIC.DESCRIBE.SIVING_FEATHER_REAL = "I can't wait to pierce something with it."
S_______WILLOW.DESCRIBE.SIVING_FEATHER_REAL = "Feather split!"
S_____WOLFGANG.DESCRIBE.SIVING_FEATHER_REAL = "A sharp fly-cutter."
S________WENDY.DESCRIBE.SIVING_FEATHER_REAL = "So sharp that it can cut my hand."
-- S_________WX78.DESCRIBE.SIVING_FEATHER_REAL = ""
S_WICKERBOTTOM.DESCRIBE.SIVING_FEATHER_REAL = "With a rocky texture, it's sharper than it looks."
-- S_______WOODIE.DESCRIBE.SIVING_FEATHER_REAL = ""
-- S______WAXWELL.DESCRIBE.SIVING_FEATHER_REAL = ""
S___WATHGRITHR.DESCRIBE.SIVING_FEATHER_REAL = "A thousand cuts is just the prelude."
S_______WEBBER.DESCRIBE.SIVING_FEATHER_REAL = "Do you want to do it?!"
-- S_______WINONA.DESCRIBE.SIVING_FEATHER_REAL = ""
S_______WORTOX.DESCRIBE.SIVING_FEATHER_REAL = "It eats away at my soul, not something easy to use."
-- S_____WORMWOOD.DESCRIBE.SIVING_FEATHER_REAL = ""
S________WARLY.DESCRIBE.SIVING_FEATHER_REAL = "I'll cut them into thin slices!"
-- S_________WURT.DESCRIBE.SIVING_FEATHER_REAL = ""
S_______WALTER.DESCRIBE.SIVING_FEATHER_REAL = "Better than my slingshot."
S________WANDA.DESCRIBE.SIVING_FEATHER_REAL = "I wish it could cut away this nightmare."

S_NAMES.SIVING_FEATHER_FAKE = "Siving Feather" --子圭玄鸟绒羽
S______GENERIC.DESCRIBE.SIVING_FEATHER_FAKE = "I'm going to slap people! All of you!"
S_______WILLOW.DESCRIBE.SIVING_FEATHER_FAKE = "Feather throw!"
S_____WOLFGANG.DESCRIBE.SIVING_FEATHER_FAKE = "A throwing knife that is not all that sharp."
-- S________WENDY.DESCRIBE.SIVING_FEATHER_FAKE = ""
-- S_________WX78.DESCRIBE.SIVING_FEATHER_FAKE = ""
-- S_WICKERBOTTOM.DESCRIBE.SIVING_FEATHER_FAKE = ""
-- S_______WOODIE.DESCRIBE.SIVING_FEATHER_FAKE = ""
S______WAXWELL.DESCRIBE.SIVING_FEATHER_FAKE = "As wild as magic!"
S___WATHGRITHR.DESCRIBE.SIVING_FEATHER_FAKE = "Can it be called a party without a fight?"
S_______WEBBER.DESCRIBE.SIVING_FEATHER_FAKE = "Better than toy darts."
-- S_______WINONA.DESCRIBE.SIVING_FEATHER_FAKE = ""
S_______WORTOX.DESCRIBE.SIVING_FEATHER_FAKE = "I'd love to try it out and see who's faster."
-- S_____WORMWOOD.DESCRIBE.SIVING_FEATHER_FAKE = ""
-- S________WARLY.DESCRIBE.SIVING_FEATHER_FAKE = ""
-- S_________WURT.DESCRIBE.SIVING_FEATHER_FAKE = ""
S_______WALTER.DESCRIBE.SIVING_FEATHER_FAKE = "Oh fun! I want to try it now!"
-- S________WANDA.DESCRIBE.SIVING_FEATHER_FAKE = ""

S_NAMES.SIVING_FEATHER_LINE = "Silked Away" --牵羽牵寻
S______GENERIC.DESCRIBE.SIVING_FEATHER_LINE = "Hidden threads, tugging at one end of each feather."
S_______WILLOW.DESCRIBE.SIVING_FEATHER_LINE = "Like the queen of blades."
-- S_____WOLFGANG.DESCRIBE.SIVING_FEATHER_LINE = ""
S________WENDY.DESCRIBE.SIVING_FEATHER_LINE = "I wonder if Abigail is controlled by me like this."
-- S_________WX78.DESCRIBE.SIVING_FEATHER_LINE = ""
S_WICKERBOTTOM.DESCRIBE.SIVING_FEATHER_LINE = "Every time it reciprocates, a thread can break."
S_______WOODIE.DESCRIBE.SIVING_FEATHER_LINE = "Lucy and I are too familiar with this trick."
S______WAXWELL.DESCRIBE.SIVING_FEATHER_LINE = "These puppet like feathers are used to hurt rather than entertain."
S___WATHGRITHR.DESCRIBE.SIVING_FEATHER_LINE = "Valkyries should also learn this!"
S_______WEBBER.DESCRIBE.SIVING_FEATHER_LINE = "It's like a yoyo."
S_______WINONA.DESCRIBE.SIVING_FEATHER_LINE = "Sharp feathers will shuttle back and forth under my command."
S_______WORTOX.DESCRIBE.SIVING_FEATHER_LINE = "The red string of fate will entangle you and me."
S_____WORMWOOD.DESCRIBE.SIVING_FEATHER_LINE = "Tug of war."
S________WARLY.DESCRIBE.SIVING_FEATHER_LINE = "This technique is also used to cut meat."
-- S_________WURT.DESCRIBE.SIVING_FEATHER_LINE = ""
S_______WALTER.DESCRIBE.SIVING_FEATHER_LINE = "I tried to add this to slingshot, but never succeeded."
-- S________WANDA.DESCRIBE.SIVING_FEATHER_LINE = ""

S_NAMES.SIVING_MASK = "Siving-Absor" --子圭·汲
S_RECIPE_DESC.SIVING_MASK = "What is the price of wearing life."
S______GENERIC.DESCRIBE.SIVING_MASK = "A stone mask that draws blood."
S_______WILLOW.DESCRIBE.SIVING_MASK = "Burn your lives for me, humble servants!"
-- S_____WOLFGANG.DESCRIBE.SIVING_MASK = ""
S________WENDY.DESCRIBE.SIVING_MASK = "Luckily it won't harm Abigail."
-- S_________WX78.DESCRIBE.SIVING_MASK = ""
S_WICKERBOTTOM.DESCRIBE.SIVING_MASK = "A magic, difficult to control. Improper use will make you hurt yourself."
-- S_______WOODIE.DESCRIBE.SIVING_MASK = ""
S______WAXWELL.DESCRIBE.SIVING_MASK = "Maybe I can live a little longer behind this mask."
S___WATHGRITHR.DESCRIBE.SIVING_MASK = "Only despicable losers would enjoy such tricks."
S_______WEBBER.DESCRIBE.SIVING_MASK = "We all think this is wrong!" --因为蜘蛛是群居生物，韦伯善良，所以都不想使用这个装备
-- S_______WINONA.DESCRIBE.SIVING_MASK = ""
S_______WORTOX.DESCRIBE.SIVING_MASK = "Disguised as a vampire who doesn't need to be invited into the house, ahahahaha!"
S_____WORMWOOD.DESCRIBE.SIVING_MASK = "It rarely becomes hostile to friends."
S________WARLY.DESCRIBE.SIVING_MASK = "Eat what sates you, right?"
-- S_________WURT.DESCRIBE.SIVING_MASK = ""
-- S_______WALTER.DESCRIBE.SIVING_MASK = ""
S________WANDA.DESCRIBE.SIVING_MASK = "Time will also slowly take away the lives of all in a similar way."

S_NAMES.SIVING_MASK_GOLD = "Siving-Movili" --子圭·歃
S_RECIPE_DESC.SIVING_MASK_GOLD = "Calls for lives."
S______GENERIC.DESCRIBE.SIVING_MASK_GOLD = "A mask of exquisite broken gold that plays with life."
S_______WILLOW.DESCRIBE.SIVING_MASK_GOLD = "Give your lives for the queen of flames, humble servants!"
S_____WOLFGANG.DESCRIBE.SIVING_MASK_GOLD = "Wolfgang is willing to give of himself to save others."
S________WENDY.DESCRIBE.SIVING_MASK_GOLD = "Tried to resurrect Abigail with it and failed, as always."
S_________WX78.DESCRIBE.SIVING_MASK_GOLD = "I ACTUALLY FELT A LITTLE WARMTH WHEN I WAS SAVED BY IT."
S_WICKERBOTTOM.DESCRIBE.SIVING_MASK_GOLD = "More mature control of life magic without hurting yourself."
S_______WOODIE.DESCRIBE.SIVING_MASK_GOLD = "If only it would have been possible to get Lucy back."
S______WAXWELL.DESCRIBE.SIVING_MASK_GOLD = "I'll hide my identity until the victory comes."
S___WATHGRITHR.DESCRIBE.SIVING_MASK_GOLD = "The lord of fallen excels in such tactics."
S_______WEBBER.DESCRIBE.SIVING_MASK_GOLD = "We only get more disgusted with this stuff!"
S_______WINONA.DESCRIBE.SIVING_MASK_GOLD = "I am the master of my destiny!"
S_______WORTOX.DESCRIBE.SIVING_MASK_GOLD = "Incarnate as the fleshless Dracula, yah ha ha!"
S_____WORMWOOD.DESCRIBE.SIVING_MASK_GOLD = "It doesn't feel right."
S________WARLY.DESCRIBE.SIVING_MASK_GOLD = "Eats grass, produces superb milk!"
-- S_________WURT.DESCRIBE.SIVING_MASK_GOLD = ""
-- S_______WALTER.DESCRIBE.SIVING_MASK_GOLD = ""
S________WANDA.DESCRIBE.SIVING_MASK_GOLD = "More efficient and cruel than the magic of time."

S_NAMES.SIVING_EGG = "Siving Phoenix Egg" --子圭石子
S______GENERIC.DESCRIBE.SIVING_EGG = "Should I break it or let it hatch?"
-- S_______WILLOW.DESCRIBE.SIVING_EGG = ""
-- S_____WOLFGANG.DESCRIBE.SIVING_EGG = ""
S________WENDY.DESCRIBE.SIVING_EGG = "Even before its birth, it's ready to die."
-- S_________WX78.DESCRIBE.SIVING_EGG = ""
S_WICKERBOTTOM.DESCRIBE.SIVING_EGG = "If it's born, it will probably be another hard battle."
S_______WOODIE.DESCRIBE.SIVING_EGG = "My advice is to nip it in the bud!"
-- S______WAXWELL.DESCRIBE.SIVING_EGG = ""
S___WATHGRITHR.DESCRIBE.SIVING_EGG = "Great warriors should have compassion."
S_______WEBBER.DESCRIBE.SIVING_EGG = "An interesting stone egg."
-- S_______WINONA.DESCRIBE.SIVING_EGG = ""
S_______WORTOX.DESCRIBE.SIVING_EGG = "An egg that's between life and death."
S_____WORMWOOD.DESCRIBE.SIVING_EGG = "Rocky egg."
S________WARLY.DESCRIBE.SIVING_EGG = "Be obedient, or I'll make you into fried eggs."
-- S_________WURT.DESCRIBE.SIVING_EGG = ""
-- S_______WALTER.DESCRIBE.SIVING_EGG = ""
S________WANDA.DESCRIBE.SIVING_EGG = "Seriously, it will start it's cycle of life again."

S_NAMES.SIVING_PHOENIX = "Siving Phoenix" --子圭玄鸟
S______GENERIC.DESCRIBE.SIVING_PHOENIX = {
    GENERIC = "A rock can also give birth to life? That's a major scientific discovery!",
    GRIEF = "It has people thoughts!"
}
S_______WILLOW.DESCRIBE.SIVING_PHOENIX = {
    GENERIC = "This bird can't burn, it's giving me a headache.",
    GRIEF = "Now you are alone."
}
S_____WOLFGANG.DESCRIBE.SIVING_PHOENIX = {
    GENERIC = "Wolfgang wants to touch it.",
    GRIEF = "Stone bird is angry!"
}
S________WENDY.DESCRIBE.SIVING_PHOENIX = {
    GENERIC = "This is not what I expected.",
    GRIEF = "Maybe the ceremony is not over yet."
}
S_________WX78.DESCRIBE.SIVING_PHOENIX = {
    GENERIC = "THAT TREE IS NOT WORTH COOPERATING WITH.",
    GRIEF = "THAT'S THE PRICE FOR LYING TO ME!"
}
S_WICKERBOTTOM.DESCRIBE.SIVING_PHOENIX = {
    GENERIC = "This is the highest form of life of siving!",
    GRIEF = "They seem to have the same thoughts and feelings as us."
}
S_______WOODIE.DESCRIBE.SIVING_PHOENIX = {
    GENERIC = "Don't blame me for being too cruel, stupid birds.",
    GRIEF = "There's one left!"
}
S______WAXWELL.DESCRIBE.SIVING_PHOENIX = {
    GENERIC = "This isn't the first time. I'm so gullible.",
    GRIEF = "I will pay for my stupidity."
}
S___WATHGRITHR.DESCRIBE.SIVING_PHOENIX = {
    GENERIC = "A great test of the sacred tree to the warriors!",
    GRIEF = "The trial is coming to an end."
}
S_______WEBBER.DESCRIBE.SIVING_PHOENIX = {
    GENERIC = "They don't seem to want to play with us.",
    GRIEF = "This isn't our intention. Sorry."
}
S_______WINONA.DESCRIBE.SIVING_PHOENIX = {
    GENERIC = "Very interesting. It's a bird shaped statue that can move!",
    GRIEF = "This statue is crazy."
}
S_______WORTOX.DESCRIBE.SIVING_PHOENIX = {
    GENERIC = "I can tell their gender.",
    GRIEF = "Where's its partner?"
}
S_____WORMWOOD.DESCRIBE.SIVING_PHOENIX = {
    GENERIC = "One rock bird, two rock birds.",
    GRIEF = "One rock bird, mad."
}
S________WARLY.DESCRIBE.SIVING_PHOENIX = {
    GENERIC = "Deception! I'll teach you a lesson.",
    GRIEF = "I feel a little sorry for it."
}
S_________WURT.DESCRIBE.SIVING_PHOENIX = {
    GENERIC = "Their existence moves me.",
    GRIEF = "I definitely didn't do it. Please spare me, flort."
}
S_______WALTER.DESCRIBE.SIVING_PHOENIX = {
    GENERIC = "Hello, can I take a rock feather as a medal?",
    GRIEF = "You're not happy. I'll ask you about the medal later."
}
S________WANDA.DESCRIBE.SIVING_PHOENIX = {
    GENERIC = "I've never completely defeated it in our countless battles.",
    GRIEF = "It fell into grief and indignation, as always."
}

S_NAMES.SIVING_BOSS_FLOWER = "Siving Petalsite" --子圭寄生花
S______GENERIC.DESCRIBE.SIVING_BOSS_FLOWER = "It grew out of my head. How terrible."
S_______WILLOW.DESCRIBE.SIVING_BOSS_FLOWER = "I'm going to tear it up!"
-- S_____WOLFGANG.DESCRIBE.SIVING_BOSS_FLOWER = ""
S________WENDY.DESCRIBE.SIVING_BOSS_FLOWER = "It thrives in silent killing."
S_________WX78.DESCRIBE.SIVING_BOSS_FLOWER = "THE IRONMAN IN BLOSSOM."
S_WICKERBOTTOM.DESCRIBE.SIVING_BOSS_FLOWER = "Note that this flower will heal the bird."
S_______WOODIE.DESCRIBE.SIVING_BOSS_FLOWER = "Lucy told me to destroy it quickly."
S______WAXWELL.DESCRIBE.SIVING_BOSS_FLOWER = "Neet... Hah... I can tell dry jokes too."
S___WATHGRITHR.DESCRIBE.SIVING_BOSS_FLOWER = "My life is my endless fighting spirit. I don't need such tricks."
S_______WEBBER.DESCRIBE.SIVING_BOSS_FLOWER = "Maybe the watermelon seeds I ate grew out of my head?"
-- S_______WINONA.DESCRIBE.SIVING_BOSS_FLOWER = ""
S_______WORTOX.DESCRIBE.SIVING_BOSS_FLOWER = "Bloodletting can't cure my soul."
S_____WORMWOOD.DESCRIBE.SIVING_BOSS_FLOWER = "A bad guy."
S________WARLY.DESCRIBE.SIVING_BOSS_FLOWER = "It's made me very weak, but my appetite has increased greatly."
S_________WURT.DESCRIBE.SIVING_BOSS_FLOWER = "Parasite, no, smelly petalsite!"
S_______WALTER.DESCRIBE.SIVING_BOSS_FLOWER = "If only all injuries could be so painless."
S________WANDA.DESCRIBE.SIVING_BOSS_FLOWER = "My time isn't the water in the sponge for you to squeeze!"

S_NAMES.SIVING_BOSSFEA_REAL = "Delicate Siving Darther" --精致子圭翎羽(Dart + Feather)
S______GENERIC.DESCRIBE.SIVING_BOSSFEA_REAL = "Shiny rocky feather with extremely sharp edges."
-- S_______WILLOW.DESCRIBE.SIVING_BOSSFEA_REAL = ""
-- S_____WOLFGANG.DESCRIBE.SIVING_BOSSFEA_REAL = ""
-- S________WENDY.DESCRIBE.SIVING_BOSSFEA_REAL = ""
S_________WX78.DESCRIBE.SIVING_BOSSFEA_REAL = "INJURY AND EXPLOSION WARNING!"
S_WICKERBOTTOM.DESCRIBE.SIVING_BOSSFEA_REAL = "Additional unstable energy is attached to this feather."
S_______WOODIE.DESCRIBE.SIVING_BOSSFEA_REAL = "A bright arrow hurled by the bird."
-- S______WAXWELL.DESCRIBE.SIVING_BOSSFEA_REAL = ""
S___WATHGRITHR.DESCRIBE.SIVING_BOSSFEA_REAL = "A sharp blade of light."
S_______WEBBER.DESCRIBE.SIVING_BOSSFEA_REAL = "We saw it coming like a dart. It was terrible."
-- S_______WINONA.DESCRIBE.SIVING_BOSSFEA_REAL = ""
S_______WORTOX.DESCRIBE.SIVING_BOSSFEA_REAL = "It's too conspicuous. It won't hurt me."
S_____WORMWOOD.DESCRIBE.SIVING_BOSSFEA_REAL = "Glowing dagger!"
S________WARLY.DESCRIBE.SIVING_BOSSFEA_REAL = "It would be cool to use it as a kitchen knife."
-- S_________WURT.DESCRIBE.SIVING_BOSSFEA_REAL = ""
-- S_______WALTER.DESCRIBE.SIVING_BOSSFEA_REAL = ""
S________WANDA.DESCRIBE.SIVING_BOSSFEA_REAL = "Great lethality, but low hit rate."

S_NAMES.SIVING_BOSSFEA_FAKE = "Siving Darther" --子圭翎羽
S______GENERIC.DESCRIBE.SIVING_BOSSFEA_FAKE = "Rocky feather with sharp edges."
-- S_______WILLOW.DESCRIBE.SIVING_BOSSFEA_FAKE = ""
-- S_____WOLFGANG.DESCRIBE.SIVING_BOSSFEA_FAKE = ""
-- S________WENDY.DESCRIBE.SIVING_BOSSFEA_FAKE = ""
S_________WX78.DESCRIBE.SIVING_BOSSFEA_FAKE = "INJURY WARNING!"
S_WICKERBOTTOM.DESCRIBE.SIVING_BOSSFEA_FAKE = "A common feather used as a weapon."
S_______WOODIE.DESCRIBE.SIVING_BOSSFEA_FAKE = "A stabbing arrow thrown by the bird."
-- S______WAXWELL.DESCRIBE.SIVING_BOSSFEA_FAKE = ""
S___WATHGRITHR.DESCRIBE.SIVING_BOSSFEA_FAKE = "A sharp blade."
S_______WEBBER.DESCRIBE.SIVING_BOSSFEA_FAKE = "We saw it coming like a dart."
-- S_______WINONA.DESCRIBE.SIVING_BOSSFEA_FAKE = ""
S_______WORTOX.DESCRIBE.SIVING_BOSSFEA_FAKE = "It can't hurt me if I teleport fast enough."
S_____WORMWOOD.DESCRIBE.SIVING_BOSSFEA_FAKE = "Dagger!"
S________WARLY.DESCRIBE.SIVING_BOSSFEA_FAKE = "If only it could be used as a kitchen knife."
-- S_________WURT.DESCRIBE.SIVING_BOSSFEA_FAKE = ""
-- S_______WALTER.DESCRIBE.SIVING_BOSSFEA_FAKE = ""
S________WANDA.DESCRIBE.SIVING_BOSSFEA_FAKE = "Not all that high of lethality and a low hit rate."

S_NAMES.SIVING_BOSS_ROOT = "Siving Root Spike" --子圭突触
S______GENERIC.DESCRIBE.SIVING_BOSS_ROOT = "Death from below!"
-- S_______WILLOW.DESCRIBE.SIVING_BOSS_ROOT = ""
-- S_____WOLFGANG.DESCRIBE.SIVING_BOSS_ROOT = ""
-- S________WENDY.DESCRIBE.SIVING_BOSS_ROOT = ""
-- S_________WX78.DESCRIBE.SIVING_BOSS_ROOT = ""
S_WICKERBOTTOM.DESCRIBE.SIVING_BOSS_ROOT = "Observe carefully, or..."
S_______WOODIE.DESCRIBE.SIVING_BOSS_ROOT = "Ugh. I need pickaxe now."
-- S______WAXWELL.DESCRIBE.SIVING_BOSS_ROOT = ""
S___WATHGRITHR.DESCRIBE.SIVING_BOSS_ROOT = "Hah, this is easy."
S_______WEBBER.DESCRIBE.SIVING_BOSS_ROOT = "Our bare feet can easily feel the dangers from under the ground."
S_______WINONA.DESCRIBE.SIVING_BOSS_ROOT = "It not only raided, but also blocked my way."
S_______WORTOX.DESCRIBE.SIVING_BOSS_ROOT = "Be careful to not have your butt pricked!"
S_____WORMWOOD.DESCRIBE.SIVING_BOSS_ROOT = "A pointed root."
-- S________WARLY.DESCRIBE.SIVING_BOSS_ROOT = ""
S_________WURT.DESCRIBE.SIVING_BOSS_ROOT = "Grrr, it makes sneak attack!"
-- S_______WALTER.DESCRIBE.SIVING_BOSS_ROOT = ""
-- S________WANDA.DESCRIBE.SIVING_BOSS_ROOT = ""

S_NAMES.HAT_ELEPHEETLE = "Elepheetle Helmet" --犀金胄甲
S_RECIPE_DESC.HAT_ELEPHEETLE = "Provides protection and the insect's super power."
S______GENERIC.DESCRIBE.HAT_ELEPHEETLE = "Fortunately, it's not worm-shaped."
S_______WILLOW.DESCRIBE.HAT_ELEPHEETLE = "Bah, I hate it!"
S_____WOLFGANG.DESCRIBE.HAT_ELEPHEETLE = "It's easier to do physical work while wearing it."
-- S________WENDY.DESCRIBE.HAT_ELEPHEETLE = ""
-- S_________WX78.DESCRIBE.HAT_ELEPHEETLE = ""
S_WICKERBOTTOM.DESCRIBE.HAT_ELEPHEETLE = "This is the knowledge learned from the unicorn beetle."
S_______WOODIE.DESCRIBE.HAT_ELEPHEETLE = "It looks like a big bug."
S______WAXWELL.DESCRIBE.HAT_ELEPHEETLE = "I don't want to look at it, I don't want to wear it."
-- S___WATHGRITHR.DESCRIBE.HAT_ELEPHEETLE = ""
S_______WEBBER.DESCRIBE.HAT_ELEPHEETLE = "Hee hee, it's as different as us."
S_______WINONA.DESCRIBE.HAT_ELEPHEETLE = "Practicality is on the line, it's appearance is not important."
S_______WORTOX.DESCRIBE.HAT_ELEPHEETLE = "This power is most suitable for farming work."
S_____WORMWOOD.DESCRIBE.HAT_ELEPHEETLE = "Scary."
S________WARLY.DESCRIBE.HAT_ELEPHEETLE = "I prefer the super power that is cooking."
-- S_________WURT.DESCRIBE.HAT_ELEPHEETLE = ""
S_______WALTER.DESCRIBE.HAT_ELEPHEETLE = "Looks like this year's Halloween costume is decided!"
S________WANDA.DESCRIBE.HAT_ELEPHEETLE = "I don't need the power of bugs."

S_NAMES.ARMOR_ELEPHEETLE = "Elepheetle Armor" --犀金护甲
S_RECIPE_DESC.ARMOR_ELEPHEETLE = "Provides resistance and the insect's extreme defense."
S______GENERIC.DESCRIBE.ARMOR_ELEPHEETLE = "It's much heavier than it looks."
S_______WILLOW.DESCRIBE.ARMOR_ELEPHEETLE = "Disgusting. I'd better burn it."
S_____WOLFGANG.DESCRIBE.ARMOR_ELEPHEETLE = "Wolfgang likes the strong sense of weightiness."
-- S________WENDY.DESCRIBE.ARMOR_ELEPHEETLE = ""
-- S_________WX78.DESCRIBE.ARMOR_ELEPHEETLE = ""
S_WICKERBOTTOM.DESCRIBE.ARMOR_ELEPHEETLE = "This is the wisdom learned from the elephant beetle."
S_______WOODIE.DESCRIBE.ARMOR_ELEPHEETLE = "After wearing it, there is a big bug."
S______WAXWELL.DESCRIBE.ARMOR_ELEPHEETLE = "I'd rather wear something actually decent."
-- S___WATHGRITHR.DESCRIBE.ARMOR_ELEPHEETLE = ""
S_______WEBBER.DESCRIBE.ARMOR_ELEPHEETLE = "We like it alot, but it's too heavy."
S_______WINONA.DESCRIBE.ARMOR_ELEPHEETLE = "Just use it. The shape is not important."
S_______WORTOX.DESCRIBE.ARMOR_ELEPHEETLE = "Wear the thickest armor to withstand the most vicious blows."
S_____WORMWOOD.DESCRIBE.ARMOR_ELEPHEETLE = "Scary."
S________WARLY.DESCRIBE.ARMOR_ELEPHEETLE = "I still prefer cooking as opposed to extreme defense."
-- S_________WURT.DESCRIBE.ARMOR_ELEPHEETLE = ""
S_______WALTER.DESCRIBE.ARMOR_ELEPHEETLE = "Looks like this year's Halloween costume is decided!"
S________WANDA.DESCRIBE.ARMOR_ELEPHEETLE = "This amount of heft mixed with my limited time doesn't match well at all!"

S_NAMES.LANCE_CARROT_L = "Carrot Lance" --胡萝卜长枪
S______GENERIC.DESCRIBE.LANCE_CARROT_L = "Using food as weapons isn't new."
-- S_______WILLOW.DESCRIBE.LANCE_CARROT_L = ""
-- S_____WOLFGANG.DESCRIBE.LANCE_CARROT_L = ""
S________WENDY.DESCRIBE.LANCE_CARROT_L = "A rabbit's weapon."
-- S_________WX78.DESCRIBE.LANCE_CARROT_L = ""
S_WICKERBOTTOM.DESCRIBE.LANCE_CARROT_L = "A carrot stick that's as hard as bamboo."
S_______WOODIE.DESCRIBE.LANCE_CARROT_L = "I just want to ask if this can be eaten."
-- S______WAXWELL.DESCRIBE.LANCE_CARROT_L = ""
S___WATHGRITHR.DESCRIBE.LANCE_CARROT_L = "When you are incisive enough, even food can be a weapon."
S_______WEBBER.DESCRIBE.LANCE_CARROT_L = "Tasty and funny long carrot!"
-- S_______WINONA.DESCRIBE.LANCE_CARROT_L = ""
-- S_______WORTOX.DESCRIBE.LANCE_CARROT_L = ""
S_____WORMWOOD.DESCRIBE.LANCE_CARROT_L = "Very long."
S________WARLY.DESCRIBE.LANCE_CARROT_L = "Unfortunately, it has hardened and cannot be eaten."
S_________WURT.DESCRIBE.LANCE_CARROT_L = "Ha, I think it suits me very well."
-- S_______WALTER.DESCRIBE.LANCE_CARROT_L = ""
S________WANDA.DESCRIBE.LANCE_CARROT_L = "Nothing new."

S_NAMES.PLANT_NEPENTHES_L = "Vase Herb" --巨食草
S______GENERIC.DESCRIBE.PLANT_NEPENTHES_L = "What a big insect eating plant!"
-- S_______WILLOW.DESCRIBE.PLANT_NEPENTHES_L = ""
S_____WOLFGANG.DESCRIBE.PLANT_NEPENTHES_L = "Wolfgang's farm has been saved."
S________WENDY.DESCRIBE.PLANT_NEPENTHES_L = "When will the struggle between insects and plants end."
S_________WX78.DESCRIBE.PLANT_NEPENTHES_L = "LET'S MARCH TOWARDS THE PESTS!"
S_WICKERBOTTOM.DESCRIBE.PLANT_NEPENTHES_L = "Its digestive juices can decompose most materials."
S_______WOODIE.DESCRIBE.PLANT_NEPENTHES_L = "I haven't seen this before."
-- S______WAXWELL.DESCRIBE.PLANT_NEPENTHES_L = ""
-- S___WATHGRITHR.DESCRIBE.PLANT_NEPENTHES_L = ""
S_______WEBBER.DESCRIBE.PLANT_NEPENTHES_L = "It must be a great place for hide and seek!"
S_______WINONA.DESCRIBE.PLANT_NEPENTHES_L = "Fantastic plants and where to find them?"
S_______WORTOX.DESCRIBE.PLANT_NEPENTHES_L = "My friend, I know you have bold ideas."
S_____WORMWOOD.DESCRIBE.PLANT_NEPENTHES_L = "Very reliable friend!"
S________WARLY.DESCRIBE.PLANT_NEPENTHES_L = "It doesn't eat me, and I don't eat it either."
-- S_________WURT.DESCRIBE.PLANT_NEPENTHES_L = ""
S_______WALTER.DESCRIBE.PLANT_NEPENTHES_L = "It eats everything, even more gluttonous than Woby."
S________WANDA.DESCRIBE.PLANT_NEPENTHES_L = "The ones I've seen before aren't that big."

S______GENERIC.DESCRIBE.TISSUE_L = "This fresh plant tissue can be used for research."
-- S_______WILLOW.DESCRIBE.TISSUE_L = ""
-- S_____WOLFGANG.DESCRIBE.TISSUE_L = ""
-- S________WENDY.DESCRIBE.TISSUE_L = ""
-- S_________WX78.DESCRIBE.TISSUE_L = ""
S_WICKERBOTTOM.DESCRIBE.TISSUE_L = "It can be used as a sample for xeeds transformation."
-- S_______WOODIE.DESCRIBE.TISSUE_L = ""
S______WAXWELL.DESCRIBE.TISSUE_L = "Even magic requires samples to study."
-- S___WATHGRITHR.DESCRIBE.TISSUE_L = ""
-- S_______WEBBER.DESCRIBE.TISSUE_L = ""
-- S_______WINONA.DESCRIBE.TISSUE_L = ""
-- S_______WORTOX.DESCRIBE.TISSUE_L = ""
S_____WORMWOOD.DESCRIBE.TISSUE_L = "A part of a friend."
-- S________WARLY.DESCRIBE.TISSUE_L = ""
-- S_________WURT.DESCRIBE.TISSUE_L = ""
-- S_______WALTER.DESCRIBE.TISSUE_L = ""
-- S________WANDA.DESCRIBE.TISSUE_L = ""

S_NAMES.TISSUE_L_CACTUS = "Living Tissue of Cactus" --仙人掌活性组织
S_NAMES.TISSUE_L_LUREPLANT = "Living Tissue of Lureplant" --食人花活性组织

--------------------------------------------------------------------------
--[[ flash and crush ]]--[[ 电闪雷鸣 ]]
--------------------------------------------------------------------------

S_NAMES.ELECOURMALINE = "Elecourmaline"    --电气重铸台
S______GENERIC.DESCRIBE.ELECOURMALINE = "It contains the power of electricity and creation."
--S_______WILLOW.DESCRIBE.ELECOURMALINE = "Oh! So cute, like my Bernie."
--S_____WOLFGANG.DESCRIBE.ELECOURMALINE = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.ELECOURMALINE = "Baby's always so cute, grown one's not."
S_________WX78.DESCRIBE.ELECOURMALINE = "I CAN CHARGE MYSELF WITH JUST A LITTLE PIECE."
S_WICKERBOTTOM.DESCRIBE.ELECOURMALINE = "I heard that the stone will discharge when heated."
--S_______WOODIE.DESCRIBE.ELECOURMALINE = "The axe that can't chop is not a good axe."
S______WAXWELL.DESCRIBE.ELECOURMALINE = "Another of Them is coming. Great."
--S___WATHGRITHR.DESCRIBE.ELECOURMALINE = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.ELECOURMALINE = "We don't want to grow up, do you?"
--S_______WINONA.DESCRIBE.ELECOURMALINE = "Great to cool off after some hard physical labor."

S_NAMES.ELECOURMALINE_KEYSTONE = "Key Stone"    --要石
S______GENERIC.DESCRIBE.ELECOURMALINE_KEYSTONE = "Natural creativity."
--S_______WILLOW.DESCRIBE.ELECOURMALINE_KEYSTONE = "Oh! So cute, like my Bernie."
--S_____WOLFGANG.DESCRIBE.ELECOURMALINE_KEYSTONE = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.ELECOURMALINE_KEYSTONE = "Baby's always so cute, grown one's not."
--S_________WX78.DESCRIBE.ELECOURMALINE_KEYSTONE = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.ELECOURMALINE_KEYSTONE = "Well, isn't that refreshing?"
S_______WOODIE.DESCRIBE.ELECOURMALINE_KEYSTONE = "Hah. Not as funny as Chaplin."
--S______WAXWELL.DESCRIBE.ELECOURMALINE_KEYSTONE = "Hm... No Monster child, no future trouble."
--S___WATHGRITHR.DESCRIBE.ELECOURMALINE_KEYSTONE = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.ELECOURMALINE_KEYSTONE = "We don't want to grow up, do you?"
S_______WINONA.DESCRIBE.ELECOURMALINE_KEYSTONE = "Neither the Keystone, nor a key thing."

S_NAMES.FIMBUL_AXE = "Fimbul's Axe"    --芬布尔斧
-- S_RECIPE_DESC.FIMBUL_AXE = "Flash and crush!" --这个不能制作
S______GENERIC.DESCRIBE.FIMBUL_AXE = "BOOM SHAKA LAKA!"
--S_______WILLOW.DESCRIBE.FIMBUL_AXE = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.FIMBUL_AXE = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.FIMBUL_AXE = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.FIMBUL_AXE = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.FIMBUL_AXE = "Well, isn't that refreshing?"
S_______WOODIE.DESCRIBE.FIMBUL_AXE = "An axe that can't chop is not a good axe."
--S______WAXWELL.DESCRIBE.FIMBUL_AXE = "Hm... I don't know what I was expecting."
--S___WATHGRITHR.DESCRIBE.FIMBUL_AXE = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.FIMBUL_AXE = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.FIMBUL_AXE = "Great to cool off after some hard physical labor."

S_NAMES.HAT_COWBOY = "Stetson"    --牛仔帽
S_RECIPE_DESC.HAT_COWBOY = "Do you want to be a master of taming?"
S______GENERIC.DESCRIBE.HAT_COWBOY = "Aha! let's riiiiiiide!"
-- S_______WILLOW.DESCRIBE.HAT_COWBOY = ""
-- S_____WOLFGANG.DESCRIBE.HAT_COWBOY = ""
-- S________WENDY.DESCRIBE.HAT_COWBOY = ""
-- S_________WX78.DESCRIBE.HAT_COWBOY = ""
-- S_WICKERBOTTOM.DESCRIBE.HAT_COWBOY = ""
-- S_______WOODIE.DESCRIBE.HAT_COWBOY = ""
-- S______WAXWELL.DESCRIBE.HAT_COWBOY = ""
-- S___WATHGRITHR.DESCRIBE.HAT_COWBOY = ""
-- S_______WEBBER.DESCRIBE.HAT_COWBOY = ""
-- S_______WINONA.DESCRIBE.HAT_COWBOY = ""

S_NAMES.DUALWRENCH = "Dual-Wrench"    --扳手-双用型
S_RECIPE_DESC.DUALWRENCH = "Definitely the wrong way to use it."
S______GENERIC.DESCRIBE.DUALWRENCH = "This is definitely the wrong way to use it."
--S_______WILLOW.DESCRIBE.DUALWRENCH = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.DUALWRENCH = "Wolfgang can eat in one bite!"
S________WENDY.DESCRIBE.DUALWRENCH = "I hope I won't wrench my hand any more."
--S_________WX78.DESCRIBE.DUALWRENCH = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.DUALWRENCH = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.DUALWRENCH = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.DUALWRENCH = "Hm... I don't know what I was expecting."
S___WATHGRITHR.DESCRIBE.DUALWRENCH = "A weapon for workmen, smash!"
S_______WEBBER.DESCRIBE.DUALWRENCH = "Let's not wrench our hands again."
S_______WINONA.DESCRIBE.DUALWRENCH = "My, my! my best wrench!"

S_NAMES.ELECARMET = "Elecarmet"    --莱克阿米特
S______GENERIC.DESCRIBE.ELECARMET = "I thought it was the end, but just the beginning."
--S_______WILLOW.DESCRIBE.ELECARMET = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.ELECARMET = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.ELECARMET = "I used to eat these with Abigail..."
--S_________WX78.DESCRIBE.ELECARMET = "STICK ADDON INSTALLED"
--S_WICKERBOTTOM.DESCRIBE.ELECARMET = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.ELECARMET = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.ELECARMET = "Hm... I don't know what I was expecting."
S___WATHGRITHR.DESCRIBE.ELECARMET = "My greatest enemy, a Fimbul."
--S_______WEBBER.DESCRIBE.ELECARMET = "Yaaay! Popsicle, popsicle!"
--S_______WINONA.DESCRIBE.ELECARMET = "Great to cool off after some hard physical labor."

S_NAMES.TOURMALINECORE = "Tourmaline"    --电气石
S______GENERIC.DESCRIBE.TOURMALINECORE = "Oh my, can I touch it?"
--S_______WILLOW.DESCRIBE.TOURMALINECORE = "Oh! So cute, like my Bernie."
--S_____WOLFGANG.DESCRIBE.TOURMALINECORE = "Wolfgang can eat in one bite!"
--S________WENDY.DESCRIBE.TOURMALINECORE = "Baby's always so cute, grown one's not."
S_________WX78.DESCRIBE.TOURMALINECORE = "THE CORE OF ENERGY, THE ENERGY OF ME!"
--S_WICKERBOTTOM.DESCRIBE.TOURMALINECORE = "Well, isn't that refreshing?"
-- S_______WOODIE.DESCRIBE.TOURMALINECORE = "Hah. Not as funny as Chaplin."
--S______WAXWELL.DESCRIBE.TOURMALINECORE = "Hm... No Monster child, no future trouble."
--S___WATHGRITHR.DESCRIBE.TOURMALINECORE = "I've somehow found a way to make it even LESS appealing!"
--S_______WEBBER.DESCRIBE.TOURMALINECORE = "We don't want to grow up, do you?"
-- S_______WINONA.DESCRIBE.TOURMALINECORE = "Neither the Keystone, nor a key thing."

S_NAMES.ICIRE_ROCK = "Icire Stone"   --鸳鸯石
S_RECIPE_DESC.ICIRE_ROCK = "Heat and cold, two sides of the same coin."
S______GENERIC.DESCRIBE.ICIRE_ROCK =
{
    FROZEN = "Like Snowpiercer.",
    COLD = "Winter is coming.",
    GENERIC = "A precious stone, neither a gem, nor a rock.",
    WARM = "Can spring be far behind?",
    HOT = "Like the heat of the sun.",
}
-- S_______WILLOW.DESCRIBE.ICIRE_ROCK = "This is the opposite of burning."
-- S_____WOLFGANG.DESCRIBE.ICIRE_ROCK = "Wolfgang can eat in one bite!"
-- S________WENDY.DESCRIBE.ICIRE_ROCK = "I can't always escape, I have to face everything."
-- S_________WX78.DESCRIBE.ICIRE_ROCK = "FIREWALL, START!"
-- S_WICKERBOTTOM.DESCRIBE.ICIRE_ROCK = "Well, isn't that refreshing?"
-- S_______WOODIE.DESCRIBE.ICIRE_ROCK = "I'd prefer maple taffy..."
-- S______WAXWELL.DESCRIBE.ICIRE_ROCK = "Hm... I don't know what I was expecting."
-- S___WATHGRITHR.DESCRIBE.ICIRE_ROCK = "Be my mirror, my sword and shield!"
-- S_______WEBBER.DESCRIBE.ICIRE_ROCK = "Yaaay! Popsicle, popsicle!"
-- S_______WINONA.DESCRIBE.ICIRE_ROCK = "Great to cool off after some hard physical labor."

S_NAMES.GUITAR_MIGUEL = "Miguel's guitar"    --米格尔的吉他
S_RECIPE_DESC.GUITAR_MIGUEL = "Become a legendary guitarist."
S______GENERIC.DESCRIBE.GUITAR_MIGUEL = "I'll cross life and death to make you remember me!"
--S_______WILLOW.DESCRIBE.GUITAR_MIGUEL = "This is the opposite of burning."
--S_____WOLFGANG.DESCRIBE.GUITAR_MIGUEL = "Wolfgang can eat in one bite!"
-- S________WENDY.DESCRIBE.GUITAR_MIGUEL = "Hello from the other side, Abigail."
S_________WX78.DESCRIBE.GUITAR_MIGUEL = "IT IS NOT MY FUNCTION TO IMPRESS OTHERS."
--S_WICKERBOTTOM.DESCRIBE.GUITAR_MIGUEL = "Well, isn't that refreshing?"
--S_______WOODIE.DESCRIBE.GUITAR_MIGUEL = "I'd prefer maple taffy..."
--S______WAXWELL.DESCRIBE.GUITAR_MIGUEL = "Hm... I don't know what I was expecting."
-- S___WATHGRITHR.DESCRIBE.GUITAR_MIGUEL = "A weapon for workmen, smash!"
-- S_______WEBBER.DESCRIBE.GUITAR_MIGUEL = "Let's not wrench our hands again."
-- S_______WINONA.DESCRIBE.GUITAR_MIGUEL = "My, my! my best wrench!"

S_NAMES.WEB_HUMP_ITEM = "Territory Mark"    --蛛网标记，物品
S_RECIPE_DESC.WEB_HUMP_ITEM = "Swear your territorial sovereignty!"
S______GENERIC.DESCRIBE.WEB_HUMP_ITEM = "It's not something I would want to use."
-- S_______WILLOW.DESCRIBE.WEB_HUMP_ITEM = "This is the opposite of burning."
-- S_____WOLFGANG.DESCRIBE.WEB_HUMP_ITEM = "Wolfgang can eat in one bite!"
-- S________WENDY.DESCRIBE.WEB_HUMP_ITEM = "Hello from the other side, Abigail."
S_________WX78.DESCRIBE.WEB_HUMP = "OBJECT CLASS: THAUMIEL"
-- S_WICKERBOTTOM.DESCRIBE.WEB_HUMP_ITEM = "Well, isn't that refreshing?"
-- S_______WOODIE.DESCRIBE.WEB_HUMP_ITEM = "I'd prefer maple taffy..."
-- S______WAXWELL.DESCRIBE.WEB_HUMP_ITEM = "Hm... I don't know what I was expecting."
-- S___WATHGRITHR.DESCRIBE.WEB_HUMP_ITEM = "A weapon for workmen, smash!"
S_______WEBBER.DESCRIBE.WEB_HUMP_ITEM = "Indeed, we have too little territory."
-- S_______WINONA.DESCRIBE.WEB_HUMP_ITEM = "My, my! my best wrench!"

S_NAMES.WEB_HUMP = "Territory Mark"    --蛛网标记
S______GENERIC.DESCRIBE.WEB_HUMP =
{
    GENERIC = "That really is too much, spiders!",
    TRYDIGUP = "It's not easy to get rid of this.",
}
-- S_______WILLOW.DESCRIBE.WEB_HUMP = "This is the opposite of burning."
-- S_____WOLFGANG.DESCRIBE.WEB_HUMP = "Wolfgang can eat in one bite!"
-- S________WENDY.DESCRIBE.WEB_HUMP = "Hello from the other side, Abigail."
S_________WX78.DESCRIBE.WEB_HUMP = 
{
    GENERIC = "SPECIAL CONTAINMENT PROCEDURES.",
    TRYDIGUP = "IT CAN NOT BE RELOCATED.",
}
-- S_WICKERBOTTOM.DESCRIBE.WEB_HUMP = "Well, isn't that refreshing?"
-- S_______WOODIE.DESCRIBE.WEB_HUMP = "I'd prefer maple taffy..."
-- S______WAXWELL.DESCRIBE.WEB_HUMP = "Hm... I don't know what I was expecting."
-- S___WATHGRITHR.DESCRIBE.WEB_HUMP = "A weapon for workmen, smash!"
S_______WEBBER.DESCRIBE.WEB_HUMP =
{
    GENERIC = "We are very popular with the residents here.",
    TRYDIGUP = "We got this!",
}
-- S_______WINONA.DESCRIBE.WEB_HUMP = "My, my! my best wrench!"

S_NAMES.SADDLE_BAGGAGE = "Baggage Saddle"    --驮运鞍具
S_RECIPE_DESC.SADDLE_BAGGAGE = "Traditional piggyback transport."
S______GENERIC.DESCRIBE.SADDLE_BAGGAGE = "Hopefully this wont be my friend's last straw."
-- S_______WILLOW.DESCRIBE.SADDLE_BAGGAGE = "This is the opposite of burning."
-- S_____WOLFGANG.DESCRIBE.SADDLE_BAGGAGE = "Wolfgang can eat in one bite!"
-- S________WENDY.DESCRIBE.SADDLE_BAGGAGE = "Hello from the other side, Abigail."
-- S_________WX78.DESCRIBE.SADDLE_BAGGAGE = "NOT MY BUILD FUNCTION TO IMPRESS OTHERS BY MELODY."
-- S_WICKERBOTTOM.DESCRIBE.SADDLE_BAGGAGE = "Well, isn't that refreshing?"
-- S_______WOODIE.DESCRIBE.SADDLE_BAGGAGE = "I'd prefer maple taffy..."
-- S______WAXWELL.DESCRIBE.SADDLE_BAGGAGE = "Hm... I don't know what I was expecting."
-- S___WATHGRITHR.DESCRIBE.SADDLE_BAGGAGE = "A weapon for workmen, smash!"
-- S_______WEBBER.DESCRIBE.SADDLE_BAGGAGE = "Indeed, we have too little territory."
-- S_______WINONA.DESCRIBE.SADDLE_BAGGAGE = "My, my! my best wrench!"

S_NAMES.TRIPLESHOVELAXE = "Triple-shovelaxe" --斧铲-三用型
S_RECIPE_DESC.TRIPLESHOVELAXE = "A low-cost multi-functional tool."
S______GENERIC.DESCRIBE.TRIPLESHOVELAXE = "Oh my, this tool is soooooo good!"
-- S_______WILLOW.DESCRIBE.TRIPLESHOVELAXE = ""
-- S_____WOLFGANG.DESCRIBE.TRIPLESHOVELAXE = ""
-- S________WENDY.DESCRIBE.TRIPLESHOVELAXE = ""
S_________WX78.DESCRIBE.TRIPLESHOVELAXE = "IT'S JUST A COMBINATION TOOL."
-- S_WICKERBOTTOM.DESCRIBE.TRIPLESHOVELAXE = ""
S_______WOODIE.DESCRIBE.TRIPLESHOVELAXE = "Even the best axe can't replace Lucy."
-- S______WAXWELL.DESCRIBE.TRIPLESHOVELAXE = ""
-- S___WATHGRITHR.DESCRIBE.TRIPLESHOVELAXE = ""
-- S_______WEBBER.DESCRIBE.TRIPLESHOVELAXE = ""
-- S_______WINONA.DESCRIBE.TRIPLESHOVELAXE = ""
-- S_______WORTOX.DESCRIBE.TRIPLESHOVELAXE = ""
S_____WORMWOOD.DESCRIBE.TRIPLESHOVELAXE = "Ugh, a sharp weapon of the nature destroyer."
-- S________WARLY.DESCRIBE.TRIPLESHOVELAXE = ""
-- S_________WURT.DESCRIBE.TRIPLESHOVELAXE = ""
-- S_______WALTER.DESCRIBE.TRIPLESHOVELAXE = ""
S________WANDA.DESCRIBE.TRIPLESHOVELAXE = "I will prepare what I need another time."

S_NAMES.TRIPLEGOLDENSHOVELAXE = "Snazzy Triple-shovelaxe" --斧铲-黄金三用型
S_RECIPE_DESC.TRIPLEGOLDENSHOVELAXE = "Extremely durable multi-functional tool."
S______GENERIC.DESCRIBE.TRIPLEGOLDENSHOVELAXE = "Oh my, this tool is soooooo perfect!"
-- S_______WILLOW.DESCRIBE.TRIPLEGOLDENSHOVELAXE = ""
S_____WOLFGANG.DESCRIBE.TRIPLEGOLDENSHOVELAXE = "Wolfgang is ready to make a big splash!"
-- S________WENDY.DESCRIBE.TRIPLEGOLDENSHOVELAXE = ""
-- S_________WX78.DESCRIBE.TRIPLEGOLDENSHOVELAXE = ""
S_WICKERBOTTOM.DESCRIBE.TRIPLEGOLDENSHOVELAXE = "What a conveniant wilderness survival tool!"
S_______WOODIE.DESCRIBE.TRIPLEGOLDENSHOVELAXE = "It's amazing! Oh, I hope Lucy didn't hear it."
-- S______WAXWELL.DESCRIBE.TRIPLEGOLDENSHOVELAXE = ""
-- S___WATHGRITHR.DESCRIBE.TRIPLEGOLDENSHOVELAXE = ""
-- S_______WEBBER.DESCRIBE.TRIPLEGOLDENSHOVELAXE = ""
S_______WINONA.DESCRIBE.TRIPLEGOLDENSHOVELAXE = "I should have more of these in my toolbox."
-- S_______WORTOX.DESCRIBE.TRIPLEGOLDENSHOVELAXE = ""
S_____WORMWOOD.DESCRIBE.TRIPLEGOLDENSHOVELAXE = "Cursed, throw it away!"
S________WARLY.DESCRIBE.TRIPLEGOLDENSHOVELAXE = "Devours natural resources like a cake!"
-- S_________WURT.DESCRIBE.TRIPLEGOLDENSHOVELAXE = ""
-- S_______WALTER.DESCRIBE.TRIPLEGOLDENSHOVELAXE = ""
S________WANDA.DESCRIBE.TRIPLEGOLDENSHOVELAXE = "I don't mind taking one with me."

S_NAMES.HAT_ALBICANS_MUSHROOM = "Albicans Funcap"    --素白蘑菇帽
S_RECIPE_DESC.HAT_ALBICANS_MUSHROOM = "Let lots of antibiotics stick to your head."
S______GENERIC.DESCRIBE.HAT_ALBICANS_MUSHROOM =
{
    GENERIC = "A hat made of antibiotic-rich fungi.",
    HUNGER = "I'm too hungry, I don't have the energy to do this.",
}
-- S_______WILLOW.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
-- S_____WOLFGANG.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
-- S________WENDY.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
S_________WX78.DESCRIBE.HAT_ALBICANS_MUSHROOM =
{
    GENERIC = "SOME CREATURES CROWD OUT OTHERS.",
    HUNGER = "I HAVE RUN OUT OF FUEL!",
}
S_WICKERBOTTOM.DESCRIBE.HAT_ALBICANS_MUSHROOM =
{
    GENERIC = "It has a good resistance to harmful bacteria.",
    HUNGER = "What if someone is allergic to antibiotics.",
}
-- S_______WOODIE.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
-- S______WAXWELL.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
-- S___WATHGRITHR.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
S_______WEBBER.DESCRIBE.HAT_ALBICANS_MUSHROOM =
{
    GENERIC = "The head shakes and the disease escapes.",
    HUNGER = "We are so hungry.",
}
-- S_______WINONA.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
-- S_______WORTOX.DESCRIBE.HAT_ALBICANS_MUSHROOM = ""
S_____WORMWOOD.DESCRIBE.HAT_ALBICANS_MUSHROOM =
{
    GENERIC = "My friends, we are saved.",
    HUNGER = "My stomach is empty!",
}
S________WARLY.DESCRIBE.HAT_ALBICANS_MUSHROOM =
{
    GENERIC = "Can I break a piece and cook it?",
    HUNGER = "Nothing magic is ever done on an empty stomach!",
}
S_________WURT.DESCRIBE.HAT_ALBICANS_MUSHROOM =
{
    GENERIC = "Maybe it can treat plants infected with fungi.",
    HUNGER = "I need fresh food!",
}

S_NAMES.ALBICANS_CAP = "Albicans Cap" --采摘的素白菇
S______GENERIC.DESCRIBE.ALBICANS_CAP = "It's the first time I've seen such delicacies."
-- S_______WILLOW.DESCRIBE.ALBICANS_CAP = ""
-- S_____WOLFGANG.DESCRIBE.ALBICANS_CAP = ""
-- S________WENDY.DESCRIBE.ALBICANS_CAP = ""
-- S_________WX78.DESCRIBE.ALBICANS_CAP = ""
S_WICKERBOTTOM.DESCRIBE.ALBICANS_CAP = "Strange, it should grow deep in the bamboo forest."
-- S_______WOODIE.DESCRIBE.ALBICANS_CAP = ""
-- S______WAXWELL.DESCRIBE.ALBICANS_CAP = ""
-- S___WATHGRITHR.DESCRIBE.ALBICANS_CAP = ""
S_______WEBBER.DESCRIBE.ALBICANS_CAP = "A mushroom wearing a skirt!"
-- S_______WINONA.DESCRIBE.ALBICANS_CAP = ""
S_______WORTOX.DESCRIBE.ALBICANS_CAP = "A sacred mushroom like this doesn't belong here."
-- S_____WORMWOOD.DESCRIBE.ALBICANS_CAP = ""
-- S________WARLY.DESCRIBE.ALBICANS_CAP = ""
-- S_________WURT.DESCRIBE.ALBICANS_CAP = ""
-- S_______WALTER.DESCRIBE.ALBICANS_CAP = ""

S_NAMES.SOUL_CONTRACTS = "Soul Contracts" --灵魂契约
S_RECIPE_DESC.SOUL_CONTRACTS = "To further shackle the soul."
S______GENERIC.DESCRIBE.SOUL_CONTRACTS =
{
    GENERIC = "What devil would have thought of such an evil thing!",
    ONLYONE = "There must be limits to evil!",
}
-- S_______WILLOW.DESCRIBE.SOUL_CONTRACTS = ""
-- S_____WOLFGANG.DESCRIBE.SOUL_CONTRACTS = ""
S________WENDY.DESCRIBE.SOUL_CONTRACTS =
{
    GENERIC = "Roaring, crying, regretting...",
    ONLYONE = "No turning back once my hands are stained.",
}
S_________WX78.DESCRIBE.SOUL_CONTRACTS =
{
    GENERIC = "THIS ENHANCES THE HATE MODULE!",
    ONLYONE = "OVERLOADING THE HATE MODULE!",
}
-- S_WICKERBOTTOM.DESCRIBE.SOUL_CONTRACTS = ""
-- S_______WOODIE.DESCRIBE.SOUL_CONTRACTS = ""
-- S______WAXWELL.DESCRIBE.SOUL_CONTRACTS = ""
-- S___WATHGRITHR.DESCRIBE.SOUL_CONTRACTS = ""
-- S_______WEBBER.DESCRIBE.SOUL_CONTRACTS = ""
-- S_______WINONA.DESCRIBE.SOUL_CONTRACTS = ""
S_______WORTOX.DESCRIBE.SOUL_CONTRACTS =
{
    GENERIC = "Hohoho, I can control my soul self better!",
    ONLYONE = "I don't want to lose myself.",
}
S_____WORMWOOD.DESCRIBE.SOUL_CONTRACTS =
{
    GENERIC = "Similar to the glittering in my chest.",
    ONLYONE = "No need.",
}
-- S________WARLY.DESCRIBE.SOUL_CONTRACTS = ""
S_________WURT.DESCRIBE.SOUL_CONTRACTS =
{
    GENERIC = "Evil, why have you stolen so much love?",
    ONLYONE = "Enough negative emotions.",
}

S_NAMES.EXPLODINGFRUITCAKE = "Exploding Fruitcake" --爆炸水果蛋糕
S_RECIPE_DESC.EXPLODINGFRUITCAKE = "Sweet bomb-bomb, bite or light!"
S______GENERIC.DESCRIBE.EXPLODINGFRUITCAKE = "A gift full of malice."
S_______WILLOW.DESCRIBE.EXPLODINGFRUITCAKE = "It's a firesnacker!"
-- S_____WOLFGANG.DESCRIBE.EXPLODINGFRUITCAKE = ""
S________WENDY.DESCRIBE.EXPLODINGFRUITCAKE = "I did it, so what..."
S_________WX78.DESCRIBE.EXPLODINGFRUITCAKE = "AFTER ANALYSIS: CAN I MAKE THIS?"
S_WICKERBOTTOM.DESCRIBE.EXPLODINGFRUITCAKE = "How to detonate, light it or bite it?"
-- S_______WOODIE.DESCRIBE.EXPLODINGFRUITCAKE = ""
S______WAXWELL.DESCRIBE.EXPLODINGFRUITCAKE = "The world between us..."
S___WATHGRITHR.DESCRIBE.EXPLODINGFRUITCAKE = "Fighting fair and square is my style!"
S_______WEBBER.DESCRIBE.EXPLODINGFRUITCAKE = "Wow, a cake!"
S_______WINONA.DESCRIBE.EXPLODINGFRUITCAKE = "No tact at all. The leads are so obvious!?"
S_______WORTOX.DESCRIBE.EXPLODINGFRUITCAKE = "I wouldn't do a prank that would kill someone!"
S_____WORMWOOD.DESCRIBE.EXPLODINGFRUITCAKE = "Ooo, Sweets!"
S________WARLY.DESCRIBE.EXPLODINGFRUITCAKE = "A sugarcoated bullet, be careful."
-- S_________WURT.DESCRIBE.EXPLODINGFRUITCAKE = ""
-- S_______WALTER.DESCRIBE.EXPLODINGFRUITCAKE = ""
S________WANDA.DESCRIBE.EXPLODINGFRUITCAKE = "Fortunately, I have time to stop this tragedy."

--------------------------------------------------------------------------
--[[ desert secret ]]--[[ 尘市蜃楼 ]]
--------------------------------------------------------------------------

S_NAMES.SHIELD_L_SAND = "Desert Defense"   --砂之抵御
S_RECIPE_DESC.SHIELD_L_SAND = "Use the power of the earth to fight back."
S______GENERIC.DESCRIBE.SHIELD_L_SAND =
{
    GENERIC = "I can feel the power of the earth!",
    WEAK = "Maybe I can't use it in the rain?",
    INSANE = "Maybe I'm too insane?",
}
--S_______WILLOW.DESCRIBE.SHIELD_L_SAND = ""
--S_____WOLFGANG.DESCRIBE.SHIELD_L_SAND = ""
S________WENDY.DESCRIBE.SHIELD_L_SAND = "I can't always escape, I have to face everything."
S_________WX78.DESCRIBE.SHIELD_L_SAND = "FIREWALL, START!"
--S_WICKERBOTTOM.DESCRIBE.SHIELD_L_SAND = ""
--S_______WOODIE.DESCRIBE.SHIELD_L_SAND = ""
--S______WAXWELL.DESCRIBE.SHIELD_L_SAND = ""
S___WATHGRITHR.DESCRIBE.SHIELD_L_SAND = "Be my mirror, my sword and my shield!"
--S_______WEBBER.DESCRIBE.SHIELD_L_SAND = ""
--S_______WINONA.DESCRIBE.SHIELD_L_SAND = ""

S_NAMES.SHYERRYTREE = "Treembling"    --颤栗树
S______GENERIC.DESCRIBE.SHYERRYTREE =
{
    BURNING = "It's on fire!",
    GENERIC = "Is that a tree with only one or two leaves?",
}
-- S_______WILLOW.DESCRIBE.SHYERRYTREE = "This is the opposite of burning."
-- S_____WOLFGANG.DESCRIBE.SHYERRYTREE = "Wolfgang can eat in one bite!"
-- S________WENDY.DESCRIBE.SHYERRYTREE = "Hello from the other side, Abigail."
-- S_________WX78.DESCRIBE.SHYERRYTREE = "NOT MY BUILD FUNCTION TO IMPRESS OTHERS BY MELODY."
S_WICKERBOTTOM.DESCRIBE.SHYERRYTREE =
{
    BURNING = "Don't worry. The fire won't burn the part underground.",
    GENERIC = "In fact, it's not really the trunk that grows outside.",
}
-- S_______WOODIE.DESCRIBE.SHYERRYTREE = "I'd prefer maple taffy..."
-- S______WAXWELL.DESCRIBE.SHYERRYTREE = "Hm... I don't know what I was expecting."
-- S___WATHGRITHR.DESCRIBE.SHYERRYTREE = "A weapon for workmen, smash!"
-- S_______WEBBER.DESCRIBE.SHYERRYTREE = "Indeed, we have too little territory."
-- S_______WINONA.DESCRIBE.SHYERRYTREE = "My, my! my best wrench!"

S_NAMES.SHYERRYTREE_PLANTED = "Treembling Core"    --栽种的颤栗树
S______GENERIC.DESCRIBE.SHYERRYTREE_PLANTED =
{
    BURNING = "The core in burning!",
    GENERIC = "The most important part of the Treembling, it's normally underground!",
}
-- S_______WILLOW.DESCRIBE.SHYERRYTREE_PLANTED = "This is the opposite of burning."
-- S_____WOLFGANG.DESCRIBE.SHYERRYTREE_PLANTED = "Wolfgang can eat in one bite!"
-- S________WENDY.DESCRIBE.SHYERRYTREE_PLANTED = "Hello from the other side, Abigail."
-- S_________WX78.DESCRIBE.SHYERRYTREE_PLANTED = "NOT MY BUILD FUNCTION TO IMPRESS OTHERS BY MELODY."
-- S_WICKERBOTTOM.DESCRIBE.SHYERRYTREE_PLANTED = "Well, isn't that refreshing?"
-- S_______WOODIE.DESCRIBE.SHYERRYTREE_PLANTED = "I'd prefer maple taffy..."
-- S______WAXWELL.DESCRIBE.SHYERRYTREE_PLANTED = "Hm... I don't know what I was expecting."
-- S___WATHGRITHR.DESCRIBE.SHYERRYTREE_PLANTED = "A weapon for workmen, smash!"
-- S_______WEBBER.DESCRIBE.SHYERRYTREE_PLANTED = "Indeed, we have too little territory."
-- S_______WINONA.DESCRIBE.SHYERRYTREE_PLANTED = "My, my! my best wrench!"

S_NAMES.SHYERRYFLOWER = "Abloom Treembling"    --颤栗花
S______GENERIC.DESCRIBE.SHYERRYFLOWER =
{
    BURNING = "A precious flower in burning!",
    GENERIC = "A blooming treembling, don't scare it!",
}
-- S_______WILLOW.DESCRIBE.SHYERRYFLOWER = "This is the opposite of burning."
-- S_____WOLFGANG.DESCRIBE.SHYERRYFLOWER = "Wolfgang can eat in one bite!"
-- S________WENDY.DESCRIBE.SHYERRYFLOWER = "Hello from the other side, Abigail."
-- S_________WX78.DESCRIBE.SHYERRYFLOWER = "NOT MY BUILD FUNCTION TO IMPRESS OTHERS BY MELODY."
S_WICKERBOTTOM.DESCRIBE.SHYERRYFLOWER =
{
    BURNING = "Unfortunately, this tree rarely bears fruit.",
    GENERIC = "In fact, the part that looks like flower isn't a real flower.",
}
-- S_______WOODIE.DESCRIBE.SHYERRYFLOWER = "I'd prefer maple taffy..."
-- S______WAXWELL.DESCRIBE.SHYERRYFLOWER = "Hm... I don't know what I was expecting."
-- S___WATHGRITHR.DESCRIBE.SHYERRYFLOWER = "A weapon for workmen, smash!"
-- S_______WEBBER.DESCRIBE.SHYERRYFLOWER = "Indeed, we have too little territory."
-- S_______WINONA.DESCRIBE.SHYERRYFLOWER = "My, my! my best wrench!"

S_NAMES.SHYERRY = "Shyerry"    --颤栗果
S______GENERIC.DESCRIBE.SHYERRY = "Wow, what a big blueberry!"
-- S_______WILLOW.DESCRIBE.SHYERRY = "This is the opposite of burning."
-- S_____WOLFGANG.DESCRIBE.SHYERRY = "Wolfgang can eat in one bite!"
-- S________WENDY.DESCRIBE.SHYERRY = "Hello from the other side, Abigail."
-- S_________WX78.DESCRIBE.SHYERRY = "NOT MY BUILD FUNCTION TO IMPRESS OTHERS BY MELODY."
S_WICKERBOTTOM.DESCRIBE.SHYERRY = "Rich in nutrition, good for your health."
-- S_______WOODIE.DESCRIBE.SHYERRY = "I'd prefer maple taffy..."
-- S______WAXWELL.DESCRIBE.SHYERRY = "Hm... I don't know what I was expecting."
-- S___WATHGRITHR.DESCRIBE.SHYERRY = "A weapon for workmen, smash!"
-- S_______WEBBER.DESCRIBE.SHYERRY = "Indeed, we have too little territory."
-- S_______WINONA.DESCRIBE.SHYERRY = "My, my! my best wrench!"

S_NAMES.SHYERRY_COOKED = "Roasted Shyerry"    --烤颤栗果
S______GENERIC.DESCRIBE.SHYERRY_COOKED = "Wow, it looks like a blue orange!"
-- S_______WILLOW.DESCRIBE.SHYERRY_COOKED = "This is the opposite of burning."
-- S_____WOLFGANG.DESCRIBE.SHYERRY_COOKED = "Wolfgang can eat in one bite!"
-- S________WENDY.DESCRIBE.SHYERRY_COOKED = "Hello from the other side, Abigail."
-- S_________WX78.DESCRIBE.SHYERRY_COOKED = "NOT MY BUILD FUNCTION TO IMPRESS OTHERS BY MELODY."
S_WICKERBOTTOM.DESCRIBE.SHYERRY_COOKED = "Well, the nutrients were all decomposed."
-- S_______WOODIE.DESCRIBE.SHYERRY_COOKED = "I'd prefer maple taffy..."
-- S______WAXWELL.DESCRIBE.SHYERRY_COOKED = "Hm... I don't know what I was expecting."
-- S___WATHGRITHR.DESCRIBE.SHYERRY_COOKED = "A weapon for workmen, smash!"
-- S_______WEBBER.DESCRIBE.SHYERRY_COOKED = "Indeed, we have too little territory."
-- S_______WINONA.DESCRIBE.SHYERRY_COOKED = "My, my! my best wrench!"

S_NAMES.SHYERRYLOG = "Big Plancon"    --宽大的木墩
S______GENERIC.DESCRIBE.SHYERRYLOG =
{
    BURNING = "It's going to be a big fire.",
    GENERIC = "Suitable for woodworking.",
}
-- S_______WILLOW.DESCRIBE.SHYERRYLOG = "This is the opposite of burning."
-- S_____WOLFGANG.DESCRIBE.SHYERRYLOG = "Wolfgang can eat in one bite!"
-- S________WENDY.DESCRIBE.SHYERRYLOG = "Hello from the other side, Abigail."
-- S_________WX78.DESCRIBE.SHYERRYLOG = "NOT MY BUILD FUNCTION TO IMPRESS OTHERS BY MELODY."
-- S_WICKERBOTTOM.DESCRIBE.SHYERRYLOG = "Well, isn't that refreshing?"
-- S_______WOODIE.DESCRIBE.SHYERRYLOG = "I'd prefer maple taffy..."
-- S______WAXWELL.DESCRIBE.SHYERRYLOG = "Hm... I don't know what I was expecting."
-- S___WATHGRITHR.DESCRIBE.SHYERRYLOG = "A weapon for workmen, smash!"
-- S_______WEBBER.DESCRIBE.SHYERRYLOG = "Indeed, we have too little territory."
-- S_______WINONA.DESCRIBE.SHYERRYLOG = "My, my! my best wrench!"

-- S_NAMES.FENCE_SHYERRY = "Pastoral Fence"    --田园栅栏
-- S______GENERIC.DESCRIBE.FENCE_SHYERRY = "Disappointing, it's no different from ordinary fences."
-- S_______WILLOW.DESCRIBE.FENCE_SHYERRY = ""
-- S_____WOLFGANG.DESCRIBE.FENCE_SHYERRY = ""
-- S________WENDY.DESCRIBE.FENCE_SHYERRY = ""
-- S_________WX78.DESCRIBE.FENCE_SHYERRY = ""
-- S_WICKERBOTTOM.DESCRIBE.FENCE_SHYERRY = ""
-- S_______WOODIE.DESCRIBE.FENCE_SHYERRY = ""
-- S______WAXWELL.DESCRIBE.FENCE_SHYERRY = ""
-- S___WATHGRITHR.DESCRIBE.FENCE_SHYERRY = ""
-- S_______WEBBER.DESCRIBE.FENCE_SHYERRY = ""
-- S_______WINONA.DESCRIBE.FENCE_SHYERRY = ""
-- S_______WORTOX.DESCRIBE.FENCE_SHYERRY = ""
-- S_____WORMWOOD.DESCRIBE.FENCE_SHYERRY = ""
-- S________WARLY.DESCRIBE.FENCE_SHYERRY = ""
-- S_________WURT.DESCRIBE.FENCE_SHYERRY = ""

-- S_NAMES.FENCE_SHYERRY_ITEM = "Pastoral Fence"    --田园栅栏 item
-- S_RECIPE_DESC.FENCE_SHYERRY_ITEM = "Surround your farmland."
-- S______GENERIC.DESCRIBE.FENCE_SHYERRY_ITEM = "Will the place surrounded by it become farmland?"
-- S_______WILLOW.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- S_____WOLFGANG.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- S________WENDY.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- S_________WX78.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- S_WICKERBOTTOM.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- S_______WOODIE.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- S______WAXWELL.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- S___WATHGRITHR.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- S_______WEBBER.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- S_______WINONA.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- S_______WORTOX.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- S_____WORMWOOD.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- S________WARLY.DESCRIBE.FENCE_SHYERRY_ITEM = ""
-- S_________WURT.DESCRIBE.FENCE_SHYERRY_ITEM = ""

S_NAMES.GUITAR_WHITEWOOD = "White Wood Guitar"    --白木吉他
S_RECIPE_DESC.GUITAR_WHITEWOOD = "A guitar, waiting to be played."
S______GENERIC.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "I really just want to play to you.",
    FAILED = "Oops, slow down a beat.",
    HUNGRY = "Too tired to play.",
}
-- S_______WILLOW.DESCRIBE.GUITAR_WHITEWOOD = ""
-- S_____WOLFGANG.DESCRIBE.GUITAR_WHITEWOOD = ""
S________WENDY.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "Abigail tried, but she didn't have that talent, hah.",
    FAILED = "It's about the consistency of the beat.",
    HUNGRY = "Hunger affects my melody.",
}
S_________WX78.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "THOSE PRIMITIVE CREATURES LOVE IT.",
    FAILED = "WHY AM I THE ONE TO COOPERATE WITH.",
    HUNGRY = "LOW POWER, LIMITED FUNCTION.",
}
S_WICKERBOTTOM.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "Only four strings? Not enough to play it alone.",
    FAILED = "My cooperation is not perfect.",
    HUNGRY = "Not in the mood for this.",
}
-- S_______WOODIE.DESCRIBE.GUITAR_WHITEWOOD = ""
S______WAXWELL.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "The violin is more elegant.",
    FAILED = "Well, I'm an assistant now?",
    HUNGRY = "Now, time for me to eat, the others can play.",
}
-- S___WATHGRITHR.DESCRIBE.GUITAR_WHITEWOOD = ""
-- S_______WEBBER.DESCRIBE.GUITAR_WHITEWOOD = ""
S_______WINONA.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "It's missing the scale.",
    FAILED = "Sorry I didn't catch up, try again?",
    HUNGRY = "How can you work if you are hungry!",
}
S_______WORTOX.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "Hee hee, that's why humans interest me so much.",
    FAILED = "Hah, this is so funny.",
    HUNGRY = "Hey! that's not what's pressing.",
}
-- S_____WORMWOOD.DESCRIBE.GUITAR_WHITEWOOD = ""
-- S________WARLY.DESCRIBE.GUITAR_WHITEWOOD = ""
-- S_________WURT.DESCRIBE.GUITAR_WHITEWOOD = ""
S_______WALTER.DESCRIBE.GUITAR_WHITEWOOD =
{
    GENERIC = "You'll be surprised. I could play it when I was three.",
    FAILED = "Don't give up. I'll get it right next time.",
    HUNGRY = "And that's the dinner bell.",
}

-- S_NAMES.TOY_SPONGEBOB = "Spongebob Toy"    --玩具小海绵
-- S______GENERIC.DESCRIBE.TOY_SPONGEBOB = "Who is it waiting for?"
-- S_______WILLOW.DESCRIBE.TOY_SPONGEBOB = ""
-- S_____WOLFGANG.DESCRIBE.TOY_SPONGEBOB = ""
-- S________WENDY.DESCRIBE.TOY_SPONGEBOB = "The flower falls, the spring goes."
-- S_________WX78.DESCRIBE.TOY_SPONGEBOB = ""
-- S_WICKERBOTTOM.DESCRIBE.TOY_SPONGEBOB = "It says that there is no place to vent one's enthusiasm."
-- S_______WOODIE.DESCRIBE.TOY_SPONGEBOB = "It also looks forward to the future, that embracing day."
-- S______WAXWELL.DESCRIBE.TOY_SPONGEBOB = "Life is so long, used to be with loneliness."
-- S___WATHGRITHR.DESCRIBE.TOY_SPONGEBOB = "I'm not looking for somebody with some superhuman gifts."
-- S_______WEBBER.DESCRIBE.TOY_SPONGEBOB = "Love it."
-- S_______WINONA.DESCRIBE.TOY_SPONGEBOB = ""
-- S_______WORTOX.DESCRIBE.TOY_SPONGEBOB = ""
-- S_____WORMWOOD.DESCRIBE.TOY_SPONGEBOB = ""
-- S________WARLY.DESCRIBE.TOY_SPONGEBOB = "Just something I can turn to, somebody I can kiss."
-- S_________WURT.DESCRIBE.TOY_SPONGEBOB = ""
-- S_______WALTER.DESCRIBE.TOY_SPONGEBOB = ""

-- S_NAMES.TOY_PATRICKSTAR = "Patrickstar Toy"    --玩具小海星
-- S______GENERIC.DESCRIBE.TOY_PATRICKSTAR = "Moving towards its goal."
-- S_______WILLOW.DESCRIBE.TOY_PATRICKSTAR = ""
-- S_____WOLFGANG.DESCRIBE.TOY_PATRICKSTAR = ""
-- S________WENDY.DESCRIBE.TOY_PATRICKSTAR = "Someone I miss is far away."
-- S_________WX78.DESCRIBE.TOY_PATRICKSTAR = ""
-- S_WICKERBOTTOM.DESCRIBE.TOY_PATRICKSTAR = "It says that time always fades everything."
-- S_______WOODIE.DESCRIBE.TOY_PATRICKSTAR = "It is also full of contradictions, sometimes at a loss."
-- S______WAXWELL.DESCRIBE.TOY_PATRICKSTAR = "Life is so short, hard and ordinary."
-- S___WATHGRITHR.DESCRIBE.TOY_PATRICKSTAR = ""
-- S_______WEBBER.DESCRIBE.TOY_PATRICKSTAR = "Adore it."
-- S_______WINONA.DESCRIBE.TOY_PATRICKSTAR = ""
-- S_______WORTOX.DESCRIBE.TOY_PATRICKSTAR = ""
-- S_____WORMWOOD.DESCRIBE.TOY_PATRICKSTAR = ""
-- S________WARLY.DESCRIBE.TOY_PATRICKSTAR = ""
-- S_________WURT.DESCRIBE.TOY_PATRICKSTAR = ""
-- S_______WALTER.DESCRIBE.TOY_PATRICKSTAR = ""

S_NAMES.PINKSTAFF = "Illusion Staff"    --幻象法杖
S_RECIPE_DESC.PINKSTAFF = "Illusion can provide eternal beauty."
S______GENERIC.DESCRIBE.PINKSTAFF = "Is this real? It might be an illusion."
-- S_______WILLOW.DESCRIBE.PINKSTAFF = ""
-- S_____WOLFGANG.DESCRIBE.PINKSTAFF = ""
-- S________WENDY.DESCRIBE.PINKSTAFF = ""
-- S_________WX78.DESCRIBE.PINKSTAFF = ""
-- S_WICKERBOTTOM.DESCRIBE.PINKSTAFF = ""
-- S_______WOODIE.DESCRIBE.PINKSTAFF = ""
-- S______WAXWELL.DESCRIBE.PINKSTAFF = ""
-- S___WATHGRITHR.DESCRIBE.PINKSTAFF = ""
-- S_______WEBBER.DESCRIBE.PINKSTAFF = ""
-- S_______WINONA.DESCRIBE.PINKSTAFF = ""
-- S_______WORTOX.DESCRIBE.PINKSTAFF = ""
-- S_____WORMWOOD.DESCRIBE.PINKSTAFF = ""
-- S________WARLY.DESCRIBE.PINKSTAFF = ""
-- S_________WURT.DESCRIBE.PINKSTAFF = ""
-- S_______WALTER.DESCRIBE.PINKSTAFF = ""

S_NAMES.THEEMPERORSCROWN = "The Emperor's Crown"  --皇帝的王冠
S_RECIPE_DESC.THEEMPERORSCROWN = "The symbol of sagacity."
S______GENERIC.DESCRIBE.THEEMPERORSCROWN = "A wise man won't believe this symbol."
-- S_______WILLOW.DESCRIBE.THEEMPERORSCROWN = ""
-- S_____WOLFGANG.DESCRIBE.THEEMPERORSCROWN = ""
-- S________WENDY.DESCRIBE.THEEMPERORSCROWN = ""
-- S_________WX78.DESCRIBE.THEEMPERORSCROWN = ""
-- S_WICKERBOTTOM.DESCRIBE.THEEMPERORSCROWN = ""
-- S_______WOODIE.DESCRIBE.THEEMPERORSCROWN = ""
-- S______WAXWELL.DESCRIBE.THEEMPERORSCROWN = ""
-- S___WATHGRITHR.DESCRIBE.THEEMPERORSCROWN = ""
-- S_______WEBBER.DESCRIBE.THEEMPERORSCROWN = ""
-- S_______WINONA.DESCRIBE.THEEMPERORSCROWN = ""
-- S_______WORTOX.DESCRIBE.THEEMPERORSCROWN = ""
-- S_____WORMWOOD.DESCRIBE.THEEMPERORSCROWN = ""
-- S________WARLY.DESCRIBE.THEEMPERORSCROWN = ""
-- S_________WURT.DESCRIBE.THEEMPERORSCROWN = ""
-- S_______WALTER.DESCRIBE.THEEMPERORSCROWN = ""

S_NAMES.THEEMPERORSMANTLE = "The Emperor's Mantle"    --皇帝的披风
S_RECIPE_DESC.THEEMPERORSMANTLE = "The symbol of gallantry."
S______GENERIC.DESCRIBE.THEEMPERORSMANTLE = "A fearless man won't believe this symbol."
-- S_______WILLOW.DESCRIBE.THEEMPERORSMANTLE = ""
-- S_____WOLFGANG.DESCRIBE.THEEMPERORSMANTLE = ""
-- S________WENDY.DESCRIBE.THEEMPERORSMANTLE = ""
-- S_________WX78.DESCRIBE.THEEMPERORSMANTLE = ""
-- S_WICKERBOTTOM.DESCRIBE.THEEMPERORSMANTLE = ""
-- S_______WOODIE.DESCRIBE.THEEMPERORSMANTLE = ""
-- S______WAXWELL.DESCRIBE.THEEMPERORSMANTLE = ""
-- S___WATHGRITHR.DESCRIBE.THEEMPERORSMANTLE = ""
-- S_______WEBBER.DESCRIBE.THEEMPERORSMANTLE = ""
-- S_______WINONA.DESCRIBE.THEEMPERORSMANTLE = ""
-- S_______WORTOX.DESCRIBE.THEEMPERORSMANTLE = ""
-- S_____WORMWOOD.DESCRIBE.THEEMPERORSMANTLE = ""
-- S________WARLY.DESCRIBE.THEEMPERORSMANTLE = ""
-- S_________WURT.DESCRIBE.THEEMPERORSMANTLE = ""
-- S_______WALTER.DESCRIBE.THEEMPERORSMANTLE = ""

S_NAMES.THEEMPERORSSCEPTER = "The Emperor's Scepter"  --皇帝的权杖
S_RECIPE_DESC.THEEMPERORSSCEPTER = "The symbol of a dignitary."
S______GENERIC.DESCRIBE.THEEMPERORSSCEPTER = "A guileless man won't believe this symbol."
-- S_______WILLOW.DESCRIBE.THEEMPERORSSCEPTER = ""
-- S_____WOLFGANG.DESCRIBE.THEEMPERORSSCEPTER = ""
-- S________WENDY.DESCRIBE.THEEMPERORSSCEPTER = ""
-- S_________WX78.DESCRIBE.THEEMPERORSSCEPTER = ""
-- S_WICKERBOTTOM.DESCRIBE.THEEMPERORSSCEPTER = ""
-- S_______WOODIE.DESCRIBE.THEEMPERORSSCEPTER = ""
-- S______WAXWELL.DESCRIBE.THEEMPERORSSCEPTER = ""
-- S___WATHGRITHR.DESCRIBE.THEEMPERORSSCEPTER = ""
-- S_______WEBBER.DESCRIBE.THEEMPERORSSCEPTER = ""
-- S_______WINONA.DESCRIBE.THEEMPERORSSCEPTER = ""
-- S_______WORTOX.DESCRIBE.THEEMPERORSSCEPTER = ""
-- S_____WORMWOOD.DESCRIBE.THEEMPERORSSCEPTER = ""
-- S________WARLY.DESCRIBE.THEEMPERORSSCEPTER = ""
-- S_________WURT.DESCRIBE.THEEMPERORSSCEPTER = ""
-- S_______WALTER.DESCRIBE.THEEMPERORSSCEPTER = ""

S_NAMES.THEEMPERORSPENDANT = "The Emperor's Pendant" --皇帝的吊坠
S_RECIPE_DESC.THEEMPERORSPENDANT = "The symbol of will."
S______GENERIC.DESCRIBE.THEEMPERORSPENDANT = "A determined man won't believe this symbol."
-- S_______WILLOW.DESCRIBE.THEEMPERORSPENDANT = ""
-- S_____WOLFGANG.DESCRIBE.THEEMPERORSPENDANT = ""
-- S________WENDY.DESCRIBE.THEEMPERORSPENDANT = ""
-- S_________WX78.DESCRIBE.THEEMPERORSPENDANT = ""
-- S_WICKERBOTTOM.DESCRIBE.THEEMPERORSPENDANT = ""
-- S_______WOODIE.DESCRIBE.THEEMPERORSPENDANT = ""
-- S______WAXWELL.DESCRIBE.THEEMPERORSPENDANT = ""
-- S___WATHGRITHR.DESCRIBE.THEEMPERORSPENDANT = ""
-- S_______WEBBER.DESCRIBE.THEEMPERORSPENDANT = ""
-- S_______WINONA.DESCRIBE.THEEMPERORSPENDANT = ""
-- S_______WORTOX.DESCRIBE.THEEMPERORSPENDANT = ""
-- S_____WORMWOOD.DESCRIBE.THEEMPERORSPENDANT = ""
-- S________WARLY.DESCRIBE.THEEMPERORSPENDANT = ""
-- S_________WURT.DESCRIBE.THEEMPERORSPENDANT = ""
-- S_______WALTER.DESCRIBE.THEEMPERORSPENDANT = ""

S_NAMES.MAT_WHITEWOOD_ITEM = "White Wood Chip" --白木地片
S_RECIPE_DESC.MAT_WHITEWOOD_ITEM = "Gives your feet a nice woody feel."
S______GENERIC.DESCRIBE.MAT_WHITEWOOD_ITEM = "White wood chips for decorating the ground."
-- S_______WILLOW.DESCRIBE.MAT_WHITEWOOD_ITEM = ""
-- S_____WOLFGANG.DESCRIBE.MAT_WHITEWOOD_ITEM = ""
-- S________WENDY.DESCRIBE.MAT_WHITEWOOD_ITEM = ""
-- S_________WX78.DESCRIBE.MAT_WHITEWOOD_ITEM = ""
-- S_WICKERBOTTOM.DESCRIBE.MAT_WHITEWOOD_ITEM = ""
-- S_______WOODIE.DESCRIBE.MAT_WHITEWOOD_ITEM = ""
S______WAXWELL.DESCRIBE.MAT_WHITEWOOD_ITEM = "A layer of cushion makes me feel more down-to-earth."
-- S___WATHGRITHR.DESCRIBE.MAT_WHITEWOOD_ITEM = ""
-- S_______WEBBER.DESCRIBE.MAT_WHITEWOOD_ITEM = ""
-- S_______WINONA.DESCRIBE.MAT_WHITEWOOD_ITEM = ""
-- S_______WORTOX.DESCRIBE.MAT_WHITEWOOD_ITEM = ""
-- S_____WORMWOOD.DESCRIBE.MAT_WHITEWOOD_ITEM = ""
-- S________WARLY.DESCRIBE.MAT_WHITEWOOD_ITEM = ""
-- S_________WURT.DESCRIBE.MAT_WHITEWOOD_ITEM = ""
-- S_______WALTER.DESCRIBE.MAT_WHITEWOOD_ITEM = ""
-- S________WANDA.DESCRIBE.MAT_WHITEWOOD_ITEM = ""

S_NAMES.CARPET_WHITEWOOD = "White Wood Mat" --白木地垫
S_RECIPE_DESC.CARPET_WHITEWOOD = "A simple wooden mat."

S_NAMES.CARPET_WHITEWOOD_BIG = "White Wood Carpet" --白木地毯
S_RECIPE_DESC.CARPET_WHITEWOOD_BIG = "A large wooden carpet."

S_NAMES.CARPET_PLUSH = "Plush Mat" --线绒地垫
S_RECIPE_DESC.CARPET_PLUSH = "A simple fluffy mat."

S_NAMES.CARPET_PLUSH_BIG = "Plush Carpet" --线绒地毯
S_RECIPE_DESC.CARPET_PLUSH_BIG = "A large fluffy carpet."

S_NAMES.CARPET_SIVING = "Hard Rock Mat" --棱石地垫
S_RECIPE_DESC.CARPET_SIVING = "A rocky mat."

S_NAMES.CARPET_SIVING_BIG = "Hard Rock Carpet" --棱石地毯
S_RECIPE_DESC.CARPET_SIVING_BIG = "A large rocky carpet."

--------------------------------------------------------------------------
--[[ other ]]--[[ 其他 ]]
--------------------------------------------------------------------------

S_NAMES.BACKCUB = "Back Cub"    --靠背熊
S______GENERIC.DESCRIBE.BACKCUB = "Hey, I think it likes my back."
S_______WILLOW.DESCRIBE.BACKCUB = "Oh! So cute, like my Bernie."
--S_____WOLFGANG.DESCRIBE.BACKCUB = ""
S________WENDY.DESCRIBE.BACKCUB = "It's babies are always so cute, now the adults are a different story."
--S_________WX78.DESCRIBE.BACKCUB = ""
--S_WICKERBOTTOM.DESCRIBE.BACKCUB = ""
--S_______WOODIE.DESCRIBE.BACKCUB = ""
S______WAXWELL.DESCRIBE.BACKCUB = "Hm... with no monster child there'd be no future trouble..."
--S___WATHGRITHR.DESCRIBE.BACKCUB = ""
S_______WEBBER.DESCRIBE.BACKCUB = "We don't want to grow up, do you?"
-- S_______WINONA.DESCRIBE.BACKCUB = ""
-- S_______WORTOX.DESCRIBE.BACKCUB = ""
-- S_____WORMWOOD.DESCRIBE.BACKCUB = ""

S_NAMES.SHIELD_L_LOG = "Log Shield" --木盾
S_RECIPE_DESC.SHIELD_L_LOG = "The first attempt at defense and counterattack."
S______GENERIC.DESCRIBE.SHIELD_L_LOG = "What a humble shield. It may work."
-- S_______WILLOW.DESCRIBE.SHIELD_L_LOG = ""
S_____WOLFGANG.DESCRIBE.SHIELD_L_LOG = "The pattern on it is a little artistic."
-- S________WENDY.DESCRIBE.SHIELD_L_LOG = ""
-- S_________WX78.DESCRIBE.SHIELD_L_LOG = ""
-- S_WICKERBOTTOM.DESCRIBE.SHIELD_L_LOG = ""
S_______WOODIE.DESCRIBE.SHIELD_L_LOG = "Not too handy."
S______WAXWELL.DESCRIBE.SHIELD_L_LOG = "I'm not going to wave around this ridiculous shield."
S___WATHGRITHR.DESCRIBE.SHIELD_L_LOG = "A new fighting idea for a warrior!"
-- S_______WEBBER.DESCRIBE.SHIELD_L_LOG = ""
-- S_______WINONA.DESCRIBE.SHIELD_L_LOG = ""
S_______WORTOX.DESCRIBE.SHIELD_L_LOG = "I just slip away when I can't hide, so I don't need this."
S_____WORMWOOD.DESCRIBE.SHIELD_L_LOG = "Friends' body has become my barrier."
-- S________WARLY.DESCRIBE.SHIELD_L_LOG = ""
-- S_________WURT.DESCRIBE.SHIELD_L_LOG = ""
-- S_______WALTER.DESCRIBE.SHIELD_L_LOG = ""
-- S________WANDA.DESCRIBE.SHIELD_L_LOG = ""

STRINGS.ACTIONS_LEGION = {
    PLAYGUITAR = "Play", --弹琴动作的名字
    STORE_BEEF_L = "Store", --右键给予牛物品动作的名字
    FEED_BEEF_L = "Feed", --左键给牛喂食
    RETURN_CONTRACTS = "Exact", --从契约书索取灵魂的名字
    PICKUP_CONTRACTS = "Put away", --捡起契约书的名字
    GIVE_CONTRACTS = "Give", --给予灵魂给契约书的名字
    PULLOUTSWORD = "Pull out", --拔剑出鞘动作的名字
    USE_UPGRADEKIT = "Assemble upgrade", --升级套件的升级动作的名字
    MAKE = "Make", --打窝器容器的按钮名字
    ATTACK_SHIELD_L = "Protective attack", --盾牌类道具通用动作的名字
    REMOVE_CARPET_L = "Fork away", --移除地毯动作的名字
}
STRINGS.ACTIONS.GIVE.SCABBARD = "Put into"  --青枝绿叶放入武器的名字
STRINGS.ACTIONS.PICK.GENETRANS = "Take down"  --收获子圭·育的名字

STRINGS.ACTIONS.OPEN_CRAFTING.RECAST = "Brainstorm with" --靠近解锁时的前置提示。名字与AddPrototyperDef里的action_str一致
STRINGS.UI.CRAFTING_STATION_FILTERS.RECAST = "Recast"
STRINGS.UI.CRAFTING_FILTERS.RECAST = "Recast"

--NEEDS..新tech的名字
STRINGS.UI.CRAFTING.NEEDSELECOURMALINE_ONE = "Find the Elecourmaline to build this!"
STRINGS.UI.CRAFTING.NEEDSELECOURMALINE_TWO = "It seems that this stone is not fully activated!"
STRINGS.UI.CRAFTING.NEEDSELECOURMALINE_THREE = "Find an activated Elecourmaline to build this!"

STRINGS.ACTIONS.REPAIR_LEGION = {
    GENERIC = "Repair",
    MERGE = "Merge",
    EMBED = "Embed"
}
S______GENERIC.ACTIONFAIL.REPAIR_LEGION = {
    GUITAR = "There's nothing to fix.",
    FUNGUS = "It's fresh and doesn't need to be repaired.",
    MAT = "Already the biggest it can be.",
    YELLOWGEM = "It's already full of gems."
}
S_______WEBBER.ACTIONFAIL.REPAIR_LEGION = {
    GUITAR = "It's none of our business.",
    FUNGUS = "We can't see what's wrong even with our several eyes.",
    MAT = "OK, that's good.",
    YELLOWGEM = "It seems that not everything can be infinite."
}
S_______WINONA.ACTIONFAIL.REPAIR_LEGION = {
    GUITAR = "Perfect as ever.",
    FUNGUS = "It's perfect.",
    MAT = "I think that's as big as it's going to get.",
    YELLOWGEM = "Enough."
}

STRINGS.CROP_LEGION = {
    SEED = "Planted {crop} Seed",
    SPROUT = "{crop} Sprout",
    SMALL = "{crop} Shoot",
    GROWING = "Growing {crop}",
    GROWN = "Mature {crop}",
    HUGE = "Huge Mature {crop}",
    ROT = "Withered {crop}",
    HUGE_ROT = "Huge Rotten {crop}",
}
S______GENERIC.ACTIONFAIL.POUR_WATER_LEGION = S______GENERIC.ACTIONFAIL.POUR_WATER_GROUNDTILE
S_______WILLOW.ACTIONFAIL.POUR_WATER_LEGION = S_______WILLOW.ACTIONFAIL.POUR_WATER_GROUNDTILE
S_____WOLFGANG.ACTIONFAIL.POUR_WATER_LEGION = S_____WOLFGANG.ACTIONFAIL.POUR_WATER_GROUNDTILE
S________WENDY.ACTIONFAIL.POUR_WATER_LEGION = S________WENDY.ACTIONFAIL.POUR_WATER_GROUNDTILE
S_________WX78.ACTIONFAIL.POUR_WATER_LEGION = S_________WX78.ACTIONFAIL.POUR_WATER_GROUNDTILE
S_WICKERBOTTOM.ACTIONFAIL.POUR_WATER_LEGION = S_WICKERBOTTOM.ACTIONFAIL.POUR_WATER_GROUNDTILE
S_______WOODIE.ACTIONFAIL.POUR_WATER_LEGION = S_______WOODIE.ACTIONFAIL.POUR_WATER_GROUNDTILE
S______WAXWELL.ACTIONFAIL.POUR_WATER_LEGION = S______WAXWELL.ACTIONFAIL.POUR_WATER_GROUNDTILE
S___WATHGRITHR.ACTIONFAIL.POUR_WATER_LEGION = S___WATHGRITHR.ACTIONFAIL.POUR_WATER_GROUNDTILE
S_______WEBBER.ACTIONFAIL.POUR_WATER_LEGION = S_______WEBBER.ACTIONFAIL.POUR_WATER_GROUNDTILE
S_______WINONA.ACTIONFAIL.POUR_WATER_LEGION = S_______WINONA.ACTIONFAIL.POUR_WATER_GROUNDTILE
S_______WORTOX.ACTIONFAIL.POUR_WATER_LEGION = S_______WORTOX.ACTIONFAIL.POUR_WATER_GROUNDTILE
S_____WORMWOOD.ACTIONFAIL.POUR_WATER_LEGION = S_____WORMWOOD.ACTIONFAIL.POUR_WATER_GROUNDTILE
S________WARLY.ACTIONFAIL.POUR_WATER_LEGION = S________WARLY.ACTIONFAIL.POUR_WATER_GROUNDTILE
S_________WURT.ACTIONFAIL.POUR_WATER_LEGION = S_________WURT.ACTIONFAIL.POUR_WATER_GROUNDTILE
S_______WALTER.ACTIONFAIL.POUR_WATER_LEGION = S_______WALTER.ACTIONFAIL.POUR_WATER_GROUNDTILE

STRINGS.ACTIONS.EXSTAY_CONTRACTS = {
    GENERIC = "Call",
    STAY = "Stay"
}
S______GENERIC.ACTIONFAIL.EXSTAY_CONTRACTS = {
    NORIGHT = "It's not under my control.",
    ONLYONE = S______GENERIC.DESCRIBE.SOUL_CONTRACTS.ONLYONE
}
-- S_______WILLOW.ACTIONFAIL.EXSTAY_CONTRACTS =
-- S_____WOLFGANG.ACTIONFAIL.EXSTAY_CONTRACTS =
-- S________WENDY.ACTIONFAIL.EXSTAY_CONTRACTS =
-- S_________WX78.ACTIONFAIL.EXSTAY_CONTRACTS =
S_WICKERBOTTOM.ACTIONFAIL.EXSTAY_CONTRACTS = {
    NORIGHT = "The signature on the cover is not mine at this time.",
    ONLYONE = (S_WICKERBOTTOM.DESCRIBE.SOUL_CONTRACTS or S______GENERIC.DESCRIBE.SOUL_CONTRACTS).ONLYONE
}
-- S_______WOODIE.ACTIONFAIL.EXSTAY_CONTRACTS =
S______WAXWELL.ACTIONFAIL.EXSTAY_CONTRACTS = {
    NORIGHT = "I was eliminated in the change of power.",
    ONLYONE = (S______WAXWELL.DESCRIBE.SOUL_CONTRACTS or S______GENERIC.DESCRIBE.SOUL_CONTRACTS).ONLYONE
}
-- S___WATHGRITHR.ACTIONFAIL.EXSTAY_CONTRACTS =
-- S_______WEBBER.ACTIONFAIL.EXSTAY_CONTRACTS =
-- S_______WINONA.ACTIONFAIL.EXSTAY_CONTRACTS =
S_______WORTOX.ACTIONFAIL.EXSTAY_CONTRACTS = {
    NORIGHT = "I steal souls, and can't control you?!",
    ONLYONE = (S_______WORTOX.DESCRIBE.SOUL_CONTRACTS or S______GENERIC.DESCRIBE.SOUL_CONTRACTS).ONLYONE
}
-- S_____WORMWOOD.ACTIONFAIL.EXSTAY_CONTRACTS =
-- S________WARLY.ACTIONFAIL.EXSTAY_CONTRACTS =
-- S_________WURT.ACTIONFAIL.EXSTAY_CONTRACTS =
-- S_______WALTER.ACTIONFAIL.EXSTAY_CONTRACTS =
S________WANDA.ACTIONFAIL.EXSTAY_CONTRACTS = {
    NORIGHT = "Forget it, it's useless to me anyway.",
    ONLYONE = (S________WANDA.DESCRIBE.SOUL_CONTRACTS or S______GENERIC.DESCRIBE.SOUL_CONTRACTS).ONLYONE
}

S______GENERIC.ACTIONFAIL.PICKUP_CONTRACTS = S______GENERIC.ACTIONFAIL.EXSTAY_CONTRACTS
-- S_______WILLOW.ACTIONFAIL.PICKUP_CONTRACTS =
-- S_____WOLFGANG.ACTIONFAIL.PICKUP_CONTRACTS =
-- S________WENDY.ACTIONFAIL.PICKUP_CONTRACTS =
-- S_________WX78.ACTIONFAIL.PICKUP_CONTRACTS =
S_WICKERBOTTOM.ACTIONFAIL.PICKUP_CONTRACTS = S_WICKERBOTTOM.ACTIONFAIL.EXSTAY_CONTRACTS
-- S_______WOODIE.ACTIONFAIL.PICKUP_CONTRACTS =
S______WAXWELL.ACTIONFAIL.PICKUP_CONTRACTS = S______WAXWELL.ACTIONFAIL.EXSTAY_CONTRACTS
-- S___WATHGRITHR.ACTIONFAIL.PICKUP_CONTRACTS =
-- S_______WEBBER.ACTIONFAIL.PICKUP_CONTRACTS =
-- S_______WINONA.ACTIONFAIL.PICKUP_CONTRACTS =
S_______WORTOX.ACTIONFAIL.PICKUP_CONTRACTS = S_______WORTOX.ACTIONFAIL.EXSTAY_CONTRACTS
-- S_____WORMWOOD.ACTIONFAIL.PICKUP_CONTRACTS =
-- S________WARLY.ACTIONFAIL.PICKUP_CONTRACTS =
-- S_________WURT.ACTIONFAIL.PICKUP_CONTRACTS =
-- S_______WALTER.ACTIONFAIL.PICKUP_CONTRACTS =
S________WANDA.ACTIONFAIL.PICKUP_CONTRACTS = S________WANDA.ACTIONFAIL.EXSTAY_CONTRACTS

STRINGS.ACTIONS.PLANTSOIL_LEGION = {
    GENERIC = "Plant",
    DISPLAY = "Replant",
    CLUSTERED = "Clustered Plant"
}

S______GENERIC.ACTIONFAIL.PLANTSOIL_LEGION = {
    NOTMATCH_C = "Different varieties can't be planted together.",
    ISMAXED_C = "It has reached its maximum planting density."
}
-- S_______WILLOW.ACTIONFAIL.PLANTSOIL_LEGION = ""
S_____WOLFGANG.ACTIONFAIL.PLANTSOIL_LEGION = {
    NOTMATCH_C = "Not a family, not a door.",
    ISMAXED_C = "There is no place to continue planting."
}
-- S________WENDY.ACTIONFAIL.PLANTSOIL_LEGION = ""
-- S_________WX78.ACTIONFAIL.PLANTSOIL_LEGION = ""
S_WICKERBOTTOM.ACTIONFAIL.PLANTSOIL_LEGION = {
    NOTMATCH_C = "They need the same genes to grow together!",
    ISMAXED_C = "I'm curious whether it can grow in such a dense environment?"
}
-- S_______WOODIE.ACTIONFAIL.PLANTSOIL_LEGION = ""
-- S______WAXWELL.ACTIONFAIL.PLANTSOIL_LEGION = ""
-- S___WATHGRITHR.ACTIONFAIL.PLANTSOIL_LEGION = ""
-- S_______WEBBER.ACTIONFAIL.PLANTSOIL_LEGION = ""
-- S_______WINONA.ACTIONFAIL.PLANTSOIL_LEGION = ""
-- S________WARLY.ACTIONFAIL.PLANTSOIL_LEGION = ""
-- S_______WORTOX.ACTIONFAIL.PLANTSOIL_LEGION = ""
S_____WORMWOOD.ACTIONFAIL.PLANTSOIL_LEGION = {
    NOTMATCH_C = "Only the same kind is welcome.",
    ISMAXED_C = "Full!"
}
-- S_________WURT.ACTIONFAIL.PLANTSOIL_LEGION = ""
-- S_______WALTER.ACTIONFAIL.PLANTSOIL_LEGION = ""
-- S________WANDA.ACTIONFAIL.PLANTSOIL_LEGION = ""

STRINGS.ACTIONS.GENETRANS = {
    GENERIC = "Put On",
    CHARGE = "Charge",
}
S______GENERIC.ACTIONFAIL.GENETRANS = {
    NOGENE = "It needs to obtain samples before transforming this.",
    GROWING = "Something is already here.",
    ENERGYOUT = "Needs to be charged before it can start.",
    WRONGITEM = "This isn't what it can transform.",
    ENERGYMAX = "Already full of life energy.",
    WRONGKEY = "This can't be used as a sample.",
    HASKEY = "It already has this sample."
}
-- S_______WILLOW.ACTIONFAIL.GENETRANS =
-- S_____WOLFGANG.ACTIONFAIL.GENETRANS =
-- S________WENDY.ACTIONFAIL.GENETRANS =
-- S_________WX78.ACTIONFAIL.GENETRANS =
-- S_WICKERBOTTOM.ACTIONFAIL.GENETRANS =
-- S_______WOODIE.ACTIONFAIL.GENETRANS =
-- S______WAXWELL.ACTIONFAIL.GENETRANS =
-- S___WATHGRITHR.ACTIONFAIL.GENETRANS =
-- S_______WEBBER.ACTIONFAIL.GENETRANS =
-- S_______WINONA.ACTIONFAIL.GENETRANS =
-- S_______WORTOX.ACTIONFAIL.GENETRANS =
-- S_____WORMWOOD.ACTIONFAIL.GENETRANS =
S________WARLY.ACTIONFAIL.GENETRANS = {
    NOGENE = "It needs a recipe to know how to do it.",
    GROWING = "A pot can only cook one dish at same time!",
    NOENERGY = "This stove is out of fuel.",
    WRONGITEM = "Wrong ingredients.",
    ENERGYMAX = "Maximum power has been reached.",
    WRONGKEY = "This is not the recipe it needs.",
    HASKEY = "It already has this recipe."
}
-- S_________WURT.ACTIONFAIL.GENETRANS =
-- S_______WALTER.ACTIONFAIL.GENETRANS =
-- S________WANDA.ACTIONFAIL.GENETRANS =

S______GENERIC.ACTIONFAIL.STORE_BEEF_L = S______GENERIC.ACTIONFAIL.STORE
S_______WILLOW.ACTIONFAIL.STORE_BEEF_L = S_______WILLOW.ACTIONFAIL.STORE
S_____WOLFGANG.ACTIONFAIL.STORE_BEEF_L = S_____WOLFGANG.ACTIONFAIL.STORE
S________WENDY.ACTIONFAIL.STORE_BEEF_L = S________WENDY.ACTIONFAIL.STORE
S_________WX78.ACTIONFAIL.STORE_BEEF_L = S_________WX78.ACTIONFAIL.STORE
S_WICKERBOTTOM.ACTIONFAIL.STORE_BEEF_L = S_WICKERBOTTOM.ACTIONFAIL.STORE
S_______WOODIE.ACTIONFAIL.STORE_BEEF_L = S_______WOODIE.ACTIONFAIL.STORE
S______WAXWELL.ACTIONFAIL.STORE_BEEF_L = S______WAXWELL.ACTIONFAIL.STORE
S___WATHGRITHR.ACTIONFAIL.STORE_BEEF_L = S___WATHGRITHR.ACTIONFAIL.STORE
S_______WEBBER.ACTIONFAIL.STORE_BEEF_L = S_______WEBBER.ACTIONFAIL.STORE
S_______WINONA.ACTIONFAIL.STORE_BEEF_L = S_______WINONA.ACTIONFAIL.STORE
S_______WORTOX.ACTIONFAIL.STORE_BEEF_L = S_______WORTOX.ACTIONFAIL.STORE
S_____WORMWOOD.ACTIONFAIL.STORE_BEEF_L = S_____WORMWOOD.ACTIONFAIL.STORE
S________WARLY.ACTIONFAIL.STORE_BEEF_L = S________WARLY.ACTIONFAIL.STORE
S_________WURT.ACTIONFAIL.STORE_BEEF_L = S_________WURT.ACTIONFAIL.STORE
S_______WALTER.ACTIONFAIL.STORE_BEEF_L = S_______WALTER.ACTIONFAIL.STORE
S________WANDA.ACTIONFAIL.STORE_BEEF_L = S________WANDA.ACTIONFAIL.STORE

S______GENERIC.ACTIONFAIL.FEED_BEEF_L = S______GENERIC.ACTIONFAIL.GIVE
S_______WILLOW.ACTIONFAIL.FEED_BEEF_L = S_______WILLOW.ACTIONFAIL.GIVE
S_____WOLFGANG.ACTIONFAIL.FEED_BEEF_L = S_____WOLFGANG.ACTIONFAIL.GIVE
S________WENDY.ACTIONFAIL.FEED_BEEF_L = S________WENDY.ACTIONFAIL.GIVE
S_________WX78.ACTIONFAIL.FEED_BEEF_L = S_________WX78.ACTIONFAIL.GIVE
S_WICKERBOTTOM.ACTIONFAIL.FEED_BEEF_L = S_WICKERBOTTOM.ACTIONFAIL.GIVE
S_______WOODIE.ACTIONFAIL.FEED_BEEF_L = S_______WOODIE.ACTIONFAIL.GIVE
S______WAXWELL.ACTIONFAIL.FEED_BEEF_L = S______WAXWELL.ACTIONFAIL.GIVE
S___WATHGRITHR.ACTIONFAIL.FEED_BEEF_L = S___WATHGRITHR.ACTIONFAIL.GIVE
S_______WEBBER.ACTIONFAIL.FEED_BEEF_L = S_______WEBBER.ACTIONFAIL.GIVE
S_______WINONA.ACTIONFAIL.FEED_BEEF_L = S_______WINONA.ACTIONFAIL.GIVE
S_______WORTOX.ACTIONFAIL.FEED_BEEF_L = S_______WORTOX.ACTIONFAIL.GIVE
S_____WORMWOOD.ACTIONFAIL.FEED_BEEF_L = S_____WORMWOOD.ACTIONFAIL.GIVE
S________WARLY.ACTIONFAIL.FEED_BEEF_L = S________WARLY.ACTIONFAIL.GIVE
S_________WURT.ACTIONFAIL.FEED_BEEF_L = S_________WURT.ACTIONFAIL.GIVE
S_______WALTER.ACTIONFAIL.FEED_BEEF_L = S_______WALTER.ACTIONFAIL.GIVE
S________WANDA.ACTIONFAIL.FEED_BEEF_L = S________WANDA.ACTIONFAIL.GIVE

STRINGS.ACTIONS.RC_SKILL_L = {
    GENERIC = "Spell",
    FEATHERTHROW = "Feather Split",
    FEATHERPULL = "Feather Retrieve"
}

STRINGS.ACTIONS.LIFEBEND = {
    GENERIC = "Rejuvenate",
    REVIVE = "Resurrect",
    CURE = "Heal"
}
S______GENERIC.ACTIONFAIL.LIFEBEND = {
    NOLIFE = "I'm out of life.",
    GHOST = "It's soul is crippled beyond repair.",
    NOTHURT = "Your health is already topped off!",
    NOWITHERED = "It's growing nicely!"
}
-- S_______WILLOW.ACTIONFAIL.LIFEBEND =
-- S_____WOLFGANG.ACTIONFAIL.LIFEBEND =
S________WENDY.ACTIONFAIL.LIFEBEND = {
    NOLIFE = "I have reached the end of my life.",
    GHOST = "Many attempts, but I don't want to give up yet.",
    NOTHURT = "You don't need me anymore, do you?",
    NOWITHERED = "Still in perfect health."
}
S_________WX78.ACTIONFAIL.LIFEBEND = {
    NOLIFE = "WARNING: LOW LIFE ENERGY!",
    GHOST = "RESURRECTING A LONE GHOST? NO!",
    NOTHURT = "SCAN: NORMAL FUNCTION.",
    NOWITHERED = "SCAN: NORMAL STATUS."
}
-- S_WICKERBOTTOM.ACTIONFAIL.LIFEBEND =
-- S_______WOODIE.ACTIONFAIL.LIFEBEND =
-- S______WAXWELL.ACTIONFAIL.LIFEBEND =
-- S___WATHGRITHR.ACTIONFAIL.LIFEBEND =
-- S_______WEBBER.ACTIONFAIL.LIFEBEND =
-- S_______WINONA.ACTIONFAIL.LIFEBEND =
-- S________WARLY.ACTIONFAIL.LIFEBEND =
-- S_______WORTOX.ACTIONFAIL.LIFEBEND =
S_____WORMWOOD.ACTIONFAIL.LIFEBEND = {
    NOLIFE = "Not enough nutrients.",
    GHOST = "No response.",
    NOTHURT = "Healthy.",
    NOWITHERED = "Thriving!"
}
-- S_________WURT.ACTIONFAIL.LIFEBEND =
-- S_______WALTER.ACTIONFAIL.LIFEBEND =
-- S________WANDA.ACTIONFAIL.LIFEBEND =

S______GENERIC.ACTIONFAIL.REMOVE_CARPET_L = {
    GENERIC = "There is no carpet to fork away."
}
-- S_______WILLOW.ACTIONFAIL.REMOVE_CARPET_L = ""
-- S_____WOLFGANG.ACTIONFAIL.REMOVE_CARPET_L = ""
-- S________WENDY.ACTIONFAIL.REMOVE_CARPET_L = ""
-- S_________WX78.ACTIONFAIL.REMOVE_CARPET_L = ""
-- S_WICKERBOTTOM.ACTIONFAIL.REMOVE_CARPET_L = ""
-- S_______WOODIE.ACTIONFAIL.REMOVE_CARPET_L = ""
-- S______WAXWELL.ACTIONFAIL.REMOVE_CARPET_L = ""
-- S___WATHGRITHR.ACTIONFAIL.REMOVE_CARPET_L = ""
-- S_______WEBBER.ACTIONFAIL.REMOVE_CARPET_L = ""
-- S_______WINONA.ACTIONFAIL.REMOVE_CARPET_L = ""
-- S________WARLY.ACTIONFAIL.REMOVE_CARPET_L = ""
-- S_______WORTOX.ACTIONFAIL.REMOVE_CARPET_L = ""
-- S_____WORMWOOD.ACTIONFAIL.REMOVE_CARPET_L = ""
-- S_________WURT.ACTIONFAIL.REMOVE_CARPET_L = ""
-- S_______WALTER.ACTIONFAIL.REMOVE_CARPET_L = ""
-- S________WANDA.ACTIONFAIL.REMOVE_CARPET_L = ""
