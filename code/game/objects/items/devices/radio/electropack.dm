/obj/item/electropack
	name = "电击项圈"
	desc = "跳舞吧，我的猴子们！跳起来！！！"
	icon = 'icons/obj/devices/tool.dmi'
	icon_state = "electropack0"
	inhand_icon_state = "electropack"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_HUGE
	sound_vary = TRUE
	pickup_sound = SFX_GENERIC_DEVICE_PICKUP
	drop_sound = SFX_GENERIC_DEVICE_DROP
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT *5, /datum/material/glass=SHEET_MATERIAL_AMOUNT * 1.25)

	var/on = TRUE
	var/code = 2
	var/frequency = FREQ_ELECTROPACK
	var/shock_cooldown = FALSE

/obj/item/electropack/Initialize(mapload)
	. = ..()
	set_frequency(frequency)

/obj/item/electropack/Destroy()
	SSradio.remove_object(src, frequency)
	return ..()

/obj/item/electropack/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] 把[user.p_them()]自己接到电击项圈上并狂按触发器！看起来[user.p_theyre()]想自杀！"))
	return FIRELOSS

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/item/electropack/attack_hand(mob/user, list/modifiers)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(src == C.back)
			to_chat(user, span_warning("你需要别人帮忙才能取下这个！"))
			return
	return ..()

/obj/item/electropack/attackby(obj/item/W, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(W, /obj/item/clothing/head/helmet))
		var/obj/item/assembly/shock_kit/A = new /obj/item/assembly/shock_kit(user)
		A.icon = 'icons/obj/devices/assemblies.dmi'

		if(!user.transferItemToLoc(W, A))
			to_chat(user, span_warning("[W]粘在你手上了，你无法把它装到[src]上！"))
			return
		W.master = A
		A.helmet_part = W

		user.transferItemToLoc(src, A, TRUE)
		master = A
		A.electropack_part = src

		user.put_in_hands(A)
		A.add_fingerprint(user)
	else
		return ..()

/obj/item/electropack/receive_signal(datum/signal/signal)
	if(!signal || signal.data["code"] != code)
		return
	if(isliving(loc) && on)
		if(shock_cooldown)
			return
		shock_cooldown = TRUE
		addtimer(VARSET_CALLBACK(src, shock_cooldown, FALSE), 10 SECONDS)
		var/mob/living/L = loc
		step(L, pick(GLOB.cardinals))

		to_chat(L, span_danger("你感到一阵剧烈的电击！"))
		do_sparks(3, TRUE, L)
		L.Paralyze(100)

	if(master)
		if(isassembly(master))
			var/obj/item/assembly/master_as_assembly = master
			master_as_assembly.pulsed()
		master.receive_signal()

/obj/item/electropack/proc/set_frequency(new_frequency)
	SSradio.remove_object(src, frequency)
	frequency = new_frequency
	SSradio.add_object(src, frequency, RADIO_SIGNALER)

/obj/item/electropack/ui_state(mob/user)
	return GLOB.hands_state

/obj/item/electropack/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Electropack", name)
		ui.open()

/obj/item/electropack/ui_data(mob/user)
	var/list/data = list()
	data["power"] = on
	data["frequency"] = frequency
	data["code"] = code
	data["minFrequency"] = MIN_FREE_FREQ
	data["maxFrequency"] = MAX_FREE_FREQ
	return data

/obj/item/electropack/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("power")
			on = !on
			icon_state = "electropack[on]"
			. = TRUE
		if("freq")
			var/value = unformat_frequency(params["freq"])
			if(value)
				frequency = sanitize_frequency(value, TRUE)
				set_frequency(frequency)
				. = TRUE
		if("code")
			var/value = text2num(params["code"])
			if(value)
				value = round(value)
				code = clamp(value, 1, 100)
				. = TRUE
		if("reset")
			if(params["reset"] == "freq")
				frequency = initial(frequency)
				. = TRUE
			else if(params["reset"] == "code")
				code = initial(code)
				. = TRUE
