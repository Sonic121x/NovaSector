/obj/item/clothing/under/rank/security/corrections_officer
	desc = "一件白色缎面衬衫，领口处有一些青铜色军衔徽章。"
	name = "惩教官员的西装"
	icon = 'modular_nova/master_files/icons/obj/clothing/under/security.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/under/security.dmi'
	icon_state = "corrections_officer"
	armor_type = /datum/armor/clothing_under/security_corrections_officer
	can_adjust = FALSE
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE

/datum/armor/clothing_under/security_corrections_officer
	melee = 10

/obj/item/clothing/under/rank/security/corrections_officer/skirt
	desc = "一件白色缎面衬衫，领口处有一些青铜色军衔徽章。"
	name = "惩教官员的裙子"
	icon_state = "corrections_officerw"
	gets_cropped_on_taurs = FALSE

/obj/item/clothing/under/rank/security/corrections_officer/sweater
	desc = "一件黑色作战毛衣套在标准配发的衬衫外面，非常适合执行叫醒服务。"
	name = "惩教官员的毛衣"
	icon_state = "corrections_officer_sweat"
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/security/corrections_officer/sweater/skirt
	icon_state = "corrections_officer_sweatw"
	gets_cropped_on_taurs = FALSE

/obj/item/radio/headset/corrections_officer
	name = "\proper 惩教官员的耳机"
	icon_state = "sec_headset"
	keyslot = new /obj/item/encryptionkey/headset_sec

/obj/item/clothing/suit/toggle/jacket/nova/corrections_officer
	name = "惩教官员的西装外套"
	desc = "一件熨烫平整的西装外套，对刺击有轻度的防护。右胸有一些军衔徽章。"
	icon = 'modular_nova/master_files/icons/obj/clothing/suits.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suit.dmi'
	icon_state = "co_coat"
	body_parts_covered = CHEST|ARMS
	armor_type = /datum/armor/jacket_corrections_officer


// LOCKER

/datum/armor/jacket_corrections_officer
	melee = 10
	melee = 10

/obj/structure/closet/secure_closet/corrections_officer
	name = "惩教官员防暴装备"
	icon = 'modular_nova/master_files/icons/obj/closet.dmi'
	icon_state = "riot"
	door_anim_time = 0 //Somebody resprite or remove this 'riot' locker. It's evil.

/obj/structure/closet/secure_closet/corrections_officer/PopulateContents()
	..()
	new /obj/item/clothing/suit/armor/riot(src)
	new /obj/item/grenade/flashbang(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/restraints/handcuffs(src)
	new /obj/item/clothing/shoes/jackboots/sec(src)
	new /obj/item/clothing/head/helmet/toggleable/riot(src)
	new /obj/item/shield/riot(src)
	new /obj/item/clothing/under/rank/security/corrections_officer(src)
