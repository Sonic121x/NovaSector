/obj/item/cortical_cage
	name = "脑蛭笼"
	desc = "一种用于捕获脑蛭的无害笼子。"
	icon = 'modular_nova/modules/cortical_borer/icons/items.dmi'
	icon_state = "cage"

	///If true, the trap is "open" and can trigger.
	var/opened = FALSE
	///The radio that is inserted into the trap.
	var/obj/item/radio/internal_radio
	///The borer that is inside the trap
	var/mob/living/basic/cortical_borer/trapped_borer

/obj/item/cortical_cage/Initialize(mapload)
	. = ..()
	update_appearance()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(spring_trap),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/item/cortical_cage/update_overlays()
	. = ..()
	if(trapped_borer)
		. += "borer"
	if(internal_radio)
		. += "radio"
	if(opened)
		. += "doors_open"
	else
		. += "doors_closed"

/obj/item/cortical_cage/attack_self(mob/user, modifiers)
	opened = !opened
	if(opened)
		user.visible_message("[user]打开了[src]。", "你打开了[src]。", "你听到一声金属撞击声。")
	else
		user.visible_message("[user]关上了[src]。", "你关上了[src]。", "你听到一声金属撞击声。")
	playsound(src, 'sound/machines/airlock/boltsup.ogg', 30, TRUE)
	update_appearance()

/obj/item/cortical_cage/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(istype(attacking_item, /obj/item/radio))
		internal_radio = attacking_item
		internal_radio.forceMove(src)
		visible_message("[internal_radio]咔哒一声附着到了[src]上。", "你将[internal_radio]安装到了[src]上。", "你听到咔哒一声。")
		update_appearance()
		return
	return ..()

/obj/item/cortical_cage/crowbar_act(mob/living/user, obj/item/tool)
	. = ..()
	if(internal_radio)
		internal_radio.forceMove(get_turf(src))
		user.visible_message("[internal_radio]从[src]上弹开了。", "你将[internal_radio]从[src]上撬了下来。", "你听到咔哒一声，接着是一声巨大的金属撞击声。")
		internal_radio = null
		update_appearance()
		return

/obj/item/cortical_cage/proc/spring_trap(datum/source, atom/movable/AM)
	SIGNAL_HANDLER
	//it will only trigger on a cortical borer, and it has to be opened
	if(!iscorticalborer(AM) || !opened)
		return
	trapped_borer = AM
	trapped_borer.visible_message("[trapped_borer]被吸进了[src]！", "你被吸进了[src]里！", "你听到一阵抽吸声。")
	trapped_borer.forceMove(src)
	opened = FALSE
	if(internal_radio)
		var/area/src_area = get_area(src)
		internal_radio.talk_into(src, "A cortical borer has been trapped in [src_area].", RADIO_CHANNEL_COMMON)
	playsound(src, 'sound/machines/airlock/boltsup.ogg', 30, TRUE)
	update_appearance()

/obj/item/cortical_cage/relaymove(mob/living/user, direction)
	if(!iscorticalborer(user))
		user.forceMove(get_turf(src))
		update_appearance()
		return
	if(opened)
		loc.visible_message(span_notice("[user]从[src]里爬了出来！"), \
		span_warning("[user]从[src]里跳了出来！"))
		opened = FALSE
		trapped_borer.forceMove(get_turf(src))
		trapped_borer = null
		update_appearance()
		return
	else if(user.client)
		container_resist_act(user)

/obj/item/cortical_cage/container_resist_act(mob/living/user)
	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	to_chat(user, span_notice("你开始尝试从栏杆之间挤出去！（这需要时间。）"))
	to_chat(loc, span_warning("你看到[user]开始尝试从栏杆之间挤出去！"))
	if(!do_after(user, rand(30 SECONDS, 40 SECONDS), target = user) || opened || !(user in contents))
		return
	loc.visible_message(span_warning("[user]从[src]的把手之间挤了出来！"), null, null, null, user)
	to_chat(user, span_boldannounce("搞定，你挤出来了！"))
	opened = FALSE
	trapped_borer.forceMove(get_turf(src))
	trapped_borer = null
	update_appearance()
