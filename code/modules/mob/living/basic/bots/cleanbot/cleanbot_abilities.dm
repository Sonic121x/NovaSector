/datum/action/cooldown/mob_cooldown/bot
	background_icon_state = "bg_tech_blue"
	overlay_icon_state = "bg_tech_blue_border"
	shared_cooldown = NONE
	melee_cooldown_time = 0 SECONDS

/datum/action/cooldown/mob_cooldown/bot/IsAvailable(feedback)
	. = ..()
	if(!.)
		return FALSE
	if(!isbot(owner))
		return TRUE
	var/mob/living/basic/bot/bot_owner = owner
	if((bot_owner.bot_mode_flags & BOT_MODE_ON))
		return TRUE
	if(feedback)
		bot_owner.balloon_alert(bot_owner, "电源关闭！")
	return FALSE

/datum/action/cooldown/mob_cooldown/bot/foam
	name = "泡沫"
	desc = "在你周围喷洒泡沫！"
	button_icon = 'icons/effects/effects.dmi'
	button_icon_state = "mfoam"
	cooldown_time = 20 SECONDS
	click_to_activate = FALSE
	///range of the foam to spread
	var/foam_range = 2

/datum/action/cooldown/mob_cooldown/bot/foam/Activate(mob/living/firer, atom/target)
	owner.visible_message(span_danger("[owner] 剧烈地旋转并冒泡，然后释放出一团泡沫！"))
	do_foam(foam_range, owner, owner.loc)
	StartCooldown()
	return TRUE
