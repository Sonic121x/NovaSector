/datum/contractor_item
	/// Name of the item datum
	var/name
	/// Description of the item datum
	var/desc
	/// Item path to spawn, no item path means you need to override `handle_purchase()`
	var/item
	/// fontawesome icon to use inside the hub - https://fontawesome.com/icons/
	var/item_icon = "broadcast-tower"
	/// Any number above 0 for how many times it can be bought in a round for a single traitor. -1 is unlimited.
	var/limited = -1
	/// Cost of the item in contract rep.
	var/cost

/// Subtract cost, and spawn if it's an item.
/datum/contractor_item/proc/handle_purchase(datum/contractor_hub/hub, mob/living/user)

	if(hub.contract_rep >= cost)
		hub.contract_rep -= cost
	else
		return FALSE

	if(limited >= 1)
		limited -= 1
	else
		return FALSE

	hub.purchased_items.Add(src)

	user.playsound_local(user, 'sound/machines/uplink/uplinkpurchase.ogg', 100)

	if(item)
		var/atom/item_to_create = new item(get_turf(user))
		if(user.put_in_hands(item_to_create))
			to_chat(user, span_notice("你购买的物品出现在了你手中！"))
		else
			to_chat(user, span_notice("你购买的物品出现在了地板上。"))

	return TRUE

/datum/contractor_item/contract_reroll
	name = "合同重掷"
	desc = "请求重掷你当前的合同列表。将为你当前可用的合同生成新的目标、报酬和投放点。"
	item_icon = "dice"
	limited = 3
	cost = 0

/datum/contractor_item/contract_reroll/handle_purchase(datum/contractor_hub/hub)
	. = ..()

	if(!(.))
		return
	// We're not regenerating already completed/aborted/extracting contracts, but we don't want to repeat their targets.
	var/list/new_target_list = list()
	for(var/datum/syndicate_contract/contract_check as anything in hub.assigned_contracts)
		if (contract_check.status != CONTRACT_STATUS_ACTIVE && contract_check.status != CONTRACT_STATUS_INACTIVE)
			if (contract_check.contract.target)
				new_target_list.Add(contract_check.contract.target)
			continue

	// Reroll contracts without duplicates
	for(var/datum/syndicate_contract/rerolling_contract as anything in hub.assigned_contracts)
		if (rerolling_contract.status != CONTRACT_STATUS_ACTIVE && rerolling_contract.status != CONTRACT_STATUS_INACTIVE)
			continue

		rerolling_contract.generate(new_target_list)
		new_target_list.Add(rerolling_contract.contract.target)

	// Set our target list with the new set we've generated.
	hub.assigned_targets = new_target_list

/datum/contractor_item/contractor_pinpointer
	name = "合约工定位仪"
	desc = "一种即使目标防护服传感器未激活也能定位的仪器。由于利用了系统内的一个漏洞，其定位精度无法与传统型号相比。首次激活后将被永久锁定给该用户。"
	item = /obj/item/pinpointer/crew/contractor
	item_icon = "search-location"
	limited = 2
	cost = 1

/datum/contractor_item/fulton_extraction_kit
	name = "富尔顿提取套件"
	desc = "用于将你的目标运过空间站，送达那些难以抵达的交接点。将信标放置在安全位置，并连接背包。对目标激活背包会将其传送至信标处——但要确保他们不会直接跑掉！"
	item = /obj/item/storage/box/contractor/fulton_extraction
	item_icon = "parachute-box"
	limited = 1
	cost = 1

/datum/contractor_item/contractor_partner
	name = "增援"
	desc = "Upon purchase we'll contact available units in the area. Should there be an agent free, we'll send them down to assist you immediately. If no units are free, we give a full refund."
	item_icon = "user-friends"
	limited = 1
	cost = 2

/datum/contractor_item/blackout
	name = "停电"
	desc = "请求辛迪加指挥部干扰空间站的电网。使整个空间站断电一小段时间。"
	item_icon = "bolt"
	limited = 2
	cost = 2

/datum/contractor_item/blackout/handle_purchase(datum/contractor_hub/hub)
	. = ..()

	if(!.)
		return
	power_fail(35, 50)
	priority_announce("Abnormal activity detected in [station_name()]'s powernet. As a precautionary measure, the station's power will be shut off for an indeterminate duration.", "Critical Power Failure", ANNOUNCER_POWEROFF)

/datum/contractor_item/comms_blackout
	name = "通讯中断"
	desc = "请求辛迪加指挥部禁用空间站的电信系统。使整个空间站的电信中断中等时长。"
	item_icon = "phone-slash"
	limited = 2
	cost = 2

/datum/contractor_item/comms_blackout/handle_purchase(datum/contractor_hub/hub)
	. = ..()

	if(!.)
		return
	var/datum/round_event_control/event = locate(/datum/round_event_control/communications_blackout) in SSevents.control
	event.run_event()

/datum/contractor_item/mod_magnetic_suit
	name = "磁力部署模块"
	desc = "一个利用磁力大幅缩短MOD防护服部署与收回所需时间的模块。"
	item = /obj/item/mod/module/springlock/contractor
	item_icon = "magnet"
	limited = 1
	cost = 2

/datum/contractor_item/mod_scorpion_hook
	name = "SCORPION钩爪模块"
	desc = "一个允许你从MOD防护服发射硬光钩爪的模块，可将目标拉入你的警棍攻击范围。"
	item = /obj/item/mod/module/scorpion_hook
	item_icon = "arrow-left" //replace if fontawesome gets an actual hook icon
	limited = 1
	cost = 3
