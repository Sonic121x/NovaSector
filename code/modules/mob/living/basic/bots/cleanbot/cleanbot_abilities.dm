// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
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
		bot_owner.balloon_alert(bot_owner, LANG("datum.f108efd46ba8f5f8", null))
	return FALSE

/datum/action/cooldown/mob_cooldown/bot/foam
	name = "Foam"
	desc = "Spread foam all around you!"
	button_icon = 'icons/effects/effects.dmi'
	button_icon_state = "mfoam"
	cooldown_time = 20 SECONDS
	click_to_activate = FALSE
	///range of the foam to spread
	var/foam_range = 2

/datum/action/cooldown/mob_cooldown/bot/foam/Activate(mob/living/firer, atom/target)
	owner.visible_message(span_danger(LANG("datum.731d2b093df8228b", list(owner))))
	do_foam(foam_range, owner, owner.loc)
	StartCooldown()
	return TRUE
