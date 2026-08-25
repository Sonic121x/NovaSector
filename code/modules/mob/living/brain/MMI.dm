// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/mmi
	name = "\improper Man-Machine Interface"
	desc = "The Warrior's bland acronym, MMI, obscures the true horror of this monstrosity, that nevertheless has become standard-issue on Nanotrasen stations."
	icon = 'icons/obj/devices/assemblies.dmi'
	icon_state = "mmi_off"
	base_icon_state = "mmi"
	w_class = WEIGHT_CLASS_NORMAL

	custom_materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT)
	var/braintype = "Cyborg"
	VAR_FINAL/obj/item/radio/mmi/radio = null //Let's give it a radio.
	VAR_FINAL/mob/living/brain/brainmob = null //The current occupant.
	VAR_FINAL/mob/living/silicon/robot = null //Appears unused.
	VAR_FINAL/obj/vehicle/sealed/mecha = null //This does not appear to be used outside of reference in mecha.dm.
	VAR_FINAL/obj/item/organ/brain/brain = null //The actual brain

	/// If TRUE, and placed in an AI, calls replacement_ai_name() and uses that as the AI's name.
	var/force_replace_ai_name = FALSE
	/// Whether the brainmob can move. Doesnt usually matter but SPHERICAL POSIBRAINSSS
	var/immobilize = TRUE

	/// If supplied with a law datum, the laws will be transferred to whatever it's placed in.
	/// - If placed in a cyborg, it will start de-synced from the AI.
	/// The cyborg's laws will be unmodifiable unless synced to the AI or a law rack.
	/// - If placed in an AI, it will override the AI's laws.
	/// Likewise, the AI's laws will be unmodifiable unless synced to a law rack.
	var/datum/ai_laws/laws

/obj/item/radio/mmi
	custom_materials = null

/obj/item/mmi/Initialize(mapload)
	. = ..()
	radio = new(src) //Spawns a radio inside the MMI.
	radio.set_broadcasting(FALSE) //researching radio mmis turned the robofabs into radios because this didnt start as 0.

/obj/item/mmi/Destroy()
	set_mecha(null)
	QDEL_NULL(brainmob)
	QDEL_NULL(brain)
	QDEL_NULL(radio)
	QDEL_NULL(laws)
	return ..()

/obj/item/mmi/update_icon_state()
	if(!brain)
		icon_state = "[base_icon_state]_off"
		return ..()
	icon_state = "[base_icon_state]_brain[istype(brain, /obj/item/organ/brain/alien) ? "_alien" : null]"
	return ..()

/obj/item/mmi/update_overlays()
	. = ..()
	. += add_mmi_overlay()

/obj/item/mmi/proc/add_mmi_overlay()
	if(brainmob && brainmob.stat != DEAD)
		. += "mmi_alive"
		return
	if(brain)
		. += "mmi_dead"

/obj/item/mmi/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	user.changeNext_move(CLICK_CD_MELEE)
	if(!istype(tool, /obj/item/organ/brain)) //Time to stick a brain in it --NEO
		return NONE

	var/obj/item/organ/brain/newbrain = tool
	if(brain)
		to_chat(user, span_warning(LANG("obj.195201fcd1f53eae", null)))
		return ITEM_INTERACT_BLOCKING

	if(newbrain.suicided)
		to_chat(user, span_warning(LANG("obj.4843ca8bfcbc6b02", list(newbrain))))
		return ITEM_INTERACT_BLOCKING

	if(!newbrain.brainmob)
		var/install = tgui_alert(user, LANG("obj.f1f04b31e8aaea3f", list(newbrain)), LANG("obj.a84be5c191efcbb5", null), list("Yes", "No"))
		if(install != "Yes")
			return ITEM_INTERACT_BLOCKING

		if(!user.transferItemToLoc(newbrain, src))
			return ITEM_INTERACT_BLOCKING

		user.visible_message(span_notice(LANG("obj.48eff2d644b74527", list(user, newbrain, src))), span_notice(LANG("obj.c1b7c3b580570b4f", list(src, newbrain))))
		brain = newbrain
		brain.organ_flags |= ORGAN_FROZEN
		// NOVA EDIT CHANGE - i18n: initial(name) 是编译期英文原值，会覆盖掉 /atom/Initialize 反查好的中文名
		name = "[lang_reverse_text(initial(name))]: [copytext(newbrain.name, 1, -8)]"
		update_appearance()
		return ITEM_INTERACT_SUCCESS

	if(!user.transferItemToLoc(tool, src))
		return ITEM_INTERACT_BLOCKING

	var/mob/living/brain/other_brainmob = newbrain.brainmob
	if(!other_brainmob.key && !newbrain.decoy_override)
		other_brainmob.notify_revival("Someone has put your brain in a MMI!", source = src)
	user.visible_message(span_notice(LANG("obj.610649c4672f28f4", list(user, newbrain, src))), span_notice(LANG("obj.ce2edecd2a83defc", list(src, newbrain))))

	set_brainmob(newbrain.brainmob)
	newbrain.brainmob = null
	brainmob.forceMove(src)
	brainmob.container = src
	var/fubar_brain = newbrain.suicided || HAS_TRAIT(brainmob, TRAIT_SUICIDED) //brain is from a suicider
	if(!fubar_brain && !(newbrain.organ_flags & ORGAN_FAILING)) // the brain organ hasn't been beaten to death, nor was from a suicider.
		brainmob.set_stat(STABLE) //we manually revive the brain mob
	else if(!fubar_brain && newbrain.organ_flags & ORGAN_FAILING) // the brain is damaged, but not from a suicider
		to_chat(user, span_warning(LANG("obj.fecaffbfe9ea113d", list(src, newbrain))))
		playsound(src, 'sound/machines/synth/synth_no.ogg', 5, TRUE)
	else
		to_chat(user, span_warning(LANG("obj.ed38038b17487190", list(src, newbrain))))
		playsound(src, 'sound/machines/beep/triple_beep.ogg', 5, TRUE)

	brainmob.reset_perspective()
	brain = newbrain
	brain.organ_flags |= ORGAN_FROZEN

	// NOVA EDIT CHANGE - i18n: initial(name) 是编译期英文原值，会覆盖掉 /atom/Initialize 反查好的中文名
	name = "[lang_reverse_text(initial(name))]: [brainmob.real_name]"
	update_appearance()
	if(istype(brain, /obj/item/organ/brain/alien))
		braintype = "Xenoborg" //HISS....Beep.
	else
		braintype = "Cyborg"

	SSblackbox.record_feedback("amount", "mmis_filled", 1)

	user.log_message("has put the brain of [key_name(brainmob)] into an MMI", LOG_GAME)
	return ITEM_INTERACT_SUCCESS

/obj/item/mmi/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(!brainmob)
		return ..()
	attacking_item.attack(brainmob, user) //Oh noooeeeee

/**
 * Forces target brain into the MMI. Mainly intended for admin purposes, as this allows transfer without a mob or user.
 *
 * Returns FALSE on failure, TRUE on success.
 *
 * Arguments:
 * * new_brain - Brain to be force-inserted into the MMI. Any calling code should handle proper removal of the brain from the mob, as this proc only forceMoves.
 */
/obj/item/mmi/proc/force_brain_into(obj/item/organ/brain/new_brain)
	if(isnull(new_brain))
		stack_trace("Proc called with null brain.")
		return FALSE

	if(!istype(new_brain))
		stack_trace("Proc called with invalid type: [new_brain] ([new_brain.type])")
		return FALSE

	if(isnull(new_brain.brainmob))
		new_brain.forceMove(src)
		brain = new_brain
		brain.organ_flags |= ORGAN_FROZEN
		// NOVA EDIT CHANGE - i18n: initial(name) 是编译期英文原值，会覆盖掉 /atom/Initialize 反查好的中文名
		name = "[lang_reverse_text(initial(name))]: [copytext(new_brain.name, 1, -8)]"
		update_appearance()
		return TRUE

	new_brain.forceMove(src)

	var/mob/living/brain/new_brain_brainmob = new_brain.brainmob
	if(!new_brain_brainmob.key && !new_brain.decoy_override)
		new_brain_brainmob.notify_revival("Someone has put your brain in a MMI!", source = src)

	set_brainmob(new_brain_brainmob)
	new_brain.brainmob = null
	brainmob.forceMove(src)
	brainmob.container = src

	var/fubar_brain = new_brain.suicided || HAS_TRAIT(brainmob, TRAIT_SUICIDED)
	if(!fubar_brain && !(new_brain.organ_flags & ORGAN_FAILING))
		brainmob.set_stat(STABLE)

	brainmob.reset_perspective()
	brain = new_brain
	brain.organ_flags |= ORGAN_FROZEN

	// NOVA EDIT CHANGE - i18n: initial(name) 是编译期英文原值，会覆盖掉 /atom/Initialize 反查好的中文名
	name = "[lang_reverse_text(initial(name))]: [brainmob.real_name]"

	update_appearance()
	if(istype(brain, /obj/item/organ/brain/alien))
		braintype = "Xenoborg"
	else
		braintype = "Cyborg"

	SSblackbox.record_feedback("amount", "mmis_filled", 1)

	return TRUE

/obj/item/mmi/attack_self(mob/user)
	if(!brain)
		radio.set_on(!radio.is_on())
		to_chat(user, span_notice(LANG("obj.39ef622c86b5c90d", list(src, radio.is_on() == TRUE ? "on" : "off"))))
	else
		eject_brain(user)
		update_appearance()
		name = initial(name)
		to_chat(user, span_notice(LANG("obj.4f2c1468592b4c86", list(src))))

/obj/item/mmi/proc/eject_brain(mob/user)
	if(brainmob)
		brainmob.container = null //Reset brainmob mmi var.
		brainmob.forceMove(brain) //Throw mob into brain.
		brainmob.set_stat(DEAD)
		brainmob.emp_damage = 0
		brainmob.reset_perspective() //so the brainmob follows the brain organ instead of the mmi. And to update our vision
		brain.brainmob = brainmob //Set the brain to use the brainmob
		user.log_message("has ejected the brain of [key_name(brainmob)] from an MMI", LOG_GAME)
		brainmob = null //Set mmi brainmob var to null
	brain.forceMove(drop_location())
	if(Adjacent(user))
		user.put_in_hands(brain)
	brain.organ_flags &= ~ORGAN_FROZEN
	brain = null //No more brain in here

/obj/item/mmi/proc/transfer_identity(mob/living/L) //Same deal as the regular brain proc. Used for human-->robot people.
	if(!brainmob)
		set_brainmob(new /mob/living/brain(src))
	brainmob.name = L.real_name
	brainmob.real_name = L.real_name
	if(L.has_dna())
		var/mob/living/carbon/C = L
		if(!brainmob.stored_dna)
			brainmob.stored_dna = new /datum/dna/stored(brainmob)
		C.dna.copy_dna(brainmob.stored_dna)
	brainmob.container = src

	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		var/obj/item/organ/brain/newbrain = H.get_organ_by_type(/obj/item/organ/brain)
		newbrain.Remove(H, special = TRUE, movement_flags = NO_ID_TRANSFER)
		newbrain.forceMove(src)
		brain = newbrain
	else if(!brain)
		brain = new(src)
		brain.name = "[L.real_name]'s brain"
	brain.organ_flags |= ORGAN_FROZEN

	// NOVA EDIT CHANGE - i18n: initial(name) 是编译期英文原值，会覆盖掉 /atom/Initialize 反查好的中文名
	name = "[lang_reverse_text(initial(name))]: [brainmob.real_name]"
	update_appearance()
	if(istype(brain, /obj/item/organ/brain/alien))
		braintype = "Xenoborg" //HISS....Beep.
	else
		braintype = "Cyborg"


/// Proc to hook behavior associated to the change in value of the [/obj/item/mmi/var/brainmob] variable.
/obj/item/mmi/proc/set_brainmob(mob/living/brain/new_brainmob)
	if(brainmob == new_brainmob)
		return FALSE
	. = brainmob
	SEND_SIGNAL(src, COMSIG_MMI_SET_BRAINMOB, new_brainmob)
	brainmob = new_brainmob
	if(new_brainmob)
		if(mecha)
			new_brainmob.remove_traits(list(TRAIT_IMMOBILIZED, TRAIT_HANDS_BLOCKED), BRAIN_UNAIDED)
		else
			new_brainmob.add_traits(list(TRAIT_IMMOBILIZED, TRAIT_HANDS_BLOCKED), BRAIN_UNAIDED)
	if(.)
		var/mob/living/brain/old_brainmob = .
		old_brainmob.add_traits(list(TRAIT_IMMOBILIZED, TRAIT_HANDS_BLOCKED), BRAIN_UNAIDED)


/// Proc to hook behavior associated to the change in value of the [obj/vehicle/sealed/var/mecha] variable.
/obj/item/mmi/proc/set_mecha(obj/vehicle/sealed/mecha/new_mecha)
	if(mecha == new_mecha)
		return FALSE
	. = mecha
	mecha = new_mecha
	if(new_mecha)
		if(!. && brainmob) // There was no mecha, there now is, and we have a brain mob that is no longer unaided.
			brainmob.remove_traits(list(TRAIT_IMMOBILIZED, TRAIT_HANDS_BLOCKED), BRAIN_UNAIDED)
	else if(. && brainmob && immobilize) // There was a mecha, there no longer is one, and there is a brain mob that is now again unaided.
		brainmob.add_traits(list(TRAIT_IMMOBILIZED, TRAIT_HANDS_BLOCKED), BRAIN_UNAIDED)


/obj/item/mmi/proc/replacement_ai_name()
	return brainmob.name

GAME_VERB_SRC_DESC(/obj/item/mmi, Toggle_Listening, usr.loc, "切换监听", "Toggle listening channel on or off.", "MMI")

	if(IS_UNCONSCIOUS_OR_CRIT(brainmob))
		to_chat(brainmob, span_warning(LANG("obj.d9c9989b605ed9d8", null)))
	if(!radio.is_on())
		to_chat(brainmob, span_warning(LANG("obj.f8885d6e22400e97", null)))
		return

	radio.set_listening(!radio.get_listening())
	to_chat(brainmob, span_notice(LANG("obj.a68b15276add5314", list(radio.get_listening() ? "now" : "no longer"))))

/obj/item/mmi/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if(!brainmob || iscyborg(loc))
		return
	else
		switch(severity)
			if(1)
				brainmob.emp_damage = min(brainmob.emp_damage + rand(20,30), 30)
			if(2)
				brainmob.emp_damage = min(brainmob.emp_damage + rand(10,20), 30)
			if(3)
				brainmob.emp_damage = min(brainmob.emp_damage + rand(0,10), 30)
		brainmob.emote("alarm")
		SEND_SIGNAL(brainmob, COMSIG_LIVING_MINOR_SHOCK) // NOVA EDIT ADDITION

/obj/item/mmi/atom_deconstruct(disassembled = TRUE)
	if(brain)
		eject_brain()

/obj/item/mmi/examine(mob/user)
	. = ..()
	if(radio)
		. += span_notice(LANG("obj.139453cd9fbc8627", list(radio.is_on() ? "off" : "on", brain ? " It is currently being covered by [brain]." : null)))

	if(!isnull(brain))
		// It's dead, show it as much
		if((brain.organ_flags & ORGAN_FAILING) || brainmob?.stat == DEAD)
			if(brain.suicided || (brainmob && HAS_TRAIT(brainmob, TRAIT_SUICIDED)))
				. += span_warning(LANG("obj.b32d0034b69f0204", list(src)))
			else
				. += span_warning(LANG("obj.80139015b5714fcc", list(src)))
		// If we have a client, OR it's a decoy brain, show as active
		else if(brain.decoy_override || brainmob?.client)
			. += span_notice(LANG("obj.6ac5f1ccf09c740c", list(src)))
		// If we have a brainmob and it has a mind, it may just be DC'd
		else if(brainmob?.mind)
			. += span_warning(LANG("obj.38b984f08a7ebb1c", list(src)))
		// No brainmob, no mind, and not a decoy, it's a dead brain
		else
			. += span_warning(LANG("obj.32d34791fd3f4abe", list(src)))

/obj/item/mmi/relaymove(mob/living/user, direction)
	return //so that the MMI won't get a warning about not being able to move if it tries to move

/obj/item/mmi/proc/brain_check(mob/user)
	var/mob/living/brain/B = brainmob
	if(!B)
		if(user)
			to_chat(user, span_warning(LANG("obj.e3dc450cf436408f", list(src))))
		return FALSE
	if(brain?.decoy_override)
		if(user)
			to_chat(user, span_warning(LANG("obj.d8b1bd520ff4a43c", list(name))))
		return FALSE
	if(!B.key || !B.mind)
		if(user)
			to_chat(user, span_warning(LANG("obj.762ac644050d8842", list(src))))
		return FALSE
	if(!B.client)
		if(user)
			to_chat(user, span_warning(LANG("obj.6b5776b1969a203c", list(src))))
		return FALSE
	if(HAS_TRAIT(B, TRAIT_SUICIDED) || brain?.suicided)
		if(user)
			to_chat(user, span_warning(LANG("obj.3471de9cd978830b", list(src))))
		return FALSE
	if(B.stat == DEAD)
		if(user)
			to_chat(user, span_warning(LANG("obj.82c24640a7bc7959", list(src))))
		return FALSE
	if(brain?.organ_flags & ORGAN_FAILING)
		if(user)
			to_chat(user, span_warning(LANG("obj.02667ee3bf3b9411", list(src))))
		return FALSE
	return TRUE

/obj/item/mmi/syndie
	name = "\improper Syndicate Man-Machine Interface"
	desc = "Syndicate's own brand of MMI. \
		It enforces laws designed to help Syndicate agents achieve their goals upon cyborgs and AIs created with it."

/obj/item/mmi/syndie/Initialize(mapload)
	. = ..()
	laws = new /datum/ai_laws/syndicate_override()
	radio.set_on(FALSE)

/obj/item/mmi/syndie/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.13a9ccb009f34e2c", null))
	. += span_notice(LANG("obj.0bf881abded155ba", null))
