/datum/crafting_recipe/strobeshield
	name = "闪光盾牌"
	result = /obj/item/shield/riot/flash
	reqs = list(
		/obj/item/wallframe/flasher = 1,
		/obj/item/assembly/flash/handheld = 1,
		/obj/item/shield/riot = 1,
	)
	time = 4 SECONDS
	category = CAT_EQUIPMENT

/datum/crafting_recipe/strobeshield/New()
	LAZYADD(blacklist, typecacheof(/obj/item/shield/riot, ignore_root_path = TRUE))
	return ..()

/datum/crafting_recipe/improvisedshield
	name = "简易盾牌"
	result = /obj/item/shield/improvised
	reqs = list(
		/obj/item/stack/sheet/iron = 10,
		/obj/item/stack/medical/wrap/sticky_tape = 2,
	)
	time = 4 SECONDS
	category = CAT_EQUIPMENT

/datum/crafting_recipe/moonflowershield
	name = "月花盾牌"
	result = /obj/item/shield/buckler/moonflower
	reqs = list(
		/obj/item/seeds/sunflower/moonflower = 3,
		/obj/item/grown/log/steel = 3,
	)
	time = 4 SECONDS
	category = CAT_EQUIPMENT

/datum/crafting_recipe/radio_containing
	abstract_type = /datum/crafting_recipe/radio_containing
	/// Shared blacklist of all the radio types for anything that uses a radio in its construction, so we don't repeat it.
	var/static/list/radio_types_blacklist

/datum/crafting_recipe/radio_containing/New()
	if(isnull(radio_types_blacklist))
		// because we got shit like /obj/item/radio/off ... WHY!?!
		radio_types_blacklist = typecacheof(list(/obj/item/radio/headset, /obj/item/radio/intercom))
	blacklist = radio_types_blacklist
	return ..()

/datum/crafting_recipe/radio_containing/radiogloves
	name = "无线电手套"
	result = /obj/item/clothing/gloves/radio
	time = 1.5 SECONDS
	reqs = list(
		/obj/item/clothing/gloves/color/black = 1,
		/obj/item/stack/cable_coil = 2,
		/obj/item/radio = 1,
	)
	tool_behaviors = list(TOOL_WIRECUTTER)
	category = CAT_EQUIPMENT

/datum/crafting_recipe/wheelchair
	name = "轮椅"
	result = /obj/vehicle/ridden/wheelchair
	reqs = list(
		/obj/item/stack/sheet/iron = 4,
		/obj/item/stack/rods = 6,
	)
	time = 10 SECONDS
	category = CAT_EQUIPMENT
	removed_mats = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 2)

/datum/crafting_recipe/motorized_wheelchair
	name = "电动轮椅"
	result = /obj/vehicle/ridden/wheelchair/motorized
	reqs = list(
		/obj/item/stack/sheet/iron = 10,
		/obj/item/stack/rods = 8,
		/obj/item/stock_parts/servo = 2,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/power_store/cell = 1,
	)
	parts = list(
		/obj/item/stock_parts/servo = 2,
		/obj/item/stock_parts/capacitor = 1,
		/obj/item/stock_parts/power_store/cell = 1,
	)
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER, TOOL_WRENCH)
	time = 20 SECONDS
	category = CAT_EQUIPMENT

/datum/crafting_recipe/secured_freezer_cabinet
	name = "安全冷冻柜"
	result = /obj/structure/closet/secure_closet/freezer/empty
	reqs = list(
		/obj/item/stack/sheet/iron = 5,
		/obj/item/assembly/igniter/condenser = 1,
		/obj/item/electronics/airlock = 1,
	)
	time = 5 SECONDS
	category = CAT_EQUIPMENT

/datum/crafting_recipe/barbeque_grill
	name = "烧烤架"
	result = /obj/machinery/grill
	reqs = list(
		/obj/item/stack/sheet/iron = 5,
		/obj/item/stack/rods = 5,
		/obj/item/assembly/igniter = 1,
	)
	time = 7 SECONDS
	category = CAT_EQUIPMENT

/datum/crafting_recipe/secure_closet
	name = "安全储物柜"
	result = /obj/structure/closet/secure_closet
	reqs = list(
		/obj/item/stack/sheet/iron = 5,
		/obj/item/electronics/airlock = 1,
	)
	time = 5 SECONDS
	category = CAT_EQUIPMENT

/datum/crafting_recipe/trapdoor_kit
	name = "活板门建造套件"
	result = /obj/item/trapdoor_kit
	reqs = list(
		/obj/item/stack/sheet/iron = 4,
		/obj/item/stack/rods = 4,
		/obj/item/stack/cable_coil = 10,
		/obj/item/stock_parts/servo = 2,
		/obj/item/assembly/signaler = 1,
	)
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER)
	time = 10 SECONDS
	category = CAT_EQUIPMENT

/datum/crafting_recipe/trapdoor_remote
	name = "活板门遥控器"
	result = /obj/item/trapdoor_remote/preloaded // since its useless without its assembly just require an assembly to craft it
	reqs = list(
		/obj/item/compact_remote = 1,
		/obj/item/stack/cable_coil = 5,
		/obj/item/assembly/trapdoor = 1,
	)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	time = 5 SECONDS
	category = CAT_EQUIPMENT

/datum/crafting_recipe/mousetrap
	name = "捕鼠夹"
	result = /obj/item/assembly/mousetrap
	time = 1 SECONDS
	reqs = list(
		/obj/item/stack/sheet/cardboard = 1,
		/obj/item/stack/rods = 1,
	)
	category = CAT_EQUIPMENT

/datum/crafting_recipe/flashlight_eyes
	name = "手电筒眼睛"
	result = /obj/item/organ/eyes/robotic/flashlight
	time = 1 SECONDS
	reqs = list(
		/obj/item/flashlight = 2,
		/obj/item/restraints/handcuffs/cable = 1
	)
	blacklist = list(
		/obj/item/flashlight/lamp/space_bubble,
	)
	category = CAT_EQUIPMENT

/datum/crafting_recipe/flashlight_eyes/New()
	LAZYADD(blacklist, typecacheof(/obj/item/flashlight/flare))
	return ..()

/datum/crafting_recipe/extendohand_r
	name = "伸缩手（右臂）"
	reqs = list(
		/obj/item/bodypart/arm/right/robot = 1,
		/obj/item/clothing/gloves/boxing = 1,
	)
	result = /obj/item/extendohand
	category = CAT_EQUIPMENT

/datum/crafting_recipe/extendohand_l
	name = "伸缩手（左臂）"
	reqs = list(
		/obj/item/bodypart/arm/left/robot = 1,
		/obj/item/clothing/gloves/boxing = 1,
	)
	result = /obj/item/extendohand
	category = CAT_EQUIPMENT

/datum/crafting_recipe/ore_sensor
	name = "矿石传感器"
	time = 3 SECONDS
	reqs = list(
		/datum/reagent/brimdust = 15,
		/obj/item/stack/sheet/bone = 1,
		/obj/item/stack/sheet/sinew = 1,
	)
	result = /obj/item/ore_sensor
	category = CAT_EQUIPMENT

/datum/crafting_recipe/material_sniffer
	name = "材料嗅探器"
	time = 3 SECONDS
	reqs = list(
		/obj/item/analyzer = 1,
		/obj/item/stack/cable_coil = 5,
	)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	result = /obj/item/pinpointer/material_sniffer
	category = CAT_EQUIPMENT

/datum/crafting_recipe/pressureplate
	name = "压力板"
	result = /obj/item/pressure_plate
	time = 0.5 SECONDS
	reqs = list(
		/obj/item/stack/sheet/iron = 1,
		/obj/item/stack/tile/iron = 1,
		/obj/item/stack/cable_coil = 2,
		/obj/item/assembly/igniter = 1,
	)
	category = CAT_EQUIPMENT

/datum/crafting_recipe/rcl
	name = "临时快速管道清洁层"
	result = /obj/item/rcl/ghetto
	time = 4 SECONDS
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER, TOOL_WRENCH)
	reqs = list(/obj/item/stack/sheet/iron = 15)
	category = CAT_EQUIPMENT

/datum/crafting_recipe/ghettojetpack
	name = "临时喷气背包"
	result = /obj/item/tank/jetpack/improvised
	time = 3 SECONDS
	reqs = list(
		/obj/item/tank/internals/oxygen = 2,
		/obj/item/extinguisher = 1,
		/obj/item/pipe = 3,
		/obj/item/stack/cable_coil = MAXCOIL,
	)
	category = CAT_EQUIPMENT
	tool_behaviors = list(TOOL_WRENCH, TOOL_WELDER, TOOL_WIRECUTTER)

/datum/crafting_recipe/gripperoffbrand
	name = "临时抓握手套"
	reqs = list(
		/obj/item/clothing/gloves/fingerless = 1,
		/obj/item/stack/medical/wrap/sticky_tape = 1,
	)
	result = /obj/item/clothing/gloves/tackler/offbrand
	category = CAT_EQUIPMENT

/datum/crafting_recipe/rebar_quiver
	name = "钢筋存储箭袋"
	result = /obj/item/storage/bag/rebar_quiver
	time = 1 SECONDS
	reqs = list(
		/obj/item/tank/internals/oxygen = 1,
		/obj/item/stack/cable_coil = 15,
	)
	category = CAT_EQUIPMENT
	tool_behaviors = list(TOOL_WELDER, TOOL_WIRECUTTER)

// NOVA EDIT REMOVAL START
/*
/datum/crafting_recipe/arrow_quiver
	name = "Archery Quiver"
	result = /obj/item/storage/bag/quiver/lesser
	time = 1 SECONDS
	reqs = list(
		/obj/item/stack/sheet/leather = 4,
		/obj/item/stack/sheet/mineral/wood = 1,
	)
	category = CAT_EQUIPMENT
	tool_behaviors = list(TOOL_WELDER, TOOL_WIRECUTTER)
*/
// NOVA EDIT REMOVAL END

/datum/crafting_recipe/tether_anchor
	name = "系绳锚点"
	result = /obj/item/tether_anchor
	reqs = list(
		/obj/item/stack/sheet/iron = 5,
		/obj/item/stack/rods = 2,
		/obj/item/stack/cable_coil = 15
	)
	tool_behaviors = list(TOOL_SCREWDRIVER, TOOL_WRENCH)
	time = 5 SECONDS
	category = CAT_EQUIPMENT

/datum/crafting_recipe/morbid_surgical_toolset
	name = "病态手术工具组植入物"
	result = /obj/item/organ/cyberimp/arm/toolkit/surgery/cruel
	reqs = list(
		/obj/item/organ/cyberimp/arm/toolkit/surgery = 1
	)
	time = 10 SECONDS
	category = CAT_EQUIPMENT
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER, TOOL_WIRECUTTER)

/datum/crafting_recipe/morbid_surgical_toolset/New()
	LAZYADD(blacklist, typecacheof(/obj/item/organ/cyberimp/arm/toolkit/surgery, ignore_root_path = TRUE))
	return ..()

/datum/crafting_recipe/surgical_toolset
	name = "手术工具组植入物"
	result = /obj/item/organ/cyberimp/arm/toolkit/surgery
	reqs = list(
		/obj/item/organ/cyberimp/arm/toolkit/surgery/cruel = 1
	)
	time = 10 SECONDS
	category = CAT_EQUIPMENT
	tool_behaviors = list(TOOL_WELDER, TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
