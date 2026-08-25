// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/mob/living/blood_worm_host
	name = "Host"
	desc = "...how are you examining this? THIS THING ISN'T EVEN EMBODIED."

	var/datum/action/changeling_expel_worm/expel_worm_action

/mob/living/blood_worm_host/Login()
	. = ..()
	if (!.)
		return

	if (IS_CHANGELING(src))
		to_chat(src, span_good(LANG("mob.3c0f4dc1a740d899", null)))

		if (!expel_worm_action)
			expel_worm_action = new(src)
			expel_worm_action.Grant(src)
