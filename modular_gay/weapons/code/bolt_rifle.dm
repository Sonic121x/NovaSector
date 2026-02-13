/obj/item/gun/ballistic/rifle/boltaction/makeshift/arisaka
	name = "\improper makeshift Arisaka type 99 rifle"
	desc = "一把仿制的有坂九九式步枪, 发射7.7×58mm无突缘弹弹药."
	icon = 'modular_gay/weapons/icon/gunz.dmi'
	icon_state = "arisaka"
	base_icon_state = "arisaka"
	lefthand_file = 'modular_gay/weapons/icon/lefthand.dmi'
	righthand_file = 'modular_gay/weapons/icon/righthand.dmi'
	inhand_icon_state = "arisaka"
	worn_icon = 'modular_gay/weapons/icon/worn.dmi'
	worn_icon_state = "arisaka"
	fire_sound = 'modular_gay/sound/weapons/hunting_rifle.ogg'
	rack_sound = 'modular_gay/sound/weapons/gunsounds/rifle/rifleback2.ogg'
	lock_back_sound = 'modular_gay/sound/weapons/gunsounds/rifle/rifleback2.ogg'
	bolt_drop_sound = 'modular_gay/sound/weapons/gunsounds/rifle/rifledrop2.ogg'
	load_sound = 'modular_gay/sound/weapons/gunsounds/rifle/riflemag_load.ogg'
	load_empty_sound = 'modular_gay/sound/weapons/gunsounds/rifle/riflemag_load.ogg'
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/arisaka
	bolt_type = BOLT_TYPE_LOCKING
	recoil = 1
	spread = 0.2
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_HEAVY
	slot_flags = ITEM_SLOT_SUITSTORE | ITEM_SLOT_BACK | ITEM_SLOT_OCLOTHING
	projectile_damage_multiplier = 1
	jamming_chance = 10
	unjam_chance = 75

/obj/item/ammo_box/magazine/internal/arisaka
	name = "Arisaka internal magazine"
	ammo_type = /obj/item/ammo_casing/makeshift/c7758
	caliber = "7.7×58mm"
	max_ammo = 5

/obj/item/ammo_box/speedloader/makeshift/arisaka
	name = "stripper clip (7.7×58mm)"
	desc = "A five-round stripper clip for Arisaka type 99."
	icon_state = "clip"
	ammo_type = /obj/item/ammo_casing/makeshift/c7758
	max_ammo = 5
	ammo_box_multiload = AMMO_BOX_MULTILOAD_ALL
	caliber = "7.7×58mm"

/datum/crafting_bench_recipe/arisaka
	recipe_name = "stripper clip (7.7×58mm)"
	recipe_requirements = list(
		/obj/item/stack/sheet/iron = 5,
	)
	resulting_item = /obj/item/ammo_box/speedloader/makeshift/arisaka
	required_good_hits = 10