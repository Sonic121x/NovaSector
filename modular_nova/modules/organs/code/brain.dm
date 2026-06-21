//Unifying vox brains and android brains, so that when one is updated the other is as well.

//The accessible cybernetic brain
/obj/item/organ/brain/cybernetic/cortical
	name = "皮层增强大脑"
	desc = "一个部分机械化了的大脑。"
	icon = 'modular_nova/master_files/icons/obj/medical/organs.dmi'
	icon_state = "brain-c"
	emp_dmg_mult = 1.5 //Note that the base damage is 20/10
	emp_dmg_max = 150 //defaults to nonlethal, severely damaged
	var/obj/item/modular_computer/pda/synth/internal_computer
	actions_types = list(/datum/action/item_action/synth/open_internal_computer)

/obj/item/organ/brain/cybernetic/cortical/Initialize(mapload)
	. = ..()
	internal_computer = new(src)
	ADD_TRAIT(src, TRAIT_SILICON_EMOTES_ALLOWED, INNATE_TRAIT)

/obj/item/organ/brain/cybernetic/cortical/Destroy()
	QDEL_NULL(internal_computer)
	return ..()

/obj/item/organ/brain/cybernetic/cortical/on_mob_insert(mob/living/carbon/human/brain_owner, special, movement_flags)
	. = ..()
	if(!istype(brain_owner))
		return
	RegisterSignal(brain_owner, COMSIG_MOB_EQUIPPED_ITEM, PROC_REF(on_equip_signal))
	if(internal_computer && brain_owner.wear_id)
		internal_computer.handle_id_slot(brain_owner, brain_owner.wear_id)

/obj/item/organ/brain/cybernetic/cortical/on_mob_remove(mob/living/carbon/human/brain_owner, special)
	. = ..()
	if(!istype(brain_owner))
		return
	UnregisterSignal(brain_owner, COMSIG_MOB_EQUIPPED_ITEM)
	if(internal_computer)
		internal_computer.handle_id_slot(brain_owner)
		internal_computer.clear_id_slot_signals(brain_owner.wear_id)

/obj/item/organ/brain/cybernetic/cortical/proc/on_equip_signal(datum/source, obj/item/item, slot)
	SIGNAL_HANDLER
	if(isnull(internal_computer))
		return
	if(slot == ITEM_SLOT_ID)
		internal_computer.handle_id_slot(owner, item)

/// Mark cortical brains as robotic for systems that require synthetic brains
/obj/item/organ/brain/cybernetic/cortical/Initialize(mapload)
	. = ..()
	organ_flags |= ORGAN_ROBOTIC

//Extra effects
/obj/item/organ/brain/cybernetic/cortical/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(owner.stat == DEAD)
		return
	switch(severity)
		if(EMP_HEAVY)
			owner.set_jitter_if_lower(30 SECONDS)
			owner.adjust_stutter(30 SECONDS)
			owner.adjust_confusion(10 SECONDS)
		if(EMP_LIGHT)
			owner.set_jitter_if_lower(15 SECONDS)
			owner.adjust_stutter(15 SECONDS)
			owner.adjust_confusion(3 SECONDS)

// It's still organic
/obj/item/organ/brain/cybernetic/cortical/brain_damage_examine()
	if(suicided)
		return span_info("它的电路正微微冒烟。他们肯定没能承受住这一切的压力。")

	// Must have a brainmob that is either active, a decoy, or has a ghost
	if(!(brainmob && (decoy_override || brainmob.client || brainmob.get_ghost())))
		return span_info("这一个已完全失去生命迹象。")

	if(organ_flags & ORGAN_FAILING)
		return span_info("它内部似乎还残留着一点能量，但受损相当严重……或许可以用一些<b>甘露醇</b>来修复。")

	if(damage >= BRAIN_DAMAGE_DEATH * 0.5)
		return span_info("你能感觉到这一个里面尚存一丝微弱的生命火花，但它有些瘀伤。或许可以用一些<b>甘露醇</b>来修复。")

	return span_info("你能感觉到这一个里面尚存一丝微弱的生命火花。")

//New vox Brain
/obj/item/organ/brain/cybernetic/cortical/vox
	name = "沃克斯增强大脑"
	desc = "一个部分机械化了的大脑。组件与肉体无缝集成。"
	emp_dmg_mult = 1 //Vox get what they used to.

//surplus; TBI to prosthetic organ quirk
/obj/item/organ/brain/cybernetic/cortical/surplus
	name = "过剩增强大脑"
	desc = "一个部分机械化了的大脑。看起来有点廉价。"
	maxHealth = BRAIN_DAMAGE_DEATH*0.5 //200 -> 100, by default
	emp_dmg_max = INFINITY
