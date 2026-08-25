// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/geiger_counter //DISCLAIMER: I know nothing about how real-life Geiger counters work. This will not be realistic. ~Xhuis
	name = "\improper Geiger counter"
	desc = "A handheld device used for detecting and measuring radiation pulses."
	icon = 'icons/obj/devices/scanner.dmi'
	icon_state = "geiger_off"
	inhand_icon_state = "multitool"
	worn_icon_state = "geiger_counter"
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT
	item_flags = NOBLUDGEON
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 1.5, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 1.5)

	var/last_perceived_radiation_danger = null

	var/scanning = FALSE

/obj/item/geiger_counter/Initialize(mapload)
	. = ..()

	RegisterSignal(src, COMSIG_IN_RANGE_OF_IRRADIATION, PROC_REF(on_pre_potential_irradiation))

/obj/item/geiger_counter/examine(mob/user)
	. = ..()
	if(!scanning)
		return
	. += span_info(LANG("obj.e25285fe1b7742e6", null))
	switch(last_perceived_radiation_danger)
		if(null)
			. += span_notice(LANG("obj.bc53102cf6d98c13", null))
		if(PERCEIVED_RADIATION_DANGER_LOW)
			. += span_alert(LANG("obj.2bf55f1002efb706", null))
		if(PERCEIVED_RADIATION_DANGER_MEDIUM)
			. += span_warning(LANG("obj.38686c30ab17e782", null))
		if(PERCEIVED_RADIATION_DANGER_HIGH)
			. += span_danger(LANG("obj.aa45e48aafc9103c", null))
		if(PERCEIVED_RADIATION_DANGER_EXTREME)
			. += span_suicide(LANG("obj.dcea44bc67a568ac", null))

/obj/item/geiger_counter/update_icon_state()
	if(!scanning)
		icon_state = "geiger_off"
		return ..()

	switch(last_perceived_radiation_danger)
		if(null)
			icon_state = "geiger_on_1"
		if(PERCEIVED_RADIATION_DANGER_LOW)
			icon_state = "geiger_on_2"
		if(PERCEIVED_RADIATION_DANGER_MEDIUM)
			icon_state = "geiger_on_3"
		if(PERCEIVED_RADIATION_DANGER_HIGH)
			icon_state = "geiger_on_4"
		if(PERCEIVED_RADIATION_DANGER_EXTREME)
			icon_state = "geiger_on_5"
	return ..()

/obj/item/geiger_counter/attack_self(mob/user)
	scanning = !scanning

	if (scanning)
		AddComponent(/datum/component/geiger_sound)
	else
		qdel(GetComponent(/datum/component/geiger_sound))

	update_appearance(UPDATE_ICON)
	balloon_alert(user, LANG("obj.008b17a1596d43a6", list(scanning ? "on" : "off")))

/obj/item/geiger_counter/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(SHOULD_SKIP_INTERACTION(interacting_with, src, user))
		return NONE
	return ranged_interact_with_atom(interacting_with, user, modifiers)

/obj/item/geiger_counter/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!CAN_IRRADIATE(interacting_with))
		return NONE

	user.visible_message(span_notice(LANG("obj.ef72f9eca4024bd2", list(user, interacting_with, src))), span_notice(LANG("obj.40e34539c33515b7", list(interacting_with, src))))
	addtimer(CALLBACK(src, PROC_REF(scan), interacting_with, user), 20, TIMER_UNIQUE) // Let's not have spamming GetAllContents
	return ITEM_INTERACT_SUCCESS

/obj/item/geiger_counter/equipped(mob/user, slot, initial)
	. = ..()

	RegisterSignal(user, COMSIG_IN_RANGE_OF_IRRADIATION, PROC_REF(on_pre_potential_irradiation))

/obj/item/geiger_counter/dropped(mob/user, silent = FALSE)
	. = ..()

	UnregisterSignal(user, COMSIG_IN_RANGE_OF_IRRADIATION)

/obj/item/geiger_counter/proc/on_pre_potential_irradiation(datum/source, datum/radiation_pulse_information/pulse_information, insulation_to_target)
	SIGNAL_HANDLER

	last_perceived_radiation_danger = get_perceived_radiation_danger(pulse_information, insulation_to_target)
	addtimer(CALLBACK(src, PROC_REF(reset_perceived_danger)), TIME_WITHOUT_RADIATION_BEFORE_RESET, TIMER_UNIQUE | TIMER_OVERRIDE)

	if (scanning)
		update_appearance(UPDATE_ICON)

/obj/item/geiger_counter/proc/reset_perceived_danger()
	last_perceived_radiation_danger = null
	if (scanning)
		update_appearance(UPDATE_ICON)

/obj/item/geiger_counter/proc/scan(atom/target, mob/user)
	if (SEND_SIGNAL(target, COMSIG_GEIGER_COUNTER_SCAN, user, src) & COMSIG_GEIGER_COUNTER_SCAN_SUCCESSFUL)
		return

	to_chat(user, span_notice(LANG("obj.1f84066b56f1128f", list(icon2html(src, user), isliving(target) ? "Subject" : "Target"))))

/obj/item/geiger_counter/click_alt(mob/living/user)
	if(!scanning)
		to_chat(user, span_warning(LANG("obj.d528d65746a56e13", list(src))))
		return CLICK_ACTION_BLOCKING
	to_chat(user, span_notice(LANG("obj.ab060bf86cf7b969", list(src))))
	last_perceived_radiation_danger = null
	update_appearance(UPDATE_ICON)
	return CLICK_ACTION_SUCCESS
