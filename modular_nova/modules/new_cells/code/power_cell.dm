/obj/item/stock_parts/power_store/cell/crank
	name = "手摇电池"
	desc = "来吧，摇动它来充电。"
	icon = 'modular_nova/modules/new_cells/icons/power.dmi'
	icon_state = "crankcell"
	charge_light_type = "old"
	emp_damage_modifier = 0.5
	/// how much each crank will give the cell charge
	var/crank_amount = STANDARD_CELL_CHARGE * 0.1
	/// how fast it takes to crank to get the crank_amount
	var/crank_speed = 1 SECONDS
	/// how much gets discharged every process
	var/discharge_amount = STANDARD_CELL_CHARGE * 0.01

/obj/item/stock_parts/power_store/cell/crank/examine(mob/user)
	. = ..()
	. += span_notice("点击开始摇动电池。")

/obj/item/stock_parts/power_store/cell/crank/Initialize(mapload, override_maxcharge)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/stock_parts/power_store/cell/crank/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/stock_parts/power_store/cell/crank/process(seconds_per_tick)
	use(discharge_amount)

/obj/item/stock_parts/power_store/cell/crank/attack_self(mob/user)
	while(charge < maxcharge)
		if(!do_after(user, crank_speed, src))
			return
		give(crank_amount)
		playsound(src, 'modular_nova/modules/new_cells/sound/crank.ogg', 25, FALSE)

/obj/item/stock_parts/power_store/cell/self_charge
	name = "充电电池"
	desc = "一种特殊的电池，会随时间自行充电。"
	icon = 'modular_nova/modules/new_cells/icons/power.dmi'
	icon_state = "chargecell"
	maxcharge = STANDARD_CELL_CHARGE * 5
	charge_light_type = "old"
	/// how much is recharged every process
	var/recharge_amount = STANDARD_CELL_CHARGE * 0.34

/obj/item/stock_parts/power_store/cell/self_charge/exotic
	name = "exotic charging cell"
	desc = "A special cell that will recharge itself over time. The casing doesn't seem to have seams."
	maxcharge = STANDARD_CELL_CHARGE * 15
	recharge_amount = STANDARD_CELL_CHARGE

/obj/item/stock_parts/power_store/cell/self_charge/anomalous
	name = "anomalous charge cell"
	desc = "A power cell of unfamiliar construction. Its casing is perfectly smooth, and it appears to recover energy on its own."
	maxcharge = STANDARD_CELL_CHARGE * 30
	recharge_amount = STANDARD_CELL_CHARGE * 2

/obj/item/stock_parts/power_store/cell/self_charge/Initialize(mapload, override_maxcharge)
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/stock_parts/power_store/cell/self_charge/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/stock_parts/power_store/cell/self_charge/process(seconds_per_tick)
	give(recharge_amount)
