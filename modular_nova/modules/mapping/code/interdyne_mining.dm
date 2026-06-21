/obj/item/circuitboard/computer/order_console/mining/interdyne
	name = "英特戴恩采矿设备供应商控制台"
	build_path = /obj/machinery/computer/order_console/mining/interdyne

// Interdyne/DS-2 mining equipment vendor that doesn't need a cargo shuttle to work

/obj/machinery/computer/order_console/mining/interdyne
	name = "因特戴恩采矿设备供应商"
	circuit = /obj/item/circuitboard/computer/order_console/mining/interdyne
	forced_express = TRUE
	express_cost_multiplier = 1
	order_categories = list(
		CATEGORY_MINING,
		CATEGORY_CONSUMABLES,
		CATEGORY_TOYS_DRONE,
		CATEGORY_PKA,
		CATEGORY_INTERDYNE,
	)

/obj/machinery/computer/order_console/mining/interdyne/Initialize(mapload)
	. = ..()
	RemoveElement(/datum/element/voucher_redeemer, /obj/item/mining_voucher, /datum/voucher_set/mining)
	AddElement(/datum/element/voucher_redeemer/interdyne, /obj/item/mining_voucher, /datum/voucher_set/mining)

/datum/element/voucher_redeemer/interdyne/generate_sets()
	..()
	qdel(set_instances[/datum/voucher_set/mining/minebot_kit::name])
	set_instances[/datum/voucher_set/mining/minebot_kit::name] = new /datum/voucher_set/interdyne/minebot_kit

/mob/living/basic/mining_drone/interdyne
	name = "\improper 因特戴恩采矿机器人"
	faction = list(FACTION_NEUTRAL, ROLE_INTERDYNE_PLANETARY_BASE)

/datum/voucher_set/interdyne/minebot_kit
	name = "采矿机器人套件"
	description = "包含一个能帮你储存矿石和狩猎野生动物的小型矿工机器人伙伴。还附带一个升级版工业焊接工具（80单位）、一个焊接面罩以及一个能让射击穿透矿工机器人的动能加速器改装套件。"
	icon = 'icons/mob/silicon/aibots.dmi'
	icon_state = "mining_drone"
	set_items = list(
		/mob/living/basic/mining_drone/interdyne,
		/obj/item/weldingtool/hugetank,
		/obj/item/clothing/head/utility/welding,
		/obj/item/borg/upgrade/modkit/minebot_passthrough,
	)
