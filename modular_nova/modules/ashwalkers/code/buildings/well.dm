/obj/structure/water_source/fuel_well
	name = "燃料井"
	desc = "一个冒着气泡的燃料池。这本来可能很有价值，但蓝空技术在200年前就摧毁了对化石燃料的需求。"
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
	to_chat(user, span_warning("你触碰了燃料池，结果弄得满身都是燃料！最好用水把它洗掉。"))

/obj/structure/water_source/fuel_well/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	flick("puddle-oil-splash", src)
	return ..()

/obj/structure/water_source/fuel_well/shovel_act(mob/living/user, obj/item/tool)
	to_chat(user, "你用土壤填平了[src]。")
	tool.play_tool_sound(src)
	deconstruct()

/obj/structure/water_source/fuel_well/welder_act(mob/living/user, obj/item/tool)
	var/obj/item/weldingtool/attacking_welder = tool
	if(istype(attacking_welder) && !attacking_welder.welding)
		if(attacking_welder.reagents.has_reagent(/datum/reagent/fuel, attacking_welder.max_fuel))
			to_chat(user, span_warning("你的[attacking_welder.name]已经满了！"))
			return

		reagents.trans_to(attacking_welder, attacking_welder.max_fuel, transferred_by = user)
		user.visible_message(span_notice("[user]给[user.p_their()]的[attacking_welder.name]重新加满了燃料。"), span_notice("你给[attacking_welder]重新加满了燃料。"))
		playsound(src, 'sound/effects/refill.ogg', 50, TRUE)
		attacking_welder.update_appearance()
		return

/obj/structure/water_source/brick_well
	name = "砖砌水井"
	desc = "一砖一瓦，建起这口水井，得以触及深藏地下的巨大未开发水源。"
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
		to_chat(user, span_warning("[src]需要将[get_turf(src)]挖开才能工作！"))
		return

	return ..()

/obj/structure/water_source/brick_well/shovel_act(mob/living/user, obj/item/tool)
	to_chat(user, span_notice("你开始拆除[src]。"))
	tool.play_tool_sound(src)
	if(!do_after(user, 5 SECONDS, target = src))
		return

	to_chat(user, span_notice("你拆除了[src]。"))
	tool.play_tool_sound(src)
	deconstruct()

//I don't enjoy the fact it is an attackby, but the parent obj uses this proc, so I'm putting the cover check here as well
/obj/structure/water_source/brick_well/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(attacking_item, /obj/item/stack/sheet/mineral/wood))
		if(well_covered)
			to_chat(user, span_notice("[src]已经盖好了……"))
			return

		if(!attacking_item.use(3))
			to_chat(user, span_warning("[src]需要三块木头来建造一个盖子！"))
			return

		to_chat(user, span_notice("你开始建造一个盖子。"))
		if(!do_after(user, 5 SECONDS, target = src))
			return

		to_chat(user, span_notice("你建造了一个盖子。"))
		well_covered = TRUE
		add_overlay("well_cover")
		return

	if(!cover_work())
		to_chat(user, span_warning("[src]需要将[get_turf(src)]挖开才能工作！"))
		return

	return ..()
