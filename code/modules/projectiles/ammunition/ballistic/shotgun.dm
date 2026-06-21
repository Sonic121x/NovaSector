// Shotgun

/obj/item/ammo_casing/shotgun
	name = "霰弹枪燃烧独头弹"
	desc = "12号铅弹。"
	icon_state = "blshell"
	worn_icon_state = "shell"
	caliber = CALIBER_SHOTGUN
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*2)
	projectile_type = /obj/projectile/bullet/shotgun_slug
	newtonian_force = 1.25

/obj/item/ammo_casing/shotgun/milspec
	name = "shotgun milspec slug"
	desc = "A 12 gauge milspec lead slug."
	projectile_type = /obj/projectile/bullet/shotgun_slug/milspec

/obj/item/ammo_casing/shotgun/executioner
	name = "处决者霰弹"
	desc = "A 12 gauge lead slug purpose built to annihilate flesh on impact."
	icon_state = "stunshell"
	projectile_type = /obj/projectile/bullet/shotgun_slug/executioner

/obj/item/ammo_casing/shotgun/pulverizer
	name = "pulverizer slug"
	desc = "A 12 gauge lead slug purpose built to annihilate bones on impact."
	icon_state = "stunshell"
	projectile_type = /obj/projectile/bullet/shotgun_slug/pulverizer

/obj/item/ammo_casing/shotgun/beanbag
	name = "豆袋弹"
	desc = "一种用于镇压骚乱的豆袋弹"
	icon_state = "bshell"
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*2.5)
	projectile_type = /obj/projectile/bullet/shotgun_beanbag

/obj/item/ammo_casing/shotgun/incendiary
	name = "燃烧弹"
	desc = "涂有燃烧剂的霰弹枪独头弹"
	icon_state = "ishell"
	projectile_type = /obj/projectile/bullet/incendiary/shotgun

/obj/item/ammo_casing/shotgun/incendiary/no_trail
	name = "精确燃烧弹"
	desc = "一种涂有燃烧剂的霰弹，经过特殊处理，仅在撞击时点燃。"
	projectile_type = /obj/projectile/bullet/incendiary/shotgun/no_trail

/obj/item/ammo_casing/shotgun/dragonsbreath
	name = "龙息弹壳"
	desc = "一种发射燃烧弹丸的霰弹。"
	icon_state = "ishell2"
	projectile_type = /obj/projectile/bullet/incendiary/shotgun/dragonsbreath
	pellets = 6
	variance = 15
	randomspread = TRUE

/obj/item/ammo_casing/shotgun/stunslug
	name = "泰瑟弹壳"
	desc = "一只高效的电击弹壳。"
	icon_state = "stunshell"
	projectile_type = /obj/projectile/bullet/shotgun_stunslug
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT*2.5)

/obj/item/ammo_casing/shotgun/meteorslug
	name = "流星弹壳"
	desc = "一发使用CMC技术的霰弹枪弹，当发射时会发出一颗巨大的单发子弹。"
	icon_state = "mshell"
	projectile_type = /obj/projectile/bullet/cannonball/meteorslug
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 8, /datum/material/glass = SHEET_MATERIAL_AMOUNT * 4)

/obj/item/ammo_casing/shotgun/pulseslug
	name = "脉冲弹头"
	desc = "A delicate device which can be loaded into a shotgun. The primer acts as a button which triggers the gain medium and fires a powerful \
	energy blast. While the heat and power drain limit it to one use, it can still allow an operator to engage targets that ballistic ammunition \
	would have difficulty with."
	icon_state = "pshell"
	projectile_type = /obj/projectile/beam/pulse/shotgun
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2.1, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 1.2)

/obj/item/ammo_casing/shotgun/frag12
	name = "FRAG-12 slug"
	desc = "用于12号口径霰弹枪的高爆冲击弹。"
	icon_state = "heshell"
	projectile_type = /obj/projectile/bullet/shotgun_frag12

/obj/item/ammo_casing/shotgun/buckshot
	name = "铅弹"
	desc = "一个12号铅弹。"
	icon_state = "gshell"
	projectile_type = /obj/projectile/bullet/pellet/shotgun_buckshot
	pellets = 6
	variance = 15
	randomspread = TRUE

/obj/item/ammo_casing/shotgun/buckshot/old
	projectile_type = /obj/projectile/bullet/pellet/shotgun_buckshot/old
	can_misfire = TRUE
	misfire_increment = 2
	integrity_damage = 4

/obj/item/ammo_casing/shotgun/buckshot/old/fire_casing(atom/target, mob/living/user, params, distro, quiet, zone_override, spread, atom/fired_from)
	. = ..()
	if(fired_from)
		do_smoke(0, fired_from, fired_from)

/obj/item/ammo_casing/shotgun/buckshot/milspec
	name = "milspec buckshot shell"
	desc = "A 12 gauge buckshot shell, used by various paramilitaries and mercernary forces."
	projectile_type = /obj/projectile/bullet/pellet/shotgun_buckshot/milspec

/obj/item/ammo_casing/shotgun/buckshot/spent
	projectile_type = null

/obj/item/ammo_casing/shotgun/rubbershot
	name = "橡胶鹿弹"
	desc = "装满密集橡胶球的霰弹枪弹壳，用于远距离控制人群。"
	icon_state = "rshell"
	projectile_type = /obj/projectile/bullet/pellet/shotgun_rubbershot
	pellets = 6
	variance = 15
	randomspread = TRUE
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*2)

/obj/item/ammo_casing/shotgun/incapacitate
	name = "自定义失能弹"
	desc = "一个装有……某种物质的霰弹，用于使目标失去行动能力。"
	icon_state = "bountyshell"
	projectile_type = /obj/projectile/bullet/pellet/shotgun_incapacitate
	pellets = 12//double the pellets, but half the stun power of each, which makes this best for just dumping right in someone's face.
	variance = 25
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*2)

/obj/item/ammo_casing/shotgun/flechette
	name = "flechette shell"
	desc = "A shotgun casing filled with small metal darts. Pokes many tiny holes into meat and kevlar alike. Useful for turning someones insides \
		into outsides."
	icon_state = "flechette"
	projectile_type = /obj/projectile/bullet/pellet/flechette
	custom_materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 2)
	pellets = 8
	variance = 10

/obj/item/ammo_casing/shotgun/flechette/donk
	name = "\improper Donk Co. 'Donk Spike' Shell"
	desc = "Donk Co., looking to create a new and exciting shell to move onto the open market, invented what they call the 'Donk Spike'. \
		A flechette not made from standard ferrous metals. But...plastic. It was a financial failure due to a complete lack of \
		confidence in the product. Now there are millions of these things in landfills across the sector. This is one such example. \
		Looks like a donk-pocket! Tastes like death!"
	icon_state = "flechette_donk"
	projectile_type = /obj/projectile/bullet/pellet/flechette/donk
	custom_materials = list(/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/plastic = SMALL_MATERIAL_AMOUNT * 2)
	pellets = 5

/obj/item/ammo_casing/shotgun/ion
	name = "离子外壳"
	desc = "An advanced shotgun shell which uses a subspace ansible crystal to produce an effect similar to a standard ion rifle. \
	The unique properties of the crystal split the pulse into a spread of individually weaker bolts."
	icon_state = "ionshell"
	projectile_type = /obj/projectile/ion/weak
	pellets = 4
	variance = 15
	randomspread = TRUE
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 0.7)

/obj/item/ammo_casing/shotgun/scatterlaser
	name = "散射激光壳"
	desc = "一种先进的霰弹枪弹药，它利用微型激光来模拟散射激光武器的射击效果，同时具备弹道性能。"
	icon_state = "lshell"
	projectile_type = /obj/projectile/beam/scatter
	pellets = 6
	variance = 15
	randomspread = TRUE

/obj/item/ammo_casing/shotgun/scatterlaser/emp_act(severity)
	. = ..()
	if(isnull(loaded_projectile) || !prob(40/severity))
		return
	name = "malfunctioning laser shell"
	desc = "An advanced shotgun shell that uses a micro laser to replicate the effects of a scatter laser weapon in a ballistic package. The capacitor powering this assembly appears to be smoking."
	projectile_type = /obj/projectile/beam/scatter/pathetic
	loaded_projectile = new projectile_type(src)

/obj/item/ammo_casing/shotgun/techshell
	name = "未装载的科技霰弹"
	desc = "一种高科技霰弹枪弹，可以装填各种材料以产生独特效果。"
	icon_state = "cshell"
	projectile_type = null

/obj/item/ammo_casing/shotgun/techshell/Initialize(mapload)
	. = ..()

	var/static/list/slapcraft_recipe_list = list(/datum/crafting_recipe/meteorslug, /datum/crafting_recipe/pulseslug, /datum/crafting_recipe/dragonsbreath, /datum/crafting_recipe/ionslug)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
	)

/obj/item/ammo_casing/shotgun/dart
	name = "霰弹枪飞镖注射弹"
	desc = "一种用于霰弹枪的镖弹。可注入最多15单位的任何化学品。"
	icon_state = "cshell"
	projectile_type = /obj/projectile/bullet/dart
	var/reagent_amount = 15

/obj/item/ammo_casing/shotgun/dart/Initialize(mapload)
	. = ..()
	create_reagents(reagent_amount, OPENCONTAINER)

/obj/item/ammo_casing/shotgun/dart/attackby()
	return

/obj/item/ammo_casing/shotgun/dart/large
	name = "XL shotgun dart"
	desc = "A dart for use in shotguns. Can be injected with up to 25 units of any chemical."
	reagent_amount = 25

/obj/item/ammo_casing/shotgun/dart/bioterror
	name = "bioterror dart"
	desc = "一种填充了致命毒素的改良型霰弹镖弹。可注入最多30单位的任何化学品。"
	reagent_amount = 30

/obj/item/ammo_casing/shotgun/dart/bioterror/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/consumable/ethanol/neurotoxin, 6)
	reagents.add_reagent(/datum/reagent/toxin/spore, 6)
	reagents.add_reagent(/datum/reagent/toxin/mutetoxin, 6) //;HELP OPS IN MAINT
	reagents.add_reagent(/datum/reagent/toxin/coniine, 6)
	reagents.add_reagent(/datum/reagent/toxin/sodium_thiopental, 6)

/obj/item/ammo_casing/shotgun/breacher
	name = "breaching slug"
	desc = "A 12 gauge anti-material slug. Great for breaching airlocks and windows, quickly and efficiently."
	icon_state = "breacher"
	projectile_type = /obj/projectile/bullet/shotgun_breaching
	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT*2)
