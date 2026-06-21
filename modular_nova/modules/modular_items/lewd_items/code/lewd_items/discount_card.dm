//Debug item, but plz leave it alone. It's unobtainable and could be used by me for some events. Or as reward from some weird god, who knows.
/obj/item/lustwish_discount
	name = "LustWish精英卡"
	desc = "一张背面印有蓝色拉弥亚的奇怪卡片。" //yes, this is card with my character on the back. Cameo.
	icon_state = "lustwish_discount"
	inhand_icon_state = null
	icon = 'modular_nova/modules/modular_items/lewd_items/icons/obj/lewd_items/lewd_items.dmi'
	w_class = WEIGHT_CLASS_TINY

//code for showing that we have something IlLeGaL
/obj/item/lustwish_discount/attack_self(mob/user, modifiers)
	. = ..()
	to_chat(loc, span_notice("[user]展示了一张lustwish精英卡！"))
