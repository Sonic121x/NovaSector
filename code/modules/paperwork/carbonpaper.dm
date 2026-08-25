// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/paper/carbon
	name = "sheet of carbon"
	icon_state = "paper_stack"
	inhand_icon_state = "paper"
	show_written_words = FALSE
	var/copied = FALSE

/obj/item/paper/carbon/update_icon_state()
	if(copied)
		icon_state = "paper"
	else
		icon_state = "paper_stack"
	if(get_total_length())
		icon_state = "[icon_state]_words"
	return ..()

/obj/item/paper/carbon/examine()
	. = ..()
	if(copied)
		return
	. += span_notice(LANG("obj.95e694c0d8820dd1", null))

/obj/item/paper/carbon/click_alt(mob/living/user)
	if(!copied)
		to_chat(user, span_notice(LANG("obj.8a2f510d914589c4", null)))
		return CLICK_ACTION_BLOCKING
	return CLICK_ACTION_SUCCESS

/obj/item/paper/carbon/proc/removecopy(mob/living/user)
	if(copied)
		to_chat(user, span_notice(LANG("obj.144491516937f7e1", null)))
		return

	var/obj/item/paper/carbon/copy = copy(/obj/item/paper/carbon_copy, loc.drop_location(), FALSE)
	copy.name = "\improper Copy - [name]"
	to_chat(user, span_notice(LANG("obj.6bdf2704039b35e6", null)))
	copied = TRUE
	update_icon_state()
	user.put_in_hands(copy)

/obj/item/paper/carbon/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	if(loc == user && user.is_holding(src))
		removecopy(user)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/paper/carbon_copy
	icon_state = "cpaper"
