#define CUM_VOLUME_MULTIPLIER 10

/obj/item/hand_item/coom
	name = "cum"
	desc = "C-can I watch...?"
	icon = 'icons/obj/service/hydroponics/harvest.dmi'
	icon_state = "eggplant"
	inhand_icon_state = "nothing"

// Jerk off into bottles and onto people.
/obj/item/hand_item/coom/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	do_masturbate(interacting_with, user)

/// Handles masturbation onto a living mob, or an atom.
/// Attempts to fill the atom's reagent container, if it has one, and it isn't full.
/obj/item/hand_item/coom/proc/do_masturbate(atom/target, mob/living/carbon/human/user)
	if (CONFIG_GET(flag/disable_erp_preferences) || user.stat >= DEAD)
		return

	var/mob/living/carbon/human/affected_human = user
	var/obj/item/organ/genital/testicles/mob_testicles = affected_human.get_organ_slot(ORGAN_SLOT_TESTICLES)

	// do you have a penis?
	if(!user.has_penis())
		to_chat(user, span_danger(LANG("obj.d2b97fa604077bae", null)))
		qdel(src)
		return

	// is the penis exposed?
	if(!user.has_penis(required_state = REQUIRE_GENITAL_EXPOSED))
		to_chat(user, span_danger(LANG("obj.c1189c0a7566fa3e", null)))
		return

	if(user.is_wearing_condom()) // i give up actually, the code from climax was refusing to work and not like its contributing to the goal here... just press the climax button
		to_chat(user, span_danger(LANG("obj.3ab13b5f33431b28", null)))
		return

	if(target == user)
		user.visible_message(span_warning(LANG("obj.addd7a8fcf7d896a", list(user, target.p_them()))), span_danger(LANG("obj.af34580c263bd6fe", null)))

	else if(target.is_refillable() && target.is_drainable())
		if(target.reagents.holder_full())
			to_chat(user, span_warning(LANG("obj.8e2d390ca03cb226", list(target))))
			return
		user.visible_message(span_warning(LANG("obj.509f7b7baaab71f5", list(user, target))), span_danger(LANG("obj.36c42e8d0d88ab75", list(target))))
	else
		user.visible_message(span_warning(LANG("obj.184b1b5966eb3bb6", list(user, target))), span_danger(LANG("obj.3ed1c4a86281ed61", list(target))))

	if(do_after(user, 6 SECONDS, target))
		if(!user.has_balls())
			user.visible_message(span_warning(LANG("obj.22415145f5c1bb58", list(user))), span_danger(LANG("obj.a241286c0b92cb31", null)))
		else if(target == user)
			user.visible_message(span_warning(LANG("obj.999b6fd27d1ea5c0", list(user, target.p_them()))), span_danger(LANG("obj.e523e15b16cd2d67", null)))
			playsound_if_pref(target, SFX_DESECRATION, 50, TRUE)
			affected_human.add_cum_splatter_floor(get_turf(target))
		else if(target.is_refillable() && target.is_drainable())
			var/cum_volume = mob_testicles.genital_size * CUM_VOLUME_MULTIPLIER
			var/datum/reagents/applied_reagents = new/datum/reagents(50)
			applied_reagents.add_reagent(/datum/reagent/consumable/cum, cum_volume) // probably should check what the target is actually cumming but we dont have custom cum settings enabled anyways...
			user.visible_message(span_warning(LANG("obj.c591380b15d005da", list(user, target))), span_danger(LANG("obj.d7335afab3204150", list(target))))
			playsound_if_pref(target, SFX_DESECRATION, 50, TRUE)
			applied_reagents.trans_to(target, cum_volume)
		else
			user.visible_message(span_warning(LANG("obj.80de15e732bcea7b", list(user, target))), span_danger(LANG("obj.4255475f7a539e6a", list(target))))
			playsound_if_pref(target, SFX_DESECRATION, 50, TRUE)
			affected_human.add_cum_splatter_floor(get_turf(target))
		log_combat(user, target, "came on")
		if(prob(40))
			affected_human.try_lewd_autoemote("moan")
		qdel(src)

#undef CUM_VOLUME_MULTIPLIER
