/obj/item/reagent_containers/cup/maunamug
	name = "莫纳马克杯"
	desc = "装在时髦马克杯里的饮品。现在自带加热功能！"
	icon = 'icons/obj/devices/mauna_mug.dmi'
	icon_state = "maunamug"
	base_icon_state = "maunamug"
	initial_reagent_flags = OPENCONTAINER
	fill_icon_state = "maunafilling"
	fill_icon_thresholds = list(25)
	var/obj/item/stock_parts/power_store/cell
	var/open = FALSE
	var/on = FALSE

/obj/item/reagent_containers/cup/maunamug/Initialize(mapload, vol)
	. = ..()
	AddElement(/datum/element/cuffable_item)
	cell = new /obj/item/stock_parts/power_store/cell(src)

/obj/item/reagent_containers/cup/maunamug/get_cell()
	return cell

/obj/item/reagent_containers/cup/maunamug/examine(mob/user)
	. = ..()
	. += span_notice("状态显示屏显示：当前温度：<b>[reagents.chem_temp]K</b> 当前电量：[cell ? "[cell.charge / cell.maxcharge * 100]%" : "No cell found"]。")
	if(open)
		. += span_notice("电池仓是打开的。")
	if(cell && cell.charge > 0)
		. += span_notice("<b>Ctrl+点击</b>来切换电源。")

/obj/item/reagent_containers/cup/maunamug/process(seconds_per_tick)
	..()
	if(on && (!cell || cell.charge <= 0)) //Check if we ran out of power
		change_power_status(FALSE)
		return FALSE
	cell.use(0.005 * STANDARD_CELL_RATE * seconds_per_tick) //Basic cell goes for like 200 seconds, bluespace for 8000
	if(!reagents.total_volume)
		return FALSE
	var/max_temp = min(500 + (500 * (0.2 * cell.rating)), 1000) // 373 to 1000
	reagents.adjust_thermal_energy(0.4 * cell.maxcharge * reagents.total_volume * seconds_per_tick, max_temp = max_temp) // 4 kelvin every tick on a basic cell. 160k on bluespace
	reagents.handle_reactions()
	update_appearance()
	if(reagents.chem_temp >= max_temp)
		change_power_status(FALSE)
		audible_message(span_notice("莫纳马克杯发出一声欢快的哔哔声，然后关闭了！"))
		playsound(src, 'sound/machines/chime.ogg', 50)

/obj/item/reagent_containers/cup/maunamug/Destroy()
	if(cell)
		QDEL_NULL(cell)
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/reagent_containers/cup/maunamug/item_ctrl_click(mob/user)
	if(on)
		change_power_status(FALSE)
	else
		if(!cell || cell.charge <= 0)
			return FALSE //No power, so don't turn on
		change_power_status(TRUE)
	return CLICK_ACTION_SUCCESS

/obj/item/reagent_containers/cup/maunamug/proc/change_power_status(status)
	on = status
	if(on)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)
	update_appearance()

/obj/item/reagent_containers/cup/maunamug/screwdriver_act(mob/living/user, obj/item/I)
	. = ..()
	open = !open
	to_chat(user, span_notice("你将电池仓拧到[src]上[open ? "open" : "closed"]了。"))
	update_appearance()

/obj/item/reagent_containers/cup/maunamug/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/stock_parts/power_store/cell))
		return ..()
	if(!open)
		to_chat(user, span_warning("必须打开电池仓才能放入能量电池！"))
		return ITEM_INTERACT_BLOCKING
	if(cell)
		to_chat(user, span_warning("里面已经有一个能量电池了！"))
		return ITEM_INTERACT_BLOCKING
	else if(!user.transferItemToLoc(tool, src))
		return ITEM_INTERACT_BLOCKING
	cell = tool
	user.visible_message(span_notice("[user]将一个能量电池放入[src]。"), span_notice("你将能量电池放入[src]。"))
	update_appearance()
	return ITEM_INTERACT_SUCCESS

/obj/item/reagent_containers/cup/maunamug/attack_hand(mob/living/user, list/modifiers)
	if(cell && open)
		user.put_in_hands(cell)
		cell = null
		to_chat(user, span_notice("你从[src]中取出了能量电池。"))
		on = FALSE
		update_appearance()
		return TRUE
	return ..()

/obj/item/reagent_containers/cup/maunamug/update_icon_state()
	if(open)
		icon_state = "[base_icon_state][cell ? null : "_no"]_bat"
		return ..()
	icon_state = "[base_icon_state][on ? "_on" : null]"
	return ..()

/obj/item/reagent_containers/cup/maunamug/update_overlays()
	. = ..()
	if(!reagents.total_volume || reagents.chem_temp < 400)
		return

	var/intensity = (reagents.chem_temp - 400) * 1 / 600 //Get the opacity of the incandescent overlay. Ranging from 400 to 1000
	var/mutable_appearance/mug_glow = mutable_appearance(icon, "maunamug_incand")
	mug_glow.alpha = 255 * intensity
	. += mug_glow
