// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/mob/living/basic/construct/harvester
	name = "Harvester"
	real_name = "Harvester"
	desc = "A long, thin construct built to herald Nar'Sie's rise. It'll be all over soon."
	icon_state = "harvester"
	icon_living = "harvester"
	maxHealth = 40
	health = 40
	sight = SEE_MOBS
	melee_damage_lower = 15
	melee_damage_upper = 20
	attack_verb_continuous = "butchers"
	attack_verb_simple = "butcher"
	attack_sound = 'sound/items/weapons/bladeslice.ogg'
	attack_vis_effect = ATTACK_EFFECT_SLASH
	construct_spells = list(
		/datum/action/cooldown/spell/aoe/area_conversion,
		/datum/action/cooldown/spell/forcewall/cult,
	)
	playstyle_string = "<B>You are a Harvester. You are incapable of directly killing humans, \
		but your attacks will remove their limbs: Bring those who still cling to this world \
		of illusion back to the Geometer so they may know Truth. Your form and any you are \
		pulling can pass through runed walls effortlessly.</B>"
	can_repair = TRUE
	slowed_by_drag = FALSE

/mob/living/basic/construct/harvester/Initialize(mapload)
	. = ..()
	grant_abilities()

/mob/living/basic/construct/harvester/proc/grant_abilities()
	AddElement(/datum/element/wall_walker, /turf/closed/wall/mineral/cult)
	AddComponent(\
		/datum/component/amputating_limbs,\
		surgery_time = 0,\
		surgery_verb = "slicing",\
		minimum_stat = STABLE,\
	)
	var/datum/action/innate/seek_prey/seek = new(src)
	seek.Grant(src)
	seek.Activate()

/// If the attack is a limbless carbon, abort the attack, paralyze them, and get a special message from Nar'Sie.
/mob/living/basic/construct/harvester/resolve_unarmed_attack(atom/attack_target, list/modifiers)
	if(!iscarbon(attack_target))
		return ..()
	var/mob/living/carbon/carbon_target = attack_target

	for(var/obj/item/bodypart/limb as anything in carbon_target.get_bodyparts())
		if(limb.body_part == HEAD || limb.body_part == CHEST)
			continue
		return ..() //if any arms or legs exist, attack

	carbon_target.Paralyze(6 SECONDS)
	visible_message(span_danger(LANG("mob.b28257ff017a2b6e", list(src, carbon_target))))
	if(theme == THEME_CULT)
		to_chat(src, span_cult_large(LANG("mob.0242a2de99f876b4", list(carbon_target.p_them()))))

/datum/action/innate/seek_master
	name = "Seek your Master"
	desc = "You and your master share a soul-link that informs you of their location"
	background_icon_state = "bg_demon"
	overlay_icon_state = "bg_demon_border"

	buttontooltipstyle = "cult"
	button_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "cult_mark"
	/// Where is nar nar? Are we even looking?
	var/tracking = FALSE
	/// The construct we're attached to
	var/mob/living/basic/construct/the_construct

/datum/action/innate/seek_master/Grant(mob/living/player)
	the_construct = player
	..()

/datum/action/innate/seek_master/Activate()
	var/datum/antagonist/cult/cult_status = owner.mind.has_antag_datum(/datum/antagonist/cult)
	if(!cult_status)
		return
	var/datum/objective/eldergod/summon_objective = locate() in cult_status.cult_team.objectives

	if(summon_objective.check_completion())
		the_construct.construct_master = cult_status.cult_team.blood_target

	if(!the_construct.construct_master)
		to_chat(the_construct, span_cult_italic(LANG("datum.594ffa72bafa7a15", null)))
		the_construct.seeking = FALSE
		return
	if(tracking)
		tracking = FALSE
		the_construct.seeking = FALSE
		to_chat(the_construct, span_cult_italic(LANG("datum.47f9afa7ffd66241", null)))
		return
	else
		tracking = TRUE
		the_construct.seeking = TRUE
		to_chat(the_construct, span_cult_italic(LANG("datum.1c4b546d1fc923af", null)))

/datum/action/innate/seek_prey
	name = "Seek the Harvest"
	desc = "None can hide from Nar'Sie, activate to track a survivor attempting to flee the red harvest!"
	button_icon = 'icons/mob/actions/actions_cult.dmi'
	background_icon_state = "bg_demon"
	overlay_icon_state = "bg_demon_border"

	buttontooltipstyle = "cult"
	button_icon_state = "cult_mark"

/datum/action/innate/seek_prey/Activate()
	if(GLOB.cult_narsie == null)
		return
	var/mob/living/basic/construct/harvester/the_construct = owner

	if(the_construct.seeking)
		desc = LANG("datum.82148b4c2b05c378", null)
		button_icon_state = "cult_mark"
		the_construct.seeking = FALSE
		to_chat(the_construct, span_cult_italic(LANG("datum.970d2bf47076d1bd", null)))
		return

	if(!LAZYLEN(GLOB.cult_narsie.souls_needed))
		to_chat(the_construct, span_cult_italic(LANG("datum.fcb6dc1ae0a086b7", null)))
		return

	the_construct.construct_master = pick(GLOB.cult_narsie.souls_needed)
	var/mob/living/real_target = the_construct.construct_master //We can typecast this way because Narsie only allows /mob/living into the souls list
	to_chat(the_construct, span_cult_italic(LANG("datum.1a80032c6d2b409a", list(real_target.real_name, real_target.p_them()))))
	desc = LANG("datum.dcc1b2285a3da239", null)
	button_icon_state = "sintouch"
	the_construct.seeking = TRUE

/mob/living/basic/construct/harvester/heretic
	name = "Rusted Harvester"
	real_name = "Rusted Harvester"
	desc = "A long, thin, decrepit construct originally built to herald Nar'Sie's rise, corrupted and rusted by the forces of the Mansus to spread its will instead."
	icon_state = "harvester"
	icon_living = "harvester"
	construct_spells = list(
		/datum/action/cooldown/spell/aoe/rust_conversion,
		/datum/action/cooldown/spell/pointed/rust_construction,
	)
	can_repair = FALSE
	slowed_by_drag = FALSE
	faction = list(FACTION_HERETIC)
	maxHealth = 45
	health = 45
	melee_damage_lower = 20
	melee_damage_upper = 25
	// Dim green
	lighting_cutoff_red = 10
	lighting_cutoff_green = 20
	lighting_cutoff_blue = 5
	playstyle_string = span_bold("You are a Rusted Harvester, built to serve the Sanguine Apostate, twisted to work the will of the Mansus. You are fragile and weak, but you rend cultists (only) apart on each attack. Follow your Master's orders!")
	theme = THEME_HERETIC

/mob/living/basic/construct/harvester/heretic/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_MANSUS_TOUCHED, REF(src))
	add_filter("rusted_harvester", 3, list("type" = "outline", "color" = COLOR_GREEN, "size" = 2, "alpha" = 40))
	RegisterSignal(src, COMSIG_MIND_TRANSFERRED, TYPE_PROC_REF(/datum/mind, enslave_mind_to_creator))
	RegisterSignal(src, COMSIG_MOB_ENSLAVED_TO, PROC_REF(link_master))

/mob/living/basic/construct/harvester/heretic/proc/link_master(mob/self, mob/master)
	SIGNAL_HANDLER
	src.construct_master = master
	RegisterSignal(construct_master, COMSIG_LIVING_DEATH, PROC_REF(on_master_death))

/mob/living/basic/construct/harvester/heretic/proc/on_master_death(mob/self, mob/master)
	SIGNAL_HANDLER
	to_chat(src, span_userdanger(LANG("mob.22ab4fdc0cbc570c", list(construct_master, construct_master.p_their()))))
	visible_message(span_alert(LANG("mob.6b3d6252ee7067a1", list(src))))
	death()

/mob/living/basic/construct/harvester/heretic/attack_animal(mob/living/simple_animal/user, list/modifiers)
	// They're pretty fragile so this is probably necessary to prevent bullshit deaths.
	if(user == src)
		return
	return ..()

/mob/living/basic/construct/harvester/heretic/grant_abilities()
	AddElement(/datum/element/wall_walker, or_trait = TRAIT_RUSTY)
	AddElement(/datum/element/rust_healing)
	AddComponent(\
		/datum/component/amputating_limbs,\
		surgery_time = 1.5 SECONDS,\
		surgery_verb = "slicing",\
		minimum_stat = STABLE,\
		pre_hit_callback = CALLBACK(src, PROC_REF(is_cultist_handler)),\
	)
	AddComponent(/datum/component/damage_aura,\
		range = 3,\
		brute_damage = 0.5,\
		burn_damage = 0.5,\
		toxin_damage = 0.5,\
		stamina_damage = 4,\
		simple_damage = 1.5,\
		immune_factions = list(FACTION_HERETIC),\
		damage_message = span_boldwarning("Your body wilts and withers as it comes near [src]'s aura."),\
		message_probability = 7,\
		current_owner = src,\
	)
	var/datum/action/innate/seek_master/heretic/seek = new(src)
	seek.Grant(src)
	seek.Activate()

// These aren't friends they're assholes
// Don't let them be near you!
/mob/living/basic/construct/harvester/heretic/Life(seconds_per_tick)
	. = ..()
	if(!.) //dead or deleted
		return

	if(!SPT_PROB(7, seconds_per_tick))
		return

	var/turf/adjacent = get_step(src, pick(GLOB.alldirs))
	// 90% chance to be directional, otherwise what we're on top of
	var/turf/open/land = (isopenturf(adjacent) && prob(90)) ? adjacent : get_turf(src)
	do_rust_heretic_act(land)

	if(prob(7))
		to_chat(src, span_notice(LANG("mob.cef8e7402748db29", null)))

/mob/living/basic/construct/harvester/heretic/proc/is_cultist_handler(mob/victim)
	return IS_CULTIST(victim)

/datum/action/innate/seek_master/heretic
	name = "Seek your Master"
	desc = "Use your direct link to the Mansus to sense where your master is located via the arrow on the top-right of your HUD."
	button_icon = 'icons/mob/actions/actions_cult.dmi'
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	tracking = TRUE

/datum/action/innate/seek_master/heretic/New(Target)
	. = ..()
	the_construct = Target
	the_construct.seeking = TRUE

// no real reason for most of this weird oldcode
/datum/action/innate/seek_master/Activate()
	return
