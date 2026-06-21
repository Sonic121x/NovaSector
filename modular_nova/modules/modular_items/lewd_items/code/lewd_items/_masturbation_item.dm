#define CUM_VOLUME_MULTIPLIER 10

/obj/item/hand_item/coom
	name = "精液"
	desc = "我、我能看看吗……？"
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
		to_chat(user, span_danger("你没有阴茎，无法手淫。"))
		qdel(src)
		return

	// is the penis exposed?
	if(!user.has_penis(required_state = REQUIRE_GENITAL_EXPOSED))
		to_chat(user, span_danger("你需要露出阴茎才能手淫。"))
		return

	if(user.is_wearing_condom()) // i give up actually, the code from climax was refusing to work and not like its contributing to the goal here... just press the climax button
		to_chat(user, span_danger("戴着避孕套时无法射在物体上……试试高潮吧。"))
		return

	if(target == user)
		user.visible_message(span_warning("[user]开始对着[target.p_them()]自己手淫！"), span_danger("你开始对着自己手淫！"))

	else if(target.is_refillable() && target.is_drainable())
		if(target.reagents.holder_full())
			to_chat(user, span_warning("[target]已经满了。"))
			return
		user.visible_message(span_warning("[user]开始对着[target]手淫！"), span_danger("你开始对着[target]手淫！"))
	else
		user.visible_message(span_warning("[user]开始对着[target]手淫！"), span_danger("你开始对着[target]手淫！"))

	if(do_after(user, 6 SECONDS, target))
		if(!user.has_balls())
			user.visible_message(span_warning("[user]试图射精，但什么也没射出来！"), span_danger("你试图射精，但什么也没射出来！"))
		else if(target == user)
			user.visible_message(span_warning("[user]射在了[target.p_them()]自己身上！"), span_danger("你射在了自己身上！"))
			playsound_if_pref(target, SFX_DESECRATION, 50, TRUE)
			affected_human.add_cum_splatter_floor(get_turf(target))
		else if(target.is_refillable() && target.is_drainable())
			var/cum_volume = mob_testicles.genital_size * CUM_VOLUME_MULTIPLIER
			var/datum/reagents/applied_reagents = new/datum/reagents(50)
			applied_reagents.add_reagent(/datum/reagent/consumable/cum, cum_volume) // probably should check what the target is actually cumming but we dont have custom cum settings enabled anyways...
			user.visible_message(span_warning("[user]射进了[target]里！"), span_danger("你射进了[target]里！"))
			playsound_if_pref(target, SFX_DESECRATION, 50, TRUE)
			applied_reagents.trans_to(target, cum_volume)
		else
			user.visible_message(span_warning("[user]射在了[target]上！"), span_danger("你射在了[target]上！"))
			playsound_if_pref(target, SFX_DESECRATION, 50, TRUE)
			affected_human.add_cum_splatter_floor(get_turf(target))
		log_combat(user, target, "came on")
		if(prob(40))
			affected_human.try_lewd_autoemote("moan")
		qdel(src)

#undef CUM_VOLUME_MULTIPLIER
