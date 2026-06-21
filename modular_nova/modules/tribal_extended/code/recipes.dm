/datum/crafting_recipe/silkstring
	name = "丝线"
	result = /obj/item/weaponcrafting/silkstring
	reqs = list(/obj/item/stack/sheet/cloth = 1)
	time = 5 SECONDS
	category = CAT_MISC

/datum/crafting_recipe/pipebow
	name = "管弓"
	result = /obj/item/gun/ballistic/bow/tribalbow/pipe
	reqs = list(
		/obj/item/pipe = 5,
		/obj/item/stack/sheet/plastic = 5,
		/obj/item/weaponcrafting/silkstring = 2,
	)
	time = 45 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/bone_arrow
	name = "骨箭"
	result = /obj/item/ammo_casing/arrow/bone
	reqs = list(
		/obj/item/stack/sheet/bone = 1,
		/obj/item/ammo_casing/arrow = 1,
	)
	category = CAT_WEAPON_AMMO
	non_craftable = TRUE
	steps = list("Reinforce the arrow with sinew.")

/datum/crafting_recipe/ashen_arrow
	name = "灰烬箭"
	result = /obj/item/ammo_casing/arrow/ash
	reqs = list(
		/obj/item/ammo_casing/arrow = 1,
		/obj/item/stack/sheet/sinew = 1,
	)
	category = CAT_WEAPON_AMMO
	non_craftable = TRUE
	steps = list("Reinforce the arrow with sinew.")

/datum/crafting_recipe/bronze_arrow
	name = "青铜箭"
	result = /obj/item/ammo_casing/arrow/bronze
	reqs = list(
		/obj/item/ammo_casing/arrow = 1,
		/obj/item/stack/tile/bronze = 1,
	)
	category = CAT_WEAPON_AMMO
	non_craftable = TRUE
	steps = list("Reinforce the arrowhead with bronze.")

/datum/crafting_recipe/goliathshield
	name = "歌利亚盾牌"
	result = /obj/item/shield/goliath
	reqs = list(
		/obj/item/stack/sheet/bone = 4,
		/obj/item/stack/sheet/animalhide/goliath_hide = 3,
	)
	time = 6 SECONDS
	category = CAT_EQUIPMENT

/datum/crafting_recipe/bonesword
	name = "骨剑"
	result = /obj/item/claymore/bone
	reqs = list(
		/obj/item/stack/sheet/bone = 2,
		/obj/item/stack/sheet/sinew = 2,
	)
	time = 4 SECONDS
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED
	category = CAT_WEAPON_MELEE

/datum/crafting_recipe/quiver
	name = "箭袋"
	result = /obj/item/storage/bag/quiver
	reqs = list(
		/obj/item/stack/sheet/leather = 2,
		/obj/item/weaponcrafting/silkstring = 4,
	)
	time = 8 SECONDS
	category = CAT_WEAPON_AMMO

/datum/crafting_recipe/bone_bow
	name = "骨弓"
	result = /obj/item/gun/ballistic/bow/tribalbow/ashen
	reqs = list(
		/obj/item/stack/sheet/bone = 4,
		/obj/item/stack/sheet/sinew = 4,
	)
	time = 20 SECONDS
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/torch
	name = "火把"
	reqs = list(/obj/item/grown/log = 1)
	result = /obj/item/flashlight/flare/torch
	category = CAT_MISC
	non_craftable = TRUE
	steps = list("Use any dried leaf-like plant on a towercap log! (Ambrosia, cannabis, tobacco, etc!)")

/datum/crafting_recipe/bonedice
	name = "骨骰"
	result = /obj/item/dice/d6/bone
	time = 5 SECONDS
	reqs = list(
		/obj/item/stack/sheet/bone = 1,
	)
	category = CAT_EQUIPMENT

/datum/crafting_recipe/runic_greatsword
	name = "符文巨剑"
	category = CAT_WEAPON_MELEE
	//recipe given to hearthkins as part of their spawner/team setting
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED
	reqs = list(
		/obj/item/forging/complete/sword = 1,
		/obj/item/stack/sheet/leather = 1,
		/obj/item/stack/sheet/mineral/wood = 1,
		/obj/item/hearthkin_ship_fragment_active = 1
	)
	tool_behaviors = list(TOOL_HAMMER)
	result = /obj/item/kinetic_crusher/runic_greatsword

/datum/crafting_recipe/runic_greataxe
	name = "符文巨斧"
	category = CAT_WEAPON_MELEE
	//recipe given to hearthkins as part of their spawner/team setting
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED
	reqs = list(
		/obj/item/forging/complete/axe = 1,
		/obj/item/stack/sheet/leather = 1,
		/obj/item/stack/sheet/mineral/wood = 1,
		/obj/item/hearthkin_ship_fragment_active = 1
	)
	tool_behaviors = list(TOOL_HAMMER)
	result = /obj/item/kinetic_crusher/runic_greataxe

/datum/crafting_recipe/runic_spear
	name = "符文长矛"
	category = CAT_WEAPON_MELEE
	//recipe given to hearthkins as part of their spawner/team setting
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED
	reqs = list(
		/obj/item/forging/complete/spear = 1,
		/obj/item/stack/sheet/leather = 1,
		/obj/item/stack/sheet/mineral/wood = 1,
		/obj/item/hearthkin_ship_fragment_active = 1
	)
	tool_behaviors = list(TOOL_HAMMER)
	result = /obj/item/kinetic_crusher/spear/runic_spear

/datum/crafting_recipe/hearthkin_ship_fragment_inactive
	name = "回收无用遗物"
	desc = "在所有这些垃圾中翻找，你找到了足够多的零件来重建一块古老炉心族科技的碎片。"
	time = 10 SECONDS
	category = CAT_MISC
	//recipe given to hearthkins as part of their spawner/team setting
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED
	reqs = list(
		/obj/item/xenoarch/broken_item = 5,
	)
	tool_behaviors = list(TOOL_HAMMER)
	result = /obj/item/hearthkin_ship_fragment_inactive
