
/mob/living/silicon/ai/attackby(obj/item/W, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(W, /obj/item/ai_module))
		var/obj/item/ai_module/MOD = W
		disconnect_shell()
		if(!mind) //A player mind is required for law procs to run antag checks.
			to_chat(user, span_warning("[src]完全无响应！"))
			return
		MOD.install(laws, user) //Proc includes a success mesage so we don't need another one
		return

	return ..()

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
		balloon_alert(user, "访问面板锁已短路！")
		return
	balloon_alert(user, "访问面板锁短路")
	var/message = (user ? "[user] 短路了你的访问面板锁！" : "你的访问面板锁被短路了！")
	to_chat(src, span_warning(message))
	do_sparks(3, FALSE, src) // just a bit of extra "oh shit" to the ai - might grab its attention
	emagged = TRUE
	return TRUE

/mob/living/silicon/ai/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	if(user.combat_mode)
		return
	if(stat != DEAD && !incapacitated && (client || deployed_shell?.client))
		// alive and well AIs control their floor bolts
		balloon_alert(user, "AI的螺栓马达抵抗了。")
		return ITEM_INTERACT_SUCCESS
	balloon_alert(user, "[!is_anchored ? "tightening" : "loosening"]螺栓...")
	balloon_alert(src, "螺栓正在被[!is_anchored ? "tightened" : "loosened"]...")
	if(!tool.use_tool(src, user, 4 SECONDS))
		return ITEM_INTERACT_SUCCESS
	flip_anchored()
	balloon_alert(user, "螺栓[is_anchored ? "tightened" : "loosened"]")
	balloon_alert(src, "螺栓[is_anchored ? "tightened" : "loosened"]")
	return ITEM_INTERACT_SUCCESS

/mob/living/silicon/ai/crowbar_act(mob/living/user, obj/item/tool)
	. = ..()
	if(user.combat_mode)
		return
	if(!is_anchored)
		balloon_alert(user, "先把它固定住！")
		return ITEM_INTERACT_SUCCESS
	if(opened)
		if(emagged)
			balloon_alert(user, "访问面板锁已损坏！")
			return ITEM_INTERACT_SUCCESS
		balloon_alert(user, "正在关闭检修面板...")
		balloon_alert(src, "检修面板正在被关闭...")
		if(!tool.use_tool(src, user, 5 SECONDS))
			return ITEM_INTERACT_SUCCESS
		balloon_alert(src, "检修面板已关闭")
		balloon_alert(user, "检修面板已关闭")
		opened = FALSE
		return ITEM_INTERACT_SUCCESS
	if(stat == DEAD)
		to_chat(user, span_warning("检修面板看起来损坏了，你试图撬开盖板。"))
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
			consent = tgui_alert(src, "[user] 正试图打开你的检修面板，要解锁面板盖吗？", "AI 检修面板", list("Yes", "No"))
			if(consent == "No" && !consent_override && !emagged)
				to_chat(user, span_notice("[src]拒绝解锁其检修面板。"))
				return ITEM_INTERACT_SUCCESS
			if(consent != "Yes" && (consent_override || emagged))
				to_chat(user, span_warning("[src] 拒绝解锁其检修面板……所以你[!emagged ? " swipe your ID and " : " "]强行打开了它！"))
		else
			if(!consent_override && !emagged)
				to_chat(user, span_notice("[src]没有响应你解锁其检修面板盖锁的请求。"))
				return ITEM_INTERACT_SUCCESS
			else
				to_chat(user, span_notice("[src] 没有回应你解锁其检修面板盖锁的请求。你[!emagged ? " swipe your ID and " : " "]强行打开了它。"))

	balloon_alert(user, "正在撬开检修面板...")
	balloon_alert(src, "检修面板正在被撬开...")
	if(!tool.use_tool(src, user, (stat == DEAD ? 40 SECONDS : 5 SECONDS)))
		return ITEM_INTERACT_SUCCESS
	balloon_alert(src, "检修面板已打开")
	balloon_alert(user, "检修面板已打开")
	opened = TRUE
	return ITEM_INTERACT_SUCCESS

/mob/living/silicon/ai/wirecutter_act(mob/living/user, obj/item/tool)
	. = ..()
	if(user.combat_mode)
		return
	if(!is_anchored)
		balloon_alert(user, "先把它用螺栓固定住！")
		return ITEM_INTERACT_SUCCESS
	if(!opened)
		balloon_alert(user, "先打开检修面板！")
		return ITEM_INTERACT_SUCCESS
	balloon_alert(src, "神经网络正在断开连接...")
	balloon_alert(user, "正在断开神经网络连接...")
	if(!tool.use_tool(src, user, (stat == DEAD ? 5 SECONDS : 40 SECONDS)))
		return ITEM_INTERACT_SUCCESS
	if(IS_MALF_AI(src))
		to_chat(user, span_userdanger("电线内部的电压急剧上升！"))
		user.electrocute_act(120, src)
		opened = FALSE
		return ITEM_INTERACT_SUCCESS
	to_chat(src, span_danger("你感到极度困惑和迷失方向。"))
	var/atom/ai_structure = ai_mob_to_structure()
	ai_structure.balloon_alert(user, "已断开神经网络连接")
	return ITEM_INTERACT_SUCCESS

/mob/living/silicon/ai/attack_effects(damage_done, hit_zone, armor_block, obj/item/attacking_item, mob/living/attacker)
	if(damage_done > 0 && attacking_item.damtype != STAMINA && stat != DEAD)
		spark_system.start()
		. = TRUE
	return ..() || .
