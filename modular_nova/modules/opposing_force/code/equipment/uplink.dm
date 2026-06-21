/datum/opposing_force_equipment/uplink
	category = OPFOR_EQUIPMENT_CATEGORY_CLOTHING_UPLINK

//Uplinks
/datum/opposing_force_equipment/uplink/uplink_old_radio
	item_type = /obj/item/uplink/old_radio
	name = "旧辛迪加上行链路"
	description = "一个老派的辛迪加上行链路，没有密码且TC账户为空。非常适合有抱负的特工。"
	admin_note = "Traitor uplink without telecrystals."

/datum/opposing_force_equipment/uplink/uplink_implant
	item_type = /obj/item/implanter/uplink
	name = "辛迪加上行链路植入器"
	admin_note = "Implanter for a Traitor uplink with no TC."

/datum/opposing_force_equipment/uplink/tc1
	item_type = /obj/item/stack/telecrystal
	name = "1 颗原始远距水晶"
	description = "最原始、最纯净形态的远距水晶；可用于激活的上行链路以增加其远距水晶数量。"

/datum/opposing_force_equipment/uplink/tc5
	item_type = /obj/item/stack/telecrystal/five
	name = "5 颗原始远距水晶"
	description = "一堆最原始、最纯净形态的远距水晶；可用于激活的上行链路以增加其远距水晶数量。"

/datum/opposing_force_equipment/uplink/tc10
	item_type = /obj/item/stack/telecrystal/twenty
	name = "20 颗原始远距水晶"
	description = "一捆最原始、最纯净形态的远距水晶；可用于激活的上行链路以增加其远距水晶数量。"

/datum/opposing_force_equipment/uplink/c10k
	name = "10000 太空现金钞票"
	item_type = /obj/item/stack/spacecash/c10000
	description = "冷冰冰的硬通货。"

//Tot powers
/datum/opposing_force_equipment/uplink/changeling
	item_type = /obj/item/antag_granter/changeling
	name = "变种人注射器"
	description = "一个重型注射器，内含一种高传染性病毒，能将使用者变成\"化形者\"。"
	admin_note = "Changeling antag granter."

/datum/opposing_force_equipment/uplink/heretic
	item_type = /obj/item/antag_granter/heretic
	name = "异端之书"
	description = "一本紫色的书，上面有一只诡异的眼睛，能将人变成\"异教徒\"，与遗忘之神融为一体。"
	admin_note = "Heretic antag granter."

/datum/opposing_force_equipment/uplink/clock_cult
	item_type = /obj/item/antag_granter/clock_cultist
	name = "发条装置"
	description = "一个黄铜制成的齿轮状装置，中心悬浮着一片玻璃透镜。能将人变成\"齿轮教团信徒\"。"
	admin_note = "Clockwork Cultist (solo) antag granter."

//Services
/datum/opposing_force_equipment/uplink/give_exploitables
	name = "可利用物访问权限"
	description = "你将获得一个可查看某些船员可利用信息的网络，可通过动词或检视查看。"
	item_type = /obj/effect/gibspawner/generic
	admin_note = "Same effect as using the traitor panel Toggle Exploitables Override button. Usually safe to give."

/datum/opposing_force_equipment/uplink/give_exploitables/on_issue(mob/living/target)
	target.mind.has_exploitables_override = TRUE
	target.mind.handle_exploitables()

/datum/opposing_force_equipment/uplink/custom_announcement
	name = "自定义公告"
	item_type = /obj/item/device/traitor_announcer
	admin_note = "Ask players to put the message inside the 'Reason' box, the item adminlogs but won't give a chance to preview. Can be VV'd to give more 'uses'."
	description = "一个一次性设备，可让你发布一条根据你选择定制的公告。"

/datum/opposing_force_equipment/uplink/power_outage
	name = "电力中断"
	description = "一个病毒将被上传至工程处理服务器，强制进行例行电网检查，导致空间站上所有APC暂时停用。"
	item_type = /obj/effect/gibspawner/generic
	admin_note = "Equivalent to the Grid Check random event."
	max_amount = 1

/datum/opposing_force_equipment/uplink/power_outage/on_issue()
	var/datum/round_event_control/event = locate(/datum/round_event_control/grid_check) in SSevents.control
	event.run_event()

/datum/opposing_force_equipment/uplink/telecom_outage
	name = "电信中断"
	description = "一个病毒将被上传至电信处理服务器，使其暂时停用。"
	item_type = /obj/effect/gibspawner/generic
	admin_note = "Equivalent to the Communications Blackout random event."
	max_amount = 1

/datum/opposing_force_equipment/uplink/telecom_outage/on_issue()
	var/datum/round_event_control/event = locate(/datum/round_event_control/communications_blackout) in SSevents.control
	event.run_event()

/datum/opposing_force_equipment/uplink/market_crash
	name = "市场崩溃"
	description = "一些伪造文件将被提交给纳米传讯，导致所有站内售货机的价格在短时间内飙升。"
	item_type = /obj/effect/gibspawner/generic
	admin_note = "Equivalent to the Market Crash random event."
	max_amount = 1

/datum/opposing_force_equipment/uplink/market_crash/on_issue()
	var/datum/round_event_control/event = locate(/datum/round_event_control/market_crash) in SSevents.control
	event.run_event()
