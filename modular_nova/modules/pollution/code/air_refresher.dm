/obj/item/air_refresher
	name = "空气清新剂"
	desc = "一个装满刺鼻浓烈香气的瓶子，配有易于使用的加压释放喷嘴。"
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
		. += "It has [uses_remaining] use\s left."
	else
		. += "It is empty."

/obj/item/air_refresher/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(uses_remaining <= 0)
		to_chat(user, span_warning("\The [src] 是空的！"))
		return NONE
	uses_remaining--
	var/turf/aimed_turf = get_turf(interacting_with)
	aimed_turf.pollute_turf(/datum/pollutant/fragrance/air_refresher, 200)
	user.visible_message(span_notice("[user] 用\the [src]喷洒周围的空气。"), span_notice("You spray the air around with \the [src]."))
	user.changeNext_move(CLICK_CD_RANGE*2)
	playsound(aimed_turf, 'sound/effects/spray2.ogg', 50, TRUE, -6)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/pollution_scrubber
	name = "污染洗涤器"
	desc = "一种会处理空气并过滤掉所有污染物的洗涤器。"
	icon = 'modular_nova/modules/pollution/icons/pollution_scrubber.dmi'
	icon_state = "scrubber"
	var/scrub_amount = 2
	var/on = FALSE

/obj/machinery/pollution_scrubber/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	on = !on
	balloon_alert(user, "净化器已[on ? "on" : "off"]")

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
