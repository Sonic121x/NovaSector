// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
// APC HULL
/obj/item/wallframe/apc
	name = "\improper APC frame"
	desc = "Used for repairing or building APCs."
	icon_state = "apc"
	result_path = /obj/machinery/power/apc/auto_name

/obj/item/wallframe/apc/try_build(turf/on_wall, user)
	var/turf/T = get_turf(on_wall) //the user is not where it needs to be.
	var/area/A = get_area(user)
	if(A.apc)
		to_chat(user, span_warning(LANG("obj.4cc02e8ab8e3d388", null)))
		return FALSE //only one APC per area
	if(!A.requires_power || A.always_unpowered)
		to_chat(user, span_warning(LANG("obj.020656f68c6d9619", list(src))))
		return FALSE //can't place apcs in areas with no power requirement
	for(var/obj/machinery/power/terminal/E in T)
		if(E.master)
			to_chat(user, span_warning(LANG("obj.3ca3c0751fe3d10a", null)))
			return FALSE
	return ..()

/obj/item/wallframe/apc/after_attach(obj/machinery/power/apc/attached_to)
	for(var/obj/machinery/power/terminal/E in attached_to.loc)
		attached_to.make_terminal()
		return
