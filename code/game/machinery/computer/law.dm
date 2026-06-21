

/obj/machinery/computer/upload
	var/mob/living/silicon/current = null //The target of future law uploads
	icon_screen = "command"
	time_to_unscrew = 6 SECONDS

/obj/machinery/computer/upload/Initialize(mapload)
	. = ..()
	if(!mapload)
		log_silicon("\A [name] was created at [loc_name(src)].")
		message_admins("\A [name] was created at [ADMIN_VERBOSEJMP(src)].")

/obj/machinery/computer/upload/attackby(obj/item/O, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(O, /obj/item/ai_module))
		var/obj/item/ai_module/M = O
		if(machine_stat & (NOPOWER|BROKEN|MAINT))
			return
		if(!current)
			to_chat(user, span_alert("你还没有选择任何目标来传输法律！"))
			return
		if(!can_upload_to(current))
			to_chat(user, span_alert("上传失败！请检查以确保[current.name]运行正常。"))
			current = null
			return
		if(!is_valid_z_level(get_turf(current), get_turf(user)))
			to_chat(user, span_alert("上传失败！无法与[current.name]建立连接。你离得太远了！"))
			current = null
			return
		M.install(current.laws, user)
		imprint_gps("Weak Upload Signal")
	else
		return ..()

/obj/machinery/computer/upload/proc/can_upload_to(mob/living/silicon/S)
	if(S.stat == DEAD)
		return FALSE
	return TRUE

/obj/machinery/computer/upload/ai
	name = "\improper AI上传控制台"
	desc = "用于将法律上传至AI。"
	circuit = /obj/item/circuitboard/computer/aiupload

/obj/machinery/computer/upload/ai/Initialize(mapload)
	. = ..()
	if(mapload && HAS_TRAIT(SSstation, STATION_TRAIT_HUMAN_AI))
		return INITIALIZE_HINT_QDEL

/obj/machinery/computer/upload/ai/interact(mob/user)
	current = select_active_ai(user, z, TRUE)

	if (!current)
		to_chat(user, span_alert("未检测到活跃的AI！"))
	else
		to_chat(user, span_notice("已选择 [current.name] 进行法律修改。"))

/obj/machinery/computer/upload/ai/can_upload_to(mob/living/silicon/ai/A)
	if(!A || !isAI(A))
		return FALSE
	if(A.control_disabled)
		return FALSE
	return ..()


/obj/machinery/computer/upload/borg
	name = "赛博上传控制台"
	desc = "用于向赛博格上传法律。"
	circuit = /obj/item/circuitboard/computer/borgupload

/obj/machinery/computer/upload/borg/interact(mob/user)
	current = select_active_free_borg(user)

	if(!current)
		to_chat(user, span_alert("未检测到未被奴役的活跃赛博"))
	else
		to_chat(user, span_notice("已选择 [current.name] 进行法律修改。"))

/obj/machinery/computer/upload/borg/can_upload_to(mob/living/silicon/robot/B)
	if(!B || !iscyborg(B))
		return FALSE
	if(B.scrambledcodes || B.emagged)
		return FALSE
	return ..()
