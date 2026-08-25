/obj/structure/water_source/fuel_well
	name = "fuel well"
	desc = "A bubbling pool of fuel. This would probably be valuable, had bluespace technology not destroyed the need for fossil fuels 200 years ago."
	icon_state = "puddle-oil"
	dispensedreagent = /datum/reagent/fuel
	color = "#742912"	//Gives it a weldingfuel hue

//attack hand is for cleaning stuff on the parent obj, and I don't want you cleaning stuff with welding fuel!
/obj/structure/water_source/fuel_well/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	flick("puddle-oil-splash", src)
	reagents.expose(user, TOUCH, 20) //Covers target in 20u of fuel.
	to_chat(user, span_warning(LANG("obj.792a46c3bc1690a2", null)))

/obj/structure/water_source/fuel_well/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	flick("puddle-oil-splash", src)
	return ..()

/obj/structure/water_source/fuel_well/shovel_act(mob/living/user, obj/item/tool)
	to_chat(user, LANG("obj.c188d34b91752433", list(src)))
	tool.play_tool_sound(src)
	deconstruct()

/obj/structure/water_source/fuel_well/welder_act(mob/living/user, obj/item/tool)
	var/obj/item/weldingtool/attacking_welder = tool
	if(istype(attacking_welder) && !attacking_welder.welding)
		if(attacking_welder.reagents.has_reagent(/datum/reagent/fuel, attacking_welder.max_fuel))
			to_chat(user, span_warning(LANG("obj.c927127059a90967", list(attacking_welder.name))))
			return

		reagents.trans_to(attacking_welder, attacking_welder.max_fuel, transferred_by = user)
		user.visible_message(span_notice(LANG("obj.3f21aaca699f8ff3", list(user, user.p_their(), attacking_welder.name))), span_notice(LANG("obj.e125cbe727e270a3", list(attacking_welder))))
		playsound(src, 'sound/effects/refill.ogg', 50, TRUE)
		attacking_welder.update_appearance()
		return

/obj/structure/water_source/brick_well
	name = "brick well"
	desc = "Brick by brick, a well has been built to access great water reserves that lay untapped underneath."
	icon = 'modular_nova/modules/ashwalkers/icons/structures.dmi'
	icon_state = "brick_well"
	density = TRUE
	custom_materials = list(/datum/material/stone = SHEET_MATERIAL_AMOUNT * 5)
	///determines whether it is covered, and whether it needs to have the ground below it dug out
	var/well_covered = FALSE

/**
 * To check if the well is on the correct turf type-- must be a diggable turf (asteroid) or else returns false
 */
/obj/structure/water_source/brick_well/proc/correct_turf()
	var/turf/src_turf = get_turf(src)
	if(istype(src_turf, /turf/open/misc/asteroid))
		return src_turf

	return FALSE

/**
 * If well_covered is true, then itll always work (on the right turf!); otherwise, check the below turf to see if it is dug
 */
/obj/structure/water_source/brick_well/proc/cover_work()
	if(!correct_turf())
		return FALSE

	if(well_covered)
		return TRUE

	var/turf/open/misc/asteroid/asteroid_turf = correct_turf()
	if(!asteroid_turf.dug)
		return FALSE

	return TRUE

//attack hand is for cleaning stuff, but if the well isn't working, then we can't wash!
/obj/structure/water_source/brick_well/attack_hand(mob/living/user, list/modifiers)
	if(!cover_work())
		to_chat(user, span_warning(LANG("obj.f235da32e3599d1f", list(src, get_turf(src)))))
		return

	return ..()

/obj/structure/water_source/brick_well/shovel_act(mob/living/user, obj/item/tool)
	to_chat(user, span_notice(LANG("obj.9f054c5c8e0247b6", list(src))))
	tool.play_tool_sound(src)
	if(!do_after(user, 5 SECONDS, target = src))
		return

	to_chat(user, span_notice(LANG("obj.a33d1bb641d47707", list(src))))
	tool.play_tool_sound(src)
	deconstruct()

//I don't enjoy the fact it is an item_interaction, but the parent obj uses this proc, so I'm putting the cover check here as well
/obj/structure/water_source/brick_well/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/stack/sheet/mineral/wood))
		if(well_covered)
			to_chat(user, span_notice(LANG("obj.0d3178b119ee39a9", list(src))))
			return ITEM_INTERACT_BLOCKING

		if(!tool.use(3))
			to_chat(user, span_warning(LANG("obj.3c2fca986bc33112", list(src))))
			return ITEM_INTERACT_BLOCKING

		to_chat(user, span_notice(LANG("obj.9628997894f597bd", null)))
		if(!do_after(user, 5 SECONDS, target = src))
			return ITEM_INTERACT_BLOCKING

		to_chat(user, span_notice(LANG("obj.43e27bb8cc628cc5", null)))
		well_covered = TRUE
		add_overlay("well_cover")
		return ITEM_INTERACT_SUCCESS

	if(!cover_work())
		to_chat(user, span_warning(LANG("obj.f235da32e3599d1f", list(src, get_turf(src)))))
		return ITEM_INTERACT_BLOCKING

	return ..()
