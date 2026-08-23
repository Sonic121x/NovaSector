// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/taster
	name = "taster"
	desc = "Tastes things, so you don't have to!"
	icon = 'icons/obj/medical/organs/organs.dmi'
	icon_state = "tongue"

	w_class = WEIGHT_CLASS_TINY

	var/taste_sensitivity = 15

/obj/item/taster/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!interacting_with.reagents)
		to_chat(user, span_notice(LANG("obj.fee6fe950b6c815e", list(src, interacting_with, interacting_with.p_they(), interacting_with.p_have()))))
	else if(interacting_with.reagents.total_volume == 0)
		to_chat(user, span_notice(LANG("obj.31ccd34eea4127ca", list(src, interacting_with, interacting_with.p_they(), interacting_with.p_are()))))
	else
		var/message = interacting_with.reagents.generate_taste_message(user, taste_sensitivity)
		to_chat(user, span_notice(LANG("obj.53fb6750b04ad6ae", list(src, message, interacting_with))))
	return user.combat_mode ? NONE : ITEM_INTERACT_SUCCESS
