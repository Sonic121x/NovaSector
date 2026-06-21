
#define TECHWEB_NODE_POWERATOR "powerator"

/obj/item/circuitboard/machine/powerator
	name = "能量转换器"
	desc = "电力交易器是一种允许空间站将电力出售给需要额外电源的其他空间站的机器。"
	greyscale_colors = CIRCUIT_COLOR_GENERIC
	build_path = /obj/machinery/powerator
	req_components = list(
		/obj/item/stack/sheet/glass = 1,
		/obj/item/stack/ore/bluespace_crystal/refined = 1,
		/obj/item/stack/cable_coil = 5,
		/datum/stock_part/capacitor = 5,
		/datum/stock_part/micro_laser = 1,
	)
	needs_anchored = TRUE

/datum/supply_pack/engineering/powerator
	name = "能量转换器"
	desc = "我们深知断电之苦，也明白中央供电的珍贵，现在轮到我们做同样的事了。所有收益将归入工程预算。"
	cost = CARGO_CRATE_VALUE * 50 // 10,000
	contains = list(/obj/item/circuitboard/machine/powerator)
	crate_name = "Powerator Circuitboard Crate"
	crate_type = /obj/structure/closet/crate

/datum/design/board/powerator
	name = "Powerator Board"
	desc = "允许建造用于制造能量转换器的电路板。"
	id = "powerator"
	build_path = /obj/item/circuitboard/machine/powerator
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_ENGINEERING,
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING

/datum/techweb_node/powerator
	id = TECHWEB_NODE_POWERATOR
	display_name = "Powerator"
	description = "我们过去曾被它拯救过，我们也应该输送一些电力！"
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(RADIO_CHANNEL_ENGINEERING)
	hidden = TRUE
	experimental = TRUE
	prereq_ids = list(TECHWEB_NODE_PARTS_ADV)
	design_ids = list(
		"powerator",
	)

// This produces 62 per 2 seconds, taxed to 49, which gives us 24-25 per second.
/obj/machinery/powerator
	name = "\improper 纳米传讯能量转换器"
	desc = "除了这个可笑的名字，它是为需要额外能源的电网运输和出售能量的标准设备！"
	icon = 'modular_nova/modules/powerator/icons/machines.dmi'
	icon_state = "powerator"

	density = TRUE
	circuit = /obj/item/circuitboard/machine/powerator
	idle_power_usage = 100

	/// the current amount of power that we are trying to process
	var/current_power = 10 KILO WATTS

	/// the max amount of power that can be sent per process, this var should be base + rating*5 at start to keep consistency. so goes from 3.25MJ to 10MJ as of this writting.
	var/max_power = 3250 KILO WATTS

	/// the base starting ratio for power
	var/power_base = 1000 KILO WATTS

	/// the rating change for the max power (upgrades)
	var/power_rating = 450 KILO WATTS

	/// power cap, if its 0 it will be ignored, otherwise caps the max power the system will have (better than using taxes for small operations)
	var/power_cap = 0

	/// how much power is needed to get 1 credit per two seconds. (And the mininum power you need to get credits.)
	var/divide_ratio = 160 KILO WATTS

	/// the attached cable to the machine
	var/obj/structure/cable/attached_cable

	/// how many credits this machine has actually made so far
	var/credits_made = 0

	/// What account is assigned to this?
	var/credits_account = ACCOUNT_ENG
	/// Percent of tax we deduct from people using the powerator, allowing easy adjustment for VV admins.
	var/tax = 20

/obj/machinery/powerator/Initialize(mapload)
	. = ..()
	attached_cable = locate() in get_turf(src)
	START_PROCESSING(SSobj, src)

/obj/machinery/powerator/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(attached_cable)
		UnregisterSignal(attached_cable, COMSIG_QDELETING)
		attached_cable = null

	return ..()

/obj/machinery/powerator/examine(mob/user)
	. = ..()
	. += "<br>"
	if(panel_open)
		. += span_warning("维护面板目前处于打开状态，导致[src]无法工作！")
	else
		. += span_notice("维护面板已关闭。")

	if(!anchored)
		. += span_warning("锚点没有固定在地板上，导致[src]无法工作！")
	else
		. += span_notice("锚点已用螺栓固定在地板上。")

	if(machine_stat & (NOPOWER | BROKEN))
		. += span_warning("存在损坏或没有电力供应，导致[src]无法工作！")
	else
		. += span_notice("没有损坏，正在供电。")

	if(isnull(attached_cable))
		. += span_warning("下方没有电源线，导致[src]无法工作！")
	else
		. += span_notice("下面有一根电源线。")

	. += span_notice("当前能量：[display_power(current_power, FALSE)]/[display_power(max_power, FALSE)]")
	. += span_notice("这台机器通过出售电力已赚取了[credits_made]信用点。")
	. += span_notice("这台机器每向外发送[display_power(divide_ratio, FALSE)]，每两秒就能赚取1信用点。")
	. += span_notice("这台机器被太阳联邦能源部征收[tax]%的信用点税。")

/obj/machinery/powerator/RefreshParts()
	. = ..()

	var/power_efficiency = 0
	for(var/datum/stock_part/capacitor/capacitor_part in component_parts)
		power_efficiency += capacitor_part.tier
	max_power = power_base + (power_efficiency * power_rating)


/obj/machinery/powerator/update_overlays()
	. = ..()

	cut_overlay("cable")
	cut_overlay("power")
	cut_overlay("work")

	if(isnull(attached_cable))
		add_overlay("cable")
		return

	if(!attached_cable.avail(power_to_energy(current_power)))
		add_overlay("power")
		return

	add_overlay("work")

/obj/machinery/powerator/process()
	update_appearance() //lets just update this
	if(machine_stat & (NOPOWER | BROKEN) || !anchored || panel_open || isnull(attached_cable)) //no power, broken, unanchored, maint panel open, or no cable? lets reset
		return

	if(current_power < 0)
		current_power = 0 //this is just for the fringe case, wouldn't want it to somehow produce power for money! unless...

	if(!attached_cable.avail(power_to_energy(current_power)))
		if(!attached_cable.newavail())
			return
		current_power = energy_to_power(attached_cable.newavail())

	if (power_cap)
		max_power = clamp(max_power, 0, power_cap)
	current_power = clamp(current_power, 0, max_power)

	if(current_power == 0)
		return

	attached_cable.add_delayedload(power_to_energy(current_power))

	var/datum/bank_account/primary_account = SSeconomy.get_dep_account(credits_account)
	var/money_ratio = round(current_power * (1/divide_ratio) * ((100-tax) / 100))
	primary_account.adjust_money(money_ratio)
	credits_made += money_ratio

/obj/machinery/powerator/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	current_power = tgui_input_number(user, "你想要抽取多少电力（以瓦特为单位）？最大值：[display_power(max_power, FALSE)]", "电力抽取", current_power, max_power, 0)
	if(isnull(current_power))
		return

/obj/machinery/powerator/screwdriver_act(mob/living/user, obj/item/tool)
	tool.play_tool_sound(src)
	panel_open = !panel_open
	if(panel_open)
		add_overlay("error")
		add_overlay("panel_open")
		cut_overlay("panel_close")

	else
		cut_overlay("error")
		cut_overlay("panel_open")
		add_overlay("panel_close")

	update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/machinery/powerator/on_set_machine_stat(old_value)
	. = ..()
	if(machine_stat & (NOPOWER | BROKEN))
		add_overlay("error")

	else
		cut_overlay("error")

/obj/machinery/powerator/crowbar_act(mob/user, obj/item/tool)
	return default_deconstruction_crowbar(user, tool)

/obj/machinery/powerator/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	default_unfasten_wrench(user, tool)
	if(anchored)
		var/turf/src_turf = get_turf(src)
		attached_cable = locate() in src_turf
		RegisterSignal(attached_cable, COMSIG_QDELETING, PROC_REF(on_cable_deleted), override = TRUE)
		cut_overlay("error")

	else
		add_overlay("error")
		attached_cable = null

	return ITEM_INTERACT_SUCCESS

/obj/machinery/powerator/proc/on_cable_deleted()
	SIGNAL_HANDLER

	UnregisterSignal(attached_cable, COMSIG_QDELETING)
	attached_cable = null

/obj/item/circuitboard/machine/powerator/syndicate
	name = "\improper 辛迪加能源机"
	build_path = /obj/machinery/powerator/syndicate

/obj/item/circuitboard/machine/powerator/interdyne
	name = "\improper 英特戴恩能源机"
	build_path = /obj/machinery/powerator/interdyne

/obj/item/circuitboard/machine/powerator/tarkon
	name = "\improper 塔肯能源机"
	build_path = /obj/machinery/powerator/tarkon

// This produces 25 per 2 seconds, no tax, so around 12 per second.
/obj/machinery/powerator/syndicate
	name = "\improper 辛迪加能源机"
	credits_account = ACCOUNT_DS2
	power_cap = 2500 KILO WATTS
	divide_ratio = 100 KILO WATTS
	tax = 0
	icon_state = "powerator_syndi"
	circuit = /obj/item/circuitboard/machine/powerator/syndicate

// This produces 25 per 2 seconds, taxed to 22-23, which gives us 11 per second.
/obj/machinery/powerator/interdyne
	name = "\improper 英特戴恩能源机"
	credits_account = ACCOUNT_INT
	power_cap = 1000 KILO WATTS
	divide_ratio = 40 KILO WATTS
	tax = 10
	icon_state = "powerator_dyne"
	circuit = /obj/item/circuitboard/machine/powerator/interdyne

// This produces 40 per 2 seconds, taxed to 28, which gives us 14 per second.
/obj/machinery/powerator/tarkon
	name = "\improper 塔肯能源机"
	credits_account = ACCOUNT_TI
	power_cap = 6000 KILO WATTS
	divide_ratio = 150 KILO WATTS
	tax = 30
	icon_state = "powerator_tarkon"
	circuit = /obj/item/circuitboard/machine/powerator/tarkon

#undef TECHWEB_NODE_POWERATOR
