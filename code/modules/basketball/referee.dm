/obj/item/clothing/mask/whistle/minigame
	name = "裁判哨"
	desc = "用于对球员吹罚犯规的裁判哨。"
	actions_types = list(/datum/action/innate/timeout)
	action_slots = ALL

// should be /datum/action/item_action but it doesn't support InterceptClickOn()
/datum/action/innate/timeout
	name = "吹罚犯规"
	desc = "将某人罚下场几秒钟。"
	button_icon = 'icons/obj/clothing/masks.dmi'
	button_icon_state = "whistle"
	click_action = TRUE
	enable_text = span_cult("你准备对某人吹罚犯规...")
	disable_text = span_cult("你判定这是一次误判...")
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
		clicker.balloon_alert(clicker, "在 [COOLDOWN_TIMELEFT(src, whistle_cooldown_minigame) *0.1] 秒内无法吹哨！")
		unset_ranged_ability(clicker)
		return FALSE

	return ..()

/datum/action/innate/timeout/do_ability(mob/living/clicker, mob/living/carbon/human/target)
	clicker.say("FOUL BY [target]!", forced = "whistle")
	playsound(clicker, 'sound/items/whistle/whistle.ogg', 30, FALSE, 4)

	new /obj/effect/timestop(get_turf(target), 0, 5 SECONDS, list(clicker), TRUE, TRUE)

	COOLDOWN_START(src, whistle_cooldown_minigame, 1 MINUTES)
	unset_ranged_ability(clicker)

	to_chat(target, span_bold("[clicker] 因你犯规而将你罚下场！"))
	to_chat(clicker, span_bold("你把[target]关禁闭了！"))
	return TRUE
