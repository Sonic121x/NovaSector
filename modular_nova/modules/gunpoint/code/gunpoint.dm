/mob/living
	///Who is the person gunpointing at? If they are
	var/datum/gunpoint/gunpointing
	///Who is gunpointing at our person?
	var/list/gunpointed = list()
	///The effect from gunpointing, to make sure we dont create multiples
	var/obj/effect/overlay/gunpoint_effect/gp_effect

/mob/living/carbon/Move(atom/newloc, direct = 0)
	. = ..()
	if(gunpointing)
		var/dir = get_dir(get_turf(gunpointing.source),get_turf(gunpointing.target))
		if(dir)
			setDir(dir)

/mob/living/ShiftMiddleClickOn(atom/A)
	var/obj/item/gun/G = get_active_held_item()
	if(istype(G, /obj/item/gun))
		DoGunpoint(A, G)
	else
		src.pointed(A)
	return

/mob/living/proc/DoGunpoint(atom/A, obj/item/gun/G)
	if(A == src)
		return
	if(!isliving(A))
		if(gunpointing) //Cancelling a gunpoint by shift + MMB on a non-mob
			qdel(gunpointing)
		return
	var/mob/living/L = A
	if(gunpointing && L == gunpointing.target) //Cancelling a gunpoint by shift + MMB on the target
		gunpointing.click_destroy()
	else
		if(!CanGunpointAt(L, TRUE))
			return
		if(gunpointing) //We're gunpoint and we already know we're locking onto a different, valid target
			qdel(gunpointing)
		gunpointing = new(src, L, G)

/mob/living/proc/CanGunpointAt(mob/living/L, notice = FALSE)
	if(resting)
		if(notice)
			to_chat(src, span_warning("你需要站着才能好好瞄准！"))
		return FALSE
	if(!(L in viewers(8, src)))
		if(notice)
			to_chat(src, span_warning("你的目标不在你的视野内！"))
		return FALSE
	if(L.alpha < 70)
		if(notice)
			to_chat(src, span_warning("你看不清你的目标！"))
		return FALSE
	return TRUE
