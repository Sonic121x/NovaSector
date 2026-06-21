#define MAX_TRANSFER 9

///it splits the reagents however you want. So you can "every 60 units, 45 goes left and 15 goes straight". The side direction is EAST, you can change this in the component
/obj/machinery/plumbing/splitter
	name = "化学分离器"
	desc = "一种用于智能化学分解的化学分离器。它会等待直至设定的条件得到满足，随后停止所有输入，并将缓冲液均匀（或按其他方式）分配至两条输出管道中。"
	icon_state = "splitter"
	buffer = 100
	density = FALSE

	///how much we must transfer straight(SOUTH)
	var/transfer_straight = 5
	///how much we must transfer to the left(EAST)
	var/transfer_left = 5
	///how much we must transfer to the right(WEST)
	var/transfer_right = 5

/obj/machinery/plumbing/splitter/Initialize(mapload, layer)
	. = ..()
	AddComponent(/datum/component/plumbing/multidirectional/splitter, layer)

/obj/machinery/plumbing/splitter/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChemSplitter", name)
		ui.set_autoupdate(FALSE)
		ui.open()

/obj/machinery/plumbing/splitter/ui_static_data(mob/user)
	return list(
		max_transfer = MAX_TRANSFER
	)

/obj/machinery/plumbing/splitter/ui_data(mob/user)
	return list(
		straight = transfer_straight,
		left = transfer_left,
		right = transfer_right,
	)

/obj/machinery/plumbing/splitter/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("set_amount")
			var/value = text2num(params["amount"])
			if(!value)
				return FALSE
			value = clamp(value, 1, MAX_TRANSFER)

			switch(params["target"])
				if("straight")
					transfer_straight = value
					return TRUE

				if("left")
					transfer_left = value
					return TRUE

				if("right")
					transfer_right = value
					return TRUE

#undef MAX_TRANSFER
