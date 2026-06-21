/obj/effect/portal/permanent/one_way/reebe
	name = "嗡鸣的传送门"
	desc = "一个高大的、发光的传送门。可以听到低沉的齿轮转动声。你觉得要回来可不容易。"
	id = "reebe_entry"
	color = "#fcbe03"


/obj/effect/portal/permanent/one_way/reebe/clock_only // Portal that only lets clock cultists through, so they get their head start.
	name = "嘈杂嗡鸣的传送门"
	/// If this prevents non-clockies from entering
	var/clock_only = TRUE


/obj/effect/portal/permanent/one_way/reebe/clock_only/teleport(atom/movable/movable, force)
	if(!ismob(movable))
		return FALSE

	var/mob/movable_mob = movable

	if(!IS_CLOCK(movable_mob) && clock_only && !isobserver(movable_mob))
		to_chat(movable_mob, span_warning("当你试图接近 [src] 时，一股无形的力量将你推了回来！"))
		return FALSE

	return ..()


/obj/effect/portal/permanent/one_way/reebe/leaving
	desc = "为那些希望或需要离开神圣前哨站的人准备。"
	id = "reebe_exit"


/obj/effect/portal/permanent/one_way/reebe/leaving/set_linked()
	hard_target = get_safe_random_station_turf()


/obj/effect/portal/permanent/one_way/reebe/leaving/teleport(atom/movable/movable, force)
	to_chat(movable, span_notice("你准备好进入 [src]……"))

	if(!do_after(movable, 4 SECONDS))
		return FALSE

	return ..()
