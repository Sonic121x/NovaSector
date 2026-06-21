/obj/item/clothing/head/mod
	name = "模块服头盔"
	desc = "模块服专用头盔。"
	icon = 'icons/obj/clothing/modsuit/mod_clothing.dmi'
	icon_state = "standard-helmet"
	base_icon_state = "helmet"
	worn_icon = 'icons/mob/clothing/modsuit/mod_clothing.dmi'
	armor_type = /datum/armor/none
	body_parts_covered = HEAD
	heat_protection = HEAD
	cold_protection = HEAD

// Even without a hat stabilizer, hats can be worn - however, they'll fall off very easily
/obj/item/clothing/head/mod/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NO_SPEED_POTION, INNATE_TRAIT)
	AddComponent(/datum/component/hat_stabilizer, loose_hat = TRUE)

/obj/item/clothing/suit/mod
	name = "模块服胸板"
	desc = "模块服专用胸板。"
	icon = 'icons/obj/clothing/modsuit/mod_clothing.dmi'
	icon_state = "standard-chestplate"
	base_icon_state = "chestplate"
	worn_icon = 'icons/mob/clothing/modsuit/mod_clothing.dmi'
	blood_overlay_type = "armor"
	allowed = list(
		/obj/item/tank/internals,
		/obj/item/flashlight,
		/obj/item/tank/jetpack/captain,
	)
	armor_type = /datum/armor/none
	body_parts_covered = CHEST|GROIN
	heat_protection = CHEST|GROIN
	cold_protection = CHEST|GROIN
	drop_sound = null

/obj/item/clothing/suit/mod/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NO_SPEED_POTION, INNATE_TRAIT)

/obj/item/clothing/gloves/mod
	name = "模块服手套"
	desc = "模块服专用手套。"
	icon = 'icons/obj/clothing/modsuit/mod_clothing.dmi'
	icon_state = "standard-gauntlets"
	base_icon_state = "gauntlets"
	worn_icon = 'icons/mob/clothing/modsuit/mod_clothing.dmi'
	armor_type = /datum/armor/none
	body_parts_covered = HANDS|ARMS
	heat_protection = HANDS|ARMS
	cold_protection = HANDS|ARMS
	equip_sound = null
	pickup_sound = null
	drop_sound = null

/obj/item/clothing/gloves/mod/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NO_SPEED_POTION, INNATE_TRAIT)

/obj/item/clothing/shoes/mod
	name = "模块服靴"
	desc = "模块服专用靴。"
	icon = 'icons/obj/clothing/modsuit/mod_clothing.dmi'
	icon_state = "standard-boots"
	base_icon_state = "boots"
	worn_icon = 'icons/mob/clothing/modsuit/mod_clothing.dmi'
	armor_type = /datum/armor/none
	body_parts_covered = FEET|LEGS
	heat_protection = FEET|LEGS
	cold_protection = FEET|LEGS
	item_flags = IGNORE_DIGITIGRADE
	fastening_type = SHOES_SLIPON
	equip_sound = null

/obj/item/clothing/shoes/mod/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NO_SPEED_POTION, INNATE_TRAIT)

/obj/item/clothing/glasses/mod
	name = "MOD眼镜"
	desc = "一套用于MOD防护服的眼镜。"
	icon = 'icons/obj/clothing/modsuit/mod_clothing.dmi'
	icon_state = "standard-glasses"
	base_icon_state = "glasses"
	worn_icon = 'icons/mob/clothing/modsuit/mod_clothing.dmi'
	armor_type = /datum/armor/none
	equip_sound = null
	pickup_sound = null
	drop_sound = null

/obj/item/clothing/glasses/mod/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NO_SPEED_POTION, INNATE_TRAIT)

/obj/item/clothing/neck/mod
	name = "MOD领带"
	desc = "一条用于MOD防护服的领带。"
	icon = 'icons/obj/clothing/modsuit/mod_clothing.dmi'
	icon_state = "standard-tie"
	base_icon_state = "tie"
	worn_icon = 'icons/mob/clothing/modsuit/mod_clothing.dmi'
	armor_type = /datum/armor/none
	equip_sound = null
	pickup_sound = null
	drop_sound = null

/obj/item/clothing/neck/mod/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NO_SPEED_POTION, INNATE_TRAIT)
