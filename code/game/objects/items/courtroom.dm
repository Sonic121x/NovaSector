// Contains:
// Gavel
// Sound Block

/obj/item/gavelhammer
	name = "gavel"
	desc = "肃静，肃静！我的法庭里不准有炸弹。"
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
	user.visible_message(span_suicide("[user]用[src]判处[user.p_them()]自己死刑！看起来[user.p_theyre()]试图自杀！"))
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

/obj/item/gavelblock/attackby(obj/item/I, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(I, /obj/item/gavelhammer))
		playsound(loc, 'sound/items/gavel.ogg', 100, TRUE)
		user.visible_message(span_warning("[user]用[I]敲击[src]。"))
		user.changeNext_move(CLICK_CD_MELEE)
	else
		return ..()
