// APC HULL
/obj/item/wallframe/apc
	name = "\improper APC frame"
	desc = "用于维修或建造APC。"
	icon_state = "apc"
	result_path = /obj/machinery/power/apc/auto_name

/obj/item/wallframe/apc/try_build(turf/on_wall, user)
	var/turf/T = get_turf(on_wall) //the user is not where it needs to be.
	var/area/A = get_area(user)
	if(A.apc)
		to_chat(user, span_warning("这个区域已经有一个APC了！"))
		return FALSE //only one APC per area
	if(!A.requires_power || A.always_unpowered)
		to_chat(user, span_warning("你不能在此区域放置[src]！"))
		return FALSE //can't place apcs in areas with no power requirement
	for(var/obj/machinery/power/terminal/E in T)
		if(E.master)
			to_chat(user, span_warning("这里已有另一个网络终端！"))
			return FALSE
	return ..()

/obj/item/wallframe/apc/after_attach(obj/machinery/power/apc/attached_to)
	for(var/obj/machinery/power/terminal/E in attached_to.loc)
		attached_to.make_terminal()
		return
