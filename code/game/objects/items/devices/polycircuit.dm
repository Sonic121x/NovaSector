/obj/item/stack/circuit_stack
	name = "聚合多用途电路"
	desc = "一个密集、过度设计的电子元件集群，试图作为多用途电路电子设备运行。可以从它上面移除电路板……如果你在这个过程中没有失血过多的话。"
	icon_state = "circuit_mess"
	inhand_icon_state = "rods"
	w_class = WEIGHT_CLASS_TINY
	max_amount = 8
	merge_type = /obj/item/stack/circuit_stack
	singular_name = "circuit aggregate"
	var/circuit_type = /obj/item/electronics/airlock
	var/chosen_circuit = "airlock"

/obj/item/stack/circuit_stack/attack_self(mob/user)// Prevents the crafting menu, and tells you how to use it.
	to_chat(user, span_warning("你不能直接使用[src]，你得尝试手动移除其中一个电路……小心点。"))

/obj/item/stack/circuit_stack/attack_hand(mob/user, list/modifiers)
	var/mob/living/carbon/human/H = user
	if(user.get_inactive_held_item() != src)
		return ..()
	else
		if(is_zero_amount(delete_if_zero = TRUE))
			return
		chosen_circuit = tgui_input_list(user, "要移除的电路", "电路移除", list("airlock","firelock","fire alarm","air alarm","APC"), chosen_circuit)
		if(isnull(chosen_circuit))
			to_chat(user, span_notice("你明智地避免将手放在[src]附近。"))
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
		to_chat(user, span_notice("你发现了想要的电路，并小心翼翼地尝试将它从[src]上取下来，别动！"))
		if(do_after(user, 3 SECONDS, target = user))
			if(!src || QDELETED(src))//Sanity Check.
				return
			var/returned_circuit = new circuit_type(src)
			user.put_in_hands(returned_circuit)
			use(1)
			if(!amount)
				to_chat(user, span_notice("你绕开电路板锋利的边缘，取下了最后一块板子。"))
			else
				to_chat(user, span_notice("你绕开电路板锋利的边缘，从[src]上取下了一块板子。"))
		else
			H.apply_damage(15, BRUTE, pick(GLOB.arm_zones))
			to_chat(user, span_warning("你被[src]上众多锋利的边角划出了一道很深的伤口！"))

/obj/item/stack/circuit_stack/full
	amount = 8
