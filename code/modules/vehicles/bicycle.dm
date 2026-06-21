/obj/vehicle/ridden/bicycle
	name = "自行车"
	desc = "远离电力"
	icon_state = "bicycle"
	max_integrity = 150
	integrity_failure = 0.5
	var/fried = FALSE

/obj/vehicle/ridden/bicycle/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/bicycle)

/obj/vehicle/ridden/bicycle/zap_act(power, zap_flags) // :::^^^)))
	//This didn't work for 3 years because none ever tested it I hate life
	name = "油炸自行车"
	desc = "好啊你做的好啊"
	color = rgb(63, 23, 4)
	can_buckle = FALSE
	fried = TRUE
	. = ..()
	for(var/m in buckled_mobs)
		unbuckle_mob(m,1)

/obj/vehicle/ridden/bicycle/welder_act(mob/living/user, obj/item/W)
	if(user.combat_mode)
		return
	. = TRUE
	if(fried)
		balloon_alert(user, "它烧坏了！")
	if(DOING_INTERACTION(user, src))
		balloon_alert(user, "你已经在修理它了！")
		return
	if(atom_integrity >= max_integrity)
		balloon_alert(user, "它没有损坏！")
		return
	if(!W.tool_start_check(user, amount=1, heat_required = HIGH_TEMPERATURE_REQUIRED))
		return
	user.balloon_alert_to_viewers("started welding [src]", "started repairing [src]")
	audible_message(span_hear("你听到了焊接声。"))
	var/did_the_thing
	while(atom_integrity < max_integrity)
		if(W.use_tool(src, user, 2.5 SECONDS, volume=50, extra_checks = CALLBACK(src, PROC_REF(can_still_fix))))
			did_the_thing = TRUE
			atom_integrity += min(10, (max_integrity - atom_integrity))
			audible_message(span_hear("你听到了焊接声。"))
		else
			break
	if(did_the_thing)
		user.balloon_alert_to_viewers("[(atom_integrity >= max_integrity) ? "fully" : "partially"] repaired [src]")
	else
		user.balloon_alert_to_viewers("stopped welding [src]", "interrupted the repair!")

///can we still fix the bike lol
/obj/vehicle/ridden/bicycle/proc/can_still_fix()
	return !fried



