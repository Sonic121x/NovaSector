GLOBAL_LIST_EMPTY(ash_rituals)

/obj/effect/ash_rune
	name = "灰烬符文"
	desc = "一个曾经强大到足以驾驭奇异能量进行嬗变的文明遗迹。"
	icon = 'modular_nova/modules/ashwalkers/icons/ash_ritual.dmi'
	icon_state = "rune"
	anchored = TRUE

	/// the current chosen ritual
	var/datum/ash_ritual/current_ritual = null

	/// List of connected side runes
	var/list/side_runes = list()

	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

/obj/effect/ash_rune/examine(mob/user)
	. = ..()
	if(!current_ritual)
		. += span_notice("<br>当前没有选定的仪式——使用中央符文来选择仪式。")
		return
	. += span_notice("<br>当前仪式是：[current_ritual.name]")
	. += span_notice(current_ritual.desc)
	. += span_warning("<br>所需组件如下：")
	for(var/direction in current_ritual.required_components)
		var/atom/component_type = current_ritual.required_components[direction]
		var/component_name = ispath(component_type, /mob/living/carbon/human) ? "a humanoid corpse" : component_type::name
		. += span_warning("[direction] 组件是 [component_name]")

/obj/effect/ash_rune/Initialize(mapload)
	. = ..()
	// this is just to spawn the "aesthetic" runes around
	for(var/direction in GLOB.cardinals)
		var/obj/effect/side_rune/spawning_rune = new (get_step(src, direction))
		side_runes += spawning_rune
		spawning_rune.icon_state = "[initial(icon_state)]_[direction]"
		spawning_rune.connected_rune = src
	if(!length(GLOB.ash_rituals))
		generate_rituals()

/obj/effect/ash_rune/Destroy(force)
	for(var/obj/side_rune as anything in side_runes)
		qdel(side_rune)
	current_ritual = null
	. = ..()

/obj/effect/ash_rune/proc/generate_rituals()
	for(var/type in subtypesof(/datum/ash_ritual))
		var/datum/ash_ritual/spawned_ritual = new type
		GLOB.ash_rituals[spawned_ritual.name] = spawned_ritual

/obj/effect/ash_rune/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(current_ritual && is_species(user, /datum/species/lizard/ashwalker))
		current_ritual.ritual_start(src)
		return
	current_ritual = tgui_input_list(user, "选择要开始的仪式...", "仪式选择", GLOB.ash_rituals)
	if(!current_ritual)
		return
	current_ritual = GLOB.ash_rituals[current_ritual]
	balloon_alert_to_viewers("ritual has been chosen-- examine the central rune for more information.")

// this is solely for aesthetics... though the central rune will check the directions, of which this is on
/obj/effect/side_rune
	desc = "这个符文似乎带有某种奇怪的真空感。"
	icon = 'modular_nova/modules/ashwalkers/icons/ash_ritual.dmi'
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF
	anchored = TRUE
	/// the central rune that this is connected to
	var/obj/effect/ash_rune/connected_rune

// just so that if you attack this, you actually attack the main rune
/obj/effect/side_rune/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(connected_rune)
		connected_rune.attack_hand(user, modifiers)

/obj/effect/side_rune/Destroy(force)
	if(connected_rune)
		connected_rune = null
	. = ..()
