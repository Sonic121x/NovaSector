/datum/crafting_recipe/tinker_bench
	name = "tinker's workbench"
	result = /obj/structure/reagent_crafting_bench/tinker
	reqs = list(
		/obj/item/stack/sheet/iron = 15,
		/obj/item/stock_parts/servo = 4,
		/obj/item/assembly/igniter = 1,
		/obj/item/paper = 1,
		/obj/item/pen = 1,
		/obj/item/flashlight/lamp = 1,
		/obj/item/wallframe/closet = 1,
		/obj/item/screwdriver/omni_drill = 1,
		/obj/item/weldingtool/electric/arc_welder = 1,
		)
	category = CAT_STRUCTURE

/datum/crafting_recipe/powder
	name = "可燃粉末"
	result = /obj/item/gun_parts/powder
	reqs = list(
		/obj/item/stack/sheet/iron = 1,
		/obj/item/paper = 1,
		/datum/reagent/fuel = 10,
		)
	category = CAT_WEAPON_AMMO

/datum/crafting_bench_recipe/grip_rubber
	recipe_name = "rubber grip"
	recipe_requirements = list(
		/obj/item/stack/sticky_tape = 1,
		/obj/item/stack/sheet/plastic = 5,
		/obj/item/stack/cable_coil = 5,
	)
	resulting_item = /obj/item/gun_parts/grip/grip_rubber
	required_good_hits = 15

/datum/crafting_bench_recipe/grip_wood
	recipe_name = "wood grip"
	recipe_requirements = list(
		/obj/item/stack/sticky_tape = 1,
		/obj/item/stack/sheet/mineral/wood = 5,
	)
	resulting_item = /obj/item/gun_parts/grip/grip_wood
	required_good_hits = 20

/datum/crafting_bench_recipe/grip_black
	recipe_name = "black grip"
	recipe_requirements = list(
		/obj/item/stack/sticky_tape = 1,
		/obj/item/stack/sheet/plasteel = 5,
	)
	resulting_item = /obj/item/gun_parts/grip/grip_black
	required_good_hits = 25

/datum/crafting_bench_recipe/mechanism_pistol
	recipe_name = "pistol mechanism"
	recipe_requirements = list(
		/obj/item/stack/cable_coil = 1,
		/obj/item/stack/sheet/iron = 2,
	)
	resulting_item = /obj/item/gun_parts/mechanism/mechanism_pistol
	required_good_hits = 30

/datum/crafting_bench_recipe/mechanism_smg
	recipe_name = "submachinegun mechanism"
	recipe_requirements = list(
		/obj/item/stack/cable_coil = 1,
		/obj/item/stack/sheet/iron = 2,
	)
	resulting_item = /obj/item/gun_parts/mechanism/mechanism_smg
	required_good_hits = 35

/datum/crafting_bench_recipe/mechanism_shotgun
	recipe_name = "shotgun mechanism"
	recipe_requirements = list(
		/obj/item/stack/cable_coil = 1,
		/obj/item/stack/sheet/iron = 4,
	)
	resulting_item = /obj/item/gun_parts/mechanism/mechanism_shotgun
	required_good_hits = 35

/datum/crafting_bench_recipe/mechanism_boltaction
	recipe_name = "boltaction rifle mechanism"
	recipe_requirements = list(
		/obj/item/stack/cable_coil = 1,
		/obj/item/stack/sheet/iron = 2,
	)
	resulting_item = /obj/item/gun_parts/mechanism/mechanism_boltaction
	required_good_hits = 30

/datum/crafting_bench_recipe/mechanism_autorifle
	recipe_name = "autorifle mechanism"
	recipe_requirements = list(
		/obj/item/stack/cable_coil = 1,
		/obj/item/stack/sheet/iron = 4,
	)
	resulting_item = /obj/item/gun_parts/mechanism/mechanism_autorifle
	required_good_hits = 40

/datum/crafting_bench_recipe/barrel_short
	recipe_name = "short barrel"
	recipe_requirements = list(
		/obj/item/stack/sheet/iron = 2,
	)
	resulting_item = /obj/item/gun_parts/barrel/barrel_short
	required_good_hits = 20

/datum/crafting_bench_recipe/barrel_long
	recipe_name = "long barrel"
	recipe_requirements = list(
		/obj/item/stack/sheet/plasteel = 2,
	)
	resulting_item = /obj/item/gun_parts/barrel/barrel_long
	required_good_hits = 30

/datum/crafting_bench_recipe/barrel_silent
	recipe_name = "silent barrel"
	recipe_requirements = list(
		/obj/item/stack/sheet/plasteel = 4,
	)
	resulting_item = /obj/item/gun_parts/barrel/barrel_silent
	required_good_hits = 40

/datum/crafting_bench_recipe/barrel_amr
	recipe_name = "heavy barrel"
	recipe_requirements = list(
		/obj/item/stack/sheet/plasteel = 5,
	)
	resulting_item = /obj/item/gun_parts/barrel/barrel_amr
	required_good_hits = 40

/datum/crafting_bench_recipe/gun_parts
	recipe_name = "gun parts"
	recipe_requirements = list(
		/obj/item/stack/cable_coil = 1,
		/obj/item/stack/sheet/iron = 2,
	)
	resulting_item = /obj/item/gun_parts/parts
	required_good_hits = 15

/datum/crafting_bench_recipe/spring
	recipe_name = "spring"
	recipe_requirements = list(
		/obj/item/stack/cable_coil = 1,
		/obj/item/stack/sheet/iron = 1,
	)
	resulting_item = /obj/item/gun_parts/spring
	required_good_hits = 5

/datum/crafting_bench_recipe/c9mm
	recipe_name = "makeshift ammo box (9mm)"
	recipe_requirements = list(
		/obj/item/shard = 5,
		/obj/item/stack/sheet/iron = 5,
		/obj/item/gun_parts/powder = 1.
	)
	resulting_item = /obj/item/ammo_box/makeshift/c9mm
	required_good_hits = 10

/datum/crafting_bench_recipe/c22
	recipe_name = "makeshift ammo box (.22)"
	recipe_requirements = list(
		/obj/item/shard = 5,
		/obj/item/stack/sheet/iron = 5,
		/obj/item/gun_parts/powder = 1.
	)
	resulting_item = /obj/item/ammo_box/makeshift/c22
	required_good_hits = 10

/datum/crafting_bench_recipe/c308
	recipe_name = "makeshift ammo box (.308)"
	recipe_requirements = list(
		/obj/item/shard = 5,
		/obj/item/stack/sheet/iron = 5,
		/obj/item/gun_parts/powder = 2.
	)
	resulting_item = /obj/item/ammo_box/makeshift/c308
	required_good_hits = 10

/datum/crafting_bench_recipe/c7758
	recipe_name = "makeshift ammo box (7.7x58mm)"
	recipe_requirements = list(
		/obj/item/shard = 5,
		/obj/item/stack/sheet/iron = 5,
		/obj/item/gun_parts/powder = 2.
	)
	resulting_item = /obj/item/ammo_box/makeshift/c7758
	required_good_hits = 10

/datum/crafting_bench_recipe/birdshot
	recipe_name = "makeshift ammo box (birdshot)"
	recipe_requirements = list(
		/obj/item/shard = 5,
		/obj/item/stack/sheet/iron = 5,
		/obj/item/gun_parts/powder = 2.
	)
	resulting_item = /obj/item/ammo_box/makeshift/birdshot
	required_good_hits = 10