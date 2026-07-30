// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// Ties the target's shoes
/datum/smite/knot_shoes
	name = "Knot Shoes"

/datum/smite/knot_shoes/effect(client/user, mob/living/target)
	. = ..()
	if (!ishuman(target))
		to_chat(user, span_warning(LANG("datum.bcb0ef0b", null)), confidential = TRUE)
		return
	var/mob/living/carbon/human/dude = target
	var/obj/item/clothing/shoes/sick_kicks = dude.shoes
	if (!istype(sick_kicks) || sick_kicks.fastening_type == SHOES_SLIPON)
		to_chat(user, span_warning(LANG("datum.ea089fb6", list(dude))), confidential = TRUE)
		return
	sick_kicks.adjust_laces(SHOES_KNOTTED)
