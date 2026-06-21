#define MIN_ENERGY_COST (0.01 * STANDARD_CELL_CHARGE)
#define MAX_ENERGY_COST (0.5 * STANDARD_CELL_CHARGE)

//Used by engineering cyborgs in place of generic circuits.
/obj/item/electroadaptive_pseudocircuit
	name = "电适应伪电路"
	desc = "一个集电路印刷、设计、合成、装配、创造和烹饪于一体的全能设备。在建造过程中，它可以替代任何通用电路板使用。"
	icon = 'icons/obj/devices/circuitry_n_data.dmi'
	icon_state = "boris"
	w_class = WEIGHT_CLASS_TINY
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 0.5, /datum/material/glass = SMALL_MATERIAL_AMOUNT * 3)
	var/recharging = FALSE
	var/circuits = 5 //How many circuits the pseudocircuit has left
	var/static/recycleable_circuits = typecacheof(list(
		/obj/item/electronics/firelock,
		/obj/item/electronics/airalarm,
		/obj/item/electronics/firealarm,
		/obj/item/electronics/apc,
	))//A typecache of circuits consumable for material

/obj/item/electroadaptive_pseudocircuit/Initialize(mapload)
	. = ..()
	maptext = MAPTEXT(circuits)

/obj/item/electroadaptive_pseudocircuit/examine(mob/user)
	. = ..()
	if(iscyborg(user))
		. += "[span_notice("It has material for <b>[circuits]</b> circuit[circuits == 1 ? "" : "s"]. Use the pseudocircuit on existing circuits to gain material.")]\n"+\
		"[span_notice("Serves as a substitute for <b>fire/air alarm</b>, <b>firelock</b>, and <b>APC</b> electronics.")]\n"+\
		span_notice("它也可以在区域电力控制器没有电源单元时，以高功耗<b>制造一个低容量单元</b>。")

/obj/item/electroadaptive_pseudocircuit/proc/adapt_circuit(mob/living/silicon/robot/R, circuit_cost = 0)
	if(QDELETED(R) || !istype(R))
		return
	if(!R.cell)
		to_chat(R, span_warning("你需要安装一个电源单元才能进行此操作。"))
		return
	if(recharging)
		to_chat(R, span_warning("[src] 需要一些时间先充能。"))
		return
	if(!R.cell.use(circuit_cost))
		to_chat(R, span_warning("你没有足够的能量进行此操作（需要[display_energy(circuit_cost)]。）"))
		return
	if(!circuits)
		to_chat(R, span_warning("你需要更多材料。使用[src]分解现有的简单电路板来获取材料。"))
		return
	playsound(R, 'sound/items/tools/rped.ogg', 50, TRUE)
	recharging = TRUE
	circuits--
	maptext = MAPTEXT(circuits)
	icon_state = "[initial(icon_state)]_recharging"
	var/recharge_time = (circuit_cost - MIN_ENERGY_COST) / (MAX_ENERGY_COST - MIN_ENERGY_COST)
	recharge_time = clamp(recharge_time, 0, 1)
	recharge_time = (5 SECONDS) + (55 SECONDS) * recharge_time //anywhere between 5 seconds to 1 minute
	addtimer(CALLBACK(src, PROC_REF(recharge)), ROUND_UP(recharge_time))
	return TRUE //The actual circuit magic itself is done on a per-object basis

/obj/item/electroadaptive_pseudocircuit/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!is_type_in_typecache(interacting_with, recycleable_circuits))
		return NONE
	circuits++
	maptext = MAPTEXT(circuits)
	user.visible_message(
		span_notice("用户用[interacting_with]分解了[src]。"),
		span_notice("你将[interacting_with]回收到[src]中。它现在有足够制造<b>[circuits]</b>个电路板的材料。")
	)
	playsound(user, 'sound/items/deconstruct.ogg', 50, TRUE)
	qdel(interacting_with)
	return ITEM_INTERACT_SUCCESS

/obj/item/electroadaptive_pseudocircuit/proc/recharge()
	playsound(src, 'sound/machines/chime.ogg', 25, TRUE)
	recharging = FALSE
	icon_state = initial(icon_state)

#undef MIN_ENERGY_COST
#undef MAX_ENERGY_COST
