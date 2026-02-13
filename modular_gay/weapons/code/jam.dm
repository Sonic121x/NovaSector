//obj/item/gun/ballistic/automatic/pistol/makeshift/M1916
//	var/unjam_chance = 35
//	var/jamming_increment = 2
//	var/jammed = FALSE
//	var/can_jam = TRUE
//	var/jamming_chance = 25
//
//
//obj/item/gun/ballistic/automatic/pistol/makeshift/M1916/process_fire(mob/user)
//	if(can_jam)
//		if(chambered.loaded_projectile)
//			if(prob(jamming_chance))
//				jammed = TRUE
//			jamming_chance += jamming_increment
//			jamming_chance = clamp (jamming_chance, 0, 500)
//	return ..()

//obj/item/gun/ballistic/automatic/pistol/makeshift/M1916/can_trigger_gun(mob/living/user)
//	. = ..()
//	if(jammed)
//		balloon_alert(user, "jammed!")
//		playsound(user,'sound/items/weapons/jammed.ogg', 75, TRUE)
//		return FALSE
//
//obj/item/gun/ballistic/automatic/pistol/makeshift/M1916/attack_self(mob/user)
///	if(can_jam)
	//	if(jammed)
	//		if(prob(unjam_chance))
//				jammed = FALSE
	//			unjam_chance = 10
//			else
//				unjam_chance += 10
//				balloon_alert(user, "jammed!")
//				playsound(user,'sound/items/weapons/jammed.ogg', 75, TRUE)
//				return FALSE
//	..()

//obj/item/gun/ballistic/automatic/pistol/makeshift/M1916/attackby(obj/item/item, mob/user, params)
//	. = ..()
//	if(can_jam)
///		if(bolt_locked)
/	///		if(istype(item, /obj/item/gun_maintenance_supplies))
//	///			if(do_after(user, 10 SECONDS, target = src))
///					user.visible_message(span_notice("[user] finishes maintenance of [src]."))
	//				jamming_chance = 10
///					qdel(item)

//obj/item/gun/ballistic/automatic/pistol/makeshift/M1916/blow_up(mob/user)
//	. = FALSE
//	if(chambered?.loaded_projectile)
////		process_fire(user, user, FALSE)
/	//	. = TRUE