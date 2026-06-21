/obj/item/organ/stomach/ethereal
	name = "生物电池"
	icon_state = "stomach-p" //Welp. At least it's more unique in functionaliy.
	desc = "一个水晶状的器官，用于储存以太族的电荷。"
	organ_traits = list(TRAIT_NOHUNGER) // We have our own hunger mechanic.
	/// Where the energy of the stomach is stored.
	var/obj/item/stock_parts/power_store/cell
	///used to keep ethereals from spam draining power sources
	var/drain_time = 0

/obj/item/organ/stomach/ethereal/Initialize(mapload)
	. = ..()
	cell = new /obj/item/stock_parts/power_store/cell/ethereal(src)

/obj/item/organ/stomach/ethereal/Destroy()
	QDEL_NULL(cell)
	return ..()

/obj/item/organ/stomach/ethereal/on_life(seconds_per_tick)
	. = ..()
	adjust_charge(-ETHEREAL_DISCHARGE_RATE * seconds_per_tick)
	handle_charge(owner, seconds_per_tick)

/obj/item/organ/stomach/ethereal/on_mob_insert(mob/living/carbon/stomach_owner)
	. = ..()
	RegisterSignal(stomach_owner, COMSIG_PROCESS_BORGCHARGER_OCCUPANT, PROC_REF(charge))
	RegisterSignal(stomach_owner, COMSIG_LIVING_ELECTROCUTE_ACT, PROC_REF(on_electrocute))

/obj/item/organ/stomach/ethereal/on_mob_remove(mob/living/carbon/stomach_owner)
	. = ..()
	UnregisterSignal(stomach_owner, COMSIG_PROCESS_BORGCHARGER_OCCUPANT)
	UnregisterSignal(stomach_owner, COMSIG_LIVING_ELECTROCUTE_ACT)
	stomach_owner.clear_mood_event("charge")
	stomach_owner.clear_alert(ALERT_ETHEREAL_CHARGE)
	stomach_owner.clear_alert(ALERT_ETHEREAL_OVERCHARGE)

/obj/item/organ/stomach/ethereal/handle_hunger_slowdown(mob/living/carbon/human/human)
	human.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/hunger, multiplicative_slowdown = (1.5 * (1 - cell.charge() / 100)))

/obj/item/organ/stomach/ethereal/proc/charge(datum/source, datum/callback/charge_cell, seconds_per_tick)
	SIGNAL_HANDLER

	charge_cell.Invoke(cell, seconds_per_tick / 3.5) // Ethereals don't have NT designed charging ports, so they charge slower.

/obj/item/organ/stomach/ethereal/proc/on_electrocute(datum/source, shock_damage, shock_source, siemens_coeff = 1, flags = NONE)
	SIGNAL_HANDLER
	if(flags & SHOCK_ILLUSION)
		return
	adjust_charge(shock_damage * siemens_coeff * 2)
	. = ethereal_shock_absorb(source, shock_damage, shock_source, siemens_coeff = 1, flags = NONE) //NOVA EDIT CHANGE - Ethereal Rework 2024 - This prevents the damage from the shocks.
	to_chat(owner, span_notice("你将一部分电击吸收进了身体！"))

/**Changes the energy of the crystal stomach.
* Args:
* - amount: The change of the energy, in joules.
* Returns: The amount of energy that actually got changed in joules.
**/
/obj/item/organ/stomach/ethereal/proc/adjust_charge(amount)
	var/amount_changed = clamp(amount, ETHEREAL_CHARGE_NONE - cell.charge(), ETHEREAL_CHARGE_DANGEROUS - cell.charge())
	return cell.change(amount_changed)

/obj/item/organ/stomach/ethereal/proc/handle_charge(mob/living/carbon/carbon, seconds_per_tick)
	switch(cell.charge())
		if(-INFINITY to ETHEREAL_CHARGE_NONE)
			carbon.add_mood_event("charge", /datum/mood_event/decharged)
			carbon.throw_alert(ALERT_ETHEREAL_CHARGE, /atom/movable/screen/alert/emptycell/ethereal)
			if(carbon.health > 10.5)
				carbon.apply_damage(0.65, TOX, null, null, carbon)
		if(ETHEREAL_CHARGE_NONE to ETHEREAL_CHARGE_LOWPOWER)
			carbon.add_mood_event("charge", /datum/mood_event/decharged)
			carbon.throw_alert(ALERT_ETHEREAL_CHARGE, /atom/movable/screen/alert/lowcell/ethereal, 3)
			if(carbon.health > 10.5)
				carbon.apply_damage(0.325 * seconds_per_tick, damagetype = TOX)
		if(ETHEREAL_CHARGE_LOWPOWER to ETHEREAL_CHARGE_NORMAL)
			carbon.add_mood_event("charge", /datum/mood_event/lowpower)
			carbon.throw_alert(ALERT_ETHEREAL_CHARGE, /atom/movable/screen/alert/lowcell/ethereal, 2)
		if(ETHEREAL_CHARGE_ALMOSTFULL to ETHEREAL_CHARGE_FULL)
			carbon.add_mood_event("charge", /datum/mood_event/charged)
			carbon.adjust_tox_loss(-0.325 * seconds_per_tick) //NOVA EDIT ADDITION - Ethereal Rework 2024 - Your natural reward for no longer being over or under charged, but having it just right.
		if(ETHEREAL_CHARGE_FULL to ETHEREAL_CHARGE_OVERLOAD)
			carbon.add_mood_event("charge", /datum/mood_event/overcharged)
			carbon.throw_alert(ALERT_ETHEREAL_OVERCHARGE, /atom/movable/screen/alert/ethereal_overcharge, 1)
			//carbon.apply_damage(0.2, TOX, null, null, carbon) //NOVA EDIT REMOVAL- Ethereal Rework 2024 - You should only really be getting that damage when you're actually overcharged.
		if(ETHEREAL_CHARGE_OVERLOAD to ETHEREAL_CHARGE_DANGEROUS)
			carbon.add_mood_event("charge", /datum/mood_event/supercharged)
			carbon.throw_alert(ALERT_ETHEREAL_OVERCHARGE, /atom/movable/screen/alert/ethereal_overcharge, 2)
			carbon.apply_damage(0.325 * seconds_per_tick, damagetype = TOX)
			if(SPT_PROB(5, seconds_per_tick)) // 5% each seacond for ethereals to explosively release excess energy if it reaches dangerous levels
				discharge_process(carbon)
			// NOVA EDIT ADDITION BEGIN
			if (SPT_PROB(10, seconds_per_tick))
				do_sparks(5, TRUE, carbon)
				carbon.visible_message(span_danger("[carbon] 迸发出电火花，[carbon.p_their()] 的身体因能量过剩而发光！"), span_warning("你的身体以电火花的形式释放电压，你应该释放一些电能！"))
			// NOVA EDIT ADDITION END
		else
			owner.clear_mood_event("charge")
			carbon.clear_alert(ALERT_ETHEREAL_CHARGE)
			carbon.clear_alert(ALERT_ETHEREAL_OVERCHARGE)

/obj/item/organ/stomach/ethereal/proc/discharge_process(mob/living/carbon/carbon)
	to_chat(carbon, span_warning("你开始失去对体内电荷的控制！"))
	carbon.visible_message(span_danger("[carbon] 开始剧烈地迸发火花！"))

	var/static/mutable_appearance/overcharge //shameless copycode from lightning spell
	overcharge = overcharge || mutable_appearance('icons/effects/effects.dmi', "electricity", EFFECTS_LAYER)
	carbon.add_overlay(overcharge)

	if(do_after(carbon, 5 SECONDS, timed_action_flags = (IGNORE_USER_LOC_CHANGE|IGNORE_HELD_ITEM|IGNORE_INCAPACITATED)))
		if(ishuman(carbon))
			var/mob/living/carbon/human/human = carbon
			if(human.dna?.species)
				//fixed_mut_color is also ethereal color (for some reason)
				carbon.flash_lighting_fx(5, 7, human.dna.species.fixed_mut_color ? human.dna.species.fixed_mut_color : human.dna.features[FEATURE_MUTANT_COLOR])

		playsound(carbon, 'sound/effects/magic/lightningshock.ogg', 100, TRUE, extrarange = 5)
		carbon.cut_overlay(overcharge)
		// Only a small amount of the energy gets discharged as the zap. The rest dissipates as heat. Keeps the damage and energy from the zap the same regardless of what STANDARD_CELL_CHARGE is.
		var/discharged_energy = -adjust_charge(ETHEREAL_CHARGE_FULL - cell.charge()) * min(7500 / STANDARD_CELL_CHARGE, 1)
		tesla_zap(source = carbon, zap_range = 2, power = discharged_energy, cutoff = 1 KILO JOULES, zap_flags = ZAP_OBJ_DAMAGE | ZAP_LOW_POWER_GEN | ZAP_ALLOW_DUPLICATES)
		carbon.visible_message(span_danger("[carbon] 剧烈地释放出能量！"), span_warning("你剧烈地释放出能量！"))

		if(prob(10)) //chance of developing heart disease to dissuade overcharging oneself
			carbon.apply_status_effect(/datum/status_effect/heart_attack)
			to_chat(carbon, span_userdanger("你相当确定刚才有那么一瞬间，你的心脏停止了跳动.."))
			carbon.playsound_local(carbon, 'sound/effects/singlebeat.ogg', 100, 0)

		carbon.Paralyze(100)
