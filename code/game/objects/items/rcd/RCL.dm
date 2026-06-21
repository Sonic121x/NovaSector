//RAPID PIPE CLEANER

/obj/item/rcl
	name = "快速管道清洁器铺设器"
	desc = "一种用于快速部署管道清洁器的设备。侧面有螺丝，可以拧下来滑出管道清洁器。未绝缘时请勿使用！"
	icon = 'icons/obj/tools.dmi'
	icon_state = "rcl-0"
	inhand_icon_state = "rcl-0"
	var/obj/structure/pipe_cleaner/last
	var/obj/item/stack/pipe_cleaner_coil/loaded
	opacity = FALSE
	force = 5 //Plastic is soft
	throwforce =5
	throw_speed = 1
	throw_range = 7
	w_class = WEIGHT_CLASS_NORMAL
	var/max_amount = 90
	var/active = FALSE
	actions_types = list(/datum/action/item_action/rcl_col,/datum/action/item_action/rcl_gui)
	var/list/colors = list("red", "yellow", "green", "blue", "pink", "orange", "cyan", "white")
	var/current_color_index = 1
	var/ghetto = FALSE
	lefthand_file = 'icons/mob/inhands/equipment/tools_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/tools_righthand.dmi'
	var/datum/radial_menu/persistent/wiring_gui_menu
	var/mob/listeningTo

/obj/item/rcl/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	AddComponent(/datum/component/two_handed, wield_callback = CALLBACK(src, PROC_REF(on_wield)), unwield_callback = CALLBACK(src, PROC_REF(on_unwield)))

/// triggered on wield of two handed item
/obj/item/rcl/proc/on_wield(obj/item/source, mob/user)
	active = TRUE

/// triggered on unwield of two handed item
/obj/item/rcl/proc/on_unwield(obj/item/source, mob/user)
	active = FALSE

/obj/item/rcl/screwdriver_act(mob/living/user, obj/item/tool)
	if(!loaded)
		return FALSE
	. = TRUE
	if(ghetto && prob(10)) //Is it a ghetto RCL? If so, give it a 10% chance to fall apart
		to_chat(user, span_warning("你试图拧松侧面的固定螺丝，但它散架了！"))
		while(loaded.amount > 30) //There are only two kinds of situations: "nodiff" (60,90), or "diff" (31-59, 61-89)
			var/diff = loaded.amount % 30
			if(diff)
				loaded.use(diff)
				new /obj/item/stack/pipe_cleaner_coil(get_turf(user), diff)
			else
				loaded.use(30)
				new /obj/item/stack/pipe_cleaner_coil(get_turf(user), 30)
		qdel(src)
		return

	tool.play_tool_sound(src)
	to_chat(user, span_notice("你拧松了侧面的固定螺丝，可以放下导向边并取出电线了。"))
	while(loaded.amount > 30) //There are only two kinds of situations: "nodiff" (60,90), or "diff" (31-59, 61-89)
		var/diff = loaded.amount % 30
		if(diff)
			loaded.use(diff)
			new /obj/item/stack/pipe_cleaner_coil(get_turf(user), diff)
		else
			loaded.use(30)
			new /obj/item/stack/pipe_cleaner_coil(get_turf(user), 30)
	loaded.max_amount = initial(loaded.max_amount)
	if(!user.put_in_hands(loaded))
		loaded.forceMove(get_turf(user))

	loaded = null
	update_appearance()

/obj/item/rcl/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stack/pipe_cleaner_coil))
		var/obj/item/stack/pipe_cleaner_coil/C = W

		if(!loaded)
			if(!user.transferItemToLoc(W, src))
				to_chat(user, span_warning("[src] 粘在你手上了！"))
				return
			else
				loaded = W //W.loc is src at this point.
				loaded.set_pipecleaner_color(colors[current_color_index])
				loaded.max_amount = max_amount //We store a lot.
				return

		if(loaded.amount < max_amount)
			var/transfer_amount = min(max_amount - loaded.amount, C.amount)
			C.use(transfer_amount)
			loaded.amount += transfer_amount
		else
			return
		update_appearance()
		to_chat(user, span_notice("你将管道清洁器加入了[src]。它现在含有[loaded.amount]。"))
	else
		..()

/obj/item/rcl/examine(mob/user)
	. = ..()
	if(loaded)
		. += span_info("它装有 [loaded.amount]/[max_amount] 根管道清洁器。")

/obj/item/rcl/Destroy()
	QDEL_NULL(loaded)
	last = null
	listeningTo = null
	QDEL_NULL(wiring_gui_menu)
	return ..()

/obj/item/rcl/update_icon_state()
	. = ..()
	if(!loaded)
		icon_state = "rcl-0"
		inhand_icon_state = "rcl-0"
		return
	switch(loaded.amount)
		if(61 to INFINITY)
			icon_state = "rcl-30"
			inhand_icon_state = "rcl"
		if(31 to 60)
			icon_state = "rcl-20"
			inhand_icon_state = "rcl"
		if(1 to 30)
			icon_state = "rcl-10"
			inhand_icon_state = "rcl"
		else
			icon_state = "rcl-0"
			inhand_icon_state = "rcl-0"

/obj/item/rcl/proc/is_empty(mob/user, loud = 1)
	update_appearance()
	if(!loaded || !loaded.amount)
		if(loud)
			to_chat(user, span_notice("最后一截管道清洁器从[src]上解开了。"))
		if(loaded)
			QDEL_NULL(loaded)
			loaded = null
		QDEL_NULL(wiring_gui_menu)
		return TRUE
	return FALSE

/obj/item/rcl/pickup(mob/user)
	..()
	getMobhook(user)


/obj/item/rcl/dropped(mob/wearer)
	..()
	UnregisterSignal(wearer, COMSIG_MOVABLE_MOVED)
	listeningTo = null
	last = null
	QDEL_NULL(wiring_gui_menu)

/obj/item/rcl/attack_self(mob/user)
	..()
	if(!active)
		last = null
	else if(!last)
		for(var/obj/structure/pipe_cleaner/C in get_turf(user))
			if(C.d1 == FALSE || C.d2 == FALSE)
				last = C
				break

/obj/item/rcl/proc/getMobhook(mob/to_hook)
	if(listeningTo == to_hook)
		return
	if(listeningTo)
		UnregisterSignal(listeningTo, COMSIG_MOVABLE_MOVED)
	RegisterSignal(to_hook, COMSIG_MOVABLE_MOVED, PROC_REF(trigger))
	listeningTo = to_hook

/obj/item/rcl/proc/trigger(mob/user)
	SIGNAL_HANDLER

	if(active)
		layCable(user)
	if(wiring_gui_menu) //update the wire options as you move
		wiringGuiUpdate(user)


//previous contents of trigger(), lays pipe_cleaner each time the player moves
/obj/item/rcl/proc/layCable(mob/user)
	if(!isturf(user.loc))
		return
	if(is_empty(user, 0))
		balloon_alert(user, "它是空的！")
		return

	if(prob(2) && ghetto) //Give ghetto RCLs a 2% chance to jam, requiring it to be reactviated manually.
		balloon_alert(user, "电线卡住了！")
		active = FALSE
		return
	else
		if(last)
			if(get_dist(last, user) == 1) //hacky, but it works
				var/turf/T = get_turf(user)
				if(!T.can_have_cabling())
					last = null
					return
				if(get_dir(last, user) == last.d2)
					//Did we just walk backwards? Well, that's the one direction we CAN'T complete a stub.
					last = null
					return
				loaded.pipe_cleaner_join(last, user, FALSE)
				if(is_empty(user))
					return //If we've run out, display message and exit
			else
				last = null
		last = loaded.place_turf(get_turf(src), user, REVERSE_DIR(user.dir))
		is_empty(user) //If we've run out, display message
	update_appearance()


//searches the current tile for a stub pipe_cleaner of the same colour
/obj/item/rcl/proc/findLinkingCable(mob/user)
	var/turf/T
	if(!isturf(user.loc))
		return

	T = get_turf(user)
	if(!T.can_have_cabling())
		return

	for(var/obj/structure/pipe_cleaner/C in T)
		if(!C)
			continue
		if(C.color != GLOB.cable_colors[colors[current_color_index]])
			continue
		if(C.d1 == 0)
			return C

/obj/item/rcl/proc/wiringGuiGenerateChoices(mob/user)
	var/fromdir = 0
	var/obj/structure/pipe_cleaner/linkingCable = findLinkingCable(user)
	if(linkingCable)
		fromdir = linkingCable.d2

	var/list/wiredirs = list("1","5","4","6","2","10","8","9")
	for(var/icondir in wiredirs)
		var/dirnum = text2num(icondir)
		var/pipe_cleanersuffix = "[min(fromdir,dirnum)]-[max(fromdir,dirnum)]"
		if(fromdir == dirnum) //pipe_cleaners can't loop back on themselves
			pipe_cleanersuffix = "invalid"
		var/image/img = image(icon = 'icons/hud/radial.dmi', icon_state = "cable_[pipe_cleanersuffix]")
		img.color = GLOB.cable_colors[colors[current_color_index]]
		wiredirs[icondir] = img
	return wiredirs

/obj/item/rcl/proc/showWiringGui(mob/user)
	var/list/choices = wiringGuiGenerateChoices(user)

	wiring_gui_menu = show_radial_menu_persistent(user, src , choices, select_proc = CALLBACK(src, PROC_REF(wiringGuiReact), user), radius = 42)

/obj/item/rcl/proc/wiringGuiUpdate(mob/user)
	if(!wiring_gui_menu)
		return

	var/list/choices = wiringGuiGenerateChoices(user)

	wiring_gui_menu.change_choices(choices,FALSE)

//Callback used to respond to interactions with the wiring menu
/obj/item/rcl/proc/wiringGuiReact(mob/living/user,choice)
	if(!choice) //close on a null choice (the center button)
		QDEL_NULL(wiring_gui_menu)
		return

	choice = text2num(choice)

	if(!isturf(user.loc))
		return
	if(is_empty(user, 0))
		to_chat(user, span_warning("\The [src] 是空的！"))
		return

	var/turf/T = get_turf(user)
	if(!T.can_have_cabling())
		return

	var/obj/structure/pipe_cleaner/linkingCable = findLinkingCable(user)
	if(linkingCable)
		if(choice != linkingCable.d2)
			loaded.pipe_cleaner_join(linkingCable, user, FALSE, choice)
			last = null
	else
		last = loaded.place_turf(get_turf(src), user, choice)

	is_empty(user) //If we've run out, display message

	wiringGuiUpdate(user)

/obj/item/rcl/pre_loaded/Initialize(mapload) //Comes preloaded with pipe_cleaner, for testing stuff
	. = ..()
	loaded = new()
	loaded.max_amount = max_amount
	loaded.amount = max_amount
	update_appearance()

/obj/item/rcl/Initialize(mapload)
	. = ..()
	update_appearance()

/obj/item/rcl/ui_action_click(mob/user, action)
	if(istype(action, /datum/action/item_action/rcl_col))
		current_color_index++;
		if (current_color_index > colors.len)
			current_color_index = 1
		var/cwname = colors[current_color_index]
		to_chat(user, "颜色已更改为[cwname]！")
		if(loaded)
			loaded.set_pipecleaner_color(colors[current_color_index])
		if(wiring_gui_menu)
			wiringGuiUpdate(user)
	else if(istype(action, /datum/action/item_action/rcl_gui))
		if(wiring_gui_menu) //The menu is already open, close it
			QDEL_NULL(wiring_gui_menu)
		else //open the menu
			showWiringGui(user)

/obj/item/rcl/ghetto
	actions_types = list()
	max_amount = 30
	name = "临时快速管道清洁层"
	ghetto = TRUE
	custom_materials = list(/datum/material/iron = SHEET_MATERIAL_AMOUNT * 15)

/obj/item/rcl/ghetto/update_icon_state()
	if(!loaded)
		icon_state = "rclg-0"
		inhand_icon_state = "rclg-0"
		return ..()
	switch(loaded.amount)
		if(1 to INFINITY)
			icon_state = "rclg-1"
			inhand_icon_state = "rcl"
		else
			icon_state = "rclg-1"
			inhand_icon_state = "rclg-1"
	return ..()

/datum/action/item_action/rcl_col
	name = "更改线缆颜色"
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "rcl_rainbow"

/datum/action/item_action/rcl_gui
	name = "切换快速布线界面"
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "rcl_gui"
