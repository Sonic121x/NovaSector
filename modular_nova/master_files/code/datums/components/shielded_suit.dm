/datum/component/shielded/suit

/datum/component/shielded/suit/process(seconds_per_tick)
	if(current_charges >= max_charges)
		STOP_PROCESSING(SSdcs, src)
		return

	if(!COOLDOWN_FINISHED(src, recently_hit_cd))
		return
	if(!COOLDOWN_FINISHED(src, charge_add_cd))
		return

	var/obj/item/item_parent = parent
	COOLDOWN_START(src, charge_add_cd, charge_increment_delay)
	adjust_charge(charge_recovery) // set the number of charges to current + recovery per increment, clamped from zero to max_charges
	playsound(item_parent, 'sound/effects/magic/charge.ogg', 50, TRUE)


/datum/component/shielded/suit/default_run_hit_callback(mob/living/owner, attack_text, current_charges)
	var/obj/item/item_parent = parent
	owner.visible_message(span_danger(LANG("datum.8063f04ab2cf4cf8", list(owner, attack_text))))
	if(current_charges <= 0)
		owner.visible_message(span_warning(LANG("datum.b8ea8e9c44a96f3b", list(owner))))
		playsound(item_parent, 'sound/items/ceramic_break.ogg', 60, TRUE)
