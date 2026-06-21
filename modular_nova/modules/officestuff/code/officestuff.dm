/obj/structure/grandfatherclock
	name = "老爷钟"
	icon = 'modular_nova/modules/officestuff/icons/cowboyobh.dmi'
	icon_state = "grandfather_clock"
	desc = "Tick, tick, tick, tick. It stands tall and daunting, loudly and ominously ticking, yet the hands are stuck close to midnight, the closer you get, the louder a faint whisper becomes a scream, a plea, something, but whatever it is, it says 'I am the Master, and you will obey me.'"
	var/datum/looping_sound/grandfatherclock/soundloop

// stolen from the wall clock
/obj/structure/grandfatherclock/examine(mob/user)
	. = ..()
	. += span_info("The current CST (local) time is: [round_timestamp()].")
	. += span_info("当前的TCT（银河）时间是：[time2text(world.realtime, "hh:mm:ss")]。")
	if(soundloop)
		. += span_notice("钟的指针正在自由地滴答走动。它们可以被<b>拧</b>紧。")
	else
		. += span_notice("钟的指针已被<b>拧</b>紧。")


// . += span_notice("The <b>screws</b> on the clock hands are loose, freely ticking away.")
// door_status" = density ? "closed" : "open",
/datum/looping_sound/grandfatherclock
	mid_sounds = list('modular_nova/modules/officestuff/sound/clock_ticking.ogg' = 1)
	mid_length = 12 SECONDS
	volume = 10

/obj/structure/grandfatherclock/Initialize(mapload)
	. = ..()
	soundloop = new(src, TRUE)

/obj/structure/grandfatherclock/Destroy()
	QDEL_NULL(soundloop)
	return ..()

/obj/structure/grandfatherclock/screwdriver_act(mob/living/user, obj/item/tool)
	if(!soundloop)
		balloon_alert(user, "正在拧松指针……")
		if(do_after(user, 2 SECONDS, src))
			soundloop = new(src, TRUE)
			balloon_alert(user, "指针已拧松！")
			return ITEM_INTERACT_SUCCESS
		return ..()

	balloon_alert(user, "拧紧指针中...")
	if(do_after(user, 2 SECONDS, src))
		QDEL_NULL(soundloop)
		balloon_alert(user, "指针已拧紧！")
		return ITEM_INTERACT_SUCCESS
	return ..()
/obj/structure/sign/painting/meat
	name = "与肉同在的人像"
	desc = "一幅描绘扭曲人像的画，坐在一分为二的牛中间。"
	icon = 'modular_nova/modules/officestuff/icons/cowboyobh.dmi'
	icon_state = "meat"
	sign_change_name = "Painting - Meat"
	is_editable = TRUE

/obj/structure/sign/painting/parting
	name = "分波"
	desc = "一幅描绘分开的大海的画，红日洒在蓝色的海洋上。"
	icon = 'modular_nova/modules/officestuff/icons/cowboyobh.dmi'
	icon_state = "jmwt4"
	is_editable = TRUE
	sign_change_name = "Painting - Waves"


/obj/structure/sign/paint
	name = "画作"
	desc = "你不应该看到这个。"
	icon = 'modular_nova/modules/officestuff/icons/cowboyobh.dmi'
	icon_state = "gravestone"


