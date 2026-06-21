/obj/structure/sacrificealtar
	name = "祭坛"
	desc = "祭坛为祭祀神灵而设计的祭坛，按住Alt键并单击可以牺牲一个被扣住的生物。"
	icon = 'icons/obj/service/hand_of_god_structures.dmi'
	icon_state = "sacrificealtar"
	anchored = TRUE
	density = FALSE
	can_buckle = 1

/obj/structure/sacrificealtar/click_alt(mob/living/user)
	if(!has_buckled_mobs())
		return CLICK_ACTION_BLOCKING
	var/mob/living/buckled_mob = locate() in buckled_mobs
	if(!buckled_mob)
		return CLICK_ACTION_BLOCKING
	to_chat(user, span_notice("你举行神圣仪式，献祭了 [buckled_mob]。"))
	buckled_mob.investigate_log("has been sacrificially gibbed on an altar.", INVESTIGATE_DEATHS)
	buckled_mob.gib(DROP_ALL_REMAINS)
	message_admins("[ADMIN_LOOKUPFLW(user)] has sacrificed [key_name_admin(buckled_mob)] on the sacrificial altar at [AREACOORD(src)].")
	return CLICK_ACTION_SUCCESS

/obj/structure/healingfountain
	name = "治愈喷泉"
	desc = "一个含有生命之水的喷泉。"
	icon = 'icons/obj/service/hand_of_god_structures.dmi'
	icon_state = "fountain"
	anchored = TRUE
	density = TRUE
	var/time_between_uses = 1800
	var/last_process = 0

/obj/structure/healingfountain/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(last_process + time_between_uses > world.time)
		to_chat(user, span_notice("喷泉似乎是空的。"))
		return
	last_process = world.time
	to_chat(user, span_notice("当你触摸时，水感觉温暖而舒缓。喷泉随后立即干涸。"))
	user.reagents.add_reagent(/datum/reagent/medicine/omnizine/godblood,20)
	update_appearance()
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom/, update_appearance)), time_between_uses)


/obj/structure/healingfountain/update_icon_state()
	if(last_process + time_between_uses > world.time)
		icon_state = "fountain"
	else
		icon_state = "fountain-red"
	return ..()
