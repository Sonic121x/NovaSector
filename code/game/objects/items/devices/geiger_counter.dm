/obj/item/geiger_counter //DISCLAIMER: I know nothing about how real-life Geiger counters work. This will not be realistic. ~Xhuis
	name = "\improper 盖革计数器"
	desc = "一种用于探测和测量辐射脉冲的手持设备。"
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
	. += span_info("Alt-点击以清除存储的辐射等级。")
	switch(last_perceived_radiation_danger)
		if(null)
			. += span_notice("环境辐射等级计数报告一切正常。")
		if(PERCEIVED_RADIATION_DANGER_LOW)
			. += span_alert("环境辐射水平略高于平均值。")
		if(PERCEIVED_RADIATION_DANGER_MEDIUM)
			. += span_warning("环境辐射等级高于平均水平。")
		if(PERCEIVED_RADIATION_DANGER_HIGH)
			. += span_danger("环境辐射等级远高于平均水平。")
		if(PERCEIVED_RADIATION_DANGER_EXTREME)
			. += span_suicide("环境辐射等级即将达到临界水平！")

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
	balloon_alert(user, "开关 [scanning ? "on" : "off"]")

/obj/item/geiger_counter/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(SHOULD_SKIP_INTERACTION(interacting_with, src, user))
		return NONE
	return ranged_interact_with_atom(interacting_with, user, modifiers)

/obj/item/geiger_counter/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!CAN_IRRADIATE(interacting_with))
		return NONE

	user.visible_message(span_notice("[user] 用 [src] 扫描了 [interacting_with]。"), span_notice("你正在用 [src] 扫描 [interacting_with] 的辐射水平..."))
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

	to_chat(user, span_notice("[icon2html(src, user)] [isliving(target) ? "Subject" : "Target"] 没有放射性污染。"))

/obj/item/geiger_counter/click_alt(mob/living/user)
	if(!scanning)
		to_chat(user, span_warning("[src] 必须处于开启状态才能重置其辐射水平！"))
		return CLICK_ACTION_BLOCKING
	to_chat(user, span_notice("你清除了 [src] 的辐射计数，将其重置为正常状态。"))
	last_perceived_radiation_danger = null
	update_appearance(UPDATE_ICON)
	return CLICK_ACTION_SUCCESS
