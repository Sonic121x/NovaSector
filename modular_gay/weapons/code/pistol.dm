obj/item/gun/ballistic/automatic/pistol/makeshift
	name = "generic makeshift gun"
	desc = "complain when seeing this"
	icon = 'modular_gay/weapons/icon/gunz.dmi'
	icon_state = "cpistol"
	worn_icon = 'modular_gay/weapons/icon/worn.dmi'
	worn_icon_state = "pistol"
	lefthand_file = 'modular_gay/weapons/icon/lefthand.dmi'
	righthand_file = 'modular_gay/weapons/icon/righthand.dmi'
	can_suppress = FALSE
	tac_reloads = TRUE
	wound_bonus = 0
	force = 10
	slot_flags = ITEM_SLOT_SUITSTORE | ITEM_SLOT_BELT

/obj/item/gun/ballistic/automatic/pistol/makeshift/C96
	name = "\improper makeshift C96 pistol"
	desc = "一把仿制的C96手枪, 发射九毫米口径弹药."
	icon_state = "cpistol"
	inhand_icon_state = "cpistol"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/makeshift/C96
	rack_sound = 'modular_gay/sound/weapons/gunsounds/44/magnumeject.ogg' //placeholder
	bolt_drop_sound = 'modular_gay/sound/weapons/gunsounds/44/magnumeject.ogg' //placeholder
	load_sound = 'modular_gay/sound/weapons/gunsounds/chinese/cpistolload2.ogg'
	load_empty_sound = 'modular_gay/sound/weapons/gunsounds/chinese/cpistolload2.ogg'
	eject_sound = 'modular_gay/sound/weapons/gunsounds/chinese/cpistoleject.ogg' //placeholder - these aren't very good
	eject_empty_sound = 'modular_gay/sound/weapons/gunsounds/chinese/cpistoleject.ogg' //placeholder - these aren't very good
	fire_sound = 'modular_gay/sound/weapons/gunsounds/chinese/chinese1.ogg'
	fire_delay = 0.5 SECONDS
	internal_magazine = TRUE

/obj/item/ammo_box/magazine/internal/makeshift/C96
	name = "C96 internal magazine"
	ammo_type = /obj/item/ammo_casing/makeshift/c9mm
	caliber = "9mm"
	max_ammo = 10

/obj/item/ammo_box/speedloader/makeshift
	name = "generic makeshift clip"
	desc = "A five-round stripper clip for makeshift guns."
	icon = 'modular_gay/ammo/icon/ammo.dmi'

/obj/item/ammo_box/speedloader/makeshift/C96
	name = "stripper clip (9mm)"
	desc = "A five-round stripper clip for M1916 pistol."
	icon_state = "cpistol"
	ammo_type = /obj/item/ammo_casing/makeshift/c9mm
	max_ammo = 5
	ammo_box_multiload = AMMO_BOX_MULTILOAD_ALL
	caliber = "9mm"

/datum/crafting_bench_recipe/C96
	recipe_name = "stripper clip (9mm)"
	recipe_requirements = list(
		/obj/item/stack/sheet/iron = 2,
	)
	resulting_item = /obj/item/ammo_box/speedloader/makeshift/C96
	required_good_hits = 10

/obj/item/gun/ballistic/automatic/pistol/makeshift/silent
	name = "\improper makeshift ruger.22 pistol"
	desc = "一把仿制的鲁格手枪, 发射.22口径弹药."
	icon_state = "22pistol"
	inhand_icon_state = "22pistol"
	spawnwithmagazine = FALSE
	accepted_magazine_type = /obj/item/ammo_box/magazine/makeshift/c22p
	rack_sound = 'modular_gay/sound/weapons/gunsounds/9mm/9mm_rack2.ogg'
	bolt_drop_sound = 'modular_gay/sound/weapons/gunsounds/9mm/9mmrack.ogg'
	load_sound = 'modular_gay/sound/weapons/gunsounds/9mm/9mm_in2.ogg' //placeholder
	load_empty_sound = 'modular_gay/sound/weapons/gunsounds/9mm/9mm_in2.ogg' //placeholder
	eject_sound = 'modular_gay/sound/weapons/gunsounds/9mm/9mm_out2.ogg' //placeholder
	eject_empty_sound = 'modular_gay/sound/weapons/gunsounds/9mm/9mm_out2.ogg' //placeholder
	fire_sound = 'modular_gay/sound/weapons/gunsounds/22/22pistol.ogg'
	fire_delay = 0.45 SECONDS
	spread = 8
	recoil = 0.1
