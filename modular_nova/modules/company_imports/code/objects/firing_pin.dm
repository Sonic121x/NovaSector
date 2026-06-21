GLOBAL_VAR_INIT(permit_pin_unrestricted, FALSE)
// Firing pin that can be used off station freely, and requires a permit to use on-station
/obj/item/firing_pin/permit_pin
	name = "许可锁定击针"
	desc = "一种为不信任船员的太空站设计的击针。仅允许你在空间站外或持有枪支许可证时开火。"
	icon_state = "firing_pin_explorer"
	fail_message = "firearms permit check failed!</span>"

// This checks that the user isn't on the station Z-level.
/obj/item/firing_pin/permit_pin/pin_auth(mob/living/user)
	var/turf/station_check = get_turf(user)

	if(obj_flags & EMAGGED)
		return TRUE

	if(GLOB.permit_pin_unrestricted)
		return TRUE

	var/obj/item/card/id/the_id = user.get_idcard()

	if(!the_id && is_station_level(station_check.z))
		return FALSE

	if(!is_station_level(station_check.z) || (ACCESS_WEAPONS in the_id.GetAccess()))
		return TRUE


/obj/item/firing_pin
	var/can_remove = TRUE

/obj/item/firing_pin/emag_act(mob/user)
	. = ..()
	if(obj_flags & EMAGGED)
		return FALSE
	balloon_alert(user, "击针已解锁！")
	obj_flags |= EMAGGED
	can_remove = TRUE
	return TRUE
