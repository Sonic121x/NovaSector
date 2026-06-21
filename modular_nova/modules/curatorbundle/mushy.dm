/obj/item/clothing/head/mush_helmet
	name = "蘑菇帽"
	desc = "一顶蘑菇帽，这个还可以当雨伞用！"
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/head/costume.dmi'
	worn_icon_state = "mush_cap"
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/mush_helmet"
	post_init_icon_state = "mush_cap"
	greyscale_config = /datum/greyscale_config/mushcap
	greyscale_config_worn = /datum/greyscale_config/mushcap/worn
	greyscale_colors = "#eb0c07"
	flags_cover = HEADCOVERSEYES
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	flags_1 = IS_PLAYER_COLORABLE_1


/datum/atom_skin/mushroom_suit
	abstract_type = /datum/atom_skin/mushroom_suit

/datum/atom_skin/mushroom_suit/male
	preview_name = "Male Mush"
	new_icon_state = "mush_male"

/datum/atom_skin/mushroom_suit/female
	preview_name = "Female Mush"
	new_icon_state = "mush_female"

/obj/item/clothing/suit/mush
	name = "蘑菇套装"
	desc = "一件蘑菇套装，偶尔能看到那些更具真菌气质的人穿着它。"
	icon = 'modular_nova/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suit.dmi'
	icon_state = "mush_male"
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	slowdown = 1
	clothing_flags = THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS

/obj/item/clothing/suit/mush/setup_reskins()
	AddComponent(/datum/component/reskinable_item, /datum/atom_skin/mushroom_suit)

/obj/item/storage/box/hero/mushperson
	name = "蘑菇人穆希 - 2305"
	desc = "你还记得吗？"

/obj/item/storage/box/hero/mushperson/PopulateContents()
	new /obj/item/clothing/suit/mush(src)
	new /obj/item/clothing/head/mush_helmet(src)
	new /obj/item/mushpunch(src)
