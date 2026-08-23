// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// Strikes the target with a lightning bolt
/datum/smite/curse_of_babel
	name = "Curse of Babel"
	/// How long should the effect last
	var/duration

/datum/smite/curse_of_babel/configure(client/user)
	duration = tgui_input_number(user, LANG("datum.af1e8a1b4994941f", null), LANG("datum.eb531f1b93f9c2ba", null), 1, 60, -1, round_value = FALSE) MINUTES

/datum/smite/curse_of_babel/effect(client/user, mob/living/carbon/target)
	. = ..()
	if(!iscarbon(target))
		to_chat(user, span_warning(LANG("datum.0c41c4cfc5eec94d", null)), confidential = TRUE)
		return

	target.apply_status_effect(/datum/status_effect/tower_of_babel, duration)
	to_chat(target, span_userdanger(LANG("datum.ff2c8df0cc6e3daf", null)), confidential = TRUE)
