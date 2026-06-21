/obj/effect/mine
	name = "假人地雷"
	desc = "最好离那玩意远点"
	density = FALSE
	anchored = TRUE
	icon = 'icons/obj/weapons/grenade.dmi'
	icon_state = "landmine"
	base_icon_state = "landmine"
	/// We manually check to see if we've been triggered in case multiple atoms cross us in the time between the mine being triggered and it actually deleting, to avoid a race condition with multiple detonations
	var/triggered = FALSE
	/// Can be set to FALSE if we want a short 'coming online' delay, then set to TRUE. Can still be set off by damage
	var/armed = TRUE
	/// If set, we default armed to FALSE and set it to TRUE after this long from initializing
	var/arm_delay

	/// Who's got their foot on the mine's pressure plate
	/// Stepping on the mine will set this to the first mob who stepped over it
	/// The mine will not detonate via movement unless the first mob steps off of it
	var/datum/weakref/foot_on_mine

/obj/effect/mine/Initialize(mapload)
	. = ..()
	if(arm_delay)
		armed = FALSE
		update_appearance(UPDATE_ICON_STATE)
		addtimer(CALLBACK(src, PROC_REF(now_armed)), arm_delay)

	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
		COMSIG_ATOM_EXITED = PROC_REF(on_exited),
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/effect/mine/examine(mob/user)
	. = ..()
	if(!armed)
		. += span_info("它看起来处于未激活状态...")

	var/atom/movable/unlucky_sod = foot_on_mine?.resolve()
	if(user == unlucky_sod)
		. += span_bolddanger("压力板已被压下。你现在任何移动都会触发它。")
	else if(!isnull(unlucky_sod))
		. += span_danger("压力板被[unlucky_sod]压下了。他们任何移动都会触发它。")

/obj/effect/mine/update_icon_state()
	. = ..()
	if(armed)
		icon_state = base_icon_state
	else
		icon_state = "[base_icon_state]-inactive"

/// The effect of the mine
/obj/effect/mine/proc/mineEffect(mob/victim)
	return

/// If the landmine was previously inactive, this beeps and displays a message marking it active
/obj/effect/mine/proc/now_armed()
	armed = TRUE
	update_appearance(UPDATE_ICON_STATE)
	playsound(src, 'sound/machines/nuke/angry_beep.ogg', 40, FALSE, -2)
	visible_message(span_danger("\The [src] 发出轻柔的哔哔声，表明它现在已激活。"), vision_distance = COMBAT_MESSAGE_RANGE)

/// Can this mine trigger on the passed movable?
/obj/effect/mine/proc/can_trigger(atom/movable/on_who)
	if(triggered || !isturf(loc) || iseffect(on_who) || !armed)
		return FALSE

	if(on_who.anchored || HAS_TRAIT(on_who, TRAIT_WALLMOUNTED))
		return FALSE

	var/mob/living/living_mob
	if(ismob(on_who))
		if(!isliving(on_who)) //no ghosties.
			return FALSE
		living_mob = on_who

	if(living_mob?.incorporeal_move || (on_who.movement_type & MOVETYPES_NOT_TOUCHING_GROUND))
		return foot_on_mine ? IS_WEAKREF_OF(on_who, foot_on_mine) : FALSE //Only go boom if their foot was on the mine PRIOR to flying/phasing. You fucked up, you live with the consequences.

	return TRUE

/obj/effect/mine/proc/on_entered(datum/source, atom/movable/arrived, atom/old_loc)
	SIGNAL_HANDLER

	if(!can_trigger(arrived))
		return
	// Someone already on it
	if(foot_on_mine?.resolve())
		return

	var/gonna_blow
	if(arrived.flags_1 & ON_BORDER_1)
		if(arrived.dir == get_dir(old_loc, src)) //see if a partial tile atom has passed the mine
			gonna_blow = TRUE
		else
			return //it didn't actually touch the mine, don't blow

	visible_message(span_danger("[icon2html(src, viewers(src))] *咔哒*"))
	playsound(src, 'sound/machines/click.ogg', 60, TRUE)
	if(gonna_blow)
		RegisterSignal(arrived, COMSIG_MOVABLE_MOVED, PROC_REF(triggermine)) //wait for it to finish the movement before blowing so it takes proper damage
		return

	foot_on_mine = WEAKREF(arrived)


/obj/effect/mine/proc/on_exited(datum/source, atom/movable/gone, direction)
	SIGNAL_HANDLER

	if(!can_trigger(gone))
		return

	if(!foot_on_mine && gone.flags_1 & ON_BORDER_1)
		if(gone.dir == REVERSE_DIR(direction)) //see if a north facing border atom (ie window) travels south (and other directions as needed)
			visible_message(span_danger("[icon2html(src, viewers(src))] *咔哒*"))
			playsound(src, 'sound/machines/click.ogg', 60, TRUE)
			triggermine() //it "passed" over the mine briefly, triggering it in the process
		return //either it blew up the mine, or it didn't and we don't have to worry about anything else.

	// Check that the guy who's on it is stepping off
	if(foot_on_mine && !IS_WEAKREF_OF(gone, foot_on_mine))
		return

	triggermine(gone)
	foot_on_mine = null

/obj/effect/mine/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir)
	. = ..()
	triggermine()

/// When something sets off a mine
/obj/effect/mine/proc/triggermine(atom/movable/triggerer)
	SIGNAL_HANDLER
	if(triggered) //too busy detonating to detonate again
		return
	if(triggerer)
		visible_message(span_danger("[triggerer] 触发了 [icon2html(src, viewers(src))] [src]！"))
	else
		visible_message(span_danger("[icon2html(src, viewers(src))] [src] 爆炸了！"))

	do_sparks(3, TRUE, src)
	mineEffect(triggerer)
	triggered = TRUE
	SEND_SIGNAL(src, COMSIG_MINE_TRIGGERED, triggerer)
	qdel(src)

/obj/effect/mine/explosive
	name = "爆炸地雷"
	/// The devastation range of the resulting explosion.
	var/range_devastation = 0
	/// The heavy impact range of the resulting explosion.
	var/range_heavy = 1
	/// The light impact range of the resulting explosion.
	var/range_light = 2
	/// The flame range of the resulting explosion.
	var/range_flame = 0
	/// The flash range of the resulting explosion.
	var/range_flash = 3

/obj/effect/mine/explosive/mineEffect(mob/victim)
	explosion(src, range_devastation, range_heavy, range_light, range_flame, range_flash)

/obj/effect/mine/explosive/light
	name = "低当量爆炸地雷"
	range_heavy = 0
	range_light = 3
	range_flash = 2

/obj/effect/mine/explosive/flame
	name = "燃烧爆炸地雷"
	range_heavy = 0
	range_light = 1
	range_flame = 3

/obj/effect/mine/explosive/flash
	name = "致盲爆炸地雷"
	range_heavy = 0
	range_light = 1
	range_flash = 6

/obj/effect/mine/stun
	name = "眩晕地雷"
	var/stun_time = 80

/obj/effect/mine/stun/mineEffect(mob/living/victim)
	if(isliving(victim) && Adjacent(victim))
		victim.Paralyze(stun_time)

/obj/effect/mine/kickmine
	name = "二踢脚地雷"

/obj/effect/mine/kickmine/mineEffect(mob/victim)
	if(isliving(victim) && victim.client && Adjacent(victim))
		to_chat(victim, span_userdanger("你被踢了，毫无理由！"))
		qdel(victim.client)

/obj/effect/mine/gas
	name = "氧气地雷"
	var/gas_amount = 360
	var/gas_type = GAS_O2

/obj/effect/mine/gas/mineEffect(mob/victim)
	atmos_spawn_air("[gas_type]=[gas_amount]")

/obj/effect/mine/gas/plasma
	name = "等离子地雷"
	gas_type = GAS_PLASMA

/obj/effect/mine/gas/n2o
	name = "\improper 一氧化二氮地雷"
	gas_type = GAS_N2O

/obj/effect/mine/gas/water_vapor
	name = "冷蒸汽地雷"
	gas_amount = 500
	gas_type = GAS_WATER_VAPOR

/obj/effect/mine/sound
	name = "喇叭起爆器 1000"
	var/sound = 'sound/items/bikehorn.ogg'

/obj/effect/mine/sound/mineEffect(mob/victim)
	playsound(loc, sound, 100, TRUE)

/obj/effect/mine/sound/bwoink
	name = "Bwoink（拟声词）地雷"
	sound = 'sound/effects/adminhelp.ogg'

/// These mines spawn pellet_clouds around them when triggered
/obj/effect/mine/shrapnel
	name = "破片地雷"
	/// The type of projectiles we're shooting out of this
	var/shrapnel_type = /obj/projectile/bullet/shrapnel
	/// Broadly, how many pellets we're spawning, the total is n! - (n-1)! pellets, so don't set it too high. For reference, 15 is probably pushing it at MAX
	var/shrapnel_magnitude = 3
	/// If TRUE, we spawn extra pellets to eviscerate the person who stepped on it, otherwise it just spawns a ring of pellets around the tile we're on (making setting it off an offensive move)
	var/shred_triggerer = FALSE

/obj/effect/mine/shrapnel/mineEffect(mob/victim)
	return

/obj/effect/mine/shrapnel/triggermine(atom/movable/AM)
	AddComponent(/datum/component/pellet_cloud, projectile_type=shrapnel_type, magnitude=shrapnel_magnitude)
	return ..()

/obj/effect/mine/shrapnel/sting
	name = "毒刺地雷"
	shrapnel_type = /obj/projectile/bullet/pellet/stingball

/obj/effect/mine/shrapnel/capspawn
	name = "\improper 反步兵地雷"
	desc = "一种装满穿甲弹片的防御性地雷，可以在狭小空间内引爆而不破坏船体。AP意味着‘保护资产’，尽管总有傻瓜去引爆它造成严重后果。"
	shrapnel_type = /obj/projectile/bullet/pellet/capmine
	shrapnel_magnitude = 4
	shred_triggerer = TRUE
	arm_delay = 3 SECONDS
	light_range = 1.6
	light_power = 2
	light_color = COLOR_VIVID_RED

/obj/effect/mine/shrapnel/capspawn/now_armed()
	. = ..()
	set_light_on(TRUE)

/obj/item/minespawner
	name = "地雷部署装置"
	desc = "激活后，将在3秒后部署反步兵地雷（保护资产地雷），非常适合从远处保护纳米传讯的高级军官们。"
	icon = 'icons/obj/devices/tracker.dmi'
	icon_state = "beacon"

	var/mine_type = /obj/effect/mine/shrapnel/capspawn
	var/active = FALSE

/obj/item/minespawner/attack_self(mob/user)
	. = ..()
	if(active)
		return

	playsound(src, 'sound/items/weapons/armbomb.ogg', 70, TRUE)
	to_chat(user, span_warning("你启动了 \the [src]，使其开始震动！它将在3秒后部署。"))
	active = TRUE
	addtimer(CALLBACK(src, PROC_REF(deploy_mine)), 3 SECONDS)

/// Deploys the mine and deletes itself
/obj/item/minespawner/proc/deploy_mine()
	do_alert_animation()
	playsound(loc, 'sound/machines/chime.ogg', 30, FALSE, -3)
	var/obj/effect/mine/new_mine = new mine_type(get_turf(src))
	visible_message(span_danger("\The [src] 喷出一股烟雾，露出了 \a [new_mine]！"))
	var/obj/effect/particle_effect/fluid/smoke/poof = new (get_turf(src))
	poof.lifetime = 3
	qdel(src)
