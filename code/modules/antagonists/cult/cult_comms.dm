// Contains cult communion, guide, and cult master abilities

/datum/action/innate/cult
	button_icon = 'icons/mob/actions/actions_cult.dmi'
	background_icon_state = "bg_demon"
	overlay_icon_state = "bg_demon_border"

	buttontooltipstyle = "cult"
	check_flags = AB_CHECK_INCAPACITATED|AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_CONSCIOUS
	ranged_mousepointer = 'icons/effects/mouse_pointers/cult_target.dmi'

/datum/action/innate/cult/IsAvailable(feedback = FALSE)
	if(!IS_CULTIST(owner))
		return FALSE
	return ..()

/datum/action/innate/cult/comm
	name = "通讯"
	desc = "所有血教徒都能听到的低语<br><b>警告:</b>所有附近的非血教徒依然能听到你"
	button_icon_state = "cult_comms"
	// Unholy words dont require hands or mobility
	check_flags = AB_CHECK_INCAPACITATED|AB_CHECK_CONSCIOUS

/datum/action/innate/cult/comm/IsAvailable(feedback = FALSE)
	if(isshade(owner) && IS_CULTIST(owner))
		return TRUE
	return ..()

/datum/action/innate/cult/comm/Activate()
	var/input = tgui_input_text(usr, "要告诉其他信徒的消息", "血之音", max_length = MAX_MESSAGE_LEN)
	if(!input || !IsAvailable(feedback = TRUE))
		return

	var/list/filter_result = CAN_BYPASS_FILTER(usr) ? null : is_ic_filtered(input)
	if(filter_result)
		REPORT_CHAT_FILTER_TO_USER(usr, filter_result)
		return

	var/list/soft_filter_result = CAN_BYPASS_FILTER(usr) ? null : is_soft_ic_filtered(input)
	if(soft_filter_result)
		if(tgui_alert(usr,"你的消息包含\"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\"。\"[soft_filter_result[CHAT_FILTER_INDEX_REASON]]\"，你确定要发送吗？", "软屏蔽词", list("Yes", "No")) != "Yes")
			return
		message_admins("[ADMIN_LOOKUPFLW(usr)] has passed the soft filter for \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\" they may be using a disallowed term. Message: \"[html_encode(input)]\"")
		log_admin_private("[key_name(usr)] has passed the soft filter for \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\" they may be using a disallowed term. Message: \"[input]\"")
	cultist_commune(usr, input)

/datum/action/innate/cult/comm/proc/cultist_commune(mob/living/user, message)
	var/my_message
	if(!message || !user.mind)
		return
	user.whisper("O bidai nabora se[pick("'","`")]sma!", language = /datum/language/common, forced = "cult invocation")
	user.whisper(html_decode(message), filterproof = TRUE)
	var/title = "Acolyte"
	var/span = "cult italic"
	var/datum/antagonist/cult/cult_datum = user.mind.has_antag_datum(/datum/antagonist/cult)
	if(cult_datum.is_cult_leader())
		span = "cult_large"
		title = "Master"
	else if(!ishuman(user))
		title = "Construct"
	my_message = "<span class='[span]'><b>[title] [findtextEx(user.name, user.real_name) ? user.name : "[user.real_name] (as [user.name])"]:</b> [message]</span>"
	for(var/mob/listener as anything in GLOB.player_list)
		if(IS_CULTIST(listener))
			to_chat(listener, my_message, type = MESSAGE_TYPE_RADIO, avoid_highlighting = listener == user)
		else if(listener in GLOB.dead_mob_list)
			var/link = FOLLOW_LINK(listener, user)
			to_chat(listener, "[link] [my_message]", type = MESSAGE_TYPE_RADIO)

	user.log_talk(message, LOG_SAY, tag="cult")

/datum/action/innate/cult/comm/spirit
	name = "精神交流"
	desc = "从灵界中传达一条所有血教徒都能听到的圣音"

/datum/action/innate/cult/comm/spirit/IsAvailable(feedback = FALSE)
	if(IS_CULTIST(owner.mind.current))
		return TRUE
	return ..()

/datum/action/innate/cult/comm/spirit/cultist_commune(mob/living/user, message)
	var/my_message
	if(!message)
		return
	my_message = span_cult_bold_italic("\The [user]：[message]")
	for(var/mob/player_list as anything in GLOB.player_list)
		if(IS_CULTIST(player_list))
			to_chat(player_list, my_message)
		else if(player_list in GLOB.dead_mob_list)
			var/link = FOLLOW_LINK(player_list, user)
			to_chat(player_list, "[link] [my_message]")

/datum/action/innate/cult/master/IsAvailable(feedback = FALSE)
	if(!owner.mind || GLOB.cult_narsie)
		return FALSE
	var/datum/antagonist/cult/cult_datum = owner.mind.has_antag_datum(/datum/antagonist/cult)
	if(!cult_datum.is_cult_leader())
		return FALSE
	return ..()

/datum/action/innate/cult/master/pass_role
	name = "传递衣钵"
	desc = "将教主身份传递给另一位自愿的教徒。这只能进行一次！"
	button_icon_state = "cultvote"
	check_flags = AB_CHECK_INCAPACITATED|AB_CHECK_CONSCIOUS|AB_CHECK_HANDS_BLOCKED

/datum/action/innate/cult/master/pass_role/IsAvailable(feedback = FALSE)
	. = ..()
	if (!.)
		return
	var/datum/antagonist/cult/mind_cult_datum = owner.mind.has_antag_datum(/datum/antagonist/cult)
	if(!mind_cult_datum || mind_cult_datum.cult_team.leader_passed_on)
		return FALSE

/datum/action/innate/cult/master/pass_role/Activate()
	var/list/choices = list()
	var/datum/antagonist/cult/owner_datum = owner.mind.has_antag_datum(/datum/antagonist/cult)
	for(var/datum/mind/team_member as anything in owner_datum.cult_team.members)
		if(!team_member.current || !ishuman(team_member.current) || team_member.current == owner || team_member.current.stat == DEAD)
			continue

		choices[team_member.current.real_name] = team_member

	var/new_master = tgui_input_list(owner, "选择另一位教徒来传递教会的教主身份。", "传递衣钵", choices)
	if (!new_master || !IsAvailable())
		return

	var/confirmation = tgui_alert(owner, "你确定要让[new_master]成为新教主吗？这只能进行一次！", "传递衣钵", list("Yes", "No"))
	if (confirmation != "Yes" || !IsAvailable())
		return

	var/datum/mind/master_mind = choices[new_master]
	var/mob/living/carbon/human/master = master_mind.current
	if (!master || master.stat == DEAD || !master.client)
		to_chat(owner, span_cult("[new_master] 无法再担任大师的角色。"))
		return

	var/datum/antagonist/cult/target_datum = master_mind.has_antag_datum(/datum/antagonist/cult)
	if(!target_datum || owner_datum.cult_team != target_datum?.cult_team)
		to_chat(owner, span_cult("[new_master] 无法再担任大师的角色。"))
		return

	SEND_SOUND(master, sound('sound/effects/magic.ogg', volume = 33))
	confirmation = tgui_alert(master, "[owner.real_name] 正在向你提供他们作为邪教大师的角色！你愿意接受吗？", "接过衣钵", list("Yes", "No"))

	if (confirmation != "Yes")
		to_chat(owner, span_cult("[new_master] 拒绝了你的提议。"))
		return

	if (!IsAvailable() || !master_mind.has_antag_datum(/datum/antagonist/cult) || !master.client)
		to_chat(owner, span_cult("[new_master] 无法再担任大师的角色。"))
		return

	target_datum.cult_team.leader_passed_on = TRUE
	owner_datum.demote_from_leader()
	target_datum.make_cult_leader()

/datum/action/innate/cult/master/finalreck
	name = "最后清算"
	desc = "将所有血教徒及构体都传送到身边的一次性法术"
	button_icon_state = "sintouch"

/datum/action/innate/cult/master/finalreck/Activate()
	var/datum/antagonist/cult/antag = owner.mind.has_antag_datum(/datum/antagonist/cult,TRUE)
	if(!antag)
		return
	var/place = get_area(owner)
	var/datum/objective/eldergod/summon_objective = locate() in antag.cult_team.objectives
	if(place in summon_objective.summon_spots)//cant do final reckoning in the summon area to prevent abuse, you'll need to get everyone to stand on the circle!
		to_chat(owner, span_cult_large("此地的帷幕太薄弱了！移动到足以支撑此魔法的区域。"))
		return
	for(var/i in 1 to 4)
		chant(i)
		var/list/destinations = list()
		for(var/turf/T in orange(1, owner))
			if(!T.is_blocked_turf(TRUE))
				destinations += T
		if(!LAZYLEN(destinations))
			to_chat(owner, span_warning("你需要更多空间来召唤你的邪教！"))
			return
		if(do_after(owner, 3 SECONDS, target = owner))
			for(var/datum/mind/B in antag.cult_team.members)
				if(B.current && B.current.stat != DEAD)
					var/turf/mobloc = get_turf(B.current)
					switch(i)
						if(1)
							new /obj/effect/temp_visual/cult/sparks(mobloc, B.current.dir)
							playsound(mobloc, SFX_SPARKS, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
						if(2)
							new /obj/effect/temp_visual/dir_setting/cult/phase/out(mobloc, B.current.dir)
							playsound(mobloc, SFX_PORTAL_ENTER, 75, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
						if(3)
							new /obj/effect/temp_visual/dir_setting/cult/phase(mobloc, B.current.dir)
							playsound(mobloc, SFX_PORTAL_ENTER, 100, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
						if(4)
							playsound(mobloc, 'sound/effects/magic/exit_blood.ogg', 100, TRUE)
							if(B.current != owner)
								var/turf/final = pick(destinations)
								if(istype(B.current.loc, /obj/item/soulstone))
									var/obj/item/soulstone/S = B.current.loc
									S.release_shades(owner)
								B.current.setDir(SOUTH)
								new /obj/effect/temp_visual/cult/blood(final)
								addtimer(CALLBACK(B.current, TYPE_PROC_REF(/mob/, reckon), final), 1 SECONDS)
		else
			return
	antag.cult_team.reckoning_complete = TRUE
	Remove(owner)

/mob/proc/reckon(turf/final)
	new /obj/effect/temp_visual/cult/blood/out(get_turf(src))
	forceMove(final)

/datum/action/innate/cult/master/finalreck/proc/chant(chant_number)
	switch(chant_number)
		if(1)
			owner.say("C'arta forbici!", language = /datum/language/common, forced = "cult invocation")
		if(2)
			owner.say("Pleggh e'ntrath!", language = /datum/language/common, forced = "cult invocation")
			playsound(get_turf(owner),'sound/effects/magic/clockwork/narsie_attack.ogg', 50, TRUE)
		if(3)
			owner.say("Barhah hra zar'garis!", language = /datum/language/common, forced = "cult invocation")
			playsound(get_turf(owner),'sound/effects/magic/clockwork/narsie_attack.ogg', 75, TRUE)
		if(4)
			owner.say("N'ath reth sh'yro eth d'rekkathnor!!!", language = /datum/language/common, forced = "cult invocation")
			playsound(get_turf(owner),'sound/effects/magic/clockwork/narsie_attack.ogg', 100, TRUE)

/datum/action/innate/cult/master/cultmark
	name = "标记目标"
	desc = "为血教标记一个目标"
	button_icon_state = "cult_mark"
	click_action = TRUE
	enable_text = span_cult("你准备为你的邪教标记一个目标。<b>点击一个目标来标记他们！</b>")
	disable_text = span_cult("你停止了标记仪式。")
	/// The duration of the mark itself
	var/cult_mark_duration = 90 SECONDS
	/// The duration of the cooldown for cult marks
	var/cult_mark_cooldown_duration = 2 MINUTES
	/// The actual cooldown tracked of the action
	COOLDOWN_DECLARE(cult_mark_cooldown)

/datum/action/innate/cult/master/cultmark/IsAvailable(feedback = FALSE)
	return ..() && COOLDOWN_FINISHED(src, cult_mark_cooldown)

/datum/action/innate/cult/master/cultmark/InterceptClickOn(mob/clicker, params, atom/clicked_on)
	var/turf/clicker_turf = get_turf(clicker)
	if(!isturf(clicker_turf))
		return FALSE

	if(!(clicked_on in view(7, clicker_turf)))
		return FALSE

	return ..()

/datum/action/innate/cult/master/cultmark/do_ability(mob/living/clicker, atom/clicked_on)
	var/datum/antagonist/cult/cultist = clicker.mind.has_antag_datum(/datum/antagonist/cult, TRUE)
	if(!cultist)
		CRASH("[type] was casted by someone without a cult antag datum.")

	var/datum/team/cult/cult_team = cultist.get_team()
	if(!cult_team)
		CRASH("[type] was casted by a cultist without a cult team datum.")

	if(cult_team.blood_target)
		to_chat(clicker, span_cult("邪教已经指定了一个目标！"))
		return FALSE

	if(cult_team.set_blood_target(clicked_on, clicker, cult_mark_duration))
		unset_ranged_ability(clicker, span_cult("标记仪式完成！它将持续 [DisplayTimeText(cult_mark_duration)] 秒。"))
		COOLDOWN_START(src, cult_mark_cooldown, cult_mark_cooldown_duration)
		build_all_button_icons()
		addtimer(CALLBACK(src, PROC_REF(build_all_button_icons)), cult_mark_cooldown_duration + 1)
		return TRUE

	unset_ranged_ability(clicker, span_cult("标记仪式失败了！"))
	return TRUE

/datum/action/innate/cult/ghostmark //Ghost version
	name = "血迹你的目标"
	desc = "为整个血教标记你在环绕的东西"
	button_icon_state = "cult_mark"
	check_flags = NONE
	/// The duration of the mark on the target
	var/cult_mark_duration = 60 SECONDS
	/// The cooldown between marks - the ability can be used in between cooldowns, but can't mark (only clear)
	var/cult_mark_cooldown_duration = 60 SECONDS
	/// The actual cooldown tracked of the action
	COOLDOWN_DECLARE(cult_mark_cooldown)

/datum/action/innate/cult/ghostmark/IsAvailable(feedback = FALSE)
	return ..() && isobserver(owner)

/datum/action/innate/cult/ghostmark/Activate()
	var/datum/antagonist/cult/cultist = owner.mind?.has_antag_datum(/datum/antagonist/cult, TRUE)
	if(!cultist)
		CRASH("[type] was casted by someone without a cult antag datum.")

	var/datum/team/cult/cult_team = cultist.get_team()
	if(!cult_team)
		CRASH("[type] was casted by a cultist without a cult team datum.")

	if(cult_team.blood_target)
		if(!COOLDOWN_FINISHED(src, cult_mark_cooldown))
			cult_team.unset_blood_target_and_timer()
			to_chat(owner, span_cult_bold("你已清除了邪教的鲜血目标！"))
			return TRUE

		to_chat(owner, span_cult_bold("邪教已经指定了一个目标！"))
		return FALSE

	if(!COOLDOWN_FINISHED(src, cult_mark_cooldown))
		to_chat(owner, span_cult_bold("你还没准备好放置另一个鲜血标记！"))
		return FALSE

	var/atom/mark_target = owner.orbiting?.parent || get_turf(owner)
	if(!mark_target)
		return FALSE

	if(cult_team.set_blood_target(mark_target, owner, 60 SECONDS))
		to_chat(owner, span_cult_bold("你已为邪教标记了[mark_target]！它将持续[DisplayTimeText(cult_mark_duration)]。"))
		COOLDOWN_START(src, cult_mark_cooldown, cult_mark_cooldown_duration)
		build_all_button_icons(UPDATE_BUTTON_NAME|UPDATE_BUTTON_ICON)
		addtimer(CALLBACK(src, PROC_REF(reset_button)), cult_mark_cooldown_duration + 1)
		return TRUE

	to_chat(owner, span_cult("标记失败了！"))
	return FALSE

/datum/action/innate/cult/ghostmark/update_button_name(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	if(COOLDOWN_FINISHED(src, cult_mark_duration))
		name = initial(name)
		desc = initial(desc)
	else
		name = "清除血迹"
		desc = "移除你先前血迹的目标"

	return ..()

/datum/action/innate/cult/ghostmark/apply_button_icon(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	if(COOLDOWN_FINISHED(src, cult_mark_duration))
		button_icon_state = initial(button_icon_state)
	else
		button_icon_state = "emp"

	return ..()

/datum/action/innate/cult/ghostmark/proc/reset_button()
	if(QDELETED(owner) || QDELETED(src))
		return

	SEND_SOUND(owner, 'sound/effects/magic/enter_blood.ogg')
	to_chat(owner, span_cult_bold("你之前的标记已消失——你现在可以创建一个新的鲜血标记了。"))
	build_all_button_icons(UPDATE_BUTTON_NAME|UPDATE_BUTTON_ICON)

//////// ELDRITCH PULSE /////////

/datum/action/innate/cult/master/pulse
	name = "异畏脉冲"
	desc = "抓取一个血教徒或者构体并将其传送到附近的位置"
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "arcane_barrage"
	click_action = TRUE
	enable_text = span_cult("你准备撕裂现实的帷幕……<b>点击一个目标来抓住他们！</b>")
	disable_text = span_cult("你停止了准备。")
	/// Weakref to whoever we're currently about to toss
	var/datum/weakref/throwee_ref
	/// Cooldown of the ability
	var/pulse_cooldown_duration = 15 SECONDS
	/// The actual cooldown tracked of the action
	COOLDOWN_DECLARE(pulse_cooldown)

/datum/action/innate/cult/master/pulse/IsAvailable(feedback = FALSE)
	return ..() && COOLDOWN_FINISHED(src, pulse_cooldown)

/datum/action/innate/cult/master/pulse/InterceptClickOn(mob/living/clicker, params, atom/clicked_on)
	var/turf/clicker_turf = get_turf(clicker)
	if(!isturf(clicker_turf))
		return FALSE

	if(!(clicked_on in view(7, clicker_turf)))
		return FALSE

	if(clicked_on == clicker)
		return FALSE

	return ..()

/datum/action/innate/cult/master/pulse/do_ability(mob/living/clicker, atom/clicked_on)
	var/atom/throwee = throwee_ref?.resolve()
	if(throwee && QDELING(throwee))
		to_chat(clicker, span_cult("你丢失了目标！"))
		throwee = null
		throwee_ref = null
		return FALSE

	if(throwee)
		if(get_dist(throwee, clicked_on) >= 16)
			to_chat(clicker, span_cult("你无法将[clicked_on.p_them()]传送那么远！"))
			return FALSE

		var/turf/throwee_turf = get_turf(throwee)

		playsound(throwee_turf, 'sound/effects/magic/exit_blood.ogg', 50)
		new /obj/effect/temp_visual/cult/sparks(throwee_turf, clicker.dir)
		throwee.visible_message(
			span_warning("一股魔法脉冲将[throwee]卷走了！"),
			span_cult("一股血魔法脉冲将你卷走……"),
		)

		if(!do_teleport(throwee, clicked_on, channel = TELEPORT_CHANNEL_CULT))
			to_chat(clicker, span_cult("传送失败了！"))
			throwee.visible_message(
				span_warning("……只不过他们没走多远"),
				span_cult("……只不过你似乎没移动多远。"),
			)
			return FALSE

		throwee_turf.Beam(clicked_on, icon_state = "sendbeam", time = 0.4 SECONDS)
		new /obj/effect/temp_visual/cult/sparks(get_turf(clicked_on), clicker.dir)
		throwee.visible_message(
			span_warning("[throwee] 突然出现在一股魔法脉冲中！"),
			span_cult("……而你出现在了别处。"),
		)

		COOLDOWN_START(src, pulse_cooldown, pulse_cooldown_duration)
		to_chat(clicker, span_cult("一股血魔法脉冲涌过你全身，你将[throwee]在时空中转移。"))
		clicker.click_intercept = null
		throwee_ref = null
		build_all_button_icons()
		addtimer(CALLBACK(src, PROC_REF(build_all_button_icons)), pulse_cooldown_duration + 1)

		return TRUE

	if(isliving(clicked_on))
		var/mob/living/living_clicked = clicked_on
		if(!IS_CULTIST(living_clicked))
			return FALSE
		SEND_SOUND(clicker, sound('sound/items/weapons/thudswoosh.ogg'))
		to_chat(clicker, span_cult_bold("你用心灵之眼穿透帷幕，抓住了[clicked_on]！<b>点击附近任意位置来传送[clicked_on.p_them()]！</b>"))
		throwee_ref = WEAKREF(clicked_on)
		return TRUE

	if(istype(clicked_on, /obj/structure/destructible/cult))
		to_chat(clicker, span_cult_bold("你用心灵之眼穿透帷幕，抬起了[clicked_on]！<b>点击附近任意位置来传送它！</b>"))
		throwee_ref = WEAKREF(clicked_on)
		return TRUE
	return FALSE
