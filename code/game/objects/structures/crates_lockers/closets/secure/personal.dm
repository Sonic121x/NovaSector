/obj/structure/closet/secure_closet/personal
	desc = "这是一个供人员使用的安全储物柜。第一个刷卡的人将获得控制权。"
	name = "个人储物柜"
	req_access = list(ACCESS_ALL_PERSONAL_LOCKERS)
	card_reader_installed = TRUE

/obj/structure/closet/secure_closet/personal/Initialize(mapload)
	. = ..()
	var/static/list/choices
	if(isnull(choices))
		choices = list("Personal")
	access_choices = choices

/obj/structure/closet/secure_closet/personal/can_unlock(mob/living/user, obj/item/card/id/player_id, obj/item/card/id/registered_id)
	if(isnull(registered_id)) //first time anyone can unlock
		return TRUE
	else
		if(allowed(user)) //players with ACCESS_ALL_PERSONAL_LOCKERS can override your ID
			return TRUE
		return player_id == registered_id

/obj/structure/closet/secure_closet/personal/PopulateContents()
	..()
	if(prob(50))
		new /obj/item/storage/backpack/duffelbag(src)
	if(prob(50))
		new /obj/item/storage/backpack(src)
	else
		new /obj/item/storage/backpack/satchel(src)
	new /obj/item/radio/headset( src )

/obj/structure/closet/secure_closet/personal/patient
	name = "病患储物柜"

/obj/structure/closet/secure_closet/personal/patient/PopulateContents()
	new /obj/item/clothing/under/color/white( src )
	new /obj/item/clothing/shoes/sneakers/white( src )

/obj/structure/closet/secure_closet/personal/cabinet
	icon_state = "cabinet"
	resistance_flags = FLAMMABLE
	max_integrity = 70
	open_sound = 'sound/machines/closet/wooden_closet_open.ogg'
	close_sound = 'sound/machines/closet/wooden_closet_close.ogg'
	open_sound_volume = 25
	close_sound_volume = 50
	door_anim_time = 0 // no animation
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 2)
	material_drop = /obj/item/stack/sheet/mineral/wood

/obj/structure/closet/secure_closet/personal/cabinet/PopulateContents()
	new /obj/item/storage/backpack/satchel/leather/withwallet( src )
	new /obj/item/instrument/piano_synth(src)
	new /obj/item/radio/headset( src )
