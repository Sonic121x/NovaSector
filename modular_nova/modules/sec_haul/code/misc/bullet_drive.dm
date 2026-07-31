/obj/machinery/dish_drive/bullet
	name = "bullet drive"
	desc = "A modified verison of the dish drive, for security. Because they're lazy."
	icon = 'modular_nova/modules/sec_haul/icons/misc/bulletdrive.dmi'
	icon_state = "synthesizer"
	density = TRUE
	circuit = /obj/item/circuitboard/machine/dish_drive/bullet
	collectable_items = list(/obj/item/ammo_casing)
	suck_distance = 8
	binrange = 10

/obj/item/circuitboard/machine/dish_drive/bullet
	name = "Bullet Drive"
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
			visible_message(span_notice(LANG("obj.02d482cc", list(src))))
		return
	var/obj/machinery/disposal/bin/bin = locate() in view(binrange, src) //NOVA EDIT CHANGE
	if(!bin)
		if(manual)
			visible_message(span_warning(LANG("obj.40c14145", list(src))))
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
		visible_message(span_notice(LANG("obj.5cba38c2", list(src, pick("whooshes", "bwooms", "fwooms", "pshooms"), disposed))))
		playsound(src, 'sound/items/pshoom/pshoom.ogg', 50, TRUE)
		playsound(bin, 'sound/items/pshoom/pshoom.ogg', 50, TRUE)
		flick("synthesizer_beam", src)
	else
		visible_message(span_notice(LANG("obj.359381c8", list(src))))
	time_since_dishes = world.time + 600

/obj/machinery/dish_drive/bullet/process()
	if(time_since_dishes <= world.time && transmit_enabled)
		do_the_dishes()
	if(!suction_enabled)
		return
	for(var/obj/item/I in view(2 + suck_distance, src))
		if(istype(I, /obj/machinery/dish_drive/bullet))
			visible_message(span_userdanger(LANG("obj.5ce1d582", list(src))))
			break
		if(is_type_in_list(I, collectable_items) && I.loc != src && (!I.reagents || !I.reagents.total_volume))
			if(I.Adjacent(src))
				LAZYADD(dish_drive_contents, I)
				visible_message(span_notice(LANG("obj.52c367cc", list(src, I))))
				I.moveToNullspace()
				playsound(src, 'sound/items/pshoom/pshoom.ogg', 50, TRUE)
				flick("synthesizer_beam", src)
			else
				step_towards(I, src)

/obj/item/flatpack/bullet_drive
	name = "flatpacked bullet drive"
	board = /obj/item/circuitboard/machine/dish_drive/bullet
