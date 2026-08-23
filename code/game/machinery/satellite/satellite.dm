// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/machinery/satellite
	name = "\improper Defunct Satellite"
	desc = ""
	icon = 'icons/obj/machines/satellite.dmi'
	icon_state = "sat_inactive"
	base_icon_state = "sat"
	anchored = FALSE
	density = TRUE
	use_power = NO_POWER_USE
	var/mode = "NTPROBEV0.8"
	var/active = FALSE
	/// global counter of IDs
	var/static/global_id = 0
	/// id number for this satellite
	var/id = 0

/obj/machinery/satellite/Initialize(mapload)
	. = ..()
	id = global_id++

/obj/machinery/satellite/Destroy()
	if(active)
		//should not be setting this directly but the satellite won't exist so we don't want the setter's effects
		active = FALSE
	return ..()

/obj/machinery/satellite/interact(mob/user)
	toggle(user)

/obj/machinery/satellite/set_anchored(anchorvalue)
	. = ..()
	if(isnull(.))
		return //no need to process if we didn't change anything.
	active = anchorvalue
	if(anchorvalue)
		begin_processing()
		animate(src, pixel_y = 2, time = 10, loop = -1)
	else
		end_processing()
		animate(src, pixel_y = 0, time = 10)
	update_appearance()

/obj/machinery/satellite/proc/toggle(mob/user)
	if(!active && !isinspace())
		if(user)
			to_chat(user, span_warning(LANG("obj.08e907777fe71f42", list(src))))
		return FALSE
	if(user)
		to_chat(user, span_notice(LANG("obj.d6171b714b8cf981", list(active ? "deactivate": "activate", src))))
	set_anchored(!anchored)
	return TRUE

/obj/machinery/satellite/update_icon_state()
	icon_state = "[base_icon_state]_[active ? "active" : "inactive"]"
	return ..()

/obj/machinery/satellite/multitool_act(mob/living/user, obj/item/I)
	..()
	to_chat(user, span_notice(LANG("obj.7d69322ad09c0894", list(id, active ? "PRIMARY" : "STANDBY", (obj_flags & EMAGGED) ? "DEBUG_MODE //" : ""))))
	return TRUE
