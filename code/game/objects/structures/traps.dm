/obj/structure/trap
	name = "这是个陷阱"
	desc = "踩在我肯定是糟糕的一天。"
	icon = 'icons/obj/service/hand_of_god_structures.dmi'
	icon_state = "trap"
	density = FALSE
	anchored = TRUE
	alpha = 30 //initially quite hidden when not "recharging"
	var/flare_message = span_warning("陷阱发出明亮的光芒！")
	var/last_trigger = 0
	var/time_between_triggers = 1 MINUTES
	var/charges = INFINITY
	var/antimagic_flags = MAGIC_RESISTANCE

	var/static/list/ignore_typecache
	var/list/mob/immune_minds = list()

	var/sparks = TRUE
	var/datum/effect_system/basic/spark_spread/spark_system

/obj/structure/trap/Initialize(mapload)
	. = ..()
	flare_message = span_warning("[src]发出明亮的光芒！")
	spark_system = new(src, 4, TRUE)

	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered)
	)
	AddElement(/datum/element/connect_loc, loc_connections)

	if(isnull(ignore_typecache))
		ignore_typecache = typecacheof(list(
			/obj/effect,
			/mob/dead,
		))

/obj/structure/trap/Destroy()
	QDEL_NULL(spark_system)
	return ..()

/obj/structure/trap/examine(mob/user)
	. = ..()
	if(!isliving(user))
		return
	if(user.mind && (user.mind in immune_minds))
		return
	if(get_dist(user, src) <= 1)
		. += span_notice("你发现了[src]！")
		flare()

/obj/structure/trap/proc/flare()
	// Makes the trap visible, and starts the cooldown until it's
	// able to be triggered again.
	visible_message(flare_message)
	if(sparks)
		spark_system.start()
	alpha = 200
	last_trigger = world.time
	charges--
	if(charges <= 0)
		animate(src, alpha = 0, time = 1 SECONDS)
		QDEL_IN(src, 1 SECONDS)
	else
		animate(src, alpha = initial(alpha), time = time_between_triggers)

/obj/structure/trap/proc/on_entered(datum/source, atom/movable/victim)
	SIGNAL_HANDLER
	if(last_trigger + time_between_triggers > world.time)
		return
	// Don't want the traps triggered by sparks, ghosts or projectiles.
	if(is_type_in_typecache(victim, ignore_typecache))
		return
	if(ismob(victim))
		var/mob/mob_victim = victim
		if(mob_victim.mind in immune_minds)
			return
		if(mob_victim.can_block_magic(antimagic_flags))
			flare()
			return
	if(charges <= 0)
		return
	flare()
	if(isliving(victim))
		trap_effect(victim)

/obj/structure/trap/proc/trap_effect(mob/living/victim)
	return

/obj/structure/trap/stun
	name = "电击陷阱"
	desc = "一个会让你被电击并让你动弹不得的陷阱，你最好避开它。"
	icon_state = "trap-shock"
	var/stun_time = 10 SECONDS

/obj/structure/trap/stun/trap_effect(mob/living/victim)
	victim.electrocute_act(30, src, flags = SHOCK_NOGLOVES) // electrocute act does a message.
	victim.Paralyze(stun_time)

/obj/structure/trap/stun/hunter
	name = "赏金陷阱"
	desc = "一种陷阱，只有当逃犯踩到它时才会爆炸，宣布位置并击晕目标，你最好避开它。"
	icon = 'icons/obj/weapons/restraints.dmi'
	icon_state = "bounty_trap_on"
	stun_time = 20 SECONDS
	sparks = FALSE //the item version gives them off to prevent runtimes (see Destroy())
	antimagic_flags = NONE
	var/obj/item/bountytrap/stored_item
	var/caught = FALSE

/obj/structure/trap/stun/hunter/Initialize(mapload)
	. = ..()
	time_between_triggers = 1 SECONDS
	flare_message = span_warning("[src]猛地合上了！")

/obj/structure/trap/stun/hunter/Destroy()
	if(!QDELETED(stored_item))
		qdel(stored_item)
	stored_item = null
	return ..()

/obj/structure/trap/stun/hunter/on_entered(datum/source, atom/movable/victim)
	if(isliving(victim))
		var/mob/living/living_victim = victim
		if(!living_victim.mind?.has_antag_datum(/datum/antagonist/fugitive))
			return
	caught = TRUE
	. = ..()

/obj/structure/trap/stun/hunter/flare()
	..()
	var/turf/our_turf = get_turf(src)
	if(!our_turf)
		return
	stored_item.forceMove(get_turf(src))
	forceMove(stored_item)
	if(caught)
		stored_item.announce_fugitive()
		caught = FALSE

/obj/item/bountytrap
	name = "赏金陷阱"
	desc = "一种陷阱，只有当逃犯踩到它时才会爆炸，宣布位置并击晕目标，它目前处于非激活状态。"
	icon = 'icons/obj/weapons/restraints.dmi'
	icon_state = "bounty_trap_off"
	var/obj/structure/trap/stun/hunter/stored_trap
	var/obj/item/radio/radio
	var/datum/effect_system/basic/spark_spread/spark_system

/obj/item/bountytrap/Initialize(mapload)
	. = ..()
	radio = new(src)
	radio.subspace_transmission = TRUE
	radio.canhear_range = 0
	radio.recalculateChannels()
	spark_system = new(src, 4, TRUE)
	spark_system.attach(src)
	name = "[name] #[rand(1, 999)]"
	stored_trap = new(src)
	stored_trap.name = name
	stored_trap.stored_item = src

/obj/item/bountytrap/proc/announce_fugitive()
	spark_system.start()
	playsound(src, 'sound/machines/ding.ogg', 50, TRUE)
	radio.talk_into(src, "Fugitive has triggered this trap in the [get_area_name(src)]!", RADIO_CHANNEL_COMMON)

/obj/item/bountytrap/attack_self(mob/living/user)
	var/turf/target_turf = get_turf(src)
	if(!user || !user.transferItemToLoc(src, target_turf))//visibly unequips
		return
	to_chat(user, span_notice("你设置了[src]。靠近并检查以解除它。"))
	stored_trap.forceMove(target_turf)//moves trap to ground
	forceMove(stored_trap)//moves item into trap

/obj/item/bountytrap/Destroy()
	if(!QDELETED(stored_trap))
		qdel(stored_trap)
	stored_trap = null
	QDEL_NULL(radio)
	QDEL_NULL(spark_system)
	. = ..()

/obj/structure/trap/fire
	name = "火焰陷阱"
	desc = "一个会让你着火的陷阱，你最好避开它。"
	icon_state = "trap-fire"

/obj/structure/trap/fire/trap_effect(mob/living/victim)
	to_chat(victim, span_danger("<B>自燃了！</B>"))
	victim.Paralyze(2 SECONDS)
	new /obj/effect/hotspot(get_turf(src))

/obj/structure/trap/chill
	name = "霜冻陷阱"
	desc = "一个会让你感到刺骨寒冷的陷阱，你最好避开它，尤其当你怕冷时。"
	icon_state = "trap-frost"

/obj/structure/trap/chill/trap_effect(mob/living/victim)
	if(HAS_TRAIT(victim, TRAIT_RESISTCOLD))
		return
	to_chat(victim, span_bolddanger("你被冻成了冰块！"))
	victim.Paralyze(2 SECONDS)
	victim.adjust_bodytemperature(-300)
	victim.apply_status_effect(/datum/status_effect/freon)


/obj/structure/trap/damage
	name = "地震陷阱"
	desc = "一个陷阱，它会召唤一场只针对你的小地震，你最好避开它。"
	icon_state = "trap-earth"


/obj/structure/trap/damage/trap_effect(mob/living/victim)
	to_chat(victim, span_bolddanger("你脚下的地面剧烈震动！"))
	victim.Paralyze(10 SECONDS)
	victim.adjust_brute_loss(35)
	var/obj/structure/flora/rock/style_random/giant_rock = new(get_turf(src))
	QDEL_IN(giant_rock, 20 SECONDS)


/obj/structure/trap/ward
	name = "神圣保护"
	desc = "一个神圣的屏障，看起来你可以用足够的努力摧毁它，或者等待它消散……"
	icon_state = "ward"
	density = TRUE
	time_between_triggers = 2 MINUTES

/obj/structure/trap/ward/Initialize(mapload)
	. = ..()
	QDEL_IN(src, time_between_triggers)

/obj/structure/trap/cult
	name = "亵渎陷阱"
	desc = "一个充满邪恶能量的陷阱，你认为你听到了……叽叽喳喳的声音？"
	icon_state = "trap-cult"

/obj/structure/trap/cult/trap_effect(mob/living/victim)
	to_chat(victim, span_bolddanger("随着一声脆响，充满敌意的构造体从藏身处现身，将你击晕了！"))
	victim.electrocute_act(10, src, flags = SHOCK_NOGLOVES) // electrocute act does a message.
	victim.Paralyze(2 SECONDS)
	new /mob/living/basic/construct/proteon/hostile(loc)
	new /mob/living/basic/construct/proteon/hostile(loc)
	QDEL_IN(src, 3 SECONDS)
