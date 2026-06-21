/// Pop out into the realm of the living.
/mob/living/basic/guardian/proc/manifest(forced)
	if (is_deployed() || isnull(summoner) || isnull(summoner.loc) || istype(summoner.loc, /obj/effect) || (!COOLDOWN_FINISHED(src, manifest_cooldown) && !forced) || locked)
		return FALSE
	forceMove(summoner.loc)
	new /obj/effect/temp_visual/guardian/phase(loc)
	COOLDOWN_START(src, manifest_cooldown, 1 SECONDS)
	reset_perspective()
	manifest_effects()
	return TRUE

/// Go and hide inside your boss.
/mob/living/basic/guardian/proc/recall(forced)
	if (!is_deployed() || isnull(summoner) || (!COOLDOWN_FINISHED(src, manifest_cooldown) && !forced) || locked)
		return FALSE
	new /obj/effect/temp_visual/guardian/phase/out(loc)
	recall_effects()
	forceMove(summoner)
	COOLDOWN_START(src, manifest_cooldown, 1 SECONDS)
	return TRUE

/// Do something when we appear.
/mob/living/basic/guardian/proc/manifest_effects()
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_GUARDIAN_MANIFESTED)

/// Do something when we vanish.
/mob/living/basic/guardian/proc/recall_effects()
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_GUARDIAN_RECALLED)

/// Swap to a different mode... if we have one
/mob/living/basic/guardian/proc/toggle_modes()
	to_chat(src, span_bolddanger("You don't have another mode!"))


/// Turn an internal light on or off.
/mob/living/basic/guardian/proc/toggle_light()
	if (!light_on)
		to_chat(src, span_notice("You activate your light."))
		set_light_on(TRUE)
	else
		to_chat(src, span_notice("You deactivate your light."))
		set_light_on(FALSE)

/// Speak with our boss at a distance
/mob/living/basic/guardian/proc/communicate()
	if (isnull(summoner))
		return
	var/sender_key = key
	var/input = tgui_input_text(src, "输入一条消息告诉你的召唤者", "守护者", max_length = MAX_MESSAGE_LEN)
	if (sender_key != key || !input) //guardian got reset, or did not enter anything
		return

	var/preliminary_message = span_boldholoparasite("[input]") //apply basic color/bolding
	var/my_message = "<font color=\"[guardian_colour]\">[span_bolditalic(src.name)]：</font> [preliminary_message]" //add source, color source with the guardian's color

	to_chat(summoner, "[my_message]")
	var/list/guardians = summoner.get_all_linked_holoparasites()
	for(var/guardian in guardians)
		to_chat(guardian, "[my_message]")
	for(var/dead_mob in GLOB.dead_mob_list)
		var/link = FOLLOW_LINK(dead_mob, src)
		to_chat(dead_mob, "[link] [my_message]")

	src.log_talk(input, LOG_SAY, tag="guardian")


/// Speak with your guardian(s) at a distance.
/datum/action/cooldown/mob_cooldown/guardian_comms
	name = "守护者通讯"
	desc = "与你的守护者进行心灵感应交流。"
	button_icon = 'icons/hud/guardian.dmi'
	button_icon_state = "communicate"
	background_icon = 'icons/hud/guardian.dmi'
	background_icon_state = "base"
	check_flags = NONE
	click_to_activate = FALSE
	cooldown_time = 0 SECONDS
	melee_cooldown_time = 0
	shared_cooldown = NONE

/datum/action/cooldown/mob_cooldown/guardian_comms/Activate(atom/target)
	StartCooldown(360 SECONDS)
	var/input = tgui_input_text(owner, "输入一条消息告诉你的守护者", "消息", max_length = MAX_MESSAGE_LEN)
	StartCooldown()
	if (!input)
		return FALSE

	var/preliminary_message = span_boldholoparasite("[input]") //apply basic color/bolding
	var/my_message = span_boldholoparasite("<i>[owner]:</i> [preliminary_message]") //add source, color source with default grey...

	to_chat(owner, "[my_message]")
	var/mob/living/living_owner = owner
	var/list/guardians = living_owner.get_all_linked_holoparasites()
	for(var/mob/living/basic/guardian/guardian as anything in guardians)
		to_chat(guardian, "<font color=\"[guardian.guardian_colour]\">[span_bolditalic(owner.real_name)]:</font> [preliminary_message]" )
	for(var/dead_mob in GLOB.dead_mob_list)
		var/link = FOLLOW_LINK(dead_mob, owner)
		to_chat(dead_mob, "[link] [my_message]")
	owner.log_talk(input, LOG_SAY, tag="guardian")

	return TRUE


/// Tell your slacking or distracted guardian to come home.
/datum/action/cooldown/mob_cooldown/recall_guardian
	name = "召回守护者"
	desc = "强制召回你的守护者。"
	button_icon = 'icons/hud/guardian.dmi'
	button_icon_state = "recall"
	background_icon = 'icons/hud/guardian.dmi'
	background_icon_state = "base"
	check_flags = NONE
	click_to_activate = FALSE
	cooldown_time = 0 SECONDS
	melee_cooldown_time = 0
	shared_cooldown = NONE

/datum/action/cooldown/mob_cooldown/recall_guardian/Activate(atom/target)
	var/mob/living/living_owner = owner
	var/list/guardians = living_owner.get_all_linked_holoparasites()
	for(var/mob/living/basic/guardian/guardian in guardians)
		guardian.recall()
	StartCooldown()
	return TRUE

/// Replace an annoying griefer you were paired up to with a different but probably no less annoying player.
/datum/action/cooldown/mob_cooldown/replace_guardian
	name = "重置守护者意识"
	desc = "用另一个幽灵的意识替换你守护者的意识。"
	button_icon = 'icons/mob/simple/mob.dmi'
	button_icon_state = "ghost"
	background_icon = 'icons/hud/guardian.dmi'
	background_icon_state = "base"
	check_flags = NONE
	click_to_activate = FALSE
	cooldown_time = 5 SECONDS
	melee_cooldown_time = 0
	shared_cooldown = NONE

/datum/action/cooldown/mob_cooldown/replace_guardian/Activate(atom/target)
	StartCooldown(5 MINUTES)

	var/mob/living/living_owner = owner
	var/list/guardians = living_owner.get_all_linked_holoparasites()
	for(var/mob/living/basic/guardian/resetting_guardian as anything in guardians)
		if (!COOLDOWN_FINISHED(resetting_guardian, resetting_cooldown))
			guardians -= resetting_guardian //clear out guardians that are already reset

	if (!length(guardians))
		to_chat(owner, span_holoparasite("你还不能重置[length(guardians) > 1 ? "any of your guardians":"your guardian"]。"))
		StartCooldown()
		return FALSE

	var/mob/living/basic/guardian/chosen_guardian = tgui_input_list(owner, "选择你想要重置的守护者", "守护者重置", sort_names(guardians))
	if (isnull(chosen_guardian))
		to_chat(owner, span_holoparasite("你决定不重置[length(guardians) > 1 ? "any of your guardians":"your guardian"]。"))
		StartCooldown()
		return FALSE

	to_chat(owner, span_holoparasite("你试图重置<font color=\"[chosen_guardian.guardian_colour]\">[span_bold(chosen_guardian.real_name)]</font>的人格..."))
	var/mob/chosen_one = SSpolling.poll_ghost_candidates("你想扮演[span_danger("[owner.real_name]'s")] [span_notice(chosen_guardian.theme.name)]吗？", check_jobban = ROLE_PAI, poll_time = 10 SECONDS, alert_pic = chosen_guardian, jump_target = owner, role_name_text = chosen_guardian.theme.name, amount_to_pick = 1)
	if(isnull(chosen_one))
		to_chat(owner, span_holoparasite("Your attempt to reset the personality of \
			<font color=\"[chosen_guardian.guardian_colour]\">[span_bold(chosen_guardian.real_name)]</font> appears to have failed... \
			Looks like you're stuck with it for now."))
		StartCooldown()
		return FALSE
	to_chat(chosen_guardian, span_holoparasite("你的使用者重置了你，你的身体被一个幽灵接管了。看来他们对你的表现不太满意。"))
	to_chat(owner, span_boldholoparasite("<font color=\"[chosen_guardian.guardian_colour]\">[chosen_guardian.theme.name]</font>的人格已被成功重置。"))
	message_admins("[key_name_admin(chosen_one)] has taken control of ([ADMIN_LOOKUPFLW(chosen_guardian)])")
	chosen_guardian.ghostize(FALSE)
	chosen_guardian.PossessByPlayer(chosen_one.key)
	COOLDOWN_START(chosen_guardian, resetting_cooldown, 5 MINUTES)
	chosen_guardian.guardian_rename() //give it a new color and name, to show it's a new person
	chosen_guardian.guardian_recolour()
	StartCooldown()
	return TRUE
