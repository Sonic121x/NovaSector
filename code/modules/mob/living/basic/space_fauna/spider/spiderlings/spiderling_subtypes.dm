/// This whole file is just a container for the spiderling subtypes that actually differentiate into different young spiders. None of them are particularly special as of now.
/// Will differentiate into the base young spider (known colloquially as the "guard" spider).
/mob/living/basic/spider/growing/spiderling/guard
	grow_as = /mob/living/basic/spider/growing/young/guard
	name = "守卫幼蛛"
	desc = "毛茸茸的棕色小家伙，看起来毫无防御能力。这一只有着闪闪发光的红色眼睛。"

/// Will differentiate into the "ambush" young spider.
/mob/living/basic/spider/growing/spiderling/ambush
	grow_as = /mob/living/basic/spider/growing/young/ambush
	name = "伏击幼蛛"
	desc = "毛茸茸的白色小家伙，看起来毫无防御能力。这一只有着闪闪发光的粉色眼睛。"
	icon = 'icons/mob/simple/arachnoid.dmi'
	icon_state = "ambush_spiderling"
	icon_dead = "ambush_spiderling_dead"

/// Will differentiate into the "scout" young spider.
/mob/living/basic/spider/growing/spiderling/scout
	grow_as = /mob/living/basic/spider/growing/young/scout
	name = "侦察幼蛛"
	desc = "毛茸茸的黑色小家伙，看起来毫无防御能力。这一只有着闪闪发光的蓝色眼睛。"
	icon = 'icons/mob/simple/arachnoid.dmi'
	icon_state = "scout_spiderling"
	icon_dead = "scout_spiderling_dead"
	sight = SEE_SELF|SEE_MOBS

/// Will differentiate into the "hunter" young spider.
/mob/living/basic/spider/growing/spiderling/hunter
	grow_as = /mob/living/basic/spider/growing/young/hunter
	name = "猎手幼蛛"
	desc = "毛茸茸的黑色小家伙，看起来毫无防御能力。这一只有着闪闪发光的紫色眼睛。"
	icon = 'icons/mob/simple/arachnoid.dmi'
	icon_state = "hunter_spiderling"
	icon_dead = "hunter_spiderling_dead"

/// Will differentiate into the "nurse" young spider.
/mob/living/basic/spider/growing/spiderling/nurse
	grow_as = /mob/living/basic/spider/growing/young/nurse
	name = "护士幼蛛"
	desc = "毛茸茸的黑色身躯，看起来毫无防御能力。这一只有着闪闪发光的绿色眼睛。"
	icon = 'icons/mob/simple/arachnoid.dmi'
	icon_state = "nurse_spiderling"
	icon_dead = "nurse_spiderling_dead"

/// Will differentiate into the "tangle" young spider.
/mob/living/basic/spider/growing/spiderling/tangle
	grow_as = /mob/living/basic/spider/growing/young/tangle
	name = "缠结蛛幼体"
	desc = "毛茸茸的棕色身躯，看起来毫无防御能力。这一只有着暗淡的棕色眼睛。"
	icon = 'icons/mob/simple/arachnoid.dmi'
	icon_state = "tangle_spiderling"
	icon_dead = "tangle_spiderling_dead"

/// Will differentiate into the "tank" young spider.
/mob/living/basic/spider/growing/spiderling/tank
	grow_as = /mob/living/basic/spider/growing/young/tank
	name = "坦克蛛幼体"
	desc = "毛茸茸的紫色身躯，看起来毫无防御能力。这一只有着暗淡的黄色眼睛。"
	icon = 'icons/mob/simple/arachnoid.dmi'
	icon_state = "tank_spiderling"
	icon_dead = "tank_spiderling_dead"

/// Will differentiate into the "breacher" young spider.
/mob/living/basic/spider/growing/spiderling/breacher
	grow_as = /mob/living/basic/spider/growing/young/breacher
	name = "破壁蛛幼体"
	desc = "毛茸茸的米色身躯，看起来毫无防御能力。这一只有着暗淡的红色眼睛。"
	icon = 'icons/mob/simple/arachnoid.dmi'
	icon_state = "breacher_spiderling"
	icon_dead = "breacher_spiderling_dead"

/// Will differentiate into the "midwife" young spider.
/mob/living/basic/spider/growing/spiderling/midwife
	grow_as = /mob/living/basic/spider/growing/young/midwife
	name = "育母蛛幼体"
	desc = "毛茸茸的黑色身躯，看起来毫无防御能力。这一只有着闪烁的绿色眼睛。可能还在某处藏着一把真刀。"
	icon = 'icons/mob/simple/arachnoid.dmi'
	icon_state = "midwife_spiderling"
	icon_dead = "midwife_spiderling_dead"

/// Will differentiate into the "viper" young spider.
/mob/living/basic/spider/growing/spiderling/viper
	grow_as = /mob/living/basic/spider/growing/young/viper
	name = "毒蛇蛛幼体"
	desc = "毛茸茸的黑色身躯，看起来毫无防御能力。这一只有着闪闪发光的品红色眼睛。"
	icon = 'icons/mob/simple/arachnoid.dmi'
	icon_state = "viper_spiderling"
	icon_dead = "viper_spiderling_dead"

/// Will differentiate into the "tarantula" young spider.
/mob/living/basic/spider/growing/spiderling/tarantula
	grow_as = /mob/living/basic/spider/growing/young/tarantula
	name = "狼蛛幼体"
	desc = "毛茸茸的黑色身躯，看起来毫无防御能力。这一只有着深渊般的红色眼睛。"
	icon = 'icons/mob/simple/arachnoid.dmi'
	icon_state = "tarantula_spiderling"
	icon_dead = "tarantula_spiderling_dead"
