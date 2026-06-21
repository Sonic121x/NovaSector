/datum/crafting_recipe/gold_horn
	name = "金色自行车喇叭"
	result = /obj/item/bikehorn/golden
	time = 2 SECONDS
	reqs = list(
		/obj/item/stack/sheet/mineral/bananium = 5,
		/obj/item/bikehorn = 1,
	)
	category = CAT_TOOLS

/datum/crafting_recipe/bonfire
	name = "篝火"
	time = 6 SECONDS
	reqs = list(/obj/item/grown/log = 5)
	parts = list(/obj/item/grown/log = 5) //Will be returned if the bonfire is dismantled
	blacklist = list(/obj/item/grown/log/steel)
	result = /obj/structure/bonfire/player_made // NOVA EDIT - Pollution - ORIGINAL: result = /obj/structure/bonfire
	category = CAT_TOOLS
	crafting_flags = parent_type::crafting_flags | CRAFT_SKIP_MATERIALS_PARITY

/datum/crafting_recipe/boneshovel
	name = "锯齿骨铲"
	reqs = list(
		/obj/item/stack/sheet/bone = 4,
		/datum/reagent/fuel/oil = 5,
		/obj/item/shovel = 1,
	)
	result = /obj/item/shovel/serrated
	category = CAT_TOOLS
	crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_MUST_BE_LEARNED

/datum/crafting_recipe/lasso
	name = "骨套索"
	reqs = list(
		/obj/item/stack/sheet/bone = 1,
		/obj/item/stack/sheet/sinew = 5,
	)
	result = /obj/item/key/lasso
	category = CAT_TOOLS

/datum/crafting_recipe/ipickaxe
	name = "临时镐"
	reqs = list(
		/obj/item/crowbar = 1,
		/obj/item/knife = 1,
		/obj/item/stack/medical/wrap/sticky_tape = 1,
	)
	result = /obj/item/pickaxe/improvised
	category = CAT_TOOLS

/datum/crafting_recipe/bandage
	name = "临时绷带"
	reqs = list(
		/obj/item/stack/sheet/cloth = 3,
		/datum/reagent/medicine/c2/libital = 10,
	)
	result = /obj/item/stack/medical/bandage/makeshift
	category = CAT_TOOLS

/datum/crafting_recipe/bone_rod
	name = "骨制鱼竿"
	result = /obj/item/fishing_rod/bone
	time = 5 SECONDS
	reqs = list(/obj/item/stack/sheet/leather = 1,
				/obj/item/stack/sheet/sinew = 2,
				/obj/item/stack/sheet/bone = 2)
	category = CAT_TOOLS

/datum/crafting_recipe/sinew_line
	name = "筋制鱼线卷轴"
	result = /obj/item/fishing_line/sinew
	reqs = list(/obj/item/stack/sheet/sinew = 2)
	time = 2 SECONDS
	category = CAT_TOOLS

/datum/crafting_recipe/bone_hook
	name = "巨兽骨钩"
	result = /obj/item/fishing_hook/bone
	reqs = list(/obj/item/stack/sheet/bone = 1)
	time = 2 SECONDS
	category = CAT_TOOLS

/datum/crafting_recipe/shuttle_blueprints
	name = "简陋穿梭机蓝图"
	result = /obj/item/shuttle_blueprints/crude
	reqs = list(
		/obj/item/paper = 1,
	)
	tool_paths = list(/obj/item/toy/crayon)
	//we can't use a generic crayon so we spawn a blue one
	unit_test_spawn_extras = list(/obj/item/toy/crayon/blue = 1)
	steps = list(
		"You must use either a a blue crayon, a rainbow crayon, or a spray can.",
		"The crayon or spray can you use must have at least 10 uses remaining."
	)
	time = 10 SECONDS
	category = CAT_TOOLS
	var/static/list/valid_types = typecacheof(list(
		/obj/item/toy/crayon/blue,
		/obj/item/toy/crayon/rainbow,
		/obj/item/toy/crayon/spraycan,
	))

/datum/crafting_recipe/shuttle_blueprints/check_tools(atom/user, list/collected_tools, final_check = FALSE)
	for(var/obj/item/toy/crayon/crayon in collected_tools)
		if(!is_type_in_typecache(crayon, valid_types))
			continue
		if(final_check ? crayon.use_charges(user, 10) : !crayon.check_empty(user, 10))
			return TRUE
	return FALSE

/datum/crafting_recipe/makeshift_radio_jammer
	name = "临时无线电干扰器"
	result = /obj/item/jammer/makeshift
	reqs = list(
		/obj/item/universal_scanner = 1,
		/obj/item/encryptionkey = 1,
		/obj/item/stack/cable_coil = 5,
	)
	category = CAT_TOOLS

/datum/crafting_recipe/jaws_of_recovery
	name = "改装版救援钳"
	desc = "这把工具的功能与标准救援钳相同，可以撬开任何门，并且不会广播你正在撬门的行为。"
	time = 10 SECONDS
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WELDER)
	result = /obj/item/crowbar/power/paramedic/silent
	reqs = list(
		/obj/item/crowbar/power = 1,
		/obj/item/bonesetter = 1,
	)
	category = CAT_TOOLS

/datum/crafting_recipe/jaws_of_recovery/New()
	LAZYADD(blacklist, typecacheof(/obj/item/crowbar/power/paramedic, ignore_root_path = TRUE))
	return ..()

/datum/crafting_recipe/lantern
	name = "提灯"
	result = /obj/item/flashlight/lantern
	reqs = list(
		/obj/item/flashlight/flare/candle = 1,
		/obj/item/stack/rods = 1,
		/obj/item/stack/sheet/glass = 1,
	)
	crafting_flags = CRAFT_SKIP_MATERIALS_PARITY
	tool_behaviors = list(TOOL_SCREWDRIVER)
	category = CAT_TOOLS
