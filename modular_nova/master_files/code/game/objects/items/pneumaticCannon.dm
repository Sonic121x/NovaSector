
/obj/item/pneumatic_cannon/load_item(obj/item/I, mob/user) //we make this compatable with the master file incase of future updates.
	if(!can_load_item(I, user))
		return FALSE
	if(user)
		if(istype(I, /obj/item/storage/toolbox/emergency/turret/mag_fed))
			to_chat(user, span_warning(LANG("obj.47e84ff3f9d5b0bf", list(I, src))))
			if(!do_after(user, 15)) //adding a warning and a delay so it cant just be invo-juggle-spammed.
				return FALSE
	return ..()

/obj/item/pneumatic_cannon/can_load_item(obj/item/I, mob/user)
	. = ..()
	if(!.)
		return
	if(locate(/obj/item/storage/toolbox/emergency/turret/mag_fed) in src) //If loaded with a turret, stops more from being put in
		if(user)
			to_chat(user, span_warning(LANG("obj.63db626a32ee858b", list(I, src))))
		return FALSE
	if(istype(I, /obj/item/storage/toolbox/emergency/turret/mag_fed) && length(loadedItems) >= 1)
		if(user)
			to_chat(user, span_warning(LANG("obj.b57cab95d95df1cb", list(I))))
		return FALSE
