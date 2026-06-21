/obj/machinery/dish_drive/bullet
	name = "子弹驱动器"
	desc = "为安保部门改造的餐盘驱动器版本。因为他们很懒。"
	icon = 'modular_nova/modules/sec_haul/icons/misc/bulletdrive.dmi'
	icon_state = "synthesizer"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/dish_drive/bullet
	collectable_items = list(/obj/item/ammo_casing)
	suck_distance = 8
	binrange = 10

/obj/item/circuitboard/machine/dish_drive/bullet
	name = "子弹驱动器"
	greyscale_colors = CIRCUIT_COLOR_SERVICE
	build_path = /obj/machinery/dish_drive/bullet
	req_components = list(
		/obj/item/stack/sheet/glass = 1,
		/datum/stock_part/servo = 1,
		/datum/stock_part/matter_bin = 2,
	)
	needs_anchored = TRUE

/obj/machinery/dish_drive/bullet/do_the_dishes(manual)
	if(!LAZYLEN(dish_drive_contents))
		if(manual)
			visible_message(span_notice("[src] 是空的！"))
		return
	var/obj/machinery/disposal/bin/bin = locate() in view(binrange, src) //NOVA EDIT CHANGE
	if(!bin)
		if(manual)
			visible_message(span_warning("[src] 发出嗡嗡声。范围内没有处理箱！"))
			playsound(src, 'sound/machines/buzz/buzz-sigh.ogg', 50, TRUE)
		return
	var/disposed = 0
	for(var/obj/item/ammo_casing/A in dish_drive_contents)
		if(!A.loaded_projectile)
			LAZYREMOVE(dish_drive_contents, A)
			qdel(A)
			use_energy(active_power_usage)
			disposed++
	if(disposed)
		visible_message(span_notice("[src] [pick("whooshes", "bwooms", "fwooms", "pshooms")] and demoleculizes [disposed] stored item\s into the nearby void."))
		playsound(src, 'sound/items/pshoom/pshoom.ogg', 50, TRUE)
		playsound(bin, 'sound/items/pshoom/pshoom.ogg', 50, TRUE)
		flick("synthesizer_beam", src)
	else
		visible_message(span_notice("[src] 里没有可处理的物品！"))
	time_since_dishes = world.time + 600

/obj/machinery/dish_drive/bullet/process()
	if(time_since_dishes <= world.time && transmit_enabled)
		do_the_dishes()
	if(!suction_enabled)
		return
	for(var/obj/item/I in view(2 + suck_distance, src))
		if(istype(I, /obj/machinery/dish_drive/bullet))
			visible_message(span_userdanger("[src] 检测到附近有另一个子弹驱动器，它很伤心！"))
			break
		if(is_type_in_list(I, collectable_items) && I.loc != src && (!I.reagents || !I.reagents.total_volume))
			if(I.Adjacent(src))
				LAZYADD(dish_drive_contents, I)
				visible_message(span_notice("[src] 传送了 [I]！"))
				I.moveToNullspace()
				playsound(src, 'sound/items/pshoom/pshoom.ogg', 50, TRUE)
				flick("synthesizer_beam", src)
			else
				step_towards(I, src)

/obj/item/flatpack/bullet_drive
	name = "扁平包装的子弹驱动器"
	board = /obj/item/circuitboard/machine/dish_drive/bullet
