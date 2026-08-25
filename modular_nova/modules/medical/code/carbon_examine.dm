/mob/living/carbon/examine_more(mob/user)
	. = ..()
	var/t_His = p_Their()
	var/t_He = p_They()
	var/t_Has = p_have()

	var/any_bodypart_damage = FALSE
	for(var/X in bodyparts)
		var/obj/item/bodypart/LB = X
		if(LB.bodypart_flags & BODYPART_PSEUDOPART)
			continue
		var/limb_max_damage = LB.max_damage
		var/status = ""
		var/brutedamage = round(LB.brute_dam/limb_max_damage*100)
		var/burndamage = round(LB.burn_dam/limb_max_damage*100)
		switch(brutedamage)
			if(20 to 50)
				status = LB.light_brute_msg
			if(51 to 75)
				status = LB.medium_brute_msg
			if(76 to 100)
				status += LB.heavy_brute_msg

		if(burndamage >= 20 && status)
			status += LANG("mob.4cbed25e0ca56ee1", null)
		switch(burndamage)
			if(20 to 50)
				status += LB.light_burn_msg
			if(51 to 75)
				status += LB.medium_burn_msg
			if(76 to 100)
				status += LB.heavy_burn_msg

		if(status)
			any_bodypart_damage = TRUE
			. += LANG("mob.32521617c00eaeb8", list(t_His, LB.name, status))

		for(var/thing in LB.wounds)
			any_bodypart_damage = TRUE
			var/datum/wound/W = thing
			switch(W.severity)
				if(WOUND_SEVERITY_TRIVIAL)
					. += LANG("mob.d2ac56ce9f718713", list(t_His, LB.name, W.a_or_from, W.get_topic_name(user)))
				if(WOUND_SEVERITY_MODERATE)
					. += LANG("mob.faf36cc6996a55b7", list(t_His, LB.name, W.a_or_from, W.get_topic_name(user)))
				if(WOUND_SEVERITY_SEVERE)
					. += LANG("mob.a29cd597781e7d83", list(t_His, LB.name, W.a_or_from, W.get_topic_name(user)))
				if(WOUND_SEVERITY_CRITICAL)
					. += LANG("mob.b2137071f44b1a3e", list(t_His, LB.name, W.a_or_from, W.get_topic_name(user)))

	if(!any_bodypart_damage)
		. += LANG("mob.d4aac760936343fe", list(t_He, t_Has))

	var/list/visible_scars
	if(all_scars)
		for(var/i in all_scars)
			var/datum/scar/S = i
			if(S.is_visible(user))
				LAZYADD(visible_scars, S)

	if(!visible_scars)
		. += LANG("mob.cded1d50dfff74ac", list(t_He, t_Has))

	return .
