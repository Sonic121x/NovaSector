/obj/item/clothing/head/helmet/space/freedom
	name = "老鹰头盔"
	desc = "一款先进的、防太空环境的头盔。它似乎是仿照旧世界的鹰设计的。"
	icon = 'icons/obj/clothing/head/costume.dmi'
	worn_icon = 'icons/mob/clothing/head/costume.dmi'
	icon_state = "griffinhat"
	inhand_icon_state = null
	armor_type = /datum/armor/space_freedom
	strip_delay = 13 SECONDS
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = ACID_PROOF | FIRE_PROOF
	fishing_modifier = 0
	visor_dirt = null

/datum/armor/space_freedom
	melee = 20
	bullet = 40
	laser = 30
	energy = 40
	bomb = 100
	bio = 100
	fire = 80
	acid = 80

/obj/item/clothing/suit/space/freedom
	name = "鹰太空服"
	desc = "An advanced, light suit, fabricated from a mixture of synthetic feathers and space-resistant material. A gun holster appears to be integrated into the suit and the wings appear to be stuck in 'freedom' mode."
	icon_state = "freedom"
	inhand_icon_state = null
	allowed = list(/obj/item/gun, /obj/item/melee/baton, /obj/item/restraints/handcuffs, /obj/item/tank/internals)
	armor_type = /datum/armor/space_freedom
	strip_delay = 13 SECONDS
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = ACID_PROOF | FIRE_PROOF
	slowdown = 0
	fishing_modifier = 0
