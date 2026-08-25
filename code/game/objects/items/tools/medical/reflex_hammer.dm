// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/reflexhammer
	name = "reflex hammer"
	desc = "A small plastic headed hammer, used to test for neurological damage."
	icon = 'icons/obj/weapons/hammer.dmi'
	icon_state = "reflex_hammer"
	icon_angle = -135
	force = 1
	throwforce = 1
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*0.75, /datum/material/plastic=SMALL_MATERIAL_AMOUNT*0.5)
	w_class = WEIGHT_CLASS_TINY
	attack_verb_continuous = list("tests", "jerks", "bonks", "taps")
	attack_verb_simple = list("test", "jerk", "bonk", "tap")

/obj/item/reflexhammer/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/kneejerk)

/obj/item/reflexhammer/suicide_act(mob/living/user)
	user.visible_message(span_suicide(LANG("obj.da5988d93270f5c9", list(user, user.p_them(), src, user.p_theyre()))))
	playsound(loc, 'sound/items/gavel.ogg', 50, TRUE, -1)
	return STAMINALOSS | SHAME
