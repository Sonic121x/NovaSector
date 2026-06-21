/**
 * Bone liver
 * Gives the owner liverless metabolism, makes them vulnerable to bone hurting juice and
 * makes milk heal them through meme magic.
 **/
/obj/item/organ/liver/bone
	name = "骨团"
	desc = "你完全不知道这团奇怪的骨头球有什么用。"
	icon_state = "liver-bone"
	organ_traits = list(TRAIT_STABLELIVER)
	///Var for brute healing via milk
	var/milk_brute_healing = 2.5
	///Var for burn healing via milk
	var/milk_burn_healing = 2.5

/obj/item/organ/liver/bone/handle_chemical(mob/living/carbon/organ_owner, datum/reagent/chem, seconds_per_tick)
	. = ..()
	// parent returned COMSIG_MOB_STOP_REAGENT_TICK or we are failing
	if((. & COMSIG_MOB_STOP_REAGENT_TICK) || (organ_flags & ORGAN_FAILING))
		return
	if(istype(chem, /datum/reagent/toxin/bonehurtingjuice))
		organ_owner.adjust_stamina_loss(3.25  * seconds_per_tick, updating_stamina = FALSE)
		organ_owner.adjust_brute_loss(0.25 * seconds_per_tick, updating_health = FALSE)
		if(SPT_PROB(10, seconds_per_tick))
			switch(rand(1, 3))
				if(1)
					INVOKE_ASYNC(organ_owner, TYPE_PROC_REF(/atom/movable, say), pick("oof.", "ouch.", "my bones.", "oof ouch.", "oof ouch my bones."), forced = chem.type)
				if(2)
					organ_owner.manual_emote(pick("oofs silently.", "looks like [organ_owner.p_their()] bones hurt.", "grimaces, as though [organ_owner.p_their()] bones hurt."))
				if(3)
					to_chat(organ_owner, span_warning("你的骨头疼！"))
		if(chem.overdosed)
			if(SPT_PROB(2, seconds_per_tick)) //big oof
				var/selected_part = pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG) //God help you if the same limb gets picked twice quickly...
				var/obj/item/bodypart/bodypart = organ_owner.get_bodypart(selected_part) //We're so sorry skeletons, you're so misunderstood
				if(bodypart)
					playsound(organ_owner, SFX_DESECRATION, 50, vary = TRUE) //You just want to socialize
					organ_owner.visible_message(span_warning("[organ_owner] 大声地嘎嘎作响并四处乱舞！！"), span_danger("你的骨头疼得让你缺失的肌肉都在痉挛！！"))
					INVOKE_ASYNC(organ_owner, TYPE_PROC_REF(/atom/movable, say), "OOF!!", forced = chem.type)
					organ_owner.apply_damage(200, BRUTE, bodypart)
				else
					to_chat(organ_owner, span_warning("你缺失的 [parse_zone(selected_part)] 从你遗弃它的地方传来阵阵疼痛。"))
					INVOKE_ASYNC(organ_owner, TYPE_PROC_REF(/mob, emote), "sigh")
		organ_owner.reagents.remove_reagent(chem.type, chem.metabolization_rate * seconds_per_tick)
		return COMSIG_MOB_STOP_REAGENT_TICK // Stop metabolism
	if(chem.type == /datum/reagent/consumable/milk)
		if(chem.volume > 50)
			organ_owner.reagents.remove_reagent(chem.type, (chem.volume - 50))
			to_chat(organ_owner, span_warning("多余的牛奶正从你的骨头上滴落！"))
		organ_owner.heal_bodypart_damage(0.5 * milk_brute_healing * seconds_per_tick, 0.5 * milk_burn_healing * seconds_per_tick)
		for(var/datum/wound/iter_wound as anything in organ_owner.all_wounds)
			iter_wound.on_xadone(0.5 * seconds_per_tick)
		return // Do normal metabolism
