/**
 * Sets a directive to be given to all future spiders created by the user.
 * This will be overwritten if used again.
 */
/datum/action/cooldown/mob_cooldown/set_spider_directive
	name = "设定指令"
	desc = "为你未来的子嗣设定一条需要遵循的指令。"
	button_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = "directive"
	background_icon_state = "bg_alien"
	overlay_icon_state = "bg_alien_border"
	check_flags = AB_CHECK_CONSCIOUS
	cooldown_time = 0
	melee_cooldown_time = 0
	shared_cooldown = NONE
	click_to_activate = FALSE
	/// Current directive to apply
	var/current_directive = ""

/datum/action/cooldown/mob_cooldown/set_spider_directive/Activate(atom/target)
	var/new_directive = tgui_input_text(owner, "输入新的指令", "创建指令", "[current_directive]", max_length = MAX_MESSAGE_LEN)
	if(isnull(new_directive) || QDELETED(src) || QDELETED(owner) || !IsAvailable(feedback = TRUE))
		return

	current_directive = new_directive
	message_admins("[ADMIN_LOOKUPFLW(owner)] set its directive to: '[current_directive]'.")
	owner.log_message("set its directive to: '[current_directive]'.", LOG_GAME)
	StartCooldown()

/**
 * Sends a message to all currently living spiders.
 */
/datum/action/cooldown/mob_cooldown/command_spiders
	name = "指挥"
	desc = "向所有存活的蜘蛛发送一条命令。"
	button_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = "command"
	background_icon_state = "bg_alien"
	overlay_icon_state = "bg_alien_border"
	check_flags = AB_CHECK_CONSCIOUS
	cooldown_time = 0
	melee_cooldown_time = 0
	shared_cooldown = NONE
	click_to_activate = FALSE

/datum/action/cooldown/mob_cooldown/command_spiders/Activate(trigger_flags)
	var/input = tgui_input_text(owner, "为你的军团输入一条要遵循的命令。", "命令", max_length = MAX_MESSAGE_LEN)
	if(!input || QDELETED(src) || QDELETED(owner) || !IsAvailable(feedback = TRUE))
		return
	spider_command(owner, input)
	StartCooldown()

/**
 * Sends a big message to all spiders from the target.
 *
 * Allows the user to send a message to all spiders that exist.  Ghosts will also see the message.
 * Arguments:
 * * user - The spider sending the message
 * * message - The message to be sent
 */
/datum/action/cooldown/mob_cooldown/command_spiders/proc/spider_command(mob/living/user, message)
	var/my_message = format_message(user,message)
	for(var/mob/living/basic/spider as anything in GLOB.spidermobs)
		to_chat(spider, my_message)
	for(var/ghost in GLOB.dead_mob_list)
		var/link = FOLLOW_LINK(ghost, user)
		to_chat(ghost, "[link] [my_message]")
	user.log_talk(message, LOG_SAY, tag = "spider command")

/**
 * Formats the string to have an appropiate size and text color
 */
/datum/action/cooldown/mob_cooldown/command_spiders/proc/format_message(mob/living/user, message)
	return span_spiderbroodmother("<b>来自[user]的命令：</b> [message]")

/**
 * Sends a small message to all currently living spiders.
 */
/datum/action/cooldown/mob_cooldown/command_spiders/communication_spiders
	name = "通讯"
	desc = "向所有存活的蜘蛛发送一份报告。"
	button_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = "message"

/datum/action/cooldown/mob_cooldown/command_spiders/communication_spiders/format_message(mob/living/user, message)
	return span_spiderscout("<b>来自[user]的报告：</b> [message]")

/**
 * Sends a smaller message to all currently living spiders.
 */
/datum/action/cooldown/mob_cooldown/command_spiders/warning_spiders
	name = "警告"
	desc = "向所有存活的蜘蛛发送一条警告。"
	button_icon = 'icons/mob/actions/actions_animal.dmi'
	button_icon_state = "warning"

/datum/action/cooldown/mob_cooldown/command_spiders/warning_spiders/format_message(mob/living/user, message)
	return span_spiderbreacher("<b>来自[user]的警告：</b> [message]")

