
/datum/action/cooldown/spell/list_target/telepathy
	name = "Telepathy-心灵感应"
	desc = "用心灵感应向目标传递信息。"
	button_icon = 'icons/mob/actions/actions_revenant.dmi'
	button_icon_state = "r_transmit"

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	antimagic_flags = MAGIC_RESISTANCE_MIND

	choose_target_message = "Choose a target to whisper to."

	/// The message we send to the next person via telepathy.
	var/message
	/// The span surrounding the telepathy message
	var/telepathy_span = "notice"
	/// The bolded span surrounding the telepathy message
	var/bold_telepathy_span = "boldnotice"

/datum/action/cooldown/spell/list_target/telepathy/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	message = tgui_input_text(owner, "你想对[cast_on]耳语什么？", "[src]", max_length = MAX_MESSAGE_LEN)
	if(QDELETED(src) || QDELETED(owner) || QDELETED(cast_on) || !can_cast_spell())
		return . | SPELL_CANCEL_CAST

	if(get_dist(cast_on, owner) > target_radius)
		owner.balloon_alert(owner, "他们太远了！")
		return . | SPELL_CANCEL_CAST

	if(!message)
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/list_target/telepathy/cast(mob/living/cast_on)
	. = ..()
	log_directed_talk(owner, cast_on, message, LOG_SAY, name)

	var/formatted_message = "<span class='[telepathy_span]'>[message]</span>"

	var/failure_message_for_ghosts = ""

	to_chat(owner, "<span class='[bold_telepathy_span]'>你向[cast_on]传讯：</span> [formatted_message]")
	if(!cast_on.can_block_magic(antimagic_flags, charge_cost = 0) && !(HAS_TRAIT(cast_on, TRAIT_PSIONIC_DAMPENER))) // NOVA EDIT CHANGE - ORIGINAL: if(!cast_on.can_block_magic(antimagic_flags, charge_cost = 0)) //hear no evil
		cast_on.balloon_alert(cast_on, "你听到了一个声音")
		to_chat(cast_on, "<span class='[bold_telepathy_span]'>你脑海中响起一个声音...</span> [formatted_message]")
	else
		owner.balloon_alert(owner, "传输被阻挡！")
		to_chat(owner, span_warning("有什么东西阻挡了你的传讯！"))
		failure_message_for_ghosts = "<span class='[bold_telepathy_span]'> (blocked by antimagic)</span>"

	for(var/mob/dead/ghost as anything in GLOB.dead_mob_list)
		if(!isobserver(ghost))
			continue

		var/from_link = FOLLOW_LINK(ghost, owner)
		var/from_mob_name = "<span class='[bold_telepathy_span]'>[owner] [src]</span>"
		from_mob_name += failure_message_for_ghosts
		from_mob_name += "<span class='[bold_telepathy_span]'>:</span>"
		var/to_link = FOLLOW_LINK(ghost, cast_on)
		var/to_mob_name = span_name("[cast_on]")

		to_chat(ghost, "[from_link] [from_mob_name] [formatted_message] [to_link] [to_mob_name]")
