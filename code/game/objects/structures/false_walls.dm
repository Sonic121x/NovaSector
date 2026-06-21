/*
 * False Walls
 */
/obj/structure/falsewall
	name = "墙"
	desc = "用来分隔房间的一大块金属"
	anchored = TRUE
	icon = 'icons/turf/walls/false_walls.dmi'
	icon_state = "wall-open"
	base_icon_state = "wall"
	layer = LOW_OBJ_LAYER
	density = TRUE
	opacity = TRUE
	max_integrity = 100
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_WALLS
	can_atmos_pass = ATMOS_PASS_DENSITY
	rad_insulation = RAD_MEDIUM_INSULATION
	material_flags = MATERIAL_EFFECTS
	/// The icon this falsewall is faking being. we'll switch out our icon with this when we're in fake mode
	var/fake_icon = 'icons/turf/walls/wall.dmi'
	var/mineral = /obj/item/stack/sheet/iron
	var/mineral_amount = 2
	var/walltype = /turf/closed/wall
	var/girder_type = /obj/structure/girder/displaced
	var/opening = FALSE

/obj/structure/falsewall/get_save_vars()
	. = ..()
	. -= NAMEOF(src, icon)
	return .

/obj/structure/falsewall/Initialize(mapload)
	. = ..()
	var/obj/item/stack/initialized_mineral = new mineral // Okay this kinda sucks.
	set_custom_materials(initialized_mineral.mats_per_unit, mineral_amount)
	qdel(initialized_mineral)
	air_update_turf(TRUE, TRUE)
	update_appearance()

/obj/structure/falsewall/attack_hand(mob/user, list/modifiers)
	if(opening)
		return
	. = ..()
	if(.)
		return

	if(!density)
		for(var/mob/living/obstacle in get_turf(src)) //Stop people from using this as a shield
			return

	opening = TRUE
	update_appearance()
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/structure/falsewall, toggle_open)), 0.5 SECONDS)

/obj/structure/falsewall/proc/toggle_open()
	if(!QDELETED(src))
		set_density(!density)
		set_opacity(density)
		opening = FALSE
		update_appearance()
		air_update_turf(TRUE, !density)

/obj/structure/falsewall/update_icon(updates=ALL)//Calling icon_update will refresh the smoothwalls if it's closed, otherwise it will make sure the icon is correct if it's open
	. = ..()
	if(!density || !(updates & UPDATE_SMOOTHING))
		return

	if(opening)
		smoothing_flags = NONE
	else
		smoothing_flags = SMOOTH_BITMASK | SMOOTH_OBJ
		QUEUE_SMOOTH(src)

/obj/structure/falsewall/update_icon_state()
	if(opening)
		icon = initial(icon)
		icon_state = "[base_icon_state]-[density ? "opening" : "closing"]"
		return ..()
	if(density)
		icon = fake_icon
		icon_state = "[base_icon_state]-[smoothing_junction]"
	else
		icon = initial(icon)
		icon_state = "[base_icon_state]-open"
	return ..()

/obj/structure/falsewall/proc/ChangeToWall(delete = 1)
	var/turf/T = get_turf(src)
	T.place_on_top(walltype)
	if(delete)
		qdel(src)
	return T

/obj/structure/falsewall/tool_act(mob/living/user, obj/item/tool, list/modifiers)
	if(!opening || !tool.tool_behaviour)
		return ..()
	to_chat(user, span_warning("你必须等到门停止移动！"))
	return ITEM_INTERACT_BLOCKING

/obj/structure/falsewall/screwdriver_act(mob/living/user, obj/item/tool)
	if(!density)
		to_chat(user, span_warning("你够不着，先把它关上！"))
		return
	var/turf/loc_turf = get_turf(src)
	if(loc_turf.density)
		to_chat(user, span_warning("[src]被挡住了！"))
		return ITEM_INTERACT_SUCCESS
	if(!isfloorturf(loc_turf))
		to_chat(user, span_warning("[src]的螺栓必须在地面上拧紧！"))
		return ITEM_INTERACT_SUCCESS
	user.visible_message(span_notice("[user]拧紧了墙上的几个螺栓。"), span_notice("你拧紧了墙上的螺栓。"))
	ChangeToWall()
	return ITEM_INTERACT_SUCCESS


/obj/structure/falsewall/welder_act(mob/living/user, obj/item/tool)
	if(tool.use_tool(src, user, 0 SECONDS, volume=50))
		dismantle(user, TRUE)
		return ITEM_INTERACT_SUCCESS
	return

/obj/structure/falsewall/attackby(obj/item/W, mob/user, list/modifiers, list/attack_modifiers)
	if(!opening)
		return ..()
	to_chat(user, span_warning("你必须等到门停止移动！"))
	return

/obj/structure/falsewall/proc/dismantle(mob/user, disassembled=TRUE, obj/item/tool = null)
	user.visible_message(span_notice("[user]拆除了假墙。"), span_notice("你拆除了假墙。"))
	if(tool)
		tool.play_tool_sound(src, 100)
	else
		playsound(src, 'sound/items/tools/welder.ogg', 100, TRUE)
	deconstruct(disassembled)

/obj/structure/falsewall/atom_deconstruct(disassembled = TRUE)
	if(disassembled)
		new girder_type(loc)
	if(mineral_amount)
		for(var/i in 1 to mineral_amount)
			new mineral(loc)

/obj/structure/falsewall/get_dumping_location()
	return null

/obj/structure/falsewall/examine_status(mob/user) //So you can't detect falsewalls by examine.
	to_chat(user, span_notice("外层板材已被<b>焊接</b>牢固。"))
	return null

/obj/structure/falsewall/mouse_drop_receive(mob/living/dropping, mob/user, params)
	. = ..()
	LoadComponent(/datum/component/leanable, dropping)

/*
 * False R-Walls
 */

/obj/structure/falsewall/reinforced
	name = "加固墙"
	desc = "用来分隔房间的一大块加固金属"
	fake_icon = 'icons/turf/walls/reinforced_wall.dmi'
	icon_state = "reinforced_wall-open"
	base_icon_state = "reinforced_wall"
	walltype = /turf/closed/wall/r_wall
	mineral = /obj/item/stack/sheet/plasteel
	smoothing_flags = SMOOTH_BITMASK

/obj/structure/falsewall/reinforced/examine_status(mob/user)
	to_chat(user, span_notice("外层<b>格栅</b>完好无损。"))
	return null

/obj/structure/falsewall/reinforced/attackby(obj/item/tool, mob/user)
	..()
	if(tool.tool_behaviour == TOOL_WIRECUTTER)
		dismantle(user, TRUE, tool)

/*
 * Uranium Falsewalls
 */

/obj/structure/falsewall/uranium
	name = "铀墙"
	desc = "一堵镀有铀的墙. 这真的很可能是个坏主意."
	fake_icon = 'icons/turf/walls/uranium_wall.dmi'
	icon_state = "uranium_wall-open"
	base_icon_state = "uranium_wall"
	mineral = /obj/item/stack/sheet/mineral/uranium
	walltype = /turf/closed/wall/mineral/uranium
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_URANIUM_WALLS + SMOOTH_GROUP_WALLS
	canSmoothWith = SMOOTH_GROUP_URANIUM_WALLS

	/// Mutex to prevent infinite recursion when propagating radiation pulses
	var/active = null

	/// The last time a radiation pulse was performed
	var/last_event = 0

/obj/structure/falsewall/uranium/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_ATOM_PROPAGATE_RAD_PULSE, PROC_REF(radiate))

/obj/structure/falsewall/uranium/attackby(obj/item/W, mob/user, list/modifiers, list/attack_modifiers)
	radiate()
	return ..()

/obj/structure/falsewall/uranium/attack_hand(mob/user, list/modifiers)
	radiate()
	return ..()

/obj/structure/falsewall/uranium/proc/radiate()
	SIGNAL_HANDLER
	if(active)
		return
	if(world.time <= last_event + 1.5 SECONDS)
		return
	active = TRUE
	radiation_pulse(
		src,
		max_range = 3,
		threshold = RAD_LIGHT_INSULATION,
		chance = URANIUM_IRRADIATION_CHANCE,
		minimum_exposure_time = URANIUM_RADIATION_MINIMUM_EXPOSURE_TIME,
	)
	propagate_radiation_pulse()
	last_event = world.time
	active = FALSE
/*
 * Other misc falsewall types
 */

/obj/structure/falsewall/gold
	name = "金墙"
	desc = "镀金的墙壁。潮！"
	fake_icon = 'icons/turf/walls/gold_wall.dmi'
	icon_state = "gold_wall-open"
	base_icon_state = "gold_wall"
	mineral = /obj/item/stack/sheet/mineral/gold
	walltype = /turf/closed/wall/mineral/gold
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_GOLD_WALLS + SMOOTH_GROUP_WALLS
	canSmoothWith = SMOOTH_GROUP_GOLD_WALLS

/obj/structure/falsewall/silver
	name = "银墙"
	desc = "镀银的墙壁. 好闪"
	fake_icon = 'icons/turf/walls/silver_wall.dmi'
	icon_state = "silver_wall-open"
	base_icon_state = "silver_wall"
	mineral = /obj/item/stack/sheet/mineral/silver
	walltype = /turf/closed/wall/mineral/silver
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_SILVER_WALLS + SMOOTH_GROUP_WALLS
	canSmoothWith = SMOOTH_GROUP_SILVER_WALLS

/obj/structure/falsewall/diamond
	name = "钻石墙"
	desc = "镀有钻石的墙壁. 浪费材料的贵物"
	fake_icon = 'icons/turf/walls/diamond_wall.dmi'
	icon_state = "diamond_wall-open"
	base_icon_state = "diamond_wall"
	mineral = /obj/item/stack/sheet/mineral/diamond
	walltype = /turf/closed/wall/mineral/diamond
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_DIAMOND_WALLS + SMOOTH_GROUP_WALLS
	canSmoothWith = SMOOTH_GROUP_DIAMOND_WALLS
	max_integrity = 800

/obj/structure/falsewall/plasma
	name = "等离子墙"
	desc = "一堵镀有等离子的墙壁. 这绝对是个坏主意"
	fake_icon = 'icons/turf/walls/plasma_wall.dmi'
	icon_state = "plasma_wall-open"
	base_icon_state = "plasma_wall"
	mineral = /obj/item/stack/sheet/mineral/plasma
	walltype = /turf/closed/wall/mineral/plasma
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_PLASMA_WALLS + SMOOTH_GROUP_WALLS
	canSmoothWith = SMOOTH_GROUP_PLASMA_WALLS

/obj/structure/falsewall/bananium
	name = "蕉矿墙"
	desc = "一面镀有蕉矿的墙。嘟嘟！"
	fake_icon = 'icons/turf/walls/bananium_wall.dmi'
	icon_state = "bananium_wall-open"
	base_icon_state = "bananium_wall"
	mineral = /obj/item/stack/sheet/mineral/bananium
	walltype = /turf/closed/wall/mineral/bananium
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_BANANIUM_WALLS + SMOOTH_GROUP_WALLS
	canSmoothWith = SMOOTH_GROUP_BANANIUM_WALLS


/obj/structure/falsewall/sandstone
	name = "砂岩墙"
	desc = "用砂岩垒成的墙。好粗糙。"
	fake_icon = 'icons/turf/walls/sandstone_wall.dmi'
	icon_state = "sandstone_wall-open"
	base_icon_state = "sandstone_wall"
	mineral = /obj/item/stack/sheet/mineral/sandstone
	walltype = /turf/closed/wall/mineral/sandstone
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_SANDSTONE_WALLS + SMOOTH_GROUP_WALLS
	canSmoothWith = SMOOTH_GROUP_SANDSTONE_WALLS

/obj/structure/falsewall/wood
	name = "木墙"
	desc = "用木板垒成的墙。好硬。"
	fake_icon = 'icons/turf/walls/wood_wall.dmi'
	icon_state = "wood_wall-open"
	base_icon_state = "wood_wall"
	mineral = /obj/item/stack/sheet/mineral/wood
	walltype = /turf/closed/wall/mineral/wood
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_WOOD_WALLS + SMOOTH_GROUP_WALLS
	canSmoothWith = SMOOTH_GROUP_WOOD_WALLS

/obj/structure/falsewall/bamboo
	name = "竹墙"
	desc = "用竹子垒成的墙。好禅。"
	fake_icon = 'icons/turf/walls/bamboo_wall.dmi'
	icon_state = "bamboo_wall-open"
	base_icon_state = "bamboo_wall"
	mineral = /obj/item/stack/sheet/mineral/bamboo
	walltype = /turf/closed/wall/mineral/bamboo
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_BAMBOO_WALLS + SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_BAMBOO_WALLS

/obj/structure/falsewall/iron
	name = "粗铁墙"
	desc = "用粗制金属板镀成的墙。"
	fake_icon = 'icons/turf/walls/iron_wall.dmi'
	icon_state = "iron_wall-open"
	base_icon_state = "iron_wall"
	mineral = /obj/item/stack/rods
	mineral_amount = 5
	walltype = /turf/closed/wall/mineral/iron
	base_icon_state = "iron_wall"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_IRON_WALLS + SMOOTH_GROUP_WALLS
	canSmoothWith = SMOOTH_GROUP_IRON_WALLS

/obj/structure/falsewall/abductor
	name = "外星墙"
	desc = "用外星合金电镀的墙。"
	fake_icon = 'icons/turf/walls/abductor_wall.dmi'
	icon_state = "abductor_wall-open"
	base_icon_state = "abductor_wall"
	mineral = /obj/item/stack/sheet/mineral/abductor
	walltype = /turf/closed/wall/mineral/abductor
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_ABDUCTOR_WALLS + SMOOTH_GROUP_WALLS
	canSmoothWith = SMOOTH_GROUP_ABDUCTOR_WALLS

/obj/structure/falsewall/titanium
	name = "wall"
	desc = "一种用于穿梭机的轻质钛钢墙。"
	fake_icon = 'icons/turf/walls/shuttle_wall.dmi'
	icon_state = "shuttle_wall-open"
	base_icon_state = "shuttle_wall"
	mineral = /obj/item/stack/sheet/mineral/titanium
	walltype = /turf/closed/wall/mineral/titanium
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_TITANIUM_WALLS + SMOOTH_GROUP_WALLS
	canSmoothWith = SMOOTH_GROUP_SHUTTLE_PARTS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_TITANIUM_WALLS

/obj/structure/falsewall/plastitanium
	name = "wall"
	desc = "等离子体和钛钢构成的邪恶之墙。"
	fake_icon = 'icons/turf/walls/plastitanium_wall.dmi'
	icon_state = "plastitanium_wall-open"
	base_icon_state = "plastitanium_wall"
	mineral = /obj/item/stack/sheet/mineral/plastitanium
	walltype = /turf/closed/wall/mineral/plastitanium
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_PLASTITANIUM_WALLS + SMOOTH_GROUP_WALLS
	canSmoothWith = SMOOTH_GROUP_SHUTTLE_PARTS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_PLASTITANIUM_WALLS

/obj/structure/falsewall/material
	name = "wall"
	desc = "等离子体和钛构成的邪恶之墙。"
	fake_icon = 'icons/turf/walls/material_wall.dmi'
	icon_state = "material_wall-open"
	base_icon_state = "material_wall"
	walltype = /turf/closed/wall/material
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS + SMOOTH_GROUP_MATERIAL_WALLS
	canSmoothWith = SMOOTH_GROUP_MATERIAL_WALLS
	material_flags = MATERIAL_EFFECTS | MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS

/obj/structure/falsewall/material/atom_deconstruct(disassembled = TRUE)
	if(disassembled)
		new girder_type(loc)
	for(var/material in custom_materials)
		var/datum/material/material_datum = material
		new material_datum.sheet_type(loc, FLOOR(custom_materials[material_datum] / SHEET_MATERIAL_AMOUNT, 1))

/obj/structure/falsewall/material/finalize_material_effects(list/materials)
	. = ..()
	desc = "一大块[get_material_english_list(materials)]，用于分隔房间。"

/obj/structure/falsewall/material/toggle_open()
	if(!QDELETED(src))
		set_density(!density)
		var/mat_opacity = TRUE
		for(var/datum/material/mat in custom_materials)
			if(mat.alpha < 255)
				mat_opacity = FALSE
				break
		set_opacity(density && mat_opacity)
		opening = FALSE
		update_appearance()
		air_update_turf(TRUE, !density)

/obj/structure/falsewall/material/ChangeToWall(delete = 1)
	var/turf/current_turf = get_turf(src)
	var/turf/closed/wall/material/new_wall = current_turf.place_on_top(/turf/closed/wall/material)
	new_wall.set_custom_materials(custom_materials)
	if(delete)
		qdel(src)
	return current_turf

/obj/structure/falsewall/material/update_icon(updates)
	. = ..()
	for(var/datum/material/mat in custom_materials)
		if(mat.alpha < 255)
			update_transparency_underlays()
			return

/obj/structure/falsewall/material/proc/update_transparency_underlays()
	underlays.Cut()
	var/girder_icon_state = "displaced"
	if(opening)
		girder_icon_state += "_[density ? "opening" : "closing"]"
	else if(!density)
		girder_icon_state += "_open"
	var/mutable_appearance/girder_underlay = mutable_appearance('icons/obj/structures.dmi', girder_icon_state, layer = LOW_OBJ_LAYER-0.01, appearance_flags = RESET_ALPHA | RESET_COLOR | KEEP_APART)
	underlays += girder_underlay
