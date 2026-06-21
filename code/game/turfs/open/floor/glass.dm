/turf/open/floor/glass
	name = "玻璃地板"
	desc = "别往上跳，或者跳也行，我又不是你妈。"
	icon = 'icons/turf/floors/glass.dmi'
	icon_state = "glass-0"
	base_icon_state = "glass"
	layer = GLASS_FLOOR_LAYER
	underfloor_accessibility = UNDERFLOOR_VISIBLE
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_TURF_OPEN + SMOOTH_GROUP_FLOOR_TRANSPARENT_GLASS
	canSmoothWith = SMOOTH_GROUP_FLOOR_TRANSPARENT_GLASS
	footstep = FOOTSTEP_PLATING
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	floor_tile = /obj/item/stack/tile/glass
	/// List of /atom/movable/render_step that are being used to make this glass floor glow
	/// These are OWNED by this floor, they delete when we delete them, not before not after
	var/list/glow_stuff
	/// How much alpha to leave when cutting away emissive blockers
	var/alpha_to_leave = 255
	/// Color of starlight to use. Defaults to STARLIGHT_COLOR if not set
	var/starlight_color

/turf/open/floor/glass/broken_states()
	return list("glass-damaged1", "glass-damaged2", "glass-damaged3")

/turf/open/floor/glass/Initialize(mapload)
	icon_state = "" //Prevent the normal icon from appearing behind the smooth overlays
	..()
	return INITIALIZE_HINT_LATELOAD

/turf/open/floor/glass/LateInitialize()
	ADD_TURF_TRANSPARENCY(src, INNATE_TRAIT)
	setup_glow()

/turf/open/floor/glass/Destroy()
	. = ..()
	QDEL_LIST(glow_stuff)
	UnregisterSignal(SSdcs, COMSIG_STARLIGHT_COLOR_CHANGED)

/// If this turf is at the bottom of the local rendering stack
/// Then we're gonna make it emissive block so the space below glows
/turf/open/floor/glass/proc/setup_glow()
	if(GET_TURF_PLANE_OFFSET(src) != GET_LOWEST_STACK_OFFSET(z)) // We ain't the bottom brother
		return
	// We assume no parallax means no space means no light
	if(SSmapping.level_trait(z, ZTRAIT_NOPARALLAX))
		return

	glow_stuff = partially_block_emissives(src, alpha_to_leave)
	if(!starlight_color)
		RegisterSignal(SSdcs, COMSIG_STARLIGHT_COLOR_CHANGED, PROC_REF(starlight_changed))
	else
		UnregisterSignal(SSdcs, COMSIG_STARLIGHT_COLOR_CHANGED)
	set_light(2, 1, starlight_color || GLOB.starlight_color, l_height = LIGHTING_HEIGHT_SPACE)

/turf/open/floor/glass/proc/starlight_changed(datum/source, old_star, new_star)
	if(light_color == old_star)
		set_light(l_color = new_star)

/turf/open/floor/glass/icemoon
	initial_gas_mix = ICEMOON_DEFAULT_ATMOS

/turf/open/floor/glass/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/glass/reinforced
	name = "强化玻璃地板"
	desc = "在上面随便跳吧，它能撑得住。"
	icon = 'icons/turf/floors/reinf_glass.dmi'
	icon_state = "reinf_glass-0"
	base_icon_state = "reinf_glass"
	floor_tile = /obj/item/stack/tile/rglass
	alpha_to_leave = 206

/turf/open/floor/glass/reinforced/telecomms
	initial_gas_mix = TCOMMS_ATMOS

/turf/open/floor/glass/reinforced/icemoon
	initial_gas_mix = ICEMOON_DEFAULT_ATMOS

/turf/open/floor/glass/reinforced/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/glass/plasma
	name = "等离子玻璃地板"
	desc = "纳米传讯材料安全部门的研究尚未确定跳上此物是否安全，请自行承担风险。"
	icon = 'icons/turf/floors/plasma_glass.dmi'
	icon_state = "plasma_glass-0"
	base_icon_state = "plasma_glass"
	floor_tile = /obj/item/stack/tile/glass/plasma
	starlight_color = COLOR_STRONG_VIOLET
	alpha_to_leave = 255

/turf/open/floor/glass/plasma/icemoon
	initial_gas_mix = ICEMOON_DEFAULT_ATMOS

/turf/open/floor/glass/plasma/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/glass/reinforced/plasma
	name = "强化等离子玻璃地板"
	desc = "尽管跳上去吧，当你在机甲里时跳上去，它能承受得住。"
	icon = 'icons/turf/floors/reinf_plasma_glass.dmi'
	icon_state = "reinf_plasma_glass-0"
	base_icon_state = "reinf_plasma_glass"
	floor_tile = /obj/item/stack/tile/rglass/plasma
	starlight_color = COLOR_STRONG_VIOLET
	alpha_to_leave = 206

/turf/open/floor/glass/reinforced/plasma/icemoon
	initial_gas_mix = ICEMOON_DEFAULT_ATMOS

/turf/open/floor/glass/reinforced/plasma/airless
	initial_gas_mix = AIRLESS_ATMOS
