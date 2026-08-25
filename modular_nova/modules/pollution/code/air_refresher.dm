/obj/item/air_refresher
	name = "air refresher"
	desc = "A bottle packed with sickly strong fragrance, with an easy to use pressurized release nozzle."
	icon = 'modular_nova/modules/pollution/icons/air_refresher.dmi'
	icon_state = "air_refresher"
	inhand_icon_state = "cleaner"
	worn_icon_state = "spraybottle"
	lefthand_file = 'icons/mob/inhands/equipment/custodial_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/custodial_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	item_flags = NOBLUDGEON
	var/uses_remaining = 20

/obj/item/air_refresher/examine(mob/user)
	. = ..()
	if(uses_remaining)
		. += LANG("obj.5bf37df5de0917f2", list(uses_remaining))
	else
		. += LANG("obj.53b0d090ad9fbc27", null)

/obj/item/air_refresher/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(uses_remaining <= 0)
		to_chat(user, span_warning(LANG("obj.9104a6b2d5c7ff59", list(src))))
		return NONE
	uses_remaining--
	var/turf/aimed_turf = get_turf(interacting_with)
	aimed_turf.pollute_turf(/datum/pollutant/fragrance/air_refresher, 200)
	user.visible_message(span_notice(LANG("obj.fe3fb593e76d30d1", list(user, src))), span_notice(LANG("obj.6ee21b956ac72b0b", list(src))))
	user.changeNext_move(CLICK_CD_RANGE*2)
	playsound(aimed_turf, 'sound/effects/spray2.ogg', 50, TRUE, -6)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/pollution_scrubber
	name = "Pollution Scrubber"
	desc = "A scrubber that will process the air and filter out any contaminants."
	icon = 'modular_nova/modules/pollution/icons/pollution_scrubber.dmi'
	icon_state = "scrubber"
	var/scrub_amount = 2
	var/on = FALSE

/obj/machinery/pollution_scrubber/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	on = !on
	balloon_alert(user, LANG("obj.fd6a54a92ed0f4ab", list(on ? "on" : "off")))

	update_appearance()

/obj/machinery/pollution_scrubber/update_icon(updates)
	. = ..()
	if(on)
		icon_state = "scrubber_on"
	else
		icon_state = "scrubber"

/obj/machinery/pollution_scrubber/process()
	if(machine_stat)
		return
	if(on && isopenturf(get_turf(src)))
		var/turf/open/open_turf = get_turf(src)
		if(open_turf.pollution)
			open_turf.pollution.scrub_amount(scrub_amount)
			use_energy(100 WATTS)
