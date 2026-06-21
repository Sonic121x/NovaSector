#define SPELLBOOK_CATEGORY_MOBILITY "Mobility"
// Wizard spells that aid mobiilty(or stealth?)
/datum/spellbook_entry/mindswap
	name = "思想互换"
	desc = "允许你与邻近的目标交换身体。当这种情况发生时，你们都会入睡，如果有人看着你这么做，很容易看出你是目标的身体。"
	spell_type = /datum/action/cooldown/spell/pointed/mind_transfer
	category = SPELLBOOK_CATEGORY_MOBILITY

/datum/spellbook_entry/knock
	name = "Knock-敲击术"
	desc = "能打开附近的门和储物柜。"
	spell_type = /datum/action/cooldown/spell/aoe/knock
	category = SPELLBOOK_CATEGORY_MOBILITY
	cost = 1

/datum/spellbook_entry/blink
	name = "Blink-闪烁"
	desc = "随机将你传送一小段距离。"
	spell_type = /datum/action/cooldown/spell/teleport/radius_turf/blink
	category = SPELLBOOK_CATEGORY_MOBILITY

/datum/spellbook_entry/teleport
	name = "Teleport-传送"
	desc = "将你传送至已选定好的区域。"
	spell_type = /datum/action/cooldown/spell/teleport/area_teleport/wizard
	category = SPELLBOOK_CATEGORY_MOBILITY

/datum/spellbook_entry/jaunt
	name = "Ethereal Jaunt-空灵穿梭"
	desc = "使你的形体变得虚无缥缈，能暂时隐身并能穿墙。"
	spell_type = /datum/action/cooldown/spell/jaunt/ethereal_jaunt
	category = SPELLBOOK_CATEGORY_MOBILITY

/datum/spellbook_entry/swap
	name = "Swap-换位术"
	desc = "在九格范围内与任意活着的目标交换位置。右键点击标记一个次要目标。你将始终与主要目标交换位置。"
	spell_type = /datum/action/cooldown/spell/pointed/swap
	category = SPELLBOOK_CATEGORY_MOBILITY
	cost = 1

/datum/spellbook_entry/item/warpwhistle
	name = "Warp Whistle-奇异口哨"
	desc = "一种奇怪的哨声，会将你传送到站上一个遥远而安全的地方。每次使用开始时都有一个脆弱窗口。"
	item_path = /obj/item/warp_whistle
	category = SPELLBOOK_CATEGORY_MOBILITY
	cost = 1

/datum/spellbook_entry/item/staffdoor
	name = "造门法杖"
	desc = "一根可以将坚固的墙壁变成华丽门的特殊法杖。在缺乏其他交通方式时非常有用。对玻璃无效。"
	item_path = /obj/item/gun/magic/staff/door
	cost = 1
	category = SPELLBOOK_CATEGORY_MOBILITY

/datum/spellbook_entry/item/teleport_rod
	name = /obj/item/teleport_rod::name
	desc = /obj/item/teleport_rod::desc
	item_path = /obj/item/teleport_rod
	cost = 2 // Puts it at 3 cost if you go for safety instant summons, but teleporting anywhere on screen is pretty good.
	category = SPELLBOOK_CATEGORY_MOBILITY

/datum/spellbook_entry/ghostliness
	name = "Forsake Body"
	desc = "A necromantic spell which permanently severs your soul from your body, and partially anchors it to the material plane. \
	In this state, you can enter a state of incorporeality, allowing you to pass through solid matter. This, however, includes \
	most such matter on or inside of you."
	spell_type = /datum/action/cooldown/spell/ghostliness
	category = SPELLBOOK_CATEGORY_MOBILITY
	no_coexistence_typecache = list(/datum/spellbook_entry/lichdom, /datum/spellbook_entry/splattercasting)

#undef SPELLBOOK_CATEGORY_MOBILITY
