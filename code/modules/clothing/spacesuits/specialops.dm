/obj/item/clothing/head/helmet/space/beret
	name = "\improper CentCom officer's beret"
	desc = "一种常用于特种作战的军官贝雷帽，它采用了先进的立场防护技术。能够保护头部免受太空环境伤害。"
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/helmet/space/beret"
	post_init_icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	inhand_icon_state = null
	greyscale_colors = "#397F3F#FFCE5B"
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL | SNUG_FIT
	flags_inv = /obj/item/clothing/head/beret::flags_inv
	flags_cover = /obj/item/clothing/head/beret::flags_cover
	armor_type = /datum/armor/space_beret
	strip_delay = 13 SECONDS
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | ACID_PROOF
	fishing_modifier = 0
	hair_mask = /datum/hair_mask/standard_hat_middle
	visor_dirt = null

/datum/armor/space_beret
	melee = 80
	bullet = 80
	laser = 50
	energy = 60
	bomb = 100
	bio = 100
	fire = 100
	acid = 100
	wound = 15

/obj/item/clothing/suit/space/officer
	name = "\improper CentCom officer's coat"
	desc = "一种特种作战中使用的防弹衣"
	icon_state = "centcom_coat"
	icon = 'icons/obj/clothing/suits/jacket.dmi'
	worn_icon = 'icons/mob/clothing/suits/jacket.dmi'
	inhand_icon_state = "centcom"
	blood_overlay_type = "coat"
	slowdown = 0
	flags_inv = 0
	w_class = WEIGHT_CLASS_NORMAL
	allowed = list(/obj/item/gun, /obj/item/melee/baton, /obj/item/restraints/handcuffs, /obj/item/tank/internals)
	armor_type = /datum/armor/space_officer
	strip_delay = 13 SECONDS
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | ACID_PROOF
	fishing_modifier = 0

/datum/armor/space_officer
	melee = 80
	bullet = 80
	laser = 50
	energy = 60
	bomb = 100
	bio = 100
	fire = 100
	acid = 100
	wound = 15
