// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
// Contains:
// Gavel
// Sound Block

/obj/item/gavelhammer
	name = "gavel"
	desc = "Order, order! No bombs in my courthouse."
	icon = 'icons/obj/weapons/hammer.dmi'
	icon_state = "gavelhammer"
	icon_angle = -135
	force = 5
	throwforce = 6
	w_class = WEIGHT_CLASS_SMALL
	attack_verb_continuous = list("bashes", "batters", "judges", "whacks")
	attack_verb_simple = list("bash", "batter", "judge", "whack")
	resistance_flags = FLAMMABLE
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 2)

/obj/item/gavelhammer/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/kneejerk)

/obj/item/gavelhammer/suicide_act(mob/living/user)
	user.visible_message(span_suicide(LANG("obj.394cd9d265af51ef", list(user, user.p_them(), src, user.p_theyre()))))
	playsound(loc, 'sound/items/gavel.ogg', 50, TRUE, -1)
	return BRUTELOSS

/obj/item/gavelblock
	name = "sound block"
	desc = "Smack it with a gavel when the assistants get rowdy."
	icon = 'icons/obj/weapons/hammer.dmi'
	icon_state = "gavelblock"
	force = 2
	throwforce = 2
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT)

/obj/item/gavelblock/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/gavelhammer))
		return NONE
	playsound(loc, 'sound/items/gavel.ogg', 100, TRUE)
	user.visible_message(span_warning(LANG("obj.42c638b658c7d275", list(user, src, tool))))
	user.changeNext_move(CLICK_CD_MELEE)
	return ITEM_INTERACT_SUCCESS
