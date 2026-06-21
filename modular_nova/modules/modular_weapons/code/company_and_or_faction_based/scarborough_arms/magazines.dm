/obj/item/ammo_box/magazine/enforcer
	name = "\improper 执法者弹匣 (10mm)"
	desc = "一把坚固手枪的坚固弹匣。"
	icon = 'modular_nova/modules/modular_weapons/icons/obj/company_and_or_faction_based/scarborough_arms/ammo.dmi'
	icon_state = "baypistol"
	base_icon_state = "baypistol"
	ammo_type = /obj/item/ammo_casing/c10mm
	caliber = CALIBER_10MM
	max_ammo = 12
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	multiple_sprite_use_base = TRUE
	ammo_band_icon = "+baypistol_band"
	ammo_band_color = null

/obj/item/ammo_box/magazine/enforcer/empty
	start_empty = TRUE

/obj/item/ammo_box/magazine/enforcer/rubber
	name = "\improper 执法者弹匣（10毫米橡胶弹）"
	ammo_type = /obj/item/ammo_casing/c10mm/rubber
	desc = parent_type::desc + "<br>装载橡胶弹，属于低致命性弹药，主要造成耐力伤害。";
	ammo_band_color = COLOR_AMMO_RUBBER

/obj/item/ammo_box/magazine/enforcer/ap
	name = "\improper 执法者弹匣 (10mm 穿甲弹)"
	MAGAZINE_TYPE_ARMORPIERCE
	ammo_type = /obj/item/ammo_casing/c10mm/ap

/obj/item/ammo_box/magazine/enforcer/hp
	name = "\improper 执法者弹匣 (10mm 空尖弹)"
	MAGAZINE_TYPE_HOLLOWPOINT
	ammo_type = /obj/item/ammo_casing/c10mm/hp

/obj/item/ammo_box/magazine/enforcer/fire
	name = "\improper 执法者弹匣（10毫米燃烧弹）"
	MAGAZINE_TYPE_INCENDIARY
	ammo_type = /obj/item/ammo_casing/c10mm/fire
