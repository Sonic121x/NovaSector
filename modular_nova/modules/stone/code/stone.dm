/obj/item/stack/sheet/mineral/stone
	name = "石材"
	desc = "石砖。"
	singular_name = "stone block"
	icon = 'modular_nova/modules/stone/icons/ore.dmi'
	icon_state = "sheet-stone"
	inhand_icon_state = "sheet-metal"
	mats_per_unit = list(/datum/material/stone = SHEET_MATERIAL_AMOUNT)
	force = 10
	throwforce = 15
	resistance_flags = FIRE_PROOF
	merge_type = /obj/item/stack/sheet/mineral/stone
	material_type = /datum/material/stone
	source = null
	walltype = /turf/closed/wall/mineral/stone
	stairs_type = /obj/structure/stairs/stone
	drop_sound = SFX_BRICK_DROP
	pickup_sound = SFX_BRICK_PICKUP

GLOBAL_LIST_INIT(stone_recipes, list (
	new/datum/stack_recipe("stone brick wall", /turf/closed/wall/mineral/stone, 5, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_STRUCTURE),
	new/datum/stack_recipe("stone brick tile", /obj/item/stack/tile/mineral/stone, 1, 4, 20, category = CAT_TILES),
	new/datum/stack_recipe("millstone", /obj/structure/millstone, 6, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_STRUCTURE),
	new/datum/stack_recipe("stone cauldron", /obj/machinery/cauldron, 5, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_STRUCTURE),
	new/datum/stack_recipe("stone stove", /obj/machinery/primitive_stove, 5, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_STRUCTURE),
	new/datum/stack_recipe("stone oven", /obj/machinery/oven/primitive, 5, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_STRUCTURE),
	new/datum/stack_recipe("stone griddle", /obj/machinery/griddle/stone, 5, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_STRUCTURE),
	new/datum/stack_recipe("brick well", /obj/structure/water_source/brick_well, 5, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND, category = CAT_STRUCTURE),
	new/datum/stack_recipe("fireplace frame", /obj/item/wallframe/fireplace, 7, crafting_flags = NONE, category = CAT_STRUCTURE),
	))

/obj/item/stack/sheet/mineral/stone/get_main_recipes()
	. = ..()
	. += GLOB.stone_recipes

/datum/material/stone
	name = "石材"
	desc = "这是石头。"
	mat_flags = MATERIAL_CLASS_RIGID | MATERIAL_BASIC_RECIPES
	mat_properties = list(
		MATERIAL_DENSITY = 5,
		MATERIAL_HARDNESS = 5,
		MATERIAL_FLEXIBILITY = 1,
		MATERIAL_REFLECTIVITY = 2,
		MATERIAL_ELECTRICAL = 1,
		MATERIAL_THERMAL = 8,
		MATERIAL_CHEMICAL = 4,
	)
	sheet_type = /obj/item/stack/sheet/mineral/stone
	value_per_unit = 0.005
	color = "#59595a"
	value_per_unit = 0.0025
	turf_sound_override = FOOTSTEP_PLATING

/obj/item/stack/stone
	name = "粗石"
	desc = "大块的未切割石头，足够坚固可以安全地用于建造……如果你能设法把它们切割成可用的东西。"
	icon = 'modular_nova/modules/stone/icons/ore.dmi'
	icon_state = "stone_ore"
	singular_name = "rough stone boulder"
	mats_per_unit = list(/datum/material/stone = SHEET_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/stone
	force = 10
	throwforce = 15

/obj/item/stack/stone/examine()
	. = ..()
	. += span_notice("用<b>凿子</b>或某种<b>镐</b>，你可以把它切割成<b>石块</b>。")

/obj/item/stack/stone/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if((attacking_item.tool_behaviour != TOOL_MINING) && !(istype(attacking_item, /obj/item/chisel)))
		return ..()
	playsound(src,  'sound/effects/pickaxe/picaxe1.ogg', 50, TRUE)
	balloon_alert_to_viewers("cutting...")
	if(!do_after(user, 5 SECONDS, target = src))
		balloon_alert_to_viewers("stopped cutting")
		return FALSE
	new /obj/item/stack/sheet/mineral/stone(get_turf(src), amount)
	qdel(src)

/obj/item/stack/tile/mineral/stone
	name = "石砖地砖"
	singular_name = "stone floor tile"
	desc = "由石砖制成的地砖，营造出堡垒般的外观。"
	icon_state = "tile_herringbone"
	inhand_icon_state = "tile"
	turf_type = /turf/open/floor/stone
	mineralType = "stone"
	mats_per_unit = list(/datum/material/stone = SHEET_MATERIAL_AMOUNT * 0.25)
	merge_type = /obj/item/stack/tile/mineral/stone

/turf/open/floor/stone
	desc = "以类似地砖的图案排列的石块，奇怪的是，它看起来也像真石头，因为它就是！" //A play on the original description for stone tiles

/turf/closed/wall/mineral/stone
	name = "石墙"
	desc = "由坚固石砖砌成的墙。"
	icon = 'modular_nova/modules/stone/icons/wall.dmi'
	icon_state = "wall-0"
	base_icon_state = "wall"
	sheet_type = /obj/item/stack/sheet/mineral/stone
	explosive_resistance = 2 // Rock and stone to the bone, or at least a bit longer than walls made of metal sheets!
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_STONE_WALLS + SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_STONE_WALLS
	custom_materials = list(
		/datum/material/stone = SHEET_MATERIAL_AMOUNT  * 2,
	)

/turf/closed/wall/mineral/stone/try_decon(obj/item/item_used, mob/user) // Lets you break down stone walls with stone breaking tools
	if(item_used.tool_behaviour != TOOL_MINING)
		return ..()

	if(!item_used.tool_start_check(user, amount = 0))
		return FALSE

	balloon_alert_to_viewers("breaking down...")

	if(!item_used.use_tool(src, user, 5 SECONDS))
		return FALSE
	dismantle_wall()
	return TRUE

/turf/closed/indestructible/stone
	name = "石墙"
	desc = "一堵由异常坚固的石砖砌成的墙。"
	icon = 'modular_nova/modules/stone/icons/wall.dmi'
	icon_state = "wall-0"
	base_icon_state = "wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_STONE_WALLS + SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_STONE_WALLS
	custom_materials = list(
		/datum/material/stone = SHEET_MATERIAL_AMOUNT  * 2,
	)

/obj/structure/falsewall/stone
	name = "石墙"
	desc = "一堵由坚固石砖砌成的墙。"
	icon = 'modular_nova/modules/stone/icons/wall.dmi'
	icon_state = "wall-open"
	base_icon_state = "wall"
	fake_icon = 'modular_nova/modules/stone/icons/wall.dmi'
	mineral = /obj/item/stack/sheet/mineral/stone
	walltype = /turf/closed/wall/mineral/stone
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_STONE_WALLS + SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_STONE_WALLS

/turf/closed/mineral/gets_drilled(mob/user, exp_multiplier = 0, triggered_by_explosion = FALSE)
	if(prob(5))
		new /obj/item/stack/stone(src)

	return ..()

/obj/item/stack/sheet/mineral/stone/fifty
	amount = 50
