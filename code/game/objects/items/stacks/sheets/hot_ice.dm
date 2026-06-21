/obj/item/stack/sheet/hot_ice
	name = "热冰"
	icon_state = "hot-ice"
	inhand_icon_state = null
	singular_name = "hot ice piece"
	icon = 'icons/obj/stack_objects.dmi'
	mats_per_unit = list(/datum/material/hot_ice=SHEET_MATERIAL_AMOUNT)
	material_type = /datum/material/hot_ice
	merge_type = /obj/item/stack/sheet/hot_ice

/obj/item/stack/sheet/hot_ice/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] 开始舔舐 \the [src]！看起来 [user.p_theyre()] 想要自杀！"))
	return FIRELOSS//dont you kids know that stuff is toxic?
