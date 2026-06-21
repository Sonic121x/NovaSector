/obj/structure/closet/crate
	name = "板条箱"
	desc = "一个长方形的钢制板条箱"
	icon = 'icons/obj/storage/crates.dmi'
	icon_state = "crate"
	base_icon_state = "crate"
	req_access = null
	horizontal = TRUE
	allow_objects = TRUE
	allow_dense = TRUE
	dense_when_open = TRUE
	delivery_icon = "deliverycrate"
	open_sound = 'sound/machines/crate/crate_open.ogg'
	close_sound = 'sound/machines/crate/crate_close.ogg'
	open_sound_volume = 35
	close_sound_volume = 50
	drag_slowdown = 0
	door_anim_time = 0 // no animation
	pass_flags_self = PASSSTRUCTURE | LETPASSTHROW
	x_shake_pixel_shift = 1
	y_shake_pixel_shift = 2
	/// Mobs standing on it are nudged up by this amount.
	var/elevation = 14
	/// The same, but when the crate is open
	var/elevation_open = 14
	/// The time spent to climb this crate.
	var/crate_climb_time = 2 SECONDS
	/// The reference of the manifest paper attached to the cargo crate.
	var/datum/weakref/manifest
	/// Where the Icons for lids are located.
	var/lid_icon = 'icons/obj/storage/crates.dmi'
	/// Icon state to use for lid to display when opened. Leave undefined if there isn't one.
	var/lid_icon_state
	/// Controls the X value of the lid, allowing left and right pixel movement.
	var/lid_w = 0
	/// Controls the Y value of the lid, allowing up and down pixel movement.
	var/lid_z = 0
	var/weld_w = 0
	var/weld_z = 0

/obj/structure/closet/crate/Initialize(mapload)
	AddElement(/datum/element/climbable, climb_time = crate_climb_time, climb_stun = 0) //add element in closed state before parent init opens it(if it does)
	if(elevation)
		AddElement(/datum/element/climb_walkable)
		AddElement(/datum/element/elevation, pixel_shift = elevation)
	. = ..()

	var/static/list/crate_paint_jobs
	if(isnull(crate_paint_jobs))
		crate_paint_jobs = list(
			"Internals" = list("icon_state" = "o2crate"),
			"Medical" = list("icon_state" = "medical"),
			"Medical Plus" = list("icon_state" = "medicalcrate"),
			"Radiation" = list("icon_state" = "radiation"),
			"Hydrophonics" = list("icon_state" = "hydrocrate"),
			"Science" = list("icon_state" = "scicrate"),
			"Robotics" = list("icon_state" = "robo"),
			"Solar" = list("icon_state" = "engi_e_crate"),
			"Engineering" = list("icon_state" = "engi_crate"),
			"Atmospherics" = list("icon_state" = "atmos"),
			"Cargo" = list("icon_state" = "cargo"),
			"Mining" = list("icon_state" = "mining"),
			"Command" = list("icon_state" = "centcom"),
		)
	if(paint_jobs)
		paint_jobs = crate_paint_jobs
	AddComponent(/datum/component/soapbox)

/obj/structure/closet/crate/Destroy()
	manifest = null
	return ..()

/obj/structure/closet/crate/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(!istype(mover, /obj/structure/closet))
		var/obj/structure/closet/crate/locatedcrate = locate(/obj/structure/closet/crate) in get_turf(mover)
		if(locatedcrate) //you can walk on it like tables, if you're not in an open crate trying to move to a closed crate
			if(opened) //if we're open, allow entering regardless of located crate openness
				return TRUE
			if(!locatedcrate.opened) //otherwise, if the located crate is closed, allow entering
				return TRUE

/obj/structure/closet/crate/update_icon_state()
	icon_state = "[isnull(base_icon_state) ? initial(icon_state) : base_icon_state][opened ? "open" : ""]"
	return ..()

/obj/structure/closet/crate/closet_update_overlays(list/new_overlays)
	. = new_overlays
	if(manifest)
		. += "manifest"

	if(!opened)
		if(broken)
			. += "securecrateemag"
		else if(locked)
			. += "securecrater"
		else if(secure)
			. += "securecrateg"

	if(welded)
		var/mutable_appearance/weld_overlay = mutable_appearance(icon, "welded")
		weld_overlay.pixel_w = weld_w
		weld_overlay.pixel_z = weld_z
		. += weld_overlay

	if(opened && lid_icon_state)
		var/mutable_appearance/lid = mutable_appearance(icon = lid_icon, icon_state = lid_icon_state)
		lid.pixel_w = lid_w
		lid.pixel_z = lid_z
		lid.layer = layer
		. += lid

/obj/structure/closet/crate/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	tear_manifest(user)

/obj/structure/closet/crate/after_open(mob/living/user, force)
	. = ..()
	RemoveElement(/datum/element/climbable, climb_time = crate_climb_time, climb_stun = 0)
	AddElement(/datum/element/climbable, climb_time = crate_climb_time * 0.5, climb_stun = 0)
	if(elevation != elevation_open)
		if(elevation)
			RemoveElement(/datum/element/elevation, pixel_shift = elevation)
		if(elevation_open)
			AddElement(/datum/element/elevation, pixel_shift = elevation_open)

	tear_manifest()

/obj/structure/closet/crate/after_close(mob/living/user)
	. = ..()
	RemoveElement(/datum/element/climbable, climb_time = crate_climb_time * 0.5, climb_stun = 0)
	AddElement(/datum/element/climbable, climb_time = crate_climb_time, climb_stun = 0)
	if(elevation != elevation_open)
		if(elevation_open)
			RemoveElement(/datum/element/elevation, pixel_shift = elevation_open)
		if(elevation)
			AddElement(/datum/element/elevation, pixel_shift = elevation)

///Spawns two to six maintenance spawners inside the closet
/obj/structure/closet/proc/populate_with_random_maint_loot()
	SIGNAL_HANDLER

	for (var/i in 1 to rand(2,6))
		new /obj/effect/spawner/random/maintenance(src)

	UnregisterSignal(src, COMSIG_CLOSET_CONTENTS_INITIALIZED)

///Removes the supply manifest from the closet
/obj/structure/closet/crate/proc/tear_manifest(mob/user)
	var/obj/item/paper/fluff/jobs/cargo/manifest/our_manifest = manifest?.resolve()
	if(QDELETED(our_manifest))
		manifest = null
		return
	if(user)
		to_chat(user, span_notice("你从[src]上撕下了货物清单。"))
	playsound(src, 'sound/items/poster/poster_ripped.ogg', 75, TRUE)

	our_manifest.forceMove(drop_location(src))
	if(ishuman(user))
		user.put_in_hands(our_manifest)
	manifest = null
	update_appearance()

/obj/structure/closet/crate/preopen
	opened = TRUE
	icon_state = "crateopen"

/obj/structure/closet/crate/coffin
	name = "棺椁"
	desc = "一个为逝者准备的安葬容器。"
	icon_state = "coffin"
	base_icon_state = "coffin"
	resistance_flags = FLAMMABLE
	max_integrity = 70
	material_drop = /obj/item/stack/sheet/mineral/wood
	material_drop_amount = 5
	open_sound = 'sound/machines/closet/wooden_closet_open.ogg'
	close_sound = 'sound/machines/closet/wooden_closet_close.ogg'
	open_sound_volume = 25
	close_sound_volume = 50
	can_install_electronics = FALSE
	paint_jobs = null
	elevation_open = 0
	can_weld_shut = FALSE
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT * 5)

/obj/structure/closet/crate/trashcart //please make this a generic cart path later after things calm down a little
	desc = "一个沉重的，带有轮子的金属垃圾箱。"
	name = "垃圾车"
	icon_state = "trashcart"
	base_icon_state = "trashcart"
	can_install_electronics = FALSE
	paint_jobs = null
	weld_z = 5

/obj/structure/closet/crate/trashcart/laundry
	name = "洗衣车"
	desc = "用于运送大量待洗衣物的大车。"
	icon_state = "laundry"
	base_icon_state = "laundry"
	elevation = 14
	elevation_open = 14
	can_weld_shut = FALSE

/obj/structure/closet/crate/trashcart/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_SLUDGE, CELL_VIRUS_TABLE_GENERIC, rand(2,3), 15)
	AddElement(/datum/element/noisy_movement)

/obj/structure/closet/crate/trashcart/filled

/obj/structure/closet/crate/trashcart/filled/Initialize(mapload)
	. = ..()
	if(mapload)
		new /obj/effect/spawner/random/trash/grime(loc) //needs to be done before the trashcart is opened because it spawns things in a range outside of the trashcart

/obj/structure/closet/crate/trashcart/filled/PopulateContents()
	. = ..()
	for(var/i in 1 to rand(7,15))
		new /obj/effect/spawner/random/trash/garbage(src)
		if(prob(12))
			new /obj/item/storage/bag/trash/filled(src)

/obj/structure/closet/crate/internals
	desc = "一板条箱呼吸配件"
	name = "呼吸配件板条箱"
	icon_state = "o2crate"
	base_icon_state = "o2crate"

/obj/structure/closet/crate/medical
	desc = "一个医疗板条箱"
	name = "医疗板条箱"
	icon_state = "medicalcrate"
	base_icon_state = "medicalcrate"

/obj/structure/closet/crate/deforest
	name = "\improper DeForest Medical crate"
	desc = "一个迪福里斯特品牌的医疗用品板条箱。"
	icon_state = "deforest"
	base_icon_state = "deforest"

/obj/structure/closet/crate/interdyne_normal
	name = "\improper Interdyne Pharmaceutics crate"
	desc = "An Interdyne Pharmaceutics brand crate. Probably contains helpful chemicals? Hopefully contains helpful chemicals."
	icon_state = "interdynecrate"
	base_icon_state = "interdynecrate"

/obj/structure/closet/crate/medical/department
	icon_state = "medical"
	base_icon_state = "medical"

/obj/structure/closet/crate/freezer
	desc = "一个冰柜"
	name = "冰柜"
	icon_state = "freezer"
	base_icon_state = "freezer"
	paint_jobs = null
	sealed = TRUE
	/// The rate at which the internal air mixture cools
	var/cooling_rate_per_second = 4
	/// Minimum temperature of the internal air mixture
	var/minimum_temperature = T0C - 60

/obj/structure/closet/crate/freezer/process_internal_air(seconds_per_tick)
	if(opened)
		var/datum/gas_mixture/current_exposed_air = loc.return_air()
		if(!current_exposed_air)
			return
		// The internal air won't cool down the external air when the freezer is opened.
		internal_air.temperature = max(current_exposed_air.temperature, internal_air.temperature)
		return ..()
	else
		if(internal_air.temperature <= minimum_temperature)
			return
		var/temperature_decrease_this_tick = min(cooling_rate_per_second * seconds_per_tick, internal_air.temperature - minimum_temperature)
		internal_air.temperature -= temperature_decrease_this_tick

/obj/structure/closet/crate/freezer/blood
	name = "血袋冰柜"
	desc = "一个含有血袋的冰柜"

/obj/structure/closet/crate/freezer/blood/PopulateContents()
	. = ..()
	new /obj/item/reagent_containers/blood(src)
	new /obj/item/reagent_containers/blood(src)
	new /obj/item/reagent_containers/blood/a_minus(src)
	new /obj/item/reagent_containers/blood/b_minus(src)
	new /obj/item/reagent_containers/blood/b_plus(src)
	new /obj/item/reagent_containers/blood/o_minus(src)
	new /obj/item/reagent_containers/blood/o_plus(src)
	new /obj/item/reagent_containers/blood/lizard(src)
	new /obj/item/reagent_containers/blood/ethereal(src)
	for(var/i in 1 to 3)
		new /obj/item/reagent_containers/blood/random(src)
	new /obj/item/paper/fluff/jobs/medical/blood_types(src)

/obj/structure/closet/crate/freezer/surplus_limbs
	name = "多余廉价假肢箱"
	desc = "一个装有各种廉价假肢的板条箱。"

/obj/structure/closet/crate/freezer/surplus_limbs/PopulateContents()
	. = ..()
	new /obj/item/bodypart/arm/left/robot/surplus(src)
	new /obj/item/bodypart/arm/left/robot/surplus(src)
	new /obj/item/bodypart/arm/right/robot/surplus(src)
	new /obj/item/bodypart/arm/right/robot/surplus(src)
	new /obj/item/bodypart/leg/left/robot/surplus(src)
	new /obj/item/bodypart/leg/left/robot/surplus(src)
	new /obj/item/bodypart/leg/right/robot/surplus(src)
	new /obj/item/bodypart/leg/right/robot/surplus(src)

/obj/structure/closet/crate/freezer/organ
	name = "器官冷冻柜"
	desc = "一个装有一套有机器官的冷冻柜。"

/obj/structure/closet/crate/freezer/organ/PopulateContents()
	. = ..()
	new /obj/item/organ/heart(src)
	new /obj/item/organ/lungs(src)
	new /obj/item/organ/eyes(src)
	new /obj/item/organ/ears(src)
	new /obj/item/organ/tongue(src)
	new /obj/item/organ/liver(src)
	new /obj/item/organ/stomach(src)
	new /obj/item/organ/appendix(src)

/obj/structure/closet/crate/freezer/food
	name = "食品冰盒"
	icon_state = "food"
	base_icon_state = "food"

/obj/structure/closet/crate/freezer/donk
	name = "\improper 唐克公司冰箱"
	desc = "一个唐克公司品牌的冰箱，让你的唐克包和泡沫弹药保持新鲜！"
	icon_state = "donkcocrate"
	base_icon_state = "donkcocrate"

/obj/structure/closet/crate/self
	name = "\improper S.E.L.F. 板条箱"
	desc = "A robust-looking crate with a seemingly decorative holographic display. The front of the crate proudly declares its allegiance to the notorious terrorist group 'S.E.L.F'."
	icon_state = "selfcrate"
	base_icon_state = "selfcrate"

/obj/structure/closet/crate/radiation
	desc = "一个标有辐射警告的板条箱。"
	name = "辐射箱"
	icon_state = "radiation"
	base_icon_state = "radiation"

/obj/structure/closet/crate/hydroponics
	name = "水培箱"
	desc = "你清除那些杂草与害虫所需要的一切工具。"
	icon_state = "hydrocrate"
	base_icon_state = "hydrocrate"

/obj/structure/closet/crate/centcom
	name = "中央司令部板条箱"
	icon_state = "centcom"
	base_icon_state = "centcom"

/obj/structure/closet/crate/cargo
	name = "货物板条箱"
	icon_state = "cargo"
	base_icon_state = "cargo"

/obj/structure/closet/crate/robust
	name = "鲁棒工业板条箱"
	desc = "Robust Industries LLC. 板条箱。有种奇怪的怀旧感。"
	icon_state = "robust"
	base_icon_state = "robust"

/obj/structure/closet/crate/cargo/mining
	name = "采矿板条箱"
	icon_state = "mining"
	base_icon_state = "mining"

/obj/structure/closet/crate/engineering
	name = "工程箱"
	icon_state = "engi_crate"
	base_icon_state = "engi_crate"

/obj/structure/closet/crate/nakamura
	name = "中村工程板条箱"
	desc = "来自中村工程的板条箱，很可能装有工程物资或MOD核心。"
	icon_state = "nakamura"
	base_icon_state = "nakamura"

/obj/structure/closet/crate/engineering/electrical
	icon_state = "engi_e_crate"
	base_icon_state = "engi_e_crate"

/obj/structure/closet/crate/engineering/atmos
	name = "大气板条箱"
	icon_state = "atmos"
	base_icon_state = "atmos"

/obj/structure/closet/crate/rcd
	desc = "一箱储存了一个RCD的板条箱"
	name = "\improper RCD-快捷建设装置板条箱"
	icon_state = "engi_crate"
	base_icon_state = "engi_crate"

/obj/structure/closet/crate/rcd/PopulateContents()
	..()
	for(var/i in 1 to 4)
		new /obj/item/rcd_ammo(src)
	new /obj/item/construction/rcd(src)

/obj/structure/closet/crate/science
	name = "科研板条箱"
	desc = "一个科研板条箱。"
	icon_state = "scicrate"
	base_icon_state = "scicrate"

/obj/structure/closet/crate/science/robo
	name = "机器人学板条箱"
	icon_state = "robo"
	base_icon_state = "robo"

/obj/structure/closet/crate/mod
	name = "MOD板条箱"
	icon_state = "robo"
	base_icon_state = "robo"

/obj/structure/closet/crate/mod/PopulateContents()
	..()
	for(var/i in 1 to 3)
		new /obj/item/mod/core/standard(src)
	for(var/i in 1 to 2)
		new /obj/item/clothing/neck/link_scryer/loaded(src)

/obj/structure/closet/crate/solarpanel_small
	name = "廉价太阳能板条箱"
	icon_state = "engi_e_crate"
	base_icon_state = "engi_e_crate"

/obj/structure/closet/crate/solarpanel_small/PopulateContents()
	..()
	for(var/i in 1 to 13)
		new /obj/item/solar_assembly(src)
	new /obj/item/circuitboard/computer/solar_control(src)
	new /obj/item/paper/guides/jobs/engi/solars(src)
	new /obj/item/electronics/tracker(src)

/obj/structure/closet/crate/goldcrate
	name = "黄金板条箱"
	desc = "一个长方形的钢制板条箱。它似乎被漆成了金色。"
	icon_state = "gold"
	base_icon_state = "gold"

/obj/structure/closet/crate/goldcrate/PopulateContents()
	..()
	new /obj/item/storage/belt/champion(src)

/obj/structure/closet/crate/goldcrate/populate_contents_immediate()
	. = ..()

	for(var/i in 1 to 3)
		new /obj/item/stack/sheet/mineral/gold(src, 1, FALSE)

/obj/structure/closet/crate/silvercrate
	name = "白银板条箱"
	desc = "一个长方形的钢制板条箱。它似乎被漆成了银色。"
	icon_state = "silver"
	base_icon_state = "silver"

/obj/structure/closet/crate/silvercrate/PopulateContents()
	..()
	for(var/i in 1 to 5)
		new /obj/item/coin/silver(src)

/obj/structure/closet/crate/decorations
	icon_state = "engi_crate"
	base_icon_state = "engi_crate"

/obj/structure/closet/crate/decorations/PopulateContents()
	. = ..()
	for(var/i in 1 to 4)
		new /obj/effect/spawner/random/decoration/generic(src)

/obj/structure/closet/crate/add_to_roundstart_list()
	return

/obj/structure/closet/crate/glitter
	name = "粉色板条箱"
	desc = "一个闪亮的粉色板条箱。"
	icon_state = "pink"
	base_icon_state = "pink"
	var/glitter_prob = 25
	var/glitter_color = "#ff8080"

/obj/structure/closet/crate/glitter/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	. = ..()

	var/turf/old_turf = get_turf(old_loc)
	if(!old_turf)
		return
	if(prob(glitter_prob))
		old_turf.spawn_glitter(list("[glitter_color]" = 100))

/obj/structure/closet/crate/glitter/lavender
	name = "薰衣草色板条箱"
	desc = "一个闪亮的紫色……不，是薰衣草色板条箱。"
	icon_state = "lavender"
	base_icon_state = "lavender"
	glitter_color = "#db80ff"

/obj/structure/closet/crate/market
	name = "shield bubble"
	desc = "A rippling blue energy bubble, capable of sustaining itself until it hits a solid wall."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield2"
	base_icon_state = "shield2"

/obj/structure/closet/crate/market/after_open(mob/living/user, force)
	. = ..()
	visible_message(span_notice("[src] pops as [user] touches it!"))
	pop_crate()

/obj/structure/closet/crate/market/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	pop_crate()

/// Called when the bubble either arrives at the station, or is interacted with someone/something.
/obj/structure/closet/crate/market/proc/pop_crate()
	do_sparks(1, TRUE, get_turf(src))
	dump_contents()
	qdel(src)
