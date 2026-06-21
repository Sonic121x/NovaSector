/obj/item/organ/heart/gland/plasma
	abductor_hint = "effluvium sanguine-synonym emitter. The abductee randomly emits clouds of plasma."
	cooldown_low = 1200
	cooldown_high = 1800
	icon_state = "slime"
	uses = -1
	mind_control_uses = 1
	mind_control_duration = 800

/obj/item/organ/heart/gland/plasma/activate()
	to_chat(owner, span_warning("你感到腹胀。"))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), owner, span_userdanger("一阵剧烈的胃痛向你袭来。")), 15 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(vomit_plasma)), 20 SECONDS)

/obj/item/organ/heart/gland/plasma/proc/vomit_plasma()
	if(!owner)
		return
	owner.visible_message(span_danger("[owner] 呕吐出一团等离子体云雾！"))
	var/turf/open/T = get_turf(owner)
	if(istype(T))
		T.atmos_spawn_air("[GAS_PLASMA]=50;[TURF_TEMPERATURE(T20C)]")
	owner.vomit(VOMIT_CATEGORY_DEFAULT)
