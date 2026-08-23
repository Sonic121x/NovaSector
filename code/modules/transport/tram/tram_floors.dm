// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/turf/open/floor/noslip/tram
	name = "high-traction tram platform"
	icon = 'icons/turf/tram.dmi'
	icon_state = "noslip_tram"
	base_icon_state = "noslip_tram"
	floor_tile = /obj/item/stack/tile/noslip/tram

/turf/open/floor/tram
	name = "tram guideway"
	icon = 'icons/turf/tram.dmi'
	icon_state = "tram_platform"
	base_icon_state = "tram_platform"
	floor_tile = /obj/item/stack/tile/tram
	footstep = FOOTSTEP_CATWALK
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_turf = FALSE
	rcd_proof = TRUE

/turf/open/floor/tram/examine(mob/user)
	. += ..()
	. += span_notice(LANG("turf.f86d54485413ce02", list(EXAMINE_HINT("wrenched"), EXAMINE_HINT("wrench"))))

/turf/open/floor/tram/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/stack/thermoplastic))
		build_with_transport_tiles(tool, user)
		return ITEM_INTERACT_SUCCESS
	if(istype(tool, /obj/item/stack/sheet/mineral/titanium))
		build_with_titanium(tool, user)
		return ITEM_INTERACT_SUCCESS
	return NONE

/turf/open/floor/tram/make_plating(force = FALSE)
	if(force)
		return ..()
	return //unplateable

/turf/open/floor/tram/try_replace_tile(obj/item/stack/tile/replacement_tile, mob/user, list/modifiers)
	return

/turf/open/floor/tram/crowbar_act(mob/living/user, obj/item/item)
	return

/turf/open/floor/tram/wrench_act(mob/living/user, obj/item/item)
	..()
	to_chat(user, span_notice(LANG("turf.321e72ef2a695ee9", null)))
	if(item.use_tool(src, user, 30, volume=80))
		if(!istype(src, /turf/open/floor/tram))
			return TRUE
		if(floor_tile)
			new floor_tile(src, 2)
		ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
	return TRUE

/turf/open/floor/tram/ex_act(severity, target)
	if(target == src)
		ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
		return TRUE
	if(is_explosion_shielded(severity))
		return FALSE

	switch(severity)
		if(EXPLODE_DEVASTATE)
			if(prob(80))
				if(!ispath(baseturf_at_depth(2), /turf/open/floor))
					attempt_lattice_replacement()
				else
					ScrapeAway(2, flags = CHANGETURF_INHERIT_AIR)
			else
				break_tile()
		if(EXPLODE_HEAVY)
			if(prob(30))
				if(!ispath(baseturf_at_depth(2), /turf/open/floor))
					attempt_lattice_replacement()
				else
					ScrapeAway(2, flags = CHANGETURF_INHERIT_AIR)
			else
				break_tile()
		if(EXPLODE_LIGHT)
			if(prob(50))
				break_tile()

	return TRUE

/turf/open/floor/tram/broken_states()
	return list("tram_platform-damaged1","tram_platform-damaged2")

/turf/open/floor/tram/tram_platform/burnt_states()
	return list("tram_platform-scorched1","tram_platform-scorched2")

/turf/open/floor/tram/plate
	name = "linear induction plate"
	desc = "The linear induction plate that powers the tram."
	icon = 'icons/turf/tram.dmi'
	icon_state = "tram_plate"
	base_icon_state = "tram_plate"
	flags_1 = NONE

/turf/open/floor/tram/plate/broken_states()
	return list("tram_plate-damaged1","tram_plate-damaged2")

/turf/open/floor/tram/plate/burnt_states()
	return list("tram_plate-scorched1","tram_plate-scorched2")

/turf/open/floor/tram/plate/energized
	desc = "The linear induction plate that powers the tram. It is currently energized."
	/// Inbound station
	var/inbound
	/// Outbound station
	var/outbound
	/// Transport ID of the tram
	var/specific_transport_id = TRAMSTATION_LINE_1

/turf/open/floor/tram/plate/energized/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/energized, inbound, outbound, specific_transport_id)

/turf/open/floor/tram/plate/energized/examine(mob/user)
	. = ..()
	if(broken || burnt)
		. += span_danger(LANG("turf.e7463f169bc3b8e4", null))
		. += span_notice(LANG("turf.99ed851432a5e089", list(EXAMINE_HINT("titanium sheet"))))

/turf/open/floor/tram/plate/energized/broken_states()
	return list("energized_plate_damaged")

/turf/open/floor/tram/plate/energized/burnt_states()
	return list("energized_plate_damaged")

/turf/open/floor/tram/plate/energized/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!broken && !burnt)
		return NONE
	if(!istype(tool, /obj/item/stack/sheet/mineral/titanium))
		return NONE
	if(!tool.use(1))
		return ITEM_INTERACT_BLOCKING
	broken = FALSE
	update_appearance()
	balloon_alert(user, LANG("turf.71c2f637d7b41282", null))
	return ITEM_INTERACT_SUCCESS

/turf/open/floor/tram/plate/energized/broken
	broken = TRUE

// Resetting the tram contents to its original state needs the turf to be there
/turf/open/indestructible/tram
	name = "tram guideway"
	icon = 'icons/turf/tram.dmi'
	icon_state = "tram_platform"
	base_icon_state = "tram_platform"
	footstep = FOOTSTEP_CATWALK
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/indestructible/tram/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/stack/thermoplastic))
		build_with_transport_tiles(tool, user)
		return ITEM_INTERACT_SUCCESS
	if(istype(tool, /obj/item/stack/sheet/mineral/titanium))
		build_with_titanium(tool, user)
		return ITEM_INTERACT_SUCCESS
	return NONE

/turf/open/indestructible/tram/plate
	name = "linear induction plate"
	desc = "The linear induction plate that powers the tram."
	icon_state = "tram_plate"
	base_icon_state = "tram_plate"
	flags_1 = NONE

/turf/open/floor/glass/reinforced/tram/Initialize(mapload)
	. = ..()
	RemoveElement(/datum/element/atmos_sensitive, mapload)

/turf/open/floor/glass/reinforced/tram
	name = "tram bridge"
	desc = "It shakes a bit when you step, but lets you cross between sides quickly!"

/obj/structure/thermoplastic
	name = "tram floor"
	desc = "A lightweight thermoplastic flooring."
	icon = 'icons/turf/tram.dmi'
	icon_state = "tram_dark"
	base_icon_state = "tram_dark"
	density = FALSE
	anchored = TRUE
	max_integrity = 150
	integrity_failure = 0.75
	armor_type = /datum/armor/tram_floor
	layer = TRAM_FLOOR_LAYER
	plane = GAME_PLANE
	obj_flags = BLOCK_Z_OUT_DOWN | BLOCK_Z_OUT_UP
	appearance_flags = PIXEL_SCALE|KEEP_TOGETHER
	custom_materials = list(/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT / 2)
	var/secured = TRUE
	var/floor_tile = /obj/item/stack/thermoplastic
	var/mutable_appearance/damage_overlay

/obj/structure/thermoplastic/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/force_move_pulled)

/datum/armor/tram_floor
	melee = 40
	bullet = 10
	laser = 10
	bomb = 45
	fire = 90
	acid = 100

/obj/structure/thermoplastic/light
	icon_state = "tram_light"
	base_icon_state = "tram_light"
	floor_tile = /obj/item/stack/thermoplastic/light

/obj/structure/thermoplastic/examine(mob/user)
	. = ..()

	if(secured)
		. += span_notice(LANG("obj.a578c58d09587c99", list(EXAMINE_HINT("screws."), EXAMINE_HINT("screwdriver."))))
	else
		. += span_notice(LANG("obj.ff2110d8bc1345f8", list(EXAMINE_HINT("crowbar"))))
		. += span_notice(LANG("obj.6fd5b2eac8706e5d", list(EXAMINE_HINT("screwdriver."))))

/obj/structure/thermoplastic/take_damage(damage_amount, damage_type = BRUTE, damage_flag = "", sound_effect = TRUE, attack_dir, armour_penetration = 0)
	. = ..()
	if(.) //received damage
		update_appearance()

/obj/structure/thermoplastic/update_icon_state()
	. = ..()
	var/ratio = atom_integrity / max_integrity
	ratio = ceil(ratio * 4) * 25
	if(ratio > 75)
		icon_state = base_icon_state
		return

	icon_state = "[base_icon_state]_damage[ratio]"

/obj/structure/thermoplastic/screwdriver_act_secondary(mob/living/user, obj/item/tool)
	. = ..()
	if(secured)
		user.visible_message(span_notice(LANG("obj.571d20f0e0a6e891", list(user))),
		span_notice(LANG("obj.679179c6e13638b4", null)))
		if(tool.use_tool(src, user, 1 SECONDS, volume = 50))
			secured = FALSE
			to_chat(user, span_notice(LANG("obj.4630c56227e957b0", null)))
	else
		user.visible_message(span_notice(LANG("obj.8fdf64255c7bfcf6", list(user))),
		span_notice(LANG("obj.8993a9b9132bbc97", null)))
		if(tool.use_tool(src, user, 1 SECONDS, volume = 50))
			secured = TRUE
			to_chat(user, span_notice(LANG("obj.9248c7b720df741f", null)))

	return ITEM_INTERACT_SUCCESS

/obj/structure/thermoplastic/crowbar_act_secondary(mob/living/user, obj/item/tool)
	. = ..()
	if(secured)
		to_chat(user, span_warning(LANG("obj.b436b070badd040f", null)))
		return FALSE

	else
		user.visible_message(span_notice(LANG("obj.b9f905f941e477ac", list(user, tool))),
		span_notice(LANG("obj.4906368b5b05a7e3", list(tool))))
		if(tool.use_tool(src, user, 1 SECONDS, volume = 50))
			to_chat(user, span_notice(LANG("obj.735aa41b5878e4e7", null)))
			var/obj/item/stack/thermoplastic/pulled_tile = new floor_tile()
			pulled_tile.update_integrity(atom_integrity)
			user.put_in_hands(pulled_tile)
			qdel(src)

	return ITEM_INTERACT_SUCCESS

/obj/structure/thermoplastic/welder_act(mob/living/user, obj/item/tool)
	if(atom_integrity >= max_integrity)
		to_chat(user, span_warning(LANG("obj.7f6370b2939fd6c1", list(src))))
		return ITEM_INTERACT_SUCCESS
	if(!tool.tool_start_check(user, amount = 0, heat_required = HIGH_TEMPERATURE_REQUIRED))
		return FALSE
	to_chat(user, span_notice(LANG("obj.93449ef42b686baf", list(src))))
	var/integrity_to_repair = max_integrity - atom_integrity
	if(tool.use_tool(src, user, integrity_to_repair * 0.5, volume = 50))
		atom_integrity = max_integrity
		to_chat(user, span_notice(LANG("obj.e94d13ebf50e7df1", list(src))))
		update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/item/stack/thermoplastic
	name = "thermoplastic tram tile"
	singular_name = "thermoplastic tram tile"
	desc = "A high-traction floor tile. It sparkles in the light."
	icon = 'icons/obj/tiles.dmi'
	lefthand_file = 'icons/mob/inhands/items/tiles_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/tiles_righthand.dmi'
	icon_state = "tile_tram_dark"
	inhand_icon_state = "tile-tram"
	color = COLOR_TRAM_BLUE
	w_class = WEIGHT_CLASS_NORMAL
	force = 1
	throwforce = 1
	throw_speed = 3
	throw_range = 7
	max_amount = 60
	novariants = TRUE
	merge_type = /obj/item/stack/thermoplastic
	mats_per_unit = list(/datum/material/plastic = HALF_SHEET_MATERIAL_AMOUNT / 2)
	var/tile_type = /obj/structure/thermoplastic

/obj/item/stack/thermoplastic/light
	icon_state = "tile_tram_light"
	color = COLOR_TRAM_LIGHT_BLUE
	merge_type = /obj/item/stack/thermoplastic/light
	tile_type = /obj/structure/thermoplastic/light

/obj/item/stack/thermoplastic/Initialize(mapload, new_amount, merge = TRUE, list/mat_override=null, mat_amt=1)
	. = ..()
	pixel_x = rand(-3, 3)
	pixel_y = rand(-3, 3) //randomize a little

/obj/item/stack/thermoplastic/examine(mob/user)
	. = ..()
	if(throwforce && !is_cyborg) //do not want to divide by zero or show the message to borgs who can't throw
		var/damage_value
		switch(ceil(MAX_LIVING_HEALTH / throwforce)) //throws to crit a human
			if(1 to 3)
				damage_value = "superb"
			if(4 to 6)
				damage_value = "great"
			if(7 to 9)
				damage_value = "good"
			if(10 to 12)
				damage_value = "fairly decent"
			if(13 to 15)
				damage_value = "mediocre"
		if(!damage_value)
			return
		. += span_notice(LANG("obj.9a8a884d8e612595", list(damage_value)))
