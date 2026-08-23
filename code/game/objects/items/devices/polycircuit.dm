// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/stack/circuit_stack
	name = "polycircuit aggregate"
	desc = "A dense, overdesigned cluster of electronics which attempted to function as a multipurpose circuit electronic. Circuits can be removed from it... if you don't bleed out in the process."
	icon_state = "circuit_mess"
	inhand_icon_state = "rods"
	w_class = WEIGHT_CLASS_TINY
	max_amount = 8
	merge_type = /obj/item/stack/circuit_stack
	singular_name = "circuit aggregate"
	var/circuit_type = /obj/item/electronics/airlock
	var/chosen_circuit = "airlock"

/obj/item/stack/circuit_stack/attack_self(mob/user)// Prevents the crafting menu, and tells you how to use it.
	to_chat(user, span_warning(LANG("obj.c4df0dba431d98ec", list(src))))

/obj/item/stack/circuit_stack/attack_hand(mob/user, list/modifiers)
	var/mob/living/carbon/human/H = user
	if(user.get_inactive_held_item() != src)
		return ..()
	else
		if(is_zero_amount(delete_if_zero = TRUE))
			return
		chosen_circuit = tgui_input_list(user, LANG("obj.059c4b2b3077887c", null), LANG("obj.7654ccd561e3e7eb", null), list("airlock","firelock","fire alarm","air alarm","APC"), chosen_circuit)
		if(isnull(chosen_circuit))
			to_chat(user, span_notice(LANG("obj.d7fc1ab303e2b765", list(src))))
			return
		if(is_zero_amount(delete_if_zero = TRUE))
			return
		if(loc != user)
			return
		switch(chosen_circuit)
			if("airlock")
				circuit_type = /obj/item/electronics/airlock
			if("firelock")
				circuit_type = /obj/item/electronics/firelock
			if("fire alarm")
				circuit_type = /obj/item/electronics/firealarm
			if("air alarm")
				circuit_type = /obj/item/electronics/airalarm
			if("APC")
				circuit_type = /obj/item/electronics/apc
		to_chat(user, span_notice(LANG("obj.d8c6e6dadbabdba6", list(src))))
		if(do_after(user, 3 SECONDS, target = user))
			if(!src || QDELETED(src))//Sanity Check.
				return
			var/returned_circuit = new circuit_type(src)
			user.put_in_hands(returned_circuit)
			use(1)
			if(!amount)
				to_chat(user, span_notice(LANG("obj.6e6440f62f7d1e65", null)))
			else
				to_chat(user, span_notice(LANG("obj.6f5b76a5af719fea", list(src))))
		else
			H.apply_damage(15, BRUTE, pick(GLOB.arm_zones))
			to_chat(user, span_warning(LANG("obj.2d863e4c2b2b0556", list(src))))

/obj/item/stack/circuit_stack/full
	amount = 8
