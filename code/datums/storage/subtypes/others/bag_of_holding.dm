/datum/storage/bag_of_holding
	max_specific_storage = WEIGHT_CLASS_GIGANTIC
	max_total_storage = 35
	max_slots = 30
	allow_big_nesting = TRUE

/datum/storage/bag_of_holding/attempt_insert(obj/item/to_insert, mob/user, override, force, messages)
	var/list/obj/item/storage/backpack/holding/matching = typecache_filter_list(to_insert.get_all_contents(), typecacheof(/obj/item/storage/backpack/holding, /obj/item/mod/control, /obj/item/mod/module/storage))
	matching -= parent
	matching -= real_location
	for(var/obj/item/mod/modsuit_or_module in matching)
		var/datum/storage/storage = modsuit_or_module.atom_storage
		if(istype(storage, /datum/storage/bag_of_holding) && storage.real_location == storage.parent)
			continue
		matching -= modsuit_or_module

	if((istype(to_insert.atom_storage, /datum/storage/bag_of_holding) || length(matching)) && can_insert(to_insert, user))
		INVOKE_ASYNC(src, PROC_REF(recursive_insertion), to_insert, user)
		return FALSE

	return ..()

/datum/storage/bag_of_holding/proc/recursive_insertion(obj/item/to_insert, mob/living/user)
	if(confirm_recursive_insertion(to_insert, user))
		create_rift(to_insert, user)

/datum/storage/bag_of_holding/proc/confirm_recursive_insertion(obj/item/to_insert, mob/living/user)
	var/area/bag_area = get_area(user)
	var/safety = tgui_alert(user, "这样做将对空间站及其船员造成极其严重的后果。请确保你清楚自己在做什么。", "放入 [to_insert.name]？", list("Proceed", "Abort"))
	return safety == "Proceed" \
		&& !QDELETED(to_insert) \
		&& !QDELETED(parent) \
		&& !QDELETED(real_location) \
		&& !QDELETED(user) \
		&& user.can_perform_action(parent, NEED_DEXTERITY) \
		&& can_insert(to_insert, user) \
		&& !(bag_area.area_flags & NO_BOH)

/datum/storage/bag_of_holding/proc/create_rift(obj/item/inserted, mob/living/user)
	var/turf/rift_loc = get_turf(parent)
	user.visible_message(
		span_userdanger("两个设备的蓝空界面发生了灾难性的故障！"),
		span_danger("两个设备的蓝空界面发生了灾难性的故障！"),
	)

	message_admins("[ADMIN_LOOKUPFLW(user)] detonated a bag of holding at [ADMIN_VERBOSEJMP(rift_loc)].")
	user.log_message("detonated a bag of holding at [loc_name(rift_loc)].", LOG_ATTACK, color = "red")

	user.investigate_log("has been gibbed by a bag of holding recursive insertion.", INVESTIGATE_DEATHS)
	user.gib()
	var/obj/reality_tear/tear = new(rift_loc)
	tear.start_disaster()
	qdel(inserted)
	qdel(parent)
