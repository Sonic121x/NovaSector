#define SPIDER_WEB_TINT	"web_colour_tint"

/obj/structure/spider
	name = "蜘蛛网"
	icon = 'icons/effects/web.dmi'
	desc = "它又粘又黏。"
	anchored = TRUE
	density = FALSE
	max_integrity = 15

/obj/structure/spider/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/atmos_sensitive, mapload)
	ADD_TRAIT(src, TRAIT_INVERTED_DEMOLITION, INNATE_TRAIT)

/obj/structure/spider/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	if(damage_type == BURN)//the stickiness of the web mutes all attack sounds except fire damage type
		playsound(loc, 'sound/items/tools/welder.ogg', 100, TRUE)

/obj/structure/spider/run_atom_armor(damage_amount, damage_type, damage_flag = 0, attack_dir)
	if(damage_flag == MELEE)
		switch(damage_type)
			if(BURN)
				damage_amount *= 1.25
			if(BRUTE)
				damage_amount *= 0.25
	return ..()

/obj/structure/spider/should_atmos_process(datum/gas_mixture/air, exposed_temperature)
	return exposed_temperature > 350

/obj/structure/spider/atmos_expose(datum/gas_mixture/air, exposed_temperature)
	take_damage(5, BURN, 0, 0)

/obj/structure/spider/stickyweb
	layer = ABOVE_OPEN_TURF_LAYER
	plane = FLOOR_PLANE
	icon = 'icons/obj/smooth_structures/stickyweb.dmi'
	base_icon_state = "stickyweb"
	icon_state = "stickyweb-0"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_SPIDER_WEB
	canSmoothWith = SMOOTH_GROUP_SPIDER_WEB + SMOOTH_GROUP_WALLS
	///Whether or not the web is a sealed web
	var/sealed = FALSE
	///Do we need to offset this based on a sprite frill?
	var/has_frill = TRUE
	/// Chance that someone will get stuck when trying to cross this tile
	var/stuck_chance = 50
	/// Chance that a bullet will hit this instead of flying through it
	var/projectile_stuck_chance = 30

/obj/structure/spider/stickyweb/Initialize(mapload)
	// Offset on init so that they look nice in the map editor
	if (has_frill)
		pixel_x = -9
		pixel_y = -9

	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
	)
	AddElement(/datum/element/connect_loc, loc_connections)
	return ..()

/obj/structure/spider/stickyweb/attack_hand(mob/user, list/modifiers)
	.= ..()
	if(.)
		return
	if(!HAS_TRAIT(user, TRAIT_WEB_WEAVER))
		return
	loc.balloon_alert_to_viewers("weaving...")
	if(!do_after(user, 2 SECONDS))
		loc.balloon_alert(user, "被打断了！")
		return
	qdel(src)
	var/obj/item/stack/sheet/cloth/woven_cloth = new /obj/item/stack/sheet/cloth
	user.put_in_hands(woven_cloth)

/obj/structure/spider/stickyweb/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if(sealed)
		return FALSE
	if(isprojectile(mover))
		return prob(projectile_stuck_chance)
	return .

/obj/structure/spider/stickyweb/proc/is_whitelisted(mob/candidate)
	return HAS_TRAIT(candidate, TRAIT_WEB_SURFER)

/obj/structure/spider/stickyweb/proc/on_entered(datum/source, atom/movable/victim, old_loc)
	SIGNAL_HANDLER

	if(!isliving(victim))
		return
	if(is_whitelisted(victim) || victim.pulledby && is_whitelisted(victim.pulledby))
		return
	if(prob(stuck_chance))
		stuck_react(victim)

/// Drains stamina and shows feedback when you get stuck moving thru a web
/obj/structure/spider/stickyweb/proc/stuck_react(mob/living/victim)
	if(victim.get_stamina_loss() > 90)
		if(victim.body_position != LYING_DOWN)
			to_chat(victim, span_warning("You trip over \the [src] due to exhaustion!"))

		victim.SetKnockdown(3 SECONDS)
		return

	if(prob(25))
		loc.balloon_alert(victim, "被蛛网缠住了！")
		victim.Shake(duration = 0.2 SECONDS)

	victim.adjust_stamina_loss(rand(10, 15))

/// Web made by geneticists, needs special handling to allow them to pass through their own webs
/obj/structure/spider/stickyweb/genetic
	desc = "它又细又粘，是从你同事身上出来的。"
	/// Mob with special permission to cross this web
	var/mob/living/allowed_mob

/obj/structure/spider/stickyweb/genetic/Initialize(mapload, allowedmob)
	. = ..()
	// Tint it purple so that spiders don't get confused about why they can't cross this one
	add_filter(SPIDER_WEB_TINT, 10, list("type" = "outline", "color" = "#ffaaf8ff", "size" = 0.1))

/obj/structure/spider/stickyweb/genetic/Initialize(mapload, allowedmob)
	allowed_mob = allowedmob
	return ..()

/obj/structure/spider/stickyweb/genetic/is_whitelisted(mob/candidate)
	return candidate == allowed_mob

/// Web with a 100% chance to intercept movement
/obj/structure/spider/stickyweb/very_sticky
	max_integrity = 20
	desc = "极其粘稠的丝线，你很难从那里通过。"
	stuck_chance = 100
	projectile_stuck_chance = 100

/obj/structure/spider/stickyweb/very_sticky/Initialize(mapload)
	. = ..()
	add_filter(SPIDER_WEB_TINT, 10, list("type" = "outline", "color" = "#ffffaaff", "size" = 0.1))

/obj/structure/spider/stickyweb/very_sticky/update_overlays()
	. = ..()
	var/mutable_appearance/web_overlay = mutable_appearance(icon = 'icons/effects/web.dmi', icon_state = "sticky_overlay", layer = layer + 1)
	web_overlay.pixel_w -= pixel_x
	web_overlay.pixel_z -= pixel_y
	. += web_overlay


/// Web 'wall'
/obj/structure/spider/stickyweb/sealed
	name = "厚密蜘网"
	desc = "一道坚固的网墙，密度足以阻挡空气流动。"
	icon = 'icons/obj/smooth_structures/webwall.dmi'
	base_icon_state = "webwall"
	icon_state = "webwall-0"
	smoothing_groups = SMOOTH_GROUP_SPIDER_WEB_WALL
	canSmoothWith = SMOOTH_GROUP_SPIDER_WEB_WALL
	plane = GAME_PLANE
	layer = OBJ_LAYER
	sealed = TRUE
	has_frill = FALSE
	can_atmos_pass = ATMOS_PASS_NO

/obj/structure/spider/stickyweb/sealed/Initialize(mapload)
	. = ..()
	air_update_turf(TRUE, TRUE)

/// Walls which reflects lasers
/obj/structure/spider/stickyweb/sealed/reflector
	name = "反射性丝网屏"
	desc = "经过特殊化学处理的硬化蛛网，能够弹开抛射物。"
	icon = 'icons/obj/smooth_structures/webwall_reflector.dmi'
	base_icon_state = "webwall_reflector"
	icon_state = "webwall_reflector-0"
	smoothing_groups = SMOOTH_GROUP_SPIDER_WEB_WALL_MIRROR
	canSmoothWith = SMOOTH_GROUP_SPIDER_WEB_WALL_MIRROR
	max_integrity = 30
	opacity = TRUE
	flags_ricochet = RICOCHET_SHINY | RICOCHET_HARD
	receive_ricochet_chance_mod = INFINITY

/// Opaque and durable web 'wall'
/obj/structure/spider/stickyweb/sealed/tough
	name = "硬化蛛网"
	desc = "通过化学过程硬化成耐用屏障的蛛网。"
	icon = 'icons/obj/smooth_structures/webwall_dark.dmi'
	base_icon_state = "webwall_dark"
	icon_state = "webwall_dark-0"
	smoothing_groups = SMOOTH_GROUP_SPIDER_WEB_WALL_TOUGH
	canSmoothWith = SMOOTH_GROUP_SPIDER_WEB_WALL_TOUGH
	opacity = TRUE
	max_integrity = 90
	layer = ABOVE_MOB_LAYER
	resistance_flags = FIRE_PROOF | FREEZE_PROOF

/// Web 'door', blocks atmos but not movement
/obj/structure/spider/passage
	name = "蛛网通道"
	desc = "一道不透明的蛛网帘幕，能封住空气但不阻碍通行。"
	icon = 'icons/obj/smooth_structures/stickyweb_rotated.dmi'
	base_icon_state = "stickyweb_rotated"
	icon_state = "stickyweb_rotated-0"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_SPIDER_WEB_ROOF
	canSmoothWith = SMOOTH_GROUP_SPIDER_WEB_ROOF + SMOOTH_GROUP_WALLS
	can_atmos_pass = ATMOS_PASS_NO
	opacity = TRUE
	max_integrity = 60
	alpha = 200
	layer = ABOVE_MOB_LAYER
	resistance_flags = FIRE_PROOF | FREEZE_PROOF

/obj/structure/spider/passage/Initialize(mapload)
	. = ..()
	pixel_x = -9
	pixel_y = -9
	air_update_turf(TRUE, TRUE)
	add_filter(SPIDER_WEB_TINT, 10, list("type" = "outline", "color" = "#ffffffff", "alpha" = 0.8, "size" = 0.1))

/obj/structure/spider/cocoon
	name = "茧"
	desc = "被丝状蛛网包裹住的东西。"
	icon_state = "cocoon1"
	max_integrity = 60

/obj/structure/spider/cocoon/Initialize(mapload)
	icon_state = pick("cocoon1","cocoon2","cocoon3")
	. = ..()

/obj/structure/spider/cocoon/container_resist_act(mob/living/user)
	var/breakout_time = 600
	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	to_chat(user, span_notice("你奋力挣脱着紧缚的蛛丝...（这大约需要[DisplayTimeText(breakout_time)]。）"))
	visible_message(span_notice("你看见有什么东西在\the [src]里挣扎扭动！"))
	if(do_after(user,(breakout_time), target = src))
		if(!user || user.stat != CONSCIOUS || user.loc != src)
			return
		qdel(src)

/obj/structure/spider/cocoon/Destroy()
	var/turf/T = get_turf(src)
	src.visible_message(span_warning("\The [src]裂开了。"))
	for(var/atom/movable/A in contents)
		A.forceMove(T)
	return ..()

/// Web caltrops
/obj/structure/spider/spikes
	name = "蛛网尖刺"
	desc = "蛛丝硬化形成的小而致命的尖刺。"
	layer = ABOVE_OPEN_TURF_LAYER
	plane = FLOOR_PLANE
	icon = 'icons/obj/smooth_structures/stickyweb_spikes.dmi'
	base_icon_state = "stickyweb_spikes"
	icon_state = "stickyweb_spikes-0"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_SPIDER_WEB
	canSmoothWith = SMOOTH_GROUP_SPIDER_WEB + SMOOTH_GROUP_WALLS
	max_integrity = 40

/obj/structure/spider/spikes/Initialize(mapload)
	. = ..()
	pixel_x = -9
	pixel_y = -9
	add_filter(SPIDER_WEB_TINT, 10, list("type" = "outline", "color" = "#ac0000ff", "size" = 0.1))
	AddComponent(/datum/component/caltrop, min_damage = 20, max_damage = 30, flags = CALTROP_NOSTUN | CALTROP_BYPASS_SHOES)

/obj/structure/spider/effigy
	name = "蛛网雕像"
	desc = "一只巨型蜘蛛！幸运的是，这只是硬化蛛丝制成的雕像。"
	icon_state = "effigy"
	max_integrity = 125
	density = TRUE
	anchored = FALSE

/obj/structure/spider/effigy/Initialize(mapload)
	. = ..()
	fade_into_nothing(1 MINUTES)

#undef SPIDER_WEB_TINT
