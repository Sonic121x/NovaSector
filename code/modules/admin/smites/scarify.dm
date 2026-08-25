// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// Gives the target fake scars
/datum/smite/scarify
	name = "Scarify"

/datum/smite/scarify/effect(client/user, mob/living/target)
	. = ..()
	if(!iscarbon(target))
		to_chat(user, span_warning(LANG("datum.0c41c4cfc5eec94d", null)), confidential = TRUE)
		return
	var/mob/living/carbon/dude = target
	dude.generate_fake_scars(rand(1, 4))
	to_chat(dude, span_warning(LANG("datum.c7eb6ecae2b819af", null)))
