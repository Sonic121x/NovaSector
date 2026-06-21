/obj/item/ammo_box/magazine/m12g/empty
	name = "霰弹枪弹匣 (12号口径)"
	icon_state = "m12gb-0"
	start_empty = TRUE
	ammo_type = /obj/item/ammo_casing/shotgun

/obj/item/ammo_box/magazine/katyusha/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[LAZYLEN(stored_ammo) ? "full" : "empty"]"

/obj/item/ammo_box/magazine/katyusha/empty
	icon_state = "spikewall_mag-empty"
	start_empty = TRUE

/obj/item/ammo_box/magazine/katyusha
	name = "\improper 喀秋莎弹鼓"
	desc = "一个适用于卡秋莎战斗霰弹枪的霰弹鼓式弹匣。"
	icon = 'modular_nova/modules/modular_weapons/icons/obj/company_and_or_faction_based/nanotrasen_armories/magazines.dmi'
	icon_state = "spikewall_mag"
	base_icon_state = "spikewall_mag"
	ammo_type = /obj/item/ammo_casing/shotgun
	caliber = CALIBER_SHOTGUN
	max_ammo = 10
	casing_phrasing = "shell"
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_box/magazine/katyusha/buckshot
	icon = 'modular_nova/modules/modular_weapons/icons/obj/company_and_or_faction_based/nanotrasen_armories/magazines.dmi'
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot

/obj/item/ammo_box/magazine/jager/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]-[LAZYLEN(stored_ammo) ? "full" : "empty"]"

/obj/item/ammo_box/magazine/jager/empty
	start_empty = TRUE

/obj/item/ammo_box/magazine/jager
	name = "\improper 猎手弹匣"
	desc = "一个霰弹枪弹匣，适用于'Jäger'战斗霰弹枪。"
	icon = 'modular_nova/modules/modular_weapons/icons/obj/company_and_or_faction_based/nanotrasen_armories/magazines.dmi'
	icon_state = "jager_mag"
	base_icon_state = "jager_mag"
	ammo_type = /obj/item/ammo_casing/shotgun
	caliber = CALIBER_SHOTGUN
	max_ammo = 4

/obj/item/ammo_box/magazine/jager/rubbershot
	ammo_type = /obj/item/ammo_casing/shotgun/rubbershot

/obj/item/ammo_box/magazine/jager/large
	name = "大型猎手弹匣"
	desc = "A magazine of shotgun shells, suitable for the 'Jager' combat shotgun."
	icon_state = "jager_mag_large"
	base_icon_state = "jager_mag_large"
	max_ammo = 7

/obj/item/ammo_box/magazine/jager/large/empty
	start_empty = TRUE

/obj/item/ammo_box/magazine/shitzu/empty
	start_empty = TRUE

/obj/item/ammo_box/magazine/shitzu
	name = "\improper 石津牌霰弹枪弹匣"
	desc = "A magazine of shotgun shells, suitable for the 'Shitzu' combat shotgun."
	icon = 'modular_nova/modules/modular_weapons/icons/obj/company_and_or_faction_based/syndicate_armaments/magazines.dmi'
	icon_state = "shitzu_mag"
	base_icon_state = "shitzu_mag"
	ammo_type = /obj/item/ammo_casing/shotgun
	caliber = CALIBER_SHOTGUN
	max_ammo = 10
	casing_phrasing = "shell"
	multiple_sprites = AMMO_BOX_FULL_EMPTY

/obj/item/ammo_box/magazine/shitzu/milspec
	ammo_type = /obj/item/ammo_casing/shotgun/milspec

/obj/item/ammo_box/magazine/shitzu/milspec_buckshot
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot/milspec
