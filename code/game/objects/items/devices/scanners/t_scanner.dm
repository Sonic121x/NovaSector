/obj/item/t_scanner
	name = "\improper T射线扫描仪"
	desc = "一种用于探测地板下物体（如电缆和管道）的太赫兹射线发射器和扫描仪。"
	custom_price = PAYCHECK_LOWER * 0.7
	icon = 'icons/obj/devices/scanner.dmi'
	icon_state = "t-ray0"
	slot_flags = ITEM_SLOT_BELT
	w_class = WEIGHT_CLASS_SMALL
	inhand_icon_state = "electronic"
	worn_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT * 1.5)
	sound_vary = TRUE
	pickup_sound = SFX_GENERIC_DEVICE_PICKUP
	drop_sound = SFX_GENERIC_DEVICE_DROP
	/// Is this T-Ray scanner currently on?
	var/on = FALSE

/obj/item/t_scanner/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user]开始用[src]向[user.p_their()]大脑发射太赫兹射线！看起来[user.p_theyre()]试图自杀！"))
	return TOXLOSS

/obj/item/t_scanner/proc/toggle_on()
	playsound(src, SFX_INDUSTRIAL_SCAN, 20, TRUE, -2, TRUE, FALSE)
	on = !on
	icon_state = copytext_char(icon_state, 1, -1) + "[on]"
	if(on)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)

/obj/item/t_scanner/attack_self(mob/user)
	toggle_on()

/obj/item/t_scanner/cyborg_unequip(mob/user)
	if(!on)
		return
	toggle_on()

/obj/item/t_scanner/process()
	if(!on)
		return PROCESS_KILL
	scan()

/obj/item/t_scanner/proc/scan()
	t_ray_scan(loc)

/proc/t_ray_scan(mob/viewer, flick_time = 8, distance = 3)
	if(!ismob(viewer) || !viewer.client)
		return
	var/list/t_ray_images = list()
	for(var/obj/O in orange(distance, viewer) )
		if(HAS_TRAIT(O, TRAIT_T_RAY_VISIBLE))
			var/image/I = new(loc = get_turf(O))
			var/mutable_appearance/MA = new(O)
			MA.alpha = 128
			MA.dir = O.dir
			I.appearance = MA
			t_ray_images += I
	if(t_ray_images.len)
		flick_overlay_global(t_ray_images, list(viewer.client), flick_time)
