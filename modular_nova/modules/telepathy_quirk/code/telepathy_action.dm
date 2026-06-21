/datum/mutation/telepathy
	power_path = /datum/action/cooldown/spell/pointed/telepathy

/datum/action/cooldown/spell/pointed/telepathy
	name = "心灵感应通讯"
	desc = "<b>左键点击</b>：指向目标以向其投射一个想法。<b>右键点击</b>：向你的上一个想法目标投射（如果在范围内）。"
	button_icon = 'icons/mob/actions/actions_revenant.dmi'
	button_icon_state = "r_transmit"
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	antimagic_flags = MAGIC_RESISTANCE_MIND
	cooldown_time = 1 SECONDS
	cast_range = 7
	/// What's the last mob we point-targeted with this ability?
	var/datum/weakref/last_target_ref
	/// The message we send
	var/message
	/// Are we blocking casts?
	var/blocked = FALSE

/datum/action/cooldown/spell/pointed/telepathy/is_valid_target(atom/cast_on)
	. = ..()
	if (!.)
		return FALSE

	if (!isliving(cast_on))
		to_chat(owner, span_warning("无生命的物体听不到你的想法。"))
		owner.balloon_alert(owner, "不是有思想的物体！")
		return FALSE

	var/mob/living/living_target = cast_on
	if (living_target.stat == DEAD)
		to_chat(owner, span_warning("逝者共振的干扰噪音抑制了你与死者沟通的能力。"))
		owner.balloon_alert(owner, "无法向死者发送信息！")
		return FALSE

	if (get_dist(living_target, owner) > cast_range)
		owner.balloon_alert(owner, "太远了！")
		return FALSE

	return TRUE

/datum/action/cooldown/spell/pointed/telepathy/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST || blocked)
		return

	message = autopunct_bare(capitalize(tgui_input_text(owner, "你想对[cast_on]耳语什么？", "[src]", max_length = MAX_MESSAGE_LEN)))
	if(QDELETED(src) || QDELETED(owner) || QDELETED(cast_on) || !can_cast_spell())
		return . | SPELL_CANCEL_CAST

	if(get_dist(cast_on, owner) > cast_range)
		owner.balloon_alert(owner, "他们太远了！")
		return . | SPELL_CANCEL_CAST

	if(!message || length(message) == 0)
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/pointed/telepathy/Trigger(trigger_flags, atom/target)
	if (trigger_flags & TRIGGER_SECONDARY_ACTION)
		var/mob/living/last_target = last_target_ref?.resolve()

		if(isnull(last_target))
			last_target_ref = null
			owner.balloon_alert(owner, "上一个目标不可用！")
			return
		else if(get_dist(last_target, owner) > cast_range)
			owner.balloon_alert(owner, "[last_target]太远了！")
			return

		blocked = TRUE

		message = autopunct_bare(capitalize(tgui_input_text(owner, "你想对[last_target]耳语什么？", "[src]", null, max_length = MAX_MESSAGE_LEN, multiline = TRUE)))
		if(QDELETED(src) || QDELETED(owner) || QDELETED(last_target) || !can_cast_spell())
			blocked = FALSE
			return
		send_thought(owner, last_target, message)
		src.StartCooldown()
		blocked = FALSE
		return

	return ..()

/datum/action/cooldown/spell/pointed/telepathy/cast(mob/living/cast_on)
	. = ..()
	owner.visible_message(
		span_warning("[owner]的注意力锁定在了[cast_on]身上。"),
		ignored_mobs = owner,
	)
	send_thought(owner, cast_on, message)

/datum/action/cooldown/spell/pointed/telepathy/proc/send_thought(mob/living/caster, mob/living/target, message)
	log_directed_talk(caster, target, message, LOG_SAY, tag = "telepathy")

	last_target_ref = WEAKREF(target)

	to_chat(owner, span_boldnotice("你伸出手，向[target]传达：\"[span_purple(message)]\""))
	// flub a runechat chat message, do something with the language later
	if(owner.client?.prefs.read_preference(/datum/preference/toggle/enable_runechat))
		owner.create_chat_message(owner, owner.get_selected_language(), message, list("italics"))
	if(!target.can_block_magic(antimagic_flags, charge_cost = 0) && target.client && !(HAS_TRAIT(target, TRAIT_PSIONIC_DAMPENER))) //make sure we've got a client before we bother sending anything
		//different messaging if the target has the telepathy mutation themselves themselves
		if (ishuman(caster))
			var/mob/living/carbon/human/human_caster = caster
			var/datum/mutation/telepathy/tele_mut = human_caster.dna.get_mutation(/datum/mutation/telepathy)

			if (tele_mut)
				to_chat(target, span_boldnotice("一个心灵感应在你脑海中回响：\"[span_purple(message)]\""))
			else
				to_chat(target, span_boldnotice("[caster]的声音在你脑海中回响：\"[span_purple(message)]\""))

		if(target.client?.prefs.read_preference(/datum/preference/toggle/enable_runechat))
			target.create_chat_message(target, target.get_selected_language(), message, list("italics")) // it appears over them since they hear it in their head
	else
		owner.balloon_alert(owner, "有什么东西阻挡了你的思绪！")
		to_chat(owner, span_warning("你的思维遇到了无法逾越的阻力：这个想法被阻挡了！"))
		return

	// send to ghosts as well i guess
	for(var/mob/dead/ghost as anything in GLOB.dead_mob_list)
		if(!isobserver(ghost))
			continue

		var/from_link = FOLLOW_LINK(ghost, owner)
		var/from_mob_name = span_boldnotice("[owner]")
		var/to_link = FOLLOW_LINK(ghost, target)
		var/to_mob_name = span_name("[target]")

		to_chat(ghost, "[from_link] " + span_purple("<b>\[心灵感应\]</b> [from_mob_name] 传达，\"[message]\"") + "向 [to_mob_name] [to_link]")
