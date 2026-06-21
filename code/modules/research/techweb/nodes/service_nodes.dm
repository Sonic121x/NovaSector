/datum/techweb_node/office_equip
	id = TECHWEB_NODE_OFFICE_EQUIP
	starting_node = TRUE
	display_name = "Office Equipment"
	description = "纳米传讯最出色的人体工学办公技术，确保空间站行政人员保持高效并遵守公司政策——因为在太空中，文书工作也永不停歇。"
	design_ids = list(
		"fax",
		"sec_pen",
		"handlabel",
		"roll",
		"universal_scanner",
		"desttagger",
		"packagewrap",
		"sticky_tape",
		"toner_large",
		"toner",
		"boxcutter",
		"bounced_radio",
		"radio_headset",
		"earmuffs",
		"recorder",
		"tape",
		"toy_balloon",
		"pet_carrier",
		"chisel",
		"spraycan",
		"camera_film",
		"camera",
		"razor",
		"bucket",
		"mop",
		"wet_floor_sign",
		"pushbroom",
		"normtrash",
		"wirebrush",
		"flashlight",
		"flare",
		"water_balloon",
		"ticket_machine",
		"radio_entertainment",
		"rdd",
		"photocopier",
	)

/datum/techweb_node/sanitation
	id = TECHWEB_NODE_SANITATION
	display_name = "Advanced Sanitation Technology"
	description = "纳米传讯最新的清洁技术，确保空间站保持一尘不染且无熊出没。"
	prereq_ids = list(TECHWEB_NODE_OFFICE_EQUIP)
	design_ids = list(
		"advmop",
		"light_replacer",
		"spraybottle",
		"paint_remover",
		"beartrap",
		"buffer",
		"vacuum",
		"washing_machine",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	discount_experiments = list(/datum/experiment/scanning/random/janitor_trash = TECHWEB_TIER_2_POINTS)
	announce_channels = list(RADIO_CHANNEL_SERVICE)

/datum/techweb_node/consoles
	id = TECHWEB_NODE_CONSOLES
	display_name = "Civilian Consoles"
	description = "为非技术性船员设计的用户友好控制台，增强沟通和对重要空间站信息的访问。"
	prereq_ids = list(TECHWEB_NODE_OFFICE_EQUIP)
	design_ids = list(
		"comconsole",
		"automated_announcement",
		"cargo",
		"cargorequest",
		"med_data",
		"crewconsole",
		"bankmachine",
		"account_console",
		"idcard",
		"c-reader",
		"libraryconsole",
		"libraryscanner",
		"bookbinder",
		"barcode_scanner",
		"vendor",
		"custom_vendor_refill",
		"bounty_pad_control",
		"bounty_pad",
		"digital_clock_frame",
		"telescreen_research",
		"telescreen_ordnance",
		"telescreen_interrogation",
		"telescreen_prison",
		"telescreen_bar",
		"telescreen_entertainment",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(RADIO_CHANNEL_SERVICE)

/datum/techweb_node/consoles/New()
	var/has_monastery = CHECK_MAP_JOB_CHANGE(JOB_CHAPLAIN, "has_monastery")
	if(has_monastery)
		design_ids += "telescreen_monastery"
	return ..()

/datum/techweb_node/gaming
	id = TECHWEB_NODE_GAMING
	display_name = "Gaming"
	description = "为空间站上的懒鬼们准备。"
	prereq_ids = list(TECHWEB_NODE_CONSOLES)
	design_ids = list(
		"arcade_battle",
		"arcade_orion",
		"slotmachine",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	discount_experiments = list(/datum/experiment/physical/arcade_winner = TECHWEB_TIER_2_POINTS)

// Kitchen root node
/datum/techweb_node/cafeteria_equip
	id = TECHWEB_NODE_CAFETERIA_EQUIP
	starting_node = TRUE
	display_name = "Cafeteria Equipment"
	description = "当标准配给的管状食物再也无法满足空间站船员的胃口时……"
	design_ids = list(
		"griddle",
		"microwave",
		"bowl",
		"plate",
		"oven_tray",
		"servingtray",
		"tongs",
		"spoon",
		"fork",
		"kitchen_knife",
		"plastic_spoon",
		"plastic_fork",
		"plastic_knife",
		"shaker",
		"drinking_glass",
		"shot_glass",
		"coffee_cartridge",
		"coffeemaker",
		"coffeepot",
		"syrup_bottle",
		"foodtray",
		"restaurant_portal",
	)

/datum/techweb_node/food_proc
	id = TECHWEB_NODE_FOOD_PROC
	display_name = "Food Processing"
	description = "来自纳米传讯的顶级厨房设备，旨在让船员吃饱吃好，保持愉快。"
	prereq_ids = list(TECHWEB_NODE_CAFETERIA_EQUIP)
	design_ids = list(
		"deepfryer",
		"oven",
		"stove",
		"range",
		"processor",
		"gibber",
		"monkey_recycler",
		"reagentgrinder",
		"microwave_engineering",
		"smartfridge",
		"dehydrator",
		"sheetifier",
		"fat_sucker",
		"dish_drive",
		"roastingstick",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	announce_channels = list(RADIO_CHANNEL_SERVICE)

// Fishing root node
/datum/techweb_node/fishing_equip
	id = TECHWEB_NODE_FISHING_EQUIP
	starting_node = TRUE
	display_name = "Fishing Equipment"
	description = "为空间站环境量身定制的基本钓鱼装备，非常适合外星水域的垂钓活动。"
	design_ids = list(
		"fishing_portal_generator",
		"fishing_rod",
		"fish_case",
		"aquarium_kit",
	)

/datum/techweb_node/fishing_equip_adv
	id = TECHWEB_NODE_FISHING_EQUIP_ADV
	display_name = "Advanced Fishing Tools"
	description = "钓鱼技术的持续进步，将尖端功能融入太空钓鱼作业中。只是别对太空鲤鱼用这个……"
	prereq_ids = list(TECHWEB_NODE_FISHING_EQUIP)
	design_ids = list(
		"fishing_rod_tech",
		"fishing_gloves",
		"mod_fishing",
		"stabilized_hook",
		"auto_reel",
		"fish_analyzer",
		"bluespace_fish_case",
		"bluespace_fish_tank_kit",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	required_experiments = list(/datum/experiment/scanning/fish)

/datum/techweb_node/marine_util
	id = TECHWEB_NODE_MARINE_UTIL
	display_name = "Marine Utility"
	description = "鱼观赏起来固然不错，但它们也能派上用场。"
	prereq_ids = list(TECHWEB_NODE_FISHING_EQUIP_ADV)
	design_ids = list(
		"bioelec_gen",
		"bluespace_reel",
		"fish_genegun",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	// only available if you've done the first fishing experiment (thus unlocking fishing tech), but not a strict requirement to get the tech
	discount_experiments = list(/datum/experiment/scanning/fish/second = TECHWEB_TIER_3_POINTS)
