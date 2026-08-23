#define SAUNA_H2O_TEMP (T20C + 20)
#define SAUNA_LOG_FUEL 150
#define SAUNA_PAPER_FUEL 5
#define SAUNA_MAXIMUM_FUEL 3000
#define SAUNA_WATER_PER_WATER_UNIT 5

/obj/structure/sauna_oven
	name = "sauna oven"
	desc = "A modest sauna oven with rocks. Add some fuel, pour some water and enjoy the moment."
	icon = 'modular_nova/master_files/icons/obj/structures/sauna_oven.dmi'
	icon_state = "sauna_oven"
	density = TRUE
	anchored = TRUE
	resistance_flags = FIRE_PROOF
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 30)
	var/lit = FALSE
	var/fuel_amount = 0
	var/water_amount = 0

/obj/structure/sauna_oven/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.19403cddaaeb1144", list(water_amount ? "moist" : "dry")))
	. += span_notice(LANG("obj.fa0c2f58ff4bad0b", list(fuel_amount ? "some fuel" : "no fuel")))

/obj/structure/sauna_oven/Destroy()
	if(lit)
		STOP_PROCESSING(SSobj, src)
	QDEL_NULL(particles)
	return ..()

/obj/structure/sauna_oven/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(lit)
		lit = FALSE
		STOP_PROCESSING(SSobj, src)
		user.visible_message(span_notice(LANG("obj.10018e19a621f27d", list(user, src))), span_notice(LANG("obj.833a08009d651401", list(src))))
	else if (fuel_amount)
		lit = TRUE
		START_PROCESSING(SSobj, src)
		user.visible_message(span_notice(LANG("obj.96d1123903230929", list(user, src))), span_notice(LANG("obj.11cd75631ed337a9", list(src))))
	update_icon()

/obj/structure/sauna_oven/update_overlays()
	. = ..()
	if(lit)
		. += "sauna_oven_on_overlay"

/obj/structure/sauna_oven/update_icon()
	..()
	icon_state = "[lit ? "sauna_oven_on" : initial(icon_state)]"

/obj/structure/sauna_oven/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(tool.tool_behaviour == TOOL_WRENCH)
		balloon_alert(user, LANG("obj.44f0e678d88c8044", null))
		if(tool.use_tool(src, user, 60, volume = 50))
			balloon_alert(user, LANG("obj.80451b1c014c10d8", null))
			new /obj/item/stack/sheet/mineral/wood(get_turf(src), 30)
			qdel(src)

	else if(istype(tool, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/reagent_container = tool
		if(!reagent_container.is_open_container())
			return ..()
		if(reagent_container.reagents.has_reagent(/datum/reagent/water))
			reagent_container.reagents.remove_reagent(/datum/reagent/water, 5)
			user.visible_message(span_notice(LANG("obj.5f7ac2eb92383a9f", list(user, src))), span_notice(LANG("obj.cab26e058eae119a", list(src))))
			water_amount += 5 * SAUNA_WATER_PER_WATER_UNIT
		else
			balloon_alert(user, LANG("obj.ac11e9660778b13d", null))

	else if(istype(tool, /obj/item/stack/sheet/mineral/wood))
		var/obj/item/stack/sheet/mineral/wood/wood = tool
		if(fuel_amount > SAUNA_MAXIMUM_FUEL)
			balloon_alert(user, LANG("obj.2cb7d3546d66854d", null))
			return ITEM_INTERACT_BLOCKING
		fuel_amount += SAUNA_LOG_FUEL * wood.amount
		wood.use(wood.amount)
		user.visible_message(span_notice(LANG("obj.2dc25b27fd670c2a", list(user, src))), span_notice(LANG("obj.bd3682ed15e0fa15", list(src))))
	else if(istype(tool, /obj/item/paper_bin))
		var/obj/item/paper_bin/paper_bin = tool
		user.visible_message(span_notice(LANG("obj.8938881bc2a5a201", list(user, tool, src))), span_notice(LANG("obj.0c27fe262b2ac3b6", list(tool, src))))
		fuel_amount += SAUNA_PAPER_FUEL * paper_bin.total_paper
		qdel(paper_bin)
	else if(istype(tool, /obj/item/paper))
		user.visible_message(span_notice(LANG("obj.8938881bc2a5a201", list(user, tool, src))), span_notice(LANG("obj.9a474d8d4e3af196", list(tool, src))))
		fuel_amount += SAUNA_PAPER_FUEL
		qdel(tool)
	return ..()

/obj/structure/sauna_oven/process()
	if(water_amount)
		water_amount--
		update_steam_particles()
		var/turf/open/pos = get_turf(src)
		if(istype(pos) && pos.air.return_pressure() < 2*ONE_ATMOSPHERE)
			pos.atmos_spawn_air("water_vapor=10;TEMP=[SAUNA_H2O_TEMP]")
	fuel_amount--
	if(fuel_amount <= 0)
		lit = FALSE
		update_steam_particles()
		STOP_PROCESSING(SSobj, src)
		update_icon()

/obj/structure/sauna_oven/proc/update_steam_particles()
	if(particles)
		if(lit && water_amount)
			return
		QDEL_NULL(particles)
		return

	if(lit && water_amount)
		particles = new /particles/smoke/steam/mild
		particles.position = list(0, 6, 0)

#undef SAUNA_H2O_TEMP
#undef SAUNA_LOG_FUEL
#undef SAUNA_PAPER_FUEL
#undef SAUNA_MAXIMUM_FUEL
#undef SAUNA_WATER_PER_WATER_UNIT
