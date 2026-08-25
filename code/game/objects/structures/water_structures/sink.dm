// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/structure/sink
	name = "sink"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "sink"
	desc = "A sink used for washing one's hands and face. Passively reclaims water over time."
	anchored = TRUE
	layer = ABOVE_OBJ_LAYER
	pixel_z = 1
	///Something's being washed at the moment
	var/busy = FALSE
	///Capacity of this sink
	var/capacity = 100
	///What kind of reagent is produced by this sink by default? (We now have actual plumbing, Arcane, August 2020)
	var/dispensedreagent = /datum/reagent/water
	///Material to drop when broken or deconstructed.
	var/buildstacktype = /obj/item/stack/sheet/iron
	///Number of sheets of material to drop when broken or deconstructed.
	var/buildstackamount = 1
	///Does the sink have a water recycler to recollect its water supply?
	var/has_water_reclaimer = TRUE
	///Units of water to reclaim per second
	var/reclaim_rate = 0.5

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sink, (-14))

/obj/structure/sink/Initialize(mapload)
	. = ..()

	create_reagents(capacity, NO_REACT)
	if(has_water_reclaimer)
		reagents.add_reagent(dispensedreagent, capacity)
	AddComponent(/datum/component/plumbing/simple_demand/extended)

	register_context()

	if(mapload && !find_and_mount_on_atom(mark_for_late_init = TRUE))
		return INITIALIZE_HINT_LATELOAD

/obj/structure/sink/LateInitialize()
	find_and_mount_on_atom(late_init = TRUE)

/obj/structure/sink/atom_deconstruct(dissambled = TRUE)
	if(buildstacktype)
		new buildstacktype(loc,buildstackamount)
	else
		for(var/i in custom_materials)
			var/datum/material/M = i
			new M.sheet_type(loc, FLOOR(custom_materials[M] / SHEET_MATERIAL_AMOUNT, 1))
	if(has_water_reclaimer)
		new /obj/item/stock_parts/water_recycler(drop_location())

/obj/structure/sink/is_mountable_turf(turf/target)
	return !isgroundlessturf(target)

/obj/structure/sink/get_turfs_to_mount_on()
	return list(get_turf(src))

/obj/structure/sink/get_mountable_objects()
	return list()

/obj/structure/sink/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = NONE
	if(isnull(held_item))
		context[SCREENTIP_CONTEXT_LMB] = "Wash hands"
		return CONTEXTUAL_SCREENTIP_SET

	if(is_reagent_container(held_item))
		if(held_item.is_refillable() && !held_item.reagents.holder_full())
			context[SCREENTIP_CONTEXT_LMB] = "Fill container"
		if(held_item.reagents.total_volume > 0)
			context[SCREENTIP_CONTEXT_RMB] = "Drain container"
		return CONTEXTUAL_SCREENTIP_SET

	if(istype(held_item, /obj/item/mop) || astype(held_item, /obj/item/rag)?.blood_level == 0)
		context[SCREENTIP_CONTEXT_LMB] = "Wet mop"
		context[SCREENTIP_CONTEXT_RMB] = "Wash out mop"
		return CONTEXTUAL_SCREENTIP_SET

	if(istype(held_item, /obj/item/stock_parts/water_recycler) && !has_water_reclaimer)
		context[SCREENTIP_CONTEXT_LMB] = "Install recycler"
		return CONTEXTUAL_SCREENTIP_SET

	if(istype(held_item, /obj/item/storage/fancy/pickles_jar))
		context[SCREENTIP_CONTEXT_LMB] = "Clean pickle jar"
		return CONTEXTUAL_SCREENTIP_SET

	if(!user.combat_mode || (held_item.item_flags & NOBLUDGEON))
		context[SCREENTIP_CONTEXT_LMB] = "Clean item"
		return CONTEXTUAL_SCREENTIP_SET

/obj/structure/sink/examine(mob/user)
	. = ..()
	if(has_water_reclaimer)
		. += span_notice(LANG("obj.6a25c0f25c1d92e4", null))
	. += span_notice(LANG("obj.31941555602f62b7", list(reagents.total_volume, reagents.maximum_volume)))
	. += span_notice(LANG("obj.fb34d46bda64385b", list(EXAMINE_HINT("right-click"))))

/obj/structure/sink/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!user || !istype(user))
		return
	if(!iscarbon(user))
		return
	if(!Adjacent(user))
		return
	if(reagents.total_volume < 5)
		to_chat(user, span_warning(LANG("obj.6e9b3a6890cdcc6c", null)))
		return
	if(busy)
		to_chat(user, span_warning(LANG("obj.d5ba1f8cb2273d77", null)))
		return

	var/selected_area = user.parse_zone_with_bodypart(user.zone_selected)
	var/washing_face = FALSE
	if(selected_area in list(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_PRECISE_EYES))
		washing_face = TRUE

	playsound(src, 'sound/machines/sink-faucet.ogg', 50)
	user.visible_message(span_notice(LANG("obj.d6e9d9cdb5ba9e5b", list(user, user.p_their(), washing_face ? "face" : "hands"))), \
						span_notice(LANG("obj.51a016361a7d4862", list(washing_face ? "face" : "hands"))))
	busy = TRUE

	if(!do_after(user, 4 SECONDS, target = src))
		busy = FALSE
		return

	busy = FALSE
	reagents.expose(user, TOUCH, 5 / max(reagents.total_volume, 5))
	reagents.remove_all(5)
	START_PROCESSING(SSobj, src)
	if(washing_face)
		SEND_SIGNAL(user, COMSIG_COMPONENT_CLEAN_FACE_ACT, CLEAN_WASH)
	else if(ishuman(user))
		var/mob/living/carbon/human/human_user = user
		if(!human_user.wash_hands(CLEAN_WASH))
			to_chat(user, span_warning(LANG("obj.7d1649c9f6a1197f", null)))
			return
	else
		user.wash(CLEAN_WASH)

	user.visible_message(span_notice(LANG("obj.b1726f637e11479d", list(user, user.p_their(), washing_face ? "face" : "hands", src))), \
						span_notice(LANG("obj.3892bd556b54860b", list(washing_face ? "face" : "hands", src))))

/obj/structure/sink/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = NONE
	if(busy)
		to_chat(user, span_warning(LANG("obj.d5ba1f8cb2273d77", null)))
		return ITEM_INTERACT_FAILURE

	if(is_reagent_container(tool))
		var/obj/item/reagent_containers/RG = tool
		if(!reagents.total_volume)
			to_chat(user, span_notice(LANG("obj.9043fdab29ed6609", list(src))))
			return ITEM_INTERACT_FAILURE
		if(RG.is_refillable())
			if(!RG.reagents.holder_full())
				reagents.trans_to(RG, RG.amount_per_transfer_from_this, transferred_by = user)
				START_PROCESSING(SSobj, src)
				to_chat(user, span_notice(LANG("obj.3adf2506e97dc688", list(RG, src))))
				return ITEM_INTERACT_SUCCESS
			to_chat(user, span_notice(LANG("obj.03adc6e9eaa5eda9", list(RG))))
		return ITEM_INTERACT_FAILURE

	if(istype(tool, /obj/item/mop) || astype(tool, /obj/item/rag)?.blood_level == 0)
		if(!reagents.total_volume)
			to_chat(user, span_notice(LANG("obj.9043fdab29ed6609", list(src))))
			return ITEM_INTERACT_FAILURE
		reagents.trans_to(tool, 5, transferred_by = user)
		START_PROCESSING(SSobj, src)
		to_chat(user, span_notice(LANG("obj.c4984f89d406562c", list(tool, src))))
		playsound(loc, 'sound/effects/slosh.ogg', 25, TRUE)
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/stock_parts/water_recycler))
		if(has_water_reclaimer)
			to_chat(user, span_warning(LANG("obj.54d98562497bd0d7", null)))
			return ITEM_INTERACT_FAILURE

		playsound(src, 'sound/machines/click.ogg', 20, TRUE)
		qdel(tool)
		has_water_reclaimer = TRUE
		START_PROCESSING(SSobj, src)
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/storage/fancy/pickles_jar))
		if(tool.contents.len)
			to_chat(user, span_notice(LANG("obj.e7bcc65c864c9946", null)))
			return ITEM_INTERACT_FAILURE
		qdel(tool)
		to_chat(user, span_notice(LANG("obj.e45bfaf164005616", null)))
		user.put_in_active_hand(new /obj/item/reagent_containers/cup/beaker/large(loc))
		return ITEM_INTERACT_SUCCESS

	if(!user.combat_mode || (tool.item_flags & NOBLUDGEON))
		if(reagents.total_volume < 5)
			to_chat(user, span_warning(LANG("obj.6e9b3a6890cdcc6c", null)))
			return ITEM_INTERACT_FAILURE

		to_chat(user, span_notice(LANG("obj.baf588ee650ec721", list(tool))))
		playsound(src, 'sound/machines/sink-faucet.ogg', 50)

		var/obj/item/melee/baton/security/baton = tool
		if(istype(baton) && baton.active && baton.cell?.use(baton.cell_hit_cost, force = TRUE))
			flick("baton_active", src)
			user.Paralyze(baton.knockdown_time)
			user.set_stutter(baton.knockdown_time)
			user.visible_message(span_warning(LANG("obj.0ce5feedec53b412", list(user, user.p_them(), baton.name))), \
								span_userdanger(LANG("obj.97884035ea4317d9", list(baton))))
			playsound(src, baton.on_stun_sound, 50, TRUE)
			return ITEM_INTERACT_FAILURE

		busy = TRUE
		if(!do_after(user, 4 SECONDS, target = src))
			busy = FALSE
			return ITEM_INTERACT_FAILURE
		busy = FALSE
		tool.wash(CLEAN_WASH)
		reagents.expose(tool, TOUCH, 5 / max(reagents.total_volume, 5))
		reagents.remove_all(5)
		START_PROCESSING(SSobj, src)
		user.visible_message(span_notice(LANG("obj.39b6ee6aeac2b202", list(user, tool, src))), \
							span_notice(LANG("obj.94ce754d4fdc0a00", list(tool, src))))
		return ITEM_INTERACT_SUCCESS

/obj/structure/sink/item_interaction_secondary(mob/living/user, obj/item/held_item, list/modifiers)
	if(!is_reagent_container(held_item) && !istype(held_item, /obj/item/mop))
		return ..()

	if(busy)
		to_chat(user, span_warning(LANG("obj.d5ba1f8cb2273d77", null)))
		return ITEM_INTERACT_BLOCKING

	if(held_item.reagents.total_volume <= 0)
		balloon_alert(user, LANG("obj.0cdc41dcfec8a1db", null))
		return ITEM_INTERACT_BLOCKING

	held_item.reagents.clear_reagents()
	playsound(src, 'sound/effects/slosh.ogg', 25, TRUE)

	user.visible_message(
		span_notice(LANG("obj.7f9a59456fc4d2b1", list(user, held_item, src))),
		span_notice(LANG("obj.19299be638b3e8f5", list(held_item, src))),
	)
	return ITEM_INTERACT_SUCCESS

/obj/structure/sink/wrench_act(mob/living/user, obj/item/tool)
	tool.play_tool_sound(src)
	deconstruct(TRUE)
	return ITEM_INTERACT_SUCCESS

/obj/structure/sink/crowbar_act(mob/living/user, obj/item/tool)
	. = ..()

	if(!has_water_reclaimer)
		to_chat(user, span_warning(LANG("obj.fe8e1f6afe2b140c", null)))
		return ITEM_INTERACT_FAILURE

	tool.play_tool_sound(src)
	has_water_reclaimer = FALSE
	new/obj/item/stock_parts/water_recycler(get_turf(loc))
	to_chat(user, span_notice(LANG("obj.fb4e97983ebf2b04", list(src))))
	return ITEM_INTERACT_SUCCESS

/obj/structure/sink/process(seconds_per_tick)
	// Water reclamation complete?
	if(!has_water_reclaimer || reagents.holder_full())
		return PROCESS_KILL

	reagents.add_reagent(dispensedreagent, reclaim_rate * seconds_per_tick)

/obj/structure/sink/kitchen
	name = "kitchen sink"
	icon_state = "sink_alt"
	pixel_z = 4

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sink/kitchen, (-16))

/obj/structure/sink/gasstation
	name = "plasma fuel station"
	desc = "A place to refuel vehicles with liquid plasma. It can also dispense into a container."
	icon_state = "sink_gasstation"
	dispensedreagent = /datum/reagent/toxin/plasma
	has_water_reclaimer = FALSE

/obj/structure/sink/greyscale
	icon_state = "sink_greyscale"
	material_flags = MATERIAL_EFFECTS | MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS
	buildstacktype = null
	has_water_reclaimer = FALSE

/obj/structure/sink/greyscale/setDir(newdir)
	return ..(REVERSE_DIR(newdir))

/obj/structure/sink/greyscale/filled
	has_water_reclaimer = TRUE

/obj/item/wallframe/sinkframe
	name = "sink frame"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "sink_frame"
	desc = "A sink frame, that needs a water recycler to finish construction."
	wall_external = TRUE
	result_path = /obj/structure/sink/greyscale
	material_flags = MATERIAL_EFFECTS | MATERIAL_ADD_PREFIX | MATERIAL_COLOR | MATERIAL_AFFECT_STATISTICS
	pixel_shift = 16
	throw_range = 1

/obj/item/wallframe/sinkframe/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	if(istype(held_item, /obj/item/stock_parts/water_recycler) && result_path == /obj/structure/sink/greyscale)
		context[SCREENTIP_CONTEXT_LMB] = "Install recycler"
		return CONTEXTUAL_SCREENTIP_SET

	return ..()

/obj/item/wallframe/sinkframe/examine(mob/user)
	. = ..()
	if(result_path == /obj/structure/sink/greyscale/filled)
		. += span_notice(LANG("obj.14ac99b94523f974", list(EXAMINE_HINT("water recycler"))))
	else
		. += span_notice(LANG("obj.5e1899e93676da7e", list(EXAMINE_HINT("water recycler"))))

/obj/item/wallframe/sinkframe/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = NONE
	if(istype(tool, /obj/item/stock_parts/water_recycler) && result_path == /obj/structure/sink/greyscale)
		qdel(tool)
		result_path = /obj/structure/sink/greyscale/filled
		playsound(src, 'sound/machines/click.ogg', 20, TRUE)
		balloon_alert(user, LANG("obj.b932e7d053cf5464", null))
		return ITEM_INTERACT_SUCCESS

/obj/item/wallframe/sinkframe/after_attach(obj/structure/sink/greyscale/attached_to)
	attached_to.set_custom_materials(custom_materials)
	attached_to.update_appearance(UPDATE_OVERLAYS)
