// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// Makes the target's blood a beautiful rainbow
/datum/smite/clownify_blood
	name = "Clownify blood"

/datum/smite/clownify_blood/effect(client/user, mob/living/target)
	. = ..()

	if (!iscarbon(target))
		to_chat(user, span_warning(LANG("datum.0c41c4cf", null)), confidential = TRUE)
		return

	var/mob/living/carbon/carbon_target = target
	carbon_target.set_blood_type(/datum/blood_type/clown)
	SEND_SOUND(carbon_target, 'sound/items/bikehorn.ogg')
