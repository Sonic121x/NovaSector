// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/mob/living/silicon/ai/blob_act(obj/structure/blob/B)
	if (stat != DEAD)
		adjust_brute_loss(60)
		return TRUE
	return FALSE

/mob/living/silicon/ai/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	disconnect_shell()
	if (prob(30))
		switch(pick(1,2))
			if(1)
				view_core()
			if(2)
				SSshuttle.requestEvac(src,"ALERT: Energy surge detected in AI core! Station integrity may be compromised! Initiati--%m091#ar-BZZT")

/mob/living/silicon/ai/ex_act(severity, target)
	switch(severity)
		if(EXPLODE_DEVASTATE)
			investigate_log("has been gibbed by an explosion.", INVESTIGATE_DEATHS)
			gib(DROP_ALL_REMAINS)
		if(EXPLODE_HEAVY)
			if (stat != DEAD)
				adjust_brute_loss(60)
				adjust_fire_loss(60)
		if(EXPLODE_LIGHT)
			if (stat != DEAD)
				adjust_brute_loss(30)

	return TRUE

/mob/living/silicon/ai/flash_act(intensity = 1, override_blindness_check = 0, affect_silicon = 0, visual = 0, type = /atom/movable/screen/fullscreen/flash, length = 25)
	return // no eyes, no flashing

/mob/living/silicon/ai/emag_act(mob/user, obj/item/card/emag/emag_card) ///emags access panel lock, so you can crowbar it without robotics access or consent
	. = ..()
	if(emagged)
		balloon_alert(user, LANG("mob.1c2ac6ac5d5af26e", null))
		return
	balloon_alert(user, LANG("mob.6cc6b66665d1eeed", null))
	var/message = (user ? "[user] shorts out your access panel lock!" : "Your access panel lock was short circuited!")
	to_chat(src, span_warning(message))
	do_sparks(3, FALSE, src) // just a bit of extra "oh shit" to the ai - might grab its attention
	emagged = TRUE
	return TRUE

/mob/living/silicon/ai/wrench_act(mob/living/user, obj/item/tool)
	if(!incapacitated && (client || deployed_shell?.client))
		// alive and well AIs control their floor bolts
		balloon_alert(user, LANG("mob.9760cd05c29ebf73", null))
		return ITEM_INTERACT_BLOCKING
	balloon_alert(user, LANG("mob.e643c62a6ff3cc30", list(!is_anchored ? "tightening" : "loosening")))
	balloon_alert(src, LANG("mob.62722c28cf8ccd0d", list(!is_anchored ? "tightened" : "loosened")))
	if(!tool.use_tool(src, user, 4 SECONDS))
		return ITEM_INTERACT_SUCCESS
	flip_anchored()
	balloon_alert(user, LANG("mob.6cf64da468aa20e3", list(is_anchored ? "tightened" : "loosened")))
	balloon_alert(src, LANG("mob.6cf64da468aa20e3", list(is_anchored ? "tightened" : "loosened")))
	return ITEM_INTERACT_SUCCESS

/mob/living/silicon/ai/crowbar_act(mob/living/user, obj/item/tool)
	. = ..()
	if(user.combat_mode)
		return
	if(!is_anchored)
		balloon_alert(user, LANG("mob.8ae26cfd9bf68674", null))
		return ITEM_INTERACT_SUCCESS
	if(opened)
		if(emagged)
			balloon_alert(user, LANG("mob.762b69cfba21dc8c", null))
			return ITEM_INTERACT_SUCCESS
		balloon_alert(user, LANG("mob.e7a5e1a445fdcfdd", null))
		balloon_alert(src, LANG("mob.0517ba2fdcfe3db1", null))
		if(!tool.use_tool(src, user, 5 SECONDS))
			return ITEM_INTERACT_SUCCESS
		balloon_alert(src, LANG("mob.4eda5d6fd74088fc", null))
		balloon_alert(user, LANG("mob.4eda5d6fd74088fc", null))
		opened = FALSE
		return ITEM_INTERACT_SUCCESS
	if(stat == DEAD)
		to_chat(user, span_warning(LANG("mob.64b6a3731374fdbc", null)))
	else
		var/consent
		var/consent_override = FALSE
		if(ishuman(user))
			var/mob/living/carbon/human/human_user = user
			if(human_user.wear_id)
				var/list/access = human_user.wear_id.GetAccess()
				if(ACCESS_ROBOTICS in access)
					consent_override = TRUE
		if(mind)
			consent = tgui_alert(src, LANG("mob.8f134fed7c4a8b75", list(user)), LANG("mob.2e10dbce97dbba20", null), list("Yes", "No"))
			if(consent == "No" && !consent_override && !emagged)
				to_chat(user, span_notice(LANG("mob.b967804bd6ac147a", list(src))))
				return ITEM_INTERACT_SUCCESS
			if(consent != "Yes" && (consent_override || emagged))
				to_chat(user, span_warning(LANG("mob.3a70c8c636b05a99", list(src, !emagged ? " swipe your ID and " : " "))))
		else
			if(!consent_override && !emagged)
				to_chat(user, span_notice(LANG("mob.a667fe3c706341cf", list(src))))
				return ITEM_INTERACT_SUCCESS
			else
				to_chat(user, span_notice(LANG("mob.f03bc398806bf9bd", list(src, !emagged ? " swipe your ID and " : " "))))

	balloon_alert(user, LANG("mob.c231d56f5c882e12", null))
	balloon_alert(src, LANG("mob.5ba414b7489250db", null))
	if(!tool.use_tool(src, user, (stat == DEAD ? 40 SECONDS : 5 SECONDS)))
		return ITEM_INTERACT_SUCCESS
	balloon_alert(src, LANG("mob.a40e832508b609a5", null))
	balloon_alert(user, LANG("mob.a40e832508b609a5", null))
	opened = TRUE
	return ITEM_INTERACT_SUCCESS

/mob/living/silicon/ai/wirecutter_act(mob/living/user, obj/item/tool)
	. = ..()
	if(user.combat_mode)
		return
	if(!is_anchored)
		balloon_alert(user, LANG("mob.8ae26cfd9bf68674", null))
		return ITEM_INTERACT_SUCCESS
	if(!opened)
		balloon_alert(user, LANG("mob.1a4ca1552f47ff14", null))
		return ITEM_INTERACT_SUCCESS
	balloon_alert(src, LANG("mob.7f600c65947dcdcf", null))
	balloon_alert(user, LANG("mob.bb03127e8cbd9682", null))
	if(!tool.use_tool(src, user, (stat == DEAD ? 5 SECONDS : 40 SECONDS)))
		return ITEM_INTERACT_SUCCESS
	if(IS_MALF_AI(src))
		to_chat(user, span_userdanger(LANG("mob.64996f9f629a4931", null)))
		user.electrocute_act(120, src)
		opened = FALSE
		return ITEM_INTERACT_SUCCESS
	to_chat(src, span_danger(LANG("mob.776c94cfc3dccc83", null)))
	var/atom/ai_structure = ai_mob_to_structure()
	ai_structure.balloon_alert(user, LANG("mob.41cde09077583758", null))
	return ITEM_INTERACT_SUCCESS

/mob/living/silicon/ai/attack_effects(damage_done, hit_zone, armor_block, obj/item/attacking_item, mob/living/attacker)
	if(damage_done > 0 && attacking_item.damtype != STAMINA && stat != DEAD)
		spark_system.start()
		. = TRUE
	return ..() || .
