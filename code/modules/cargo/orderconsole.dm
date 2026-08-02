// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/machinery/computer/cargo
	name = "supply console"
	desc = "Used to order supplies, approve requests, and control the shuttle."
	icon_state = MAP_SWITCH("computer", "/obj/machinery/computer/cargo")
	icon_screen = "supply"
	circuit = /obj/item/circuitboard/computer/cargo
	light_color = COLOR_BRIGHT_ORANGE

	///Can the supply console send the shuttle back and forth? Used in the UI backend.
	var/can_send = TRUE
	///Can this console only send requests? Typically used at the cargo front desk for pedestrians.
	var/requestonly = FALSE
	///Can you approve requests placed for cargo? Works differently between the app and the computer.
	var/can_approve_requests = TRUE
	var/contraband = FALSE
	var/self_paid = FALSE
	var/safety_warning = "For safety and ethical reasons, the automated supply shuttle cannot transport live organisms, \
		human remains, classified nuclear weaponry, mail, undelivered departmental order crates, syndicate bombs, \
		homing beacons, unstable eigenstates, fax machines, or machinery housing any form of artificial intelligence."
	var/blockade_warning = "Bluespace instability detected. Shuttle movement impossible."
	/// var that tracks message cooldown
	var/message_cooldown
	var/list/loaded_coupons
	/// var that makes express console use rockets
	var/is_express = FALSE
	///The name of the shuttle template being used as the cargo shuttle. 'cargo' is default and contains critical code. Don't change this unless you know what you're doing.
	var/cargo_shuttle = "cargo"
	///The docking port called when returning to the station.
	var/docking_home = "cargo_home"
	///The docking port called when leaving the station.
	var/docking_away = "cargo_away"
	///If this console can loan the cargo shuttle. Set to false to disable.
	var/stationcargo = TRUE
	///The account this console processes and displays. Independent from the account the shuttle processes.
	var/cargo_account = ACCOUNT_CAR
	///Interface name for the ui_interact call for different subtypes.
	var/interface_type = "Cargo"

/obj/machinery/computer/cargo/request
	name = "supply request console"
	desc = "Used to request supplies from cargo."
	icon_screen = "request"
	circuit = /obj/item/circuitboard/computer/cargo/request
	can_send = FALSE
	can_approve_requests = FALSE
	requestonly = TRUE

/obj/machinery/computer/cargo/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/trade_chip))
		return NONE
	var/obj/item/trade_chip/contract = tool
	contract.try_to_unlock_contract(user)
	return ITEM_INTERACT_SUCCESS

/obj/machinery/computer/cargo/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return FALSE
	if(user)
		if (emag_card)
			user.visible_message(span_warning(LANG("obj.f9eb3449", list(user, emag_card, src))))
		to_chat(user, span_notice(LANG("obj.7f25b3b6", list(src))))

	obj_flags |= EMAGGED
	contraband = TRUE

	// This also permanently sets this on the circuit board
	var/obj/item/circuitboard/computer/cargo/board = circuit
	board.contraband = TRUE
	board.obj_flags |= EMAGGED
	update_static_data(user)
	return TRUE

/obj/machinery/computer/cargo/on_construction(mob/user)
	. = ..()
	circuit.configure_machine(src)

/obj/machinery/computer/cargo/ui_interact(mob/user, datum/tgui/ui)
	. = ..()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, interface_type, name)
		ui.open()

/obj/machinery/computer/cargo/ui_data()
	var/list/data = list()
	data["department"] = "Cargo" // Hardcoded here, for customization in budgetordering.dm AKA NT IRN
	data["location"] = SSshuttle.supply.getStatusText()
	var/datum/bank_account/bank = SSeconomy.get_dep_account(cargo_account)
	if(bank)
		data["points"] = bank.account_balance
	data["grocery"] = SSshuttle.chef_groceries.len
	data["away"] = SSshuttle.supply.getDockedId() == docking_away
	data["self_paid"] = self_paid
	data["docked"] = SSshuttle.supply.mode == SHUTTLE_IDLE
	data["loan"] = !!SSshuttle.shuttle_loan
	data["loan_dispatched"] = SSshuttle.shuttle_loan && SSshuttle.shuttle_loan.dispatched
	data["can_send"] = can_send
	data["can_approve_requests"] = can_approve_requests
	data["requestonly"] = requestonly
	var/message = "Remember to stamp and send back the supply manifests."
	if(SSshuttle.centcom_message)
		message = SSshuttle.centcom_message
	if(SSshuttle.supply_blocked)
		message = blockade_warning
	data["message"] = message

	var/cart_list = list()
	for(var/datum/supply_order/order in SSshuttle.shopping_list)
		if(cart_list[order.pack.name])
			cart_list[order.pack.name][1]["amount"]++
			cart_list[order.pack.name][1]["cost"] += order.get_final_cost()
			if(order.department_destination)
				cart_list[order.pack.name][1]["dep_order"]++
			if(!isnull(order.paying_account))
				cart_list[order.pack.name][1]["paid"]++
			continue

		cart_list[order.pack.name] = list(list(
			"cost_type" = order.cost_type,
			"object" = lang_reverse_text(order.pack.name), // NOVA EDIT CHANGE - I18N - ORIGINAL: "object" = order.pack.name, （显示用译名；act 回传经 lang_unreverse_text 还原英文比较，见 name_to_id/remove/modify）
			"cost" = order.get_final_cost(),
			"id" = order.id,
			"amount" = 1,
			"orderer" = order.orderer,
			"paid" = !isnull(order.paying_account), //number of orders purchased privatly
			"dep_order" = !!order.department_destination, //number of orders purchased by a department
			"can_be_cancelled" = order.can_be_cancelled,
		))
	data["cart"] = list()
	for(var/item_id in cart_list)
		data["cart"] += cart_list[item_id]


	data["requests"] = list()
	for(var/datum/supply_order/order in SSshuttle.request_list)
		var/datum/supply_pack/pack = order.pack
		data["requests"] += list(list(
			"object" = lang_reverse_text(pack.name), // NOVA EDIT CHANGE - I18N - ORIGINAL: "object" = pack.name,
			"cost" = pack.get_cost(),
			"orderer" = order.orderer,
			"reason" = order.reason,
			"id" = order.id,
			"account" = order.paying_account ? order.paying_account.account_holder : "Cargo Department"
		))

	return data

/obj/machinery/computer/cargo/ui_static_data(mob/user)
	var/list/data = list()
	data["max_order"] = CARGO_MAX_ORDER
	data["supplies"] = list()

	var/list/packs_by_group = get_packs_data_by_group()
	for(var/group in packs_by_group)
		var/list/available_packs = packs_by_group[group]
		if(!length(available_packs)) // Somehow????
			continue
		data["supplies"][group] = list(
			"name" = lang_reverse_text(group), // NOVA EDIT CHANGE - I18N - ORIGINAL: "name" = group, （分类名仅前端状态键，整串译显示=安全；单词类如 Armory 也覆盖）
			"packs" = available_packs,
		)

	data["displayed_currency_full_name"] = " [MONEY_NAME]"
	data["displayed_currency_name"] = " [MONEY_SYMBOL]"

	return data

/**
 * returns a list of supply pack ui data by group
 */
/obj/machinery/computer/cargo/proc/get_packs_data_by_group()
	var/list/packs_by_group = list()
	for(var/pack_id in SSshuttle.supply_packs)
		var/datum/supply_pack/pack = SSshuttle.supply_packs[pack_id]

		if(pack.order_flags & ORDER_INVISIBLE)
			continue

		if((pack.order_flags & ORDER_EMAG_ONLY) && !(obj_flags & EMAGGED))
			continue
		if((pack.order_flags & ORDER_SPECIAL) && !(pack.order_flags & ORDER_SPECIAL_ENABLED))
			continue

		if((pack.order_flags & ORDER_CONTRABAND) && !contraband)
			continue

		if(!is_express && (pack.order_flags & ORDER_POD_ONLY))
			continue
		// NOVA EDIT ADDITION START
		if (is_express && pack.express_lock && !bypass_express_lock)
			continue

		if(!(pack.console_flag & console_flag))
			continue
		// NOVA EDIT ADDITION END

		var/obj/item/first_item = length(pack.contains) > 0 ? pack.contains[1] : null
		var/list/packs = packs_by_group[pack.group]
		if(isnull(packs))
			packs = list()
			packs_by_group[pack.group] = packs

		packs += list(list(
			"name" = lang_reverse_text(pack.name), // NOVA EDIT CHANGE - I18N - ORIGINAL: "name" = pack.name, （目录显示用译名；add 走 id、openContents/搜索按此 name 在本地数据内匹配=译名一致安全；单词类 auto_name 包如 binoculars 也覆盖）
			"cost" = pack.get_cost() * get_discount(),
			"id" = pack_id,
			"desc" = lang_reverse_text(pack.desc || pack.name), // NOVA EDIT CHANGE - I18N: reverse the pack desc (SINK_VAR, display-only tooltip; exact match). ORIGINAL: "desc" = pack.desc || pack.name, // If there is a description, use it. Otherwise use the pack's name.
			"first_item_icon" = first_item?.icon,
			"first_item_icon_state" = first_item?.icon_state,
			"goody" = (pack.order_flags & ORDER_GOODY),
			"access" = pack.access,
			"contraband" = (pack.order_flags & ORDER_CONTRABAND),
			"contains" = pack.get_contents_ui_data(),
		))

	return packs_by_group

/**
 * returns the discount multiplier applied to all supply packs,
 * the discount is calculated as follows: pack_cost * get_discount()
 */
/obj/machinery/computer/cargo/proc/get_discount()
	return 1

/**
 * adds an supply pack to the checkout cart
 * * user - the mobe doing this order
 * * id - the type of pack to order
 * * amount - the amount to order. You may not order more then 10 things at once
 */
/obj/machinery/computer/cargo/proc/add_item(mob/user, id, amount = 1)
	if(is_express)
		return
	id = text2path(id) || id
	var/datum/supply_pack/pack = SSshuttle.supply_packs[id]
	if(!istype(pack))
		CRASH("Unknown supply pack id given by order console ui. ID: [id]")
	if(amount > CARGO_MAX_ORDER || amount < 1) // Holy shit fuck off
		CRASH("Invalid amount passed into add_item")

	if(((pack.order_flags & ORDER_EMAG_ONLY) && !(obj_flags & EMAGGED)) || ((pack.order_flags & ORDER_CONTRABAND) && !contraband) || (pack.order_flags & ORDER_POD_ONLY) || ((pack.order_flags & ORDER_SPECIAL) && !(pack.order_flags & ORDER_SPECIAL_ENABLED)))
		return

	var/name = "*None Provided*"
	var/rank = "*None Provided*"
	var/ckey = user.ckey
	if(ishuman(user))
		var/mob/living/carbon/human/human = user
		name = human.get_authentification_name()
		rank = human.get_assignment(hand_first = TRUE)
	else if(HAS_SILICON_ACCESS(user))
		name = user.real_name
		rank = "Silicon"

	var/datum/bank_account/account

	if(isliving(user))
		var/mob/living/living_user = user
		var/obj/item/card/id/id_card = living_user.get_idcard(TRUE)

		var/bypass = FALSE
		if(istype(id_card, /obj/item/card/id/advanced/chameleon)) //We'll bypass access restrictions
			bypass = TRUE

		account = id_card?.registered_account // We can still assign an account for request department purposes.
		if(self_paid)
			if(!istype(id_card))
				say(LANG("obj.9caa768c", null))
				return
			if(IS_DEPARTMENTAL_CARD(id_card))
				say(LANG("obj.eb8fcdad", list(src, id_card)))
				return
			if(!istype(account))
				say(LANG("obj.3ad4c193", null))
				return
			var/list/access = id_card.GetAccess()
			if((pack.access_view && !(pack.access_view in access)) && !bypass)
				say(LANG("obj.4e11fbde", list(id_card)))
				return

	// The list we are operating on right now
	var/list/working_list = SSshuttle.shopping_list
	var/reason = ""
	var/datum/bank_account/personal_department
	var/uses_cargo_budget = FALSE // NOVA EDIT ADDITION - boolean flag to check if we are using the cargo budget without doing excessive shenanigans.
	if(requestonly && !self_paid && (!(pack.order_flags & ORDER_GOODY) || (pack.order_flags & ORDER_DEPARTMENTAL_GOODY))) // NOVA EDIT CHANGE - should never have a dept goodie thats not a goody. ORIGINAL: if(requestonly && !self_paid && !(pack.order_flags & ORDER_GOODY))
		working_list = SSshuttle.request_list
		reason = tgui_input_text(user, LANG("obj.ba5380f4", null), name, max_length = MAX_MESSAGE_LEN)
		if(isnull(reason))
			return

		name = account?.account_holder
		if(account?.account_job)
			personal_department = SSeconomy.get_dep_account(account.account_job.paycheck_department)
			if(!(personal_department.account_holder == "Cargo Budget"))
				var/dept_choice = tgui_alert(user, LANG("obj.b7de779a", null), LANG("obj.a672d0c4", null), list("Cargo Budget", "[personal_department.account_holder]"))
				if(!dept_choice)
					return
				if(dept_choice == "Cargo Budget")
					personal_department = null
					uses_cargo_budget = TRUE // NOVA EDIT ADDITION
			// NOVA EDIT ADDITION START
			else
				uses_cargo_budget = TRUE // NOVA EDIT ADDITION
			// NOVA EDIT ADDITION END


		if(isliving(user))
			var/mob/living/living_user = user
			var/obj/item/card/id/id_card = living_user.get_idcard(TRUE)
			var/list/access = id_card?.GetAccess()
			if(!id_card || !living_user || !access)
				living_user = user
				id_card = living_user.get_idcard(TRUE)
			if(pack.access_view && !(pack.access_view in access) && personal_department)
				// We want to block cargo requests when a player is requesting a restricted pack that they don't have access to.
				// BUT only when it's requested with non-cargo funds, as cargo had direct oversight over their own purchases with their own budget.
				// HOWEVER, this shouldn't prevent someone from buying something using their own personal funds.
				say(LANG("obj.13fe6ebe", null))
				return

	if(((pack.order_flags & ORDER_GOODY) && (!(pack.order_flags & ORDER_DEPARTMENTAL_GOODY) || uses_cargo_budget)) && (!self_paid || !requestonly)) // NOVA EDIT CHANGE - ORIGINAL: if((pack.order_flags & ORDER_GOODY) && !self_paid)
		playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 50, FALSE)
		// NOVA EDIT CHANGE - ORIGINAL: say("ERROR: Small crates may only be purchased by private accounts.")
		// 上游只在「非私人购买」时拦，那句文案是准的。Nova 这条额外加了 `|| !requestonly`，
		// 于是主控台上无论开不开私人购买都会被拦——照抄上游文案就成了自相矛盾的提示
		// （玩家开了私人购买，机器还说「只能由私人账户购买」）。改成说清真正的限制。
		say(LANG("obj.47495ce9", null))
		return

	var/similar_count = SSshuttle.supply.get_order_count(pack)
	if(similar_count == OVER_ORDER_LIMIT)
		playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 50, FALSE)
		say(LANG("obj.6627f598", list(CARGO_MAX_ORDER)))
		return

	if(!self_paid)
		account = personal_department
		// NOVA EDIT ADDITION START
		if ((uses_cargo_budget || !requestonly) && ((pack.order_flags & ORDER_COMPANY) == ORDER_COMPANY))
			playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 50, FALSE)
			say(LANG("obj.90374cfb", null))
			return
		// NOVA EDIT ADDITION END

	amount = clamp(amount, 1, CARGO_MAX_ORDER - similar_count)
	for(var/count in 1 to amount)
		var/obj/item/coupon/applied_coupon
		for(var/obj/item/coupon/coupon_check in loaded_coupons)
			if(pack.type == coupon_check.discounted_pack)
				say(LANG("obj.2ad02099", list(round(coupon_check.discount_pct_off * 100))))
				coupon_check.moveToNullspace()
				applied_coupon = coupon_check
				break

		var/datum/supply_order/order = new(
			pack = pack,
			orderer = name,
			orderer_rank = rank,
			orderer_ckey = ckey,
			reason = reason,
			paying_account = account,
			coupon = applied_coupon,
		)
		working_list += order

	if(self_paid)
		say(LANG("obj.cf813d0c", list(account.account_holder)))
	if(requestonly && message_cooldown < world.time)
		aas_config_announce(/datum/aas_config_entry/cargo_orders_announcement, list("AMOUNT" = amount), src, list(RADIO_CHANNEL_SUPPLY), amount == 1 ? "Single Order" : "Multiple Orders")
		message_cooldown = world.time + 30 SECONDS
	. = TRUE

/**
 * removes an item from the checkout cart
 * * id - the id of the cart item to remove
 */
/obj/machinery/computer/cargo/proc/remove_item(id)
	for(var/datum/supply_order/order in SSshuttle.shopping_list)
		if(order.id != id)
			continue
		if(order.department_destination)
			say(LANG("obj.666c9c11", null))
			return FALSE
		if(order.applied_coupon)
			say(LANG("obj.93e2806e", null))
			order.applied_coupon.forceMove(get_turf(src))
		SSshuttle.shopping_list -= order
		qdel(order)
		return TRUE
	return FALSE
/**
 * maps the ordename displayed on the ui to its supply pack id
 * * order_name - the name of the order
 */
/obj/machinery/computer/cargo/proc/name_to_id(order_name)
	for(var/pack in SSshuttle.supply_packs)
		var/datum/supply_pack/supply = SSshuttle.supply_packs[pack]
		// NOVA EDIT CHANGE - I18N - ORIGINAL: if(order_name == supply.name)
		// 前端显示用译名（见 ui_data/ui_static_data 的 lang_reverse_text），回传的 order_name 可能是中文；
		// lang_unreverse_text 把它映回英文再比较（locale==en 时原样返回 → 与原逻辑等价）。
		if(order_name == supply.name || lang_unreverse_text(order_name) == supply.name)
			return pack
	return null

/obj/machinery/computer/cargo/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("send")
			if(!SSshuttle.supply.canMove())
				say(safety_warning)
				return
			if(SSshuttle.supply_blocked)
				say(blockade_warning)
				return

			if(SSshuttle.supply.getDockedId() == docking_home)
				SSshuttle.moveShuttle(cargo_shuttle, docking_away, TRUE)
				say(LANG("obj.c8889dde", null))
				ui.user.investigate_log("sent the supply shuttle away.", INVESTIGATE_CARGO)
			else
				//create the paper from the SSshuttle.shopping_list
				if(length(SSshuttle.shopping_list))
					var/obj/item/paper/requisition/requisition_paper = new(get_turf(src))
					requisition_paper.name = "requisition form - [server_timestamp(ic_time = TRUE)] (PT: [round_timestamp()])"
					var/requisition_text = "<h2>[station_name()] [lang_reverse_text("Supply Requisition")]</h2>" // NOVA EDIT - I18N - 单据标签反查（en locale no-op）
					requisition_text += "<hr/>"
					requisition_text += "[lang_reverse_text("Time of Order")]: [UNDERLINED_HTML_TEXT("[server_timestamp(ic_time = TRUE)]", "Shift Time: [round_timestamp()]")]<br/><br/>" // NOVA EDIT - I18N
					for(var/datum/supply_order/order as anything in SSshuttle.shopping_list)
						requisition_text += "<b>[lang_reverse_text(order.pack.name)]</b></br>" // NOVA EDIT CHANGE - i18n: pack 名反查 - ORIGINAL: [order.pack.name]
						requisition_text += "- [lang_reverse_text("Order ID")]: [order.id]</br>" // NOVA EDIT - I18N
						var/restrictions = SSid_access.get_access_desc(order.pack.access)
						if(restrictions)
							requisition_text += "- [lang_reverse_text("Access Restrictions")]: [restrictions]</br>" // NOVA EDIT - I18N
						requisition_text += "- [lang_reverse_text("Ordered by")]: [order.orderer] ([order.orderer_rank])</br>" // NOVA EDIT - I18N
						var/paying_account = order.paying_account
						if(paying_account)
							requisition_text += "- [lang_reverse_text("Paid Privately by")]: [order.paying_account.account_holder]<br/>" // NOVA EDIT - I18N
						var/reason = order.reason
						if(reason)
							requisition_text += "- [lang_reverse_text("Reason Given")]: [reason]</br>" // NOVA EDIT - I18N
						requisition_text += "</br></br>"
					requisition_paper.add_raw_text(requisition_text, advanced_html = TRUE)
					requisition_paper.color = "#9ef5ff"
					requisition_paper.update_appearance()

				ui.user.investigate_log("called the supply shuttle.", INVESTIGATE_CARGO)
				say(LANG("obj.8a1a83d6", list(SSshuttle.supply.timeLeft(600))))
				SSshuttle.moveShuttle(cargo_shuttle, docking_home, TRUE)

			. = TRUE
		if("loan")
			if(!SSshuttle.shuttle_loan)
				return
			if(SSshuttle.supply_blocked)
				say(blockade_warning)
				return
			else if(SSshuttle.supply.mode != SHUTTLE_IDLE)
				return
			else if(SSshuttle.supply.getDockedId() != docking_away)
				return
			else if(stationcargo != TRUE)
				return
			else
				SSshuttle.shuttle_loan.loan_shuttle()
				say(LANG("obj.a29fce78", null))
				ui.user.investigate_log("accepted a shuttle loan event.", INVESTIGATE_CARGO)
				ui.user.log_message("accepted a shuttle loan event.", LOG_GAME)
				. = TRUE
		if("add")
			return add_item(ui.user, params["id"])
		if("add_by_name")
			var/supply_pack_id = name_to_id(params["order_name"])
			if(!supply_pack_id)
				return
			return add_item(ui.user, supply_pack_id)
		if("remove")
			var/order_name = params["order_name"]
			//try removing at least one item with the specified name. An order may not be removed if it was from the department
			for(var/datum/supply_order/order in SSshuttle.shopping_list)
				if(order.pack.name != order_name && order.pack.name != lang_unreverse_text(order_name)) // NOVA EDIT CHANGE - I18N - ORIGINAL: if(order.pack.name != order_name) （译名回传，还原英文比较）
					continue
				if(remove_item(order.id))
					return TRUE

			return TRUE
		if("modify")
			var/order_name = params["order_name"]

			//clear out all orders with the above mentioned order_name name to make space for the new amount
			for(var/datum/supply_order/order in SSshuttle.shopping_list) //find corresponding order id for the order name
				if(order.pack.name == order_name || order.pack.name == lang_unreverse_text(order_name)) // NOVA EDIT CHANGE - I18N - ORIGINAL: if(order.pack.name == order_name) （译名回传，还原英文比较）
					remove_item(order.id)

			//now add the new amount stuff
			var/amount = text2num(params["amount"])
			if(amount == 0)
				return TRUE
			if(amount > CARGO_MAX_ORDER)
				return
			var/supply_pack_id = name_to_id(order_name) //map order name to supply pack id for adding
			if(!supply_pack_id)
				return
			return add_item(ui.user, supply_pack_id, amount)
		if("clear")
			//create copy of list else we will get runtimes when iterating & removing items on the same list SSshuttle.shopping_list
			var/list/shopping_cart = SSshuttle.shopping_list.Copy()
			for(var/datum/supply_order/cancelled_order in shopping_cart)
				if(cancelled_order.department_destination || !cancelled_order.can_be_cancelled)
					continue //don't cancel other department's orders or orders that can't be cancelled
				remove_item(cancelled_order.id) //remove & properly refund any coupons attached with this order
		if("approve")
			var/id = text2num(params["id"])
			for(var/datum/supply_order/SO in SSshuttle.request_list)
				if(SO.id == id)
					SSshuttle.request_list -= SO
					SSshuttle.shopping_list += SO
					. = TRUE
					break
		if("deny")
			var/id = text2num(params["id"])
			for(var/datum/supply_order/SO in SSshuttle.request_list)
				if(SO.id == id)
					SSshuttle.request_list -= SO
					. = TRUE
					break
		if("denyall")
			SSshuttle.request_list.Cut()
			. = TRUE
		if("toggleprivate")
			self_paid = !self_paid
			. = TRUE
	if(.)
		post_signal(cargo_shuttle)

/obj/machinery/computer/cargo/proc/post_signal(command)

	var/datum/radio_frequency/frequency = SSradio.return_frequency(FREQ_STATUS_DISPLAYS)

	if(!frequency)
		return

	var/datum/signal/status_signal = new(list("command" = command))
	frequency.post_signal(src, status_signal)

/datum/aas_config_entry/cargo_orders_announcement
	name = "Cargo Alert: New Orders"
	announcement_lines_map = list(
		"Single Order" = "A new order has been requested.",
		"Multiple Orders" = "%AMOUNT orders have been requested.",
	)
	vars_and_tooltips_map = list(
		"AMOUNT" = "will be replaced wuth number of orders.",
	)
