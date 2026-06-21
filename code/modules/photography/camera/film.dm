/*
 * Film
 */
/obj/item/camera_film
	name = "胶卷盒"
	icon = 'icons/obj/art/camera.dmi'
	desc = "一个胶卷盒。将其放入相机中以更换使用过的胶卷。"
	icon_state = "film"
	inhand_icon_state = "electropack"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*0.1, /datum/material/glass = SMALL_MATERIAL_AMOUNT*0.1)
