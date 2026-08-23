// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// "Fully immerses" the player, making them manually breathe and blink
/datum/smite/immerse
	name = "Fully Immerse"

/datum/smite/immerse/effect(client/user, mob/living/target)
	. = ..()
	immerse_player(target)
	SEND_SOUND(target, sound('sound/misc/roleplay.ogg'))
	to_chat(target, span_boldnotice(LANG("datum.93cd467b59731534", null)))
