

/obj/machinery/computer/order_console/mining
	name = "采矿设备订购台"
	desc = "为矿工准备的设备商店，在矿石回收机收集的点数可以在这里消费。"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "mining"
	icon_keyboard = null
	icon_screen = null
	circuit = /obj/item/circuitboard/computer/order_console/mining
	cooldown_time = 10 SECONDS //just time to let you know your order went through.
	cargo_cost_multiplier = 0.65
	express_cost_multiplier = 1
	purchase_tooltip = @{"您购买的商品将送达货物处，
并希望由他们派送。
比快递便宜35%。"}
	express_tooltip = @{"立即发送您购买的商品。"}
	credit_type = MONEY_MINING_SYMBOL

	order_categories = list(
		CATEGORY_MINING,
		CATEGORY_CONSUMABLES,
		CATEGORY_TOYS_DRONE,
		CATEGORY_PKA,
	)
	blackbox_key = "mining"
	announcement_line = "A shaft miner has ordered equipment which will arrive on the cargo shuttle! Please make sure it gets to them as soon as possible!"

/obj/machinery/computer/order_console/mining/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/voucher_redeemer, /obj/item/mining_voucher, /datum/voucher_set/mining)

/obj/machinery/computer/order_console/mining/subtract_points(final_cost, obj/item/card/id/card)
	if(final_cost <= card.registered_account.mining_points)
		card.registered_account.mining_points -= final_cost
		return TRUE
	return FALSE

/obj/machinery/computer/order_console/mining/order_groceries(mob/living/purchaser, obj/item/card/id/card, list/groceries)
	var/list/things_to_order = list()
	for(var/datum/orderable_item/item as anything in groceries)
		things_to_order[item.purchase_path] = groceries[item]

	var/datum/supply_pack/custom/mining_pack = new(
		purchaser = purchaser, \
		cost = get_total_cost(), \
		contains = things_to_order,
	)
	var/datum/supply_order/disposable/new_order = new(
		pack = mining_pack,
		orderer = purchaser,
		orderer_rank = "Mining Vendor",
		orderer_ckey = purchaser.ckey,
		reason = "",
		paying_account = card.registered_account,
		department_destination = null,
		coupon = null,
		charge_on_purchase = FALSE,
		manifest_can_fail = FALSE,
		cost_type = credit_type,
		can_be_cancelled = FALSE,
	)
	say("Thank you for your purchase! It will arrive on the next cargo shuttle!")
	aas_config_announce(/datum/aas_config_entry/order_console, list(), src, list(radio_channel), capitalize(blackbox_key))
	SSshuttle.shopping_list += new_order

/obj/machinery/computer/order_console/mining/retrieve_points(obj/item/card/id/id_card)
	return round(id_card.registered_account.mining_points)

/obj/machinery/computer/order_console/mining/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(!.)
		flick("mining-deny", src)

/obj/machinery/computer/order_console/mining/update_icon_state()
	icon_state = "[initial(icon_state)][powered() ? null : "-off"]"
	return ..()

/**********************Mining Equipment Voucher**********************/

/obj/item/mining_voucher
	name = "采矿代金券"
	desc = "用于兑换一件设备的代币。在采矿设备供应商处使用它。"
	icon = 'icons/obj/mining.dmi'
	icon_state = "mining_voucher"
	w_class = WEIGHT_CLASS_TINY

/**********************Mining Point Card**********************/

#define TO_USER_ID "Transfer Card → ID"
#define TO_POINT_CARD "ID → Transfer Card"

/obj/item/card/mining_point_card
	name = "矿点转移卡"
	desc = "一张可重复使用的小卡片，用于转移矿点。将您的ID卡划过它以开始转移过程。"
	icon_state = "data_1"

	///Amount of points this card contains.
	var/points = 0

/obj/item/card/mining_point_card/examine(mob/user)
	. = ..()
	. += span_notice("卡上有[points] point\s 。")

/obj/item/card/mining_point_card/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(!isidcard(attacking_item))
		return ..()
	var/obj/item/card/id/attacking_id = attacking_item
	balloon_alert(user, "开始转移")
	var/point_movement = tgui_alert(user, "转给ID（从卡中）还是转给卡（从ID中）？", "采矿点数转移", list(TO_USER_ID, TO_POINT_CARD))
	if(!point_movement)
		return
	var/amount = tgui_input_number(user, "你想转移多少？ID余额：[attacking_id.registered_account.mining_points]，卡余额：[points]", "转移点数", min_value = 0, round_value = 1)
	if(!amount)
		return
	switch(point_movement)
		if(TO_USER_ID)
			if(amount > points)
				amount = points
			attacking_id.registered_account.mining_points += amount
			points -= amount
			to_chat(user, span_notice("你从 [src] 向 [attacking_id] 转移了 [amount] 矿点。"))
		if(TO_POINT_CARD)
			if(amount > attacking_id.registered_account.mining_points)
				amount = attacking_id.registered_account.mining_points
			attacking_id.registered_account.mining_points -= amount
			points += amount
			to_chat(user, span_notice("你从 [attacking_id] 向 [src] 转移了 [amount] 矿点。"))

#undef TO_POINT_CARD
#undef TO_USER_ID
