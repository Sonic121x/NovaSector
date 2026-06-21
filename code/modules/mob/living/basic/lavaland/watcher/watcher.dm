/// A floating eyeball which keeps its distance and sometimes make you look away.
/mob/living/basic/mining/watcher
	name = "监视者"
	desc = "一种悬浮的单眼生物，由翼状脉管支撑在空中。其身体突出一根尖锐的水晶棘刺。"
	icon = 'icons/mob/simple/lavaland/lavaland_monsters_wide.dmi'
	icon_state = "watcher"
	icon_living = "watcher"
	icon_dead = "watcher_dead"
	health_doll_icon = "watcher"
	pixel_x = -12
	base_pixel_x = -12
	speak_emote = list("chimes")
	speed = 3
	maxHealth = 160
	health = 160
	melee_damage_lower = 15
	melee_damage_upper = 15
	attack_sound = 'sound/items/weapons/bladeslice.ogg'
	attack_verb_continuous = "buffets"
	attack_verb_simple = "buffet"
	crusher_loot = /obj/item/crusher_trophy/watcher_wing
	ai_controller = /datum/ai_controller/basic_controller/watcher
	butcher_results = list(
		/obj/item/stack/sheet/bone = 1,
		/obj/item/stack/ore/diamond = 2,
		/obj/item/stack/sheet/sinew = 2,
	)
	/// How often can we shoot?
	var/ranged_cooldown = 3 SECONDS
	/// What kind of beams we got?
	var/projectile_type = /obj/projectile/temp/watcher
	/// Icon state for our eye overlay
	var/eye_glow = "watcher_glow"
	/// Sound to play when we shoot
	var/shoot_sound = 'sound/items/weapons/pierce.ogg'
	/// Typepath of our gaze ability
	var/gaze_attack = /datum/action/cooldown/mob_cooldown/watcher_gaze
	// We attract and eat these things for some reason
	var/list/wanted_objects = list(
		/obj/item/stack/sheet/mineral/diamond,
		/obj/item/stack/ore/diamond,
		/obj/item/pen/survival,
	)

/mob/living/basic/mining/watcher/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/ai_retaliate)
	AddElement(/datum/element/simple_flying)
	AddElement(/datum/element/content_barfer)
	AddComponent(/datum/component/ai_target_timer)
	AddComponent(/datum/component/basic_ranged_ready_overlay, overlay_state = eye_glow)
	AddComponent(\
		/datum/component/ranged_attacks,\
		cooldown_time = ranged_cooldown,\
		projectile_type = projectile_type,\
		projectile_sound = shoot_sound,\
	)
	AddComponent(\
		/datum/component/magnet,\
		attracted_typecache = wanted_objects,\
		on_contact = CALLBACK(src, PROC_REF(consume)),\
	)
	update_appearance(UPDATE_OVERLAYS)

	var/datum/action/cooldown/mob_cooldown/watcher_gaze/gaze = new gaze_attack(src)
	gaze.Grant(src)
	ai_controller.set_blackboard_key(BB_GENERIC_ACTION, gaze)
	AddComponent(/datum/component/revenge_ability, gaze, targeting = GET_TARGETING_STRATEGY(ai_controller.blackboard[BB_TARGETING_STRATEGY]))

/mob/living/basic/mining/watcher/update_overlays()
	. = ..()
	if (stat == DEAD)
		return
	. += emissive_appearance(icon, "watcher_emissive", src, effect_type = EMISSIVE_NO_BLOOM)
	. += emissive_appearance(icon, "watcher_emissive_bloom", src)

/// I love eating diamonds yum
/mob/living/basic/mining/watcher/proc/consume(atom/movable/thing)
	visible_message(span_warning("[thing]似乎消失在了[src]的身体里！"))
	thing.forceMove(src)

/// More durable, burning projectiles
/mob/living/basic/mining/watcher/magmawing
	name = "熔岩翼监视者"
	desc = "面对极端温度，适应性强的监视者通过其循环翼吸收热量，并将其转化为武器。"
	icon_state = "watcher_magmawing"
	icon_living = "watcher_magmawing"
	icon_dead = "watcher_magmawing_dead"
	eye_glow = "fire_glow"
	maxHealth = 175 //Compensate for the lack of slowdown on projectiles with a bit of extra health
	health = 175
	projectile_type = /obj/projectile/temp/watcher/magma_wing
	gaze_attack = /datum/action/cooldown/mob_cooldown/watcher_gaze/fire
	crusher_loot = /obj/item/crusher_trophy/blaster_tubes/magma_wing
	crusher_drop_chance = 100 // There's only going to be one of these per round throw them a bone

/// Less durable, freezing projectiles
/mob/living/basic/mining/watcher/icewing
	name = "冰翼监视者"
	desc = "在发育过程中未能吸收足够热量的监视者会变得脆弱，但会将体内的寒意分享给敌人。"
	icon_state = "watcher_icewing"
	icon_living = "watcher_icewing"
	icon_dead = "watcher_icewing_dead"
	eye_glow = "ice_glow"
	maxHealth = 130
	health = 130
	projectile_type = /obj/projectile/temp/watcher/ice_wing
	gaze_attack = /datum/action/cooldown/mob_cooldown/watcher_gaze/ice
	butcher_results = list(/obj/item/stack/ore/diamond = 5, /obj/item/stack/sheet/bone = 1)
	crusher_loot = /obj/item/crusher_trophy/watcher_wing/ice_wing
	crusher_drop_chance = 100
