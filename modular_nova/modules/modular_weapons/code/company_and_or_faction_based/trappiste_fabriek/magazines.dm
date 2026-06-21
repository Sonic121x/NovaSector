// .585 pistol magazines

/obj/item/ammo_box/magazine/c585trappiste_pistol
	name = "\improper 特拉皮斯特手枪弹匣"
	desc = "特拉皮斯特手枪的标准尺寸弹匣，可容纳十发子弹。"

	icon = 'modular_nova/modules/modular_weapons/icons/obj/company_and_or_faction_based/trappiste_fabriek/ammo.dmi'
	icon_state = "pistol_585_standard"

	multiple_sprites = AMMO_BOX_FULL_EMPTY

	w_class = WEIGHT_CLASS_SMALL

	ammo_type = /obj/item/ammo_casing/c585trappiste
	caliber = CALIBER_585TRAPPISTE
	max_ammo = 10

/obj/item/ammo_box/magazine/c585trappiste_pistol/spawns_empty
	start_empty = TRUE
