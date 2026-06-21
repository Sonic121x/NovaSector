/obj/item/ammo_box/c9mm
	name = "弹药箱（9mm）"
	icon_state = "9mmbox"
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 30

/obj/item/ammo_box/c10mm
	name = "弹药箱（10mm）"
	icon_state = "10mmbox"
	ammo_type = /obj/item/ammo_casing/c10mm
	max_ammo = 20

/obj/item/ammo_box/c45
	name = "弹药箱（.45）"
	icon_state = "45box"
	ammo_type = /obj/item/ammo_casing/c45
	max_ammo = 20

/obj/item/ammo_box/a40mm
	name = "弹药箱（40 毫米榴弹）"
	icon_state = "40mm"
	ammo_type = /obj/item/ammo_casing/a40mm
	max_ammo = 4
	multiple_sprites = AMMO_BOX_PER_BULLET

/obj/item/ammo_box/a40mm/rubber
	name = "ammo box (40mm rubber puck)"
	ammo_type = /obj/item/ammo_casing/a40mm/rubber

/obj/item/ammo_box/a40mm/flak
	name = "ammo box (40mm titanium flak)"
	ammo_type = /obj/item/ammo_casing/a40mm/flak

/obj/item/ammo_box/a40mm/incendiary
	name = "ammo box (40mm incendiary grenade)"
	ammo_type = /obj/item/ammo_casing/a40mm/incendiary

/obj/item/ammo_box/a40mm/tear_gas
	name = "ammo box (40mm tear gas grenade)"
	ammo_type = /obj/item/ammo_casing/a40mm/tear_gas

/obj/item/ammo_box/rocket
	name = "火箭弹花束（84mm高爆弹）"
	icon_state = "rocketbundle"
	ammo_type = /obj/item/ammo_casing/rocket
	max_ammo = 3
	multiple_sprites = AMMO_BOX_PER_BULLET

/obj/item/ammo_box/rocket/can_load(mob/user)
	return FALSE

/obj/item/ammo_box/n762
	name = "弹药箱（7.62x38mmR）"
	icon_state = "10mmbox"
	ammo_type = /obj/item/ammo_casing/n762
	max_ammo = 14

/obj/item/ammo_box/foambox
	name = "弹药箱（泡沫飞镖）"
	icon = 'icons/obj/weapons/guns/toy.dmi'
	icon_state = "foambox"
	ammo_type = /obj/item/ammo_casing/foam_dart
	max_ammo = 40
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*5)

/obj/item/ammo_box/foambox/mini
	icon_state = "foambox_mini"
	max_ammo = 20
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*2.5)

/obj/item/ammo_box/foambox/riot
	icon_state = "foambox_riot"
	ammo_type = /obj/item/ammo_casing/foam_dart/riot
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*25)

/obj/item/ammo_box/foambox/riot/mini
	icon_state = "foambox_riot_mini"
	max_ammo = 20
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT*12.5)
