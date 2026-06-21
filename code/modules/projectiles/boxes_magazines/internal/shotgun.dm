/obj/item/ammo_box/magazine/internal/shot
	name = "霰弹枪内置弹匣"
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	caliber = CALIBER_SHOTGUN
	max_ammo = 4
	// this inherits regular magazines' AMMO_BOX_MULTILOAD_IN, which means that regular shotguns shouldn't be multiloading from Bulldog magazines
	// if someone has the bright idea to add shotgun speedloaders, i certainly hope they know what they're inviting by doing so

/obj/item/ammo_box/magazine/internal/shot/tube
	name = "双管霰弹枪内管"
	ammo_type = /obj/item/ammo_casing/shotgun/rubbershot
	max_ammo = 4

/obj/item/ammo_box/magazine/internal/shot/tube/fire
	ammo_type = /obj/item/ammo_casing/shotgun/incendiary/no_trail

/obj/item/ammo_box/magazine/internal/shot/tube/buckshot
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot

/obj/item/ammo_box/magazine/internal/shot/tube/slug
	ammo_type = /obj/item/ammo_casing/shotgun

/obj/item/ammo_box/magazine/internal/shot/lethal
	ammo_type = /obj/item/ammo_casing/shotgun/buckshot

/obj/item/ammo_box/magazine/internal/shot/com
	name = "战斗霰弹枪内置弹匣"
	ammo_type = /obj/item/ammo_casing/shotgun/rubbershot
	max_ammo = 6

/obj/item/ammo_box/magazine/internal/shot/com/compact
	name = "紧凑型霰弹枪内置弹匣"
	max_ammo = 5

/obj/item/ammo_box/magazine/internal/shot/dual
	name = "双管猎枪内置弹匣"
	max_ammo = 2

/obj/item/ammo_box/magazine/internal/shot/dual/slugs
	name = "双管霰弹枪内置弹仓（独头弹）"
	ammo_type = /obj/item/ammo_casing/shotgun

/obj/item/ammo_box/magazine/internal/shot/dual/breacherslug
	name = "双管霰弹枪内置弹匣（破门弹）"
	ammo_type = /obj/item/ammo_casing/shotgun/breacher

/obj/item/ammo_box/magazine/internal/shot/riot
	name = "镇暴霰弹枪内置弹匣"
	ammo_type = /obj/item/ammo_casing/shotgun/rubbershot
	max_ammo = 6

/obj/item/ammo_box/magazine/internal/shot/lake
	name = "pump-action grenade launcher internal magazine"
	ammo_type = /obj/item/ammo_casing/a40mm
	caliber = CALIBER_40MM
	max_ammo = 3

/obj/item/ammo_box/magazine/internal/shot/bounty
	name = "三管猎枪内置弹匣"
	ammo_type = /obj/item/ammo_casing/shotgun/incapacitate
	max_ammo = 3

/obj/item/ammo_box/magazine/internal/shot/single
	name = "单管霰弹枪内置弹匣"
	max_ammo = 1

/obj/item/ammo_box/magazine/internal/shot/single/musket
	name = "\improper 咚克公司火枪内置弹匣"
	ammo_type = /obj/item/ammo_casing/shotgun/flechette/donk
