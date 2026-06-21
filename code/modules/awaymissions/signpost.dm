/obj/structure/signpost
	name = "路标"
	desc = "难道没人给我个指示吗？"
	icon = 'icons/obj/fluff/general.dmi'
	icon_state = "signpost"
	anchored = TRUE
	density = TRUE

	/// Whether or not this enables the Houlihan element.
	var/teleports = FALSE
	/// Optional replacement for the teleport question.
	var/question = null
	/// Optional list of z-levels that the Houlihan element can send us to. Modify this on Initialize().
	VAR_FINAL/list/zlevels = null

/obj/structure/signpost/Initialize(mapload)
	..()
	set_light(2)
	return INITIALIZE_HINT_LATELOAD

/obj/structure/signpost/LateInitialize()
	// This is here cause we wanna be super sure zlevels is properly initialized
	if(teleports)
		AddComponent(/datum/component/houlihan_teleport, question, zlevels)

/* ----------------- */

/obj/structure/signpost/salvation
	name = "\proper 救赎"
	desc = "在最黑暗的时刻，我们将找到回家的路。"
	resistance_flags = INDESTRUCTIBLE
	teleports = TRUE

/obj/structure/signpost/void
	name = "宇宙边缘的路标"
	desc = "无向虚空中的一个方向。"
	density = FALSE
	/// Brightness of the signpost.
	var/range = 2
	/// Light power of the signpost.
	var/power = 0.8

/obj/structure/signpost/void/Initialize(mapload)
	. = ..()
	set_light(range, power)
