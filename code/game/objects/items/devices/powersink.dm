// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
#define DISCONNECTED 0
#define CLAMPED_OFF 1
#define OPERATING 2

#define FRACTION_TO_RELEASE 25
#define ALERT 90
#define MINIMUM_HEAT 20000

// Powersink - used to drain station power

/obj/item/powersink
	name = "power sink"
	desc = "A power sink which drains energy from electrical systems and converts it to heat. Ensure short workloads and ample time to cool down if used in high energy systems."
	icon = 'icons/obj/devices/syndie_gadget.dmi'
	icon_state = "powersink0"
	inhand_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	obj_flags = CONDUCTS_ELECTRICITY
	item_flags = NO_PIXEL_RANDOM_DROP
	throwforce = 5
	throw_speed = 1
	throw_range = 2
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT* 7.5)
	var/max_heat = 100 * STANDARD_BATTERY_CHARGE // Maximum contained heat before exploding. Not actual temperature.
	var/internal_heat = 0 // Contained heat, goes down every tick.
	var/mode = DISCONNECTED // DISCONNECTED, CLAMPED_OFF, OPERATING
	var/warning_given = FALSE //! Stop warning spam, only warn the admins/deadchat once that we are about to boom.

	var/obj/structure/cable/attached

/obj/item/powersink/update_icon_state()
	icon_state = "powersink[mode == OPERATING]"
	return ..()

/obj/item/powersink/examine(mob/user)
	. = ..()
	if(mode)
		. += LANG("obj.7aaa418012486a86", list(src))
	if((in_range(user, src) || isobserver(user)) && internal_heat > max_heat * 0.5)
		. += span_danger(LANG("obj.e7ed87472badf526", list(src)))

/obj/item/powersink/set_anchored(anchorvalue)
	. = ..()
	set_density(anchorvalue)

/obj/item/powersink/proc/set_mode(value)
	if(value == mode)
		return
	switch(value)
		if(DISCONNECTED)
			attached = null
			if(mode == OPERATING && internal_heat < MINIMUM_HEAT)
				STOP_PROCESSING(SSobj, src)
				internal_heat = 0
			set_anchored(FALSE)

		if(CLAMPED_OFF)
			if(!attached)
				return
			if(mode == OPERATING && internal_heat < MINIMUM_HEAT)
				STOP_PROCESSING(SSobj, src)
				internal_heat = 0
			set_anchored(TRUE)

		if(OPERATING)
			if(!attached)
				return
			START_PROCESSING(SSobj, src)
			set_anchored(TRUE)

	mode = value
	update_appearance()
	set_light(0)

/obj/item/powersink/wrench_act(mob/living/user, obj/item/tool)
	. = TRUE
	if(mode == DISCONNECTED)
		var/turf/T = loc
		if(isturf(T) && T.underfloor_accessibility >= UNDERFLOOR_INTERACTABLE)
			attached = locate() in T
			if(!attached)
				to_chat(user, span_warning(LANG("obj.2bd002083b56a922", list(src))))
			else
				set_mode(CLAMPED_OFF)
				user.visible_message( \
					LANG("obj.9757020596812064", list(user, src)), \
					span_notice(LANG("obj.b346b7fc3f0e1fb7", list(src))),
					span_hear(LANG("obj.7d716371ffbd4fdd", null)))
		else
			to_chat(user, span_warning(LANG("obj.2bd002083b56a922", list(src))))
	else
		set_mode(DISCONNECTED)
		user.visible_message( \
			LANG("obj.f180bf4ceeeeaf38", list(user, src)), \
			span_notice(LANG("obj.020e329d030c4d74", list(src))),
			span_hear(LANG("obj.b8c00fb8e733e37a", null)))

/obj/item/powersink/screwdriver_act(mob/living/user, obj/item/tool)
	user.visible_message( \
		LANG("obj.a9dc0f202709ff2f", list(user, src)), \
		span_notice(LANG("obj.9a479330d0489299", list(src))))
	return TRUE

/obj/item/powersink/attack_paw(mob/user, list/modifiers)
	return

/obj/item/powersink/attack_ai()
	return

/obj/item/powersink/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	switch(mode)
		if(DISCONNECTED)
			..()

		if(CLAMPED_OFF)
			user.visible_message( \
				LANG("obj.c4887f356612d7e9", list(user, src)), \
				span_notice(LANG("obj.41ddd5031269c4e0", list(src))),
				span_hear(LANG("obj.0f830183df1905e6", null)))
			message_admins("Power sink activated by [ADMIN_LOOKUPFLW(user)] at [ADMIN_VERBOSEJMP(src)]")
			user.log_message("activated a powersink", LOG_GAME)
			notify_ghosts(
				LANG("obj.bec61c37b5cd5544", list(user.real_name)),
				source = src,
				header = "Shocking News!",
			)
			set_mode(OPERATING)

		if(OPERATING)
			user.visible_message( \
				LANG("obj.072be970f51996ff", list(user, src)), \
				span_notice(LANG("obj.03d7907e8d038ced", list(src))),
				span_hear(LANG("obj.0f830183df1905e6", null)))
			user.log_message("deactivated the powersink", LOG_GAME)
			set_mode(CLAMPED_OFF)

/// Removes internal heat and shares it with the atmosphere.
/obj/item/powersink/proc/release_heat()
	var/turf/our_turf = get_turf(src)
	var/temp_to_give = internal_heat / FRACTION_TO_RELEASE
	internal_heat -= temp_to_give
	var/datum/gas_mixture/environment = our_turf.return_air()
	var/delta_temperature = temp_to_give / environment.heat_capacity()
	if(delta_temperature)
		environment.temperature += delta_temperature
		air_update_turf(FALSE, FALSE)
	if(warning_given && internal_heat < max_heat * 0.75)
		warning_given = FALSE
		message_admins("Power sink at ([x],[y],[z] - <A href='byond://?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>) has cooled down and will not explode.")
	if(mode != OPERATING && internal_heat < MINIMUM_HEAT)
		internal_heat = 0
		STOP_PROCESSING(SSobj, src)

/// Drains power from the connected powernet, if any.
/obj/item/powersink/proc/drain_power()
	var/datum/powernet/powernet = attached.powernet
	var/drained = 0
	set_light(5)

	// Drain as much as we can from the powernet.
	drained = attached.newavail()
	attached.add_delayedload(drained)

	// If tried to drain more than available on powernet, now look for APCs and drain their cells
	for(var/obj/machinery/power/terminal/terminal in powernet.nodes)
		if(istype(terminal.master, /obj/machinery/power/apc))
			var/obj/machinery/power/apc/apc = terminal.master
			if(apc.operating && apc.cell)
				drained += 0.001 * apc.cell.use(0.1 * STANDARD_BATTERY_CHARGE, force = TRUE)
	internal_heat += drained

/obj/item/powersink/process()
	if(!attached)
		set_mode(DISCONNECTED)

	release_heat()

	if(mode != OPERATING)
		return

	drain_power()

	if(internal_heat > max_heat * ALERT / 100)
		if (!warning_given)
			warning_given = TRUE
			message_admins("Power sink at ([x],[y],[z] - <A href='byond://?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>) has reached [ALERT]% of max heat. Explosion imminent.")
			notify_ghosts(
				LANG("obj.4012c1917f3c29c2", list(src)),
				source = src,
				header = "Power Sunk",
			)
		playsound(src, 'sound/effects/screech.ogg', 100, TRUE, TRUE)

	if(internal_heat >= max_heat)
		STOP_PROCESSING(SSobj, src)
		explosion(src, devastation_range = 4, heavy_impact_range = 8, light_impact_range = 16, flash_range = 32)
		qdel(src)

#undef DISCONNECTED
#undef CLAMPED_OFF
#undef OPERATING
#undef FRACTION_TO_RELEASE
#undef ALERT
#undef MINIMUM_HEAT
