/obj/item/ammo_box/magazine/makeshift/c22p
	name = "pistol magazine (.22)"
	icon = 'modular_gay/ammo/icon/ammo.dmi'
	icon_state = "22"
	base_icon_state = "22"
	desc = "A .22 handgun magazine, suitable for the silent pistol."
	ammo_type = /obj/item/ammo_casing/makeshift/c22
	caliber = ".22"
	max_ammo = 16
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	multiple_sprite_use_base = TRUE

/obj/item/ammo_box/magazine/makeshift/c22smg
	name = "submachine gun pan (.22)"
	icon = 'modular_gay/ammo/icon/ammo.dmi'
	icon_state = "smg22"
	base_icon_state = "smg22"
	desc = "A .22 submachine gun pan magzine, suitable for the .22 submachine gun."
	ammo_type = /obj/item/ammo_casing/makeshift/c22
	caliber = ".22"
	max_ammo = 100
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	multiple_sprite_use_base = TRUE

/obj/item/ammo_box/magazine/makeshift/c308
	name = "garand clip (.308)"
	icon = 'modular_gay/ammo/icon/ammo.dmi'
	icon_state = "garand"
	base_icon_state = "garand"
	desc = "A garand rifle clip, suitable for the garand rifle."
	ammo_type = /obj/item/ammo_casing/makeshift/c308
	caliber = ".308"
	max_ammo = 8
	multiple_sprites = AMMO_BOX_PER_BULLET

/datum/crafting_bench_recipe/c308clip
	recipe_name = "garand clip (.308)"
	recipe_requirements = list(
		/obj/item/stack/sheet/iron = 2,
		/obj/item/gun_parts/spring = 1.
	)
	resulting_item = /obj/item/ammo_box/magazine/makeshift/c308
	required_good_hits = 10

/datum/crafting_bench_recipe/c22smg
	recipe_name = "submachine gun pan (.22)"
	recipe_requirements = list(
		/obj/item/stack/sheet/iron = 10,
		/obj/item/gun_parts/spring = 1.
	)
	resulting_item = /obj/item/ammo_box/magazine/makeshift/c22smg
	required_good_hits = 10

/datum/crafting_bench_recipe/c22p
	recipe_name = "pistol magazine (.22)"
	recipe_requirements = list(
		/obj/item/stack/sheet/iron = 2,
		/obj/item/gun_parts/spring = 1.
	)
	resulting_item = /obj/item/ammo_box/magazine/makeshift/c22p
	required_good_hits = 10