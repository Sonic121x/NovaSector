/datum/crafting_recipe/arisaka
	name = "makeshift Arisaka type 99 rifle"
	result = /obj/item/gun/ballistic/rifle/boltaction/makeshift/arisaka
	reqs = list(
		/obj/item/gun_parts/mechanism/mechanism_boltaction = 1,
		/obj/item/gun_parts/barrel/barrel_long = 1,
		/obj/item/stack/sheet/mineral/wood = 5,
		)
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/c22smg
	name = ".22 submachine gun"
	result = /obj/item/gun/ballistic/automatic/smg/makeshift/american180
	reqs = list(
		/obj/item/gun_parts/grip/grip_wood = 1,
		/obj/item/gun_parts/barrel/barrel_long = 1,
		/obj/item/gun_parts/mechanism/mechanism_smg = 1,
		)
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/C96
	name = "makeshift C96 pistol"
	result = /obj/item/gun/ballistic/automatic/pistol/makeshift/C96
	reqs = list(
		/obj/item/gun_parts/grip/grip_wood = 1,
		/obj/item/gun_parts/mechanism/mechanism_pistol = 1,
		/obj/item/gun_parts/barrel/barrel_short = 1,
		)
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/c22
	name = "makeshift ruger.22 pistol"
	result = /obj/item/gun/ballistic/automatic/pistol/makeshift/silent
	reqs = list(
		/obj/item/gun_parts/mechanism/mechanism_pistol = 1,
		/obj/item/gun_parts/barrel/barrel_silent = 1,
		)
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/singleshot
	name = "makeshift single shotgun"
	result = /obj/item/gun/ballistic/rifle/boltaction/makeshift/singleshot
	reqs = list(
		/obj/item/gun_parts/grip/grip_wood = 1,
		/obj/item/gun_parts/mechanism/mechanism_shotgun = 1,
		/obj/item/gun_parts/barrel/barrel_long = 1,
		)
	category = CAT_WEAPON_RANGED

/datum/crafting_recipe/huntingshot
	name = "makeshift auto shotgun"
	result = /obj/item/gun/ballistic/shotgun/makeshift/huntingshot
	reqs = list(
		/obj/item/gun_parts/grip/grip_wood = 1,
		/obj/item/gun_parts/mechanism/mechanism_shotgun = 1,
		/obj/item/gun_parts/barrel/barrel_long = 1,
		)
	category = CAT_WEAPON_RANGED