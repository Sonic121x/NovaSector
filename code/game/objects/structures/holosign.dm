
//holographic signs and barriers

/obj/structure/holosign
	name = "全息标识"
	icon = 'icons/effects/holosigns.dmi'
	anchored = TRUE
	max_integrity = 1
	armor_type = /datum/armor/structure_holosign
	// How can you freeze a trick of the light?
	resistance_flags = FREEZE_PROOF
	var/obj/item/holosign_creator/projector
	var/use_vis_overlay = TRUE

/datum/armor/structure_holosign
	bullet = 50
	laser = 50
	energy = 50
	fire = 20
	acid = 20

/obj/structure/holosign/Initialize(mapload, source_projector)
	. = ..()
	AddComponent(/datum/component/holographic_nature)
	create_vis_overlay()
	if(source_projector)
		projector = source_projector
		LAZYADD(projector.signs, src)

/obj/structure/holosign/Destroy()
	if(projector)
		LAZYREMOVE(projector.signs, src)
		projector = null
	return ..()

/obj/structure/holosign/update_atom_colour()
	. = ..()
	create_vis_overlay()

/obj/structure/holosign/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	attack_holosign(user, modifiers)

/obj/structure/holosign/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(!. && isprojectile(mover)) // Its short enough to be shot over
		return TRUE

/obj/structure/holosign/proc/attack_holosign(mob/living/user, list/modifiers)
	user.do_attack_animation(src, ATTACK_EFFECT_PUNCH)
	user.changeNext_move(CLICK_CD_MELEE)
	take_damage(5 , BRUTE, MELEE, 1)
	log_combat(user, src, "swatted")

/obj/structure/holosign/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			playsound(loc, 'sound/items/weapons/egloves.ogg', 80, TRUE)
		if(BURN)
			playsound(loc, 'sound/items/weapons/egloves.ogg', 80, TRUE)

/obj/structure/holosign/proc/create_vis_overlay()
	if(!use_vis_overlay)
		return

	var/turf/our_turf = get_turf(src)
	alpha = 0
	SSvis_overlays.remove_vis_overlay(src, managed_vis_overlays)
	var/obj/effect/overlay/vis/overlay = SSvis_overlays.add_vis_overlay(src, icon, icon_state, ABOVE_MOB_LAYER, MUTATE_PLANE(GAME_PLANE, our_turf), dir, add_appearance_flags = KEEP_APART|RESET_ALPHA) //you see mobs under it, but you hit them like they are above it
	if (color || cached_color_filter)
		overlay.add_atom_colour(cached_color_filter || color, FIXED_COLOUR_PRIORITY)

/obj/structure/holosign/wetsign
	name = "地板潮湿标识"
	desc = "这些文字闪烁不定，仿佛毫无意义。"
	icon_state = "holosign"
	base_icon_state = "holosign"

/obj/structure/holosign/barrier
	name = "安保全息屏障"
	desc = "一种坚固的短型安保全息屏障，用于人群控制和封锁犯罪现场。只能通过步行穿过。"
	icon_state = "holosign_sec"
	base_icon_state = "holosign_sec"
	pass_flags_self = PASSTABLE | PASSGRILLE | PASSGLASS | LETPASSTHROW
	density = TRUE
	max_integrity = 20
	COOLDOWN_DECLARE(cooldown_open)
	///Can we pass through it on walk intent?
	var/allow_walk = TRUE
	///Can it be temporarily opened with the holosign projector?
	var/openable = TRUE
	///Is it opened?
	var/opened = FALSE
	///What is the icon of opened holobarrier?
	var/pass_icon_state = "holosign_pass"

/obj/structure/holosign/barrier/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(.)
		return

	if(opened)
		return TRUE

	if(iscarbon(mover))
		var/mob/living/carbon/moving_carbon = mover
		if(moving_carbon.stat) // Lets not prevent dragging unconscious/dead people.
			return TRUE
		if(allow_walk && moving_carbon.move_intent == MOVE_INTENT_WALK)
			return TRUE

/obj/structure/holosign/barrier/ranged_item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	if(tool != projector)
		return
	if(openable)
		open(user)

/obj/structure/holosign/barrier/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	. = ..()
	if(tool != projector)
		return
	qdel(src)

/obj/structure/holosign/barrier/update_icon_state()
	if(!opened)
		icon_state = base_icon_state
	else
		icon_state = pass_icon_state

	create_vis_overlay()
	. = ..()

/obj/structure/holosign/barrier/proc/open(user)
	if(!openable)
		balloon_alert(user, "无法！")
		return

	if(!COOLDOWN_FINISHED(src, cooldown_open))
		balloon_alert(user, "冷却中！")
		return

	if(!opened)
		density = FALSE
		opened = TRUE
		playsound(src, 'sound/machines/door/door_open.ogg', 50, TRUE)
	else
		density = TRUE
		opened = FALSE
		playsound(src, 'sound/machines/door/door_close.ogg', 50, TRUE)

	update_icon_state()
	COOLDOWN_START(src, cooldown_open, 1 SECONDS)

/obj/structure/holosign/barrier/wetsign
	name = "地板湿润全息屏障"
	desc = "当它说步行时，意思是<b>步行！</b>"
	icon_state = "holosign_dense"
	base_icon_state = "holosign_dense"
	max_integrity = 1
	openable = FALSE

/obj/structure/holosign/barrier/wetsign/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(iscarbon(mover))
		var/mob/living/carbon/C = mover
		if(C.stat) // Lets not prevent dragging unconscious/dead people.
			return TRUE
		if(allow_walk && C.move_intent != MOVE_INTENT_WALK)
			return FALSE

/obj/structure/holosign/barrier/engineering
	name = "工程全息屏障"
	desc = "一种短型工程全息屏障，用于标记危险区域，能略微阻挡辐射。只能通过步行穿过。"
	icon_state = "holosign_engi"
	base_icon_state = "holosign_engi"
	rad_insulation = RAD_LIGHT_INSULATION
	max_integrity = 1

/obj/structure/holosign/barrier/atmos
	name = "全息火锁"
	desc = "一个以类似实体火锁方式运作的全息屏障。不阻止固体物品通过，但气体则被阻挡在外。"
	icon_state = "holo_firelock"
	base_icon_state = "holo_firelock"
	openable = FALSE
	density = FALSE
	anchored = TRUE
	can_atmos_pass = ATMOS_PASS_NO
	alpha = 150
	rad_insulation = RAD_LIGHT_INSULATION
	resistance_flags = FIRE_PROOF | FREEZE_PROOF

/obj/structure/holosign/barrier/atmos/proc/clearview_transparency()
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	alpha = 25
	SSvis_overlays.remove_vis_overlay(src, managed_vis_overlays)
	var/turf/our_turf = get_turf(src)
	SSvis_overlays.add_vis_overlay(src, icon, icon_state, ABOVE_MOB_LAYER, MUTATE_PLANE(GAME_PLANE, our_turf), dir)

/obj/structure/holosign/barrier/atmos/proc/reset_transparency()
	mouse_opacity = initial(mouse_opacity)
	alpha = initial(alpha)
	SSvis_overlays.remove_vis_overlay(src, managed_vis_overlays)
	var/turf/our_turf = get_turf(src)
	SSvis_overlays.add_vis_overlay(src, icon, icon_state, ABOVE_MOB_LAYER, MUTATE_PLANE(GAME_PLANE, our_turf), dir, add_appearance_flags = RESET_ALPHA)

/obj/structure/holosign/barrier/atmos/sturdy
	name = "坚固的全息火锁"
	max_integrity = 150
	openable = FALSE

/obj/structure/holosign/barrier/atmos/tram
	name = "电车大气屏障"
	max_integrity = 150
	icon_state = "holo_tram"
	base_icon_state = "holo_tram"
	openable = FALSE

/obj/structure/holosign/barrier/atmos/Initialize(mapload)
	. = ..()
	air_update_turf(TRUE, TRUE)
	AddElement(/datum/element/give_turf_traits, string_list(list(TRAIT_FIREDOOR_STOP)))

/obj/structure/holosign/barrier/atmos/block_superconductivity() //Didn't used to do this, but it's "normal", and will help ease heat flow transitions with the players.
	return TRUE

/obj/structure/holosign/barrier/atmos/Destroy()
	air_update_turf(TRUE, FALSE)
	return ..()

/obj/structure/holosign/barrier/cyborg
	name = "能量力场"
	desc = "阻挡动能的脆弱能量场。擅长拦截致命射弹。"
	density = TRUE
	max_integrity = 10
	allow_walk = FALSE
	armor_type = /datum/armor/structure_holosign/cyborg_barrier // Gets a special armor subtype which is extra good at defense.

/datum/armor/structure_holosign/cyborg_barrier
	bullet = 80
	laser = 80
	energy = 80
	melee = 20

/obj/structure/holosign/barrier/medical
	name = "\improper PENLITE全息屏障"
	desc = "一种用生物识别装置来检测病毒的全息屏障。能拒绝携带可被轻易检测的恶意病毒的人员通过。非常适合用于实施隔离。"
	icon_state = "holo_medical"
	base_icon_state = "holo_medical"
	max_integrity = 1
	openable = FALSE
	COOLDOWN_DECLARE(virus_detected)

/obj/structure/holosign/barrier/medical/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(istype(mover, /obj/vehicle/ridden))
		for(var/M in mover.buckled_mobs)
			if(ishuman(M))
				if(!CheckHuman(M))
					return FALSE
	if(ishuman(mover))
		return CheckHuman(mover)
	return TRUE

/obj/structure/holosign/barrier/medical/Bumped(atom/movable/AM)
	. = ..()
	icon_state = base_icon_state
	update_icon_state()
	if(!ishuman(AM) && CheckHuman(AM))
		return

	if(!COOLDOWN_FINISHED(src, virus_detected))
		return

	playsound(get_turf(src),'sound/machines/buzz/buzz-sigh.ogg', 65, TRUE, 4)
	COOLDOWN_START(src, virus_detected, 1 SECONDS)
	icon_state = "holo_medical-deny"
	update_icon_state()

/obj/structure/holosign/barrier/medical/proc/CheckHuman(mob/living/carbon/human/sickboi)
	var/threat = sickboi.check_virus()
	if(get_disease_severity_value(threat) > get_disease_severity_value(DISEASE_SEVERITY_MINOR))
		return FALSE
	return TRUE

/obj/structure/holosign/barrier/cyborg/hacked
	name = "充能能量力场"
	desc = "一种可阻碍移动的强大能量场。能量从中散发出来。"
	max_integrity = 20
	armor_type = /datum/armor/structure_holosign //Yeah no this doesn't get projectile resistance.
	var/shockcd = 0

/obj/structure/holosign/barrier/cyborg/hacked/proc/cooldown()
	shockcd = FALSE

/obj/structure/holosign/barrier/cyborg/hacked/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!shockcd)
		if(ismob(user))
			var/mob/living/M = user
			M.electrocute_act(15,"Energy Barrier")
			shockcd = TRUE
			addtimer(CALLBACK(src, PROC_REF(cooldown)), 0.5 SECONDS)

/obj/structure/holosign/barrier/cyborg/hacked/Bumped(atom/movable/AM)
	if(shockcd)
		return

	if(!ismob(AM))
		return

	var/mob/living/M = AM
	M.electrocute_act(15,"Energy Barrier")
	shockcd = TRUE
	addtimer(CALLBACK(src, PROC_REF(cooldown)), 0.5 SECONDS)
