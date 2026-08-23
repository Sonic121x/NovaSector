// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// Turns the user into a sliding puzzle
/datum/smite/puzzle
	name = "Puzzle"

/datum/smite/puzzle/effect(client/user, mob/living/target)
	. = ..()
	if(!puzzle_imprison(target))
		to_chat(user, span_warning(LANG("datum.526aa4cfd4ce4708", null)), confidential = TRUE)
