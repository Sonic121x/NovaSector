// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/clothing/mask/whistle/minigame
	name = "referee whistle"
	desc = "A referee whistle used to call fouls against players."
	actions_types = list(/datum/action/innate/timeout)
	action_slots = ALL

// should be /datum/action/item_action but it doesn't support InterceptClickOn()
/datum/action/innate/timeout
	name = "Call foul"
	desc = "Puts a person in a timeout for a few seconds."
	button_icon = 'icons/obj/clothing/masks.dmi'
	button_icon_state = "whistle"
	click_action = TRUE
	enable_text = span_cult("You prepare to call a foul on someone...")
	disable_text = span_cult("You decide it was a bad call...")
	COOLDOWN_DECLARE(whistle_cooldown_minigame)

/datum/action/innate/timeout/InterceptClickOn(mob/living/clicker, params, atom/clicked_on)
	var/turf/clicker_turf = get_turf(clicker)
	if(!isturf(clicker_turf))
		return FALSE

	if(!ishuman(clicked_on) || get_dist(clicker, clicked_on) > 7)
		return FALSE

	if(clicked_on == clicker) // can't call a foul on yourself
		return FALSE

	if(!COOLDOWN_FINISHED(src, whistle_cooldown_minigame))
		clicker.balloon_alert(clicker, LANG("datum.36ad20c0ac5546bd", list(COOLDOWN_TIMELEFT(src, whistle_cooldown_minigame) *0.1)))
		unset_ranged_ability(clicker)
		return FALSE

	return ..()

/datum/action/innate/timeout/do_ability(mob/living/clicker, mob/living/carbon/human/target)
	clicker.say(LANG("datum.756c16ff7c43b962", list(target)), forced = "whistle")
	playsound(clicker, 'sound/items/whistle/whistle.ogg', 30, FALSE, 4)

	new /obj/effect/timestop(get_turf(target), 0, 5 SECONDS, list(clicker), TRUE, TRUE)

	COOLDOWN_START(src, whistle_cooldown_minigame, 1 MINUTES)
	unset_ranged_ability(clicker)

	to_chat(target, span_bold(LANG("datum.73e69dad28189c16", list(clicker))))
	to_chat(clicker, span_bold(LANG("datum.1b2569ad93b889b4", list(target))))
	return TRUE
