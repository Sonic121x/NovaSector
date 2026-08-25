// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/vehicle/ridden/bicycle
	name = "bicycle"
	desc = "Keep away from electricity."
	icon_state = "bicycle"
	max_integrity = 150
	integrity_failure = 0.5
	var/fried = FALSE

/obj/vehicle/ridden/bicycle/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/ridable, /datum/component/riding/vehicle/bicycle)

/obj/vehicle/ridden/bicycle/zap_act(power, zap_flags) // :::^^^)))
	//This didn't work for 3 years because none ever tested it I hate life
	name = "fried bicycle"
	desc = LANG("obj.ae9ba06148eef3bd", null)
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
		balloon_alert(user, LANG("obj.48b95dace995060b", null))
	if(DOING_INTERACTION(user, src))
		balloon_alert(user, LANG("obj.94b27c3f734d7f63", null))
		return
	if(atom_integrity >= max_integrity)
		balloon_alert(user, LANG("obj.9e4cb9c48761232b", null))
		return
	if(!W.tool_start_check(user, amount=1, heat_required = HIGH_TEMPERATURE_REQUIRED))
		return
	user.balloon_alert_to_viewers(LANG("obj.2ca5dd8041de3d6b", list(src)), LANG("obj.ecacaee5cb6304e8", list(src)))
	audible_message(span_hear(LANG("obj.1aa82fa3545466eb", null)))
	var/did_the_thing
	while(atom_integrity < max_integrity)
		if(W.use_tool(src, user, 2.5 SECONDS, volume=50, extra_checks = CALLBACK(src, PROC_REF(can_still_fix))))
			did_the_thing = TRUE
			atom_integrity += min(10, (max_integrity - atom_integrity))
			audible_message(span_hear(LANG("obj.1aa82fa3545466eb", null)))
		else
			break
	if(did_the_thing)
		user.balloon_alert_to_viewers(LANG("obj.e3cfcef3ece6006c", list((atom_integrity >= max_integrity) ? "fully" : "partially", src)))
	else
		user.balloon_alert_to_viewers(LANG("obj.1324f89299b29d06", list(src)), LANG("obj.87135ad0ded5d854", null))

///can we still fix the bike lol
/obj/vehicle/ridden/bicycle/proc/can_still_fix()
	return !fried



