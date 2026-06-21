/// The common cardboard box.
/obj/item/storage/box
	name = "箱子"
	desc = "这只是一个普通的箱子。"
	icon = 'icons/obj/storage/box.dmi'
	icon_state = "box"
	inhand_icon_state = "syringe_kit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	resistance_flags = FLAMMABLE
	drop_sound = 'sound/items/handling/cardboard_box/cardboardbox_drop.ogg'
	pickup_sound = 'sound/items/handling/cardboard_box/cardboardbox_pickup.ogg'
	storage_type = /datum/storage/box

	/// What material do we get when we fold this box?
	var/foldable_result = /obj/item/stack/sheet/cardboard
	/// What drawing will we get on the face of the box?
	var/illustration = "writing"

/obj/item/storage/box/Initialize(mapload)
	. = ..()
	if(foldable_result == /obj/item/stack/sheet/cardboard)
		set_custom_materials(list(/datum/material/cardboard = SHEET_MATERIAL_AMOUNT))
	update_appearance()

/obj/item/storage/box/suicide_act(mob/living/carbon/user)
	var/obj/item/bodypart/head/myhead = user.get_bodypart(BODY_ZONE_HEAD)
	if(myhead)
		user.visible_message(span_suicide("[user] 把 [user.p_their()] 头伸进 \the [src] 并开始关上它！看起来 [user.p_theyre()] 想要自杀！"))
		if (myhead.dismember())
			myhead.forceMove(src) //force your enemies to kill themselves with your head collection box!
		playsound(user, "desecration-01.ogg", 50, TRUE, -1)
		return BRUTELOSS
	user.visible_message(span_suicide("[user] 正在用 \the [user.p_them()] 殴打 [src] 自己！看起来 [user.p_theyre()] 想要自杀！"))
	return BRUTELOSS

/obj/item/storage/box/update_overlays()
	. = ..()
	if(illustration)
		. += illustration

/obj/item/storage/box/attack_self(mob/user)
	..()

	if(!foldable_result || (flags_1 & HOLOGRAM_1))
		return
	if(contents.len)
		balloon_alert(user, "里面有物品！")
		return
	if(!ispath(foldable_result))
		return

	var/obj/item/result = new foldable_result(user.drop_location())
	balloon_alert(user, "已折叠")
	qdel(src)
	user.put_in_hands(result)
