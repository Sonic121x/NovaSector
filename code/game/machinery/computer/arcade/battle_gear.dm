/datum/battle_arcade_gear
	///The name of the gear, used in shops.
	var/name = "装备"
	///The slot this gear fits into
	var/slot
	///The world the player has to be at in order to buy this item.
	var/world_available
	///The stat given by the gear
	var/bonus_modifier

/datum/battle_arcade_gear/tier_1
	world_available = BATTLE_WORLD_ONE

/datum/battle_arcade_gear/tier_1/weapon
	name = "剑"
	slot = WEAPON_SLOT
	bonus_modifier = 1.5

/datum/battle_arcade_gear/tier_1/armor
	name = "皮甲"
	slot = ARMOR_SLOT
	bonus_modifier = 1.5

/datum/battle_arcade_gear/tier_2
	world_available = BATTLE_WORLD_TWO

/datum/battle_arcade_gear/tier_2/weapon
	name = "斧头"
	slot = WEAPON_SLOT
	bonus_modifier = 1.75

/datum/battle_arcade_gear/tier_2/armor
	name = "锁子甲"
	slot = ARMOR_SLOT
	bonus_modifier = 1.75

/datum/battle_arcade_gear/tier_3
	world_available = BATTLE_WORLD_THREE

/datum/battle_arcade_gear/tier_3/weapon
	name = "钉头锤"
	slot = WEAPON_SLOT
	bonus_modifier = 2

/datum/battle_arcade_gear/tier_3/armor
	name = "板甲"
	slot = ARMOR_SLOT
	bonus_modifier = 2

/datum/battle_arcade_gear/tier_4
	world_available = BATTLE_WORLD_FOUR

/datum/battle_arcade_gear/tier_4/weapon
	name = "巨剑"
	slot = WEAPON_SLOT
	bonus_modifier = 2.5

/datum/battle_arcade_gear/tier_4/armor
	name = "全身板甲"
	slot = ARMOR_SLOT
	bonus_modifier = 2.5

/datum/battle_arcade_gear/tier_5
	world_available = BATTLE_WORLD_FIVE

/datum/battle_arcade_gear/tier_5/weapon
	name = "戟"
	slot = WEAPON_SLOT
	bonus_modifier = 3

/datum/battle_arcade_gear/tier_5/armor
	name = "龙鳞甲"
	slot = ARMOR_SLOT
	bonus_modifier = 3

/datum/battle_arcade_gear/tier_6
	world_available = BATTLE_WORLD_SIX

/datum/battle_arcade_gear/tier_6/weapon
	name = "战锤"
	slot = WEAPON_SLOT
	bonus_modifier = 3.5

/datum/battle_arcade_gear/tier_6/armor
	name = "精金护甲"
	slot = ARMOR_SLOT
	bonus_modifier = 3.5

/datum/battle_arcade_gear/tier_7
	world_available = BATTLE_WORLD_SEVEN

/datum/battle_arcade_gear/tier_7/weapon
	name = "王者之剑"
	slot = WEAPON_SLOT
	bonus_modifier = 4

/datum/battle_arcade_gear/tier_7/armor
	name = "以太护甲"
	slot = ARMOR_SLOT
	bonus_modifier = 4

/datum/battle_arcade_gear/tier_8
	world_available = BATTLE_WORLD_EIGHT

/datum/battle_arcade_gear/tier_8/weapon
	name = "永恒之枪"
	slot = WEAPON_SLOT
	bonus_modifier = 4.5

/datum/battle_arcade_gear/tier_8/armor
	name = "天界护甲"
	slot = ARMOR_SLOT
	bonus_modifier = 4.5

/datum/battle_arcade_gear/tier_9
	world_available = BATTLE_WORLD_NINE

/datum/battle_arcade_gear/tier_9/weapon
	name = "雷神之锤"
	slot = WEAPON_SLOT
	bonus_modifier = 5

/datum/battle_arcade_gear/tier_9/armor
	name = "虚空护甲"
	slot = ARMOR_SLOT
	bonus_modifier = 5
