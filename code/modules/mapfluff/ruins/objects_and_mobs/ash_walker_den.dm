// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
#define ASH_WALKER_SPAWN_THRESHOLD 2
//The ash walker den consumes corpses or unconscious mobs to create ash walker eggs. For more info on those, check ghost_role_spawners.dm
/obj/structure/lavaland/ash_walker
	name = "necropolis tendril nest"
	desc = "A vile tendril of corruption. It's surrounded by a nest of rapidly growing eggs..."
	icon = 'icons/mob/simple/lavaland/nest.dmi'
	icon_state = "ash_walker_nest"

	move_resist=INFINITY // just killing it tears a massive hole in the ground, let's not move it
	anchored = TRUE
	density = TRUE

	resistance_flags = FIRE_PROOF | LAVA_PROOF
	max_integrity = 200

	faction = list(FACTION_ASHWALKER)

	var/meat_counter = 6
	var/datum/team/ashwalkers/ashies
	var/datum/linked_objective

/obj/structure/lavaland/ash_walker/Initialize(mapload)
	.=..()
	ashies = new /datum/team/ashwalkers()
	var/datum/objective/protect_object/objective = new
	objective.set_target(src)
	objective.team = ashies
	linked_objective = objective
	ashies.objectives += objective
	START_PROCESSING(SSprocessing, src)

/obj/structure/lavaland/ash_walker/Destroy()
	ashies = null
	linked_objective = null
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/structure/lavaland/ash_walker/atom_deconstruct(disassembled)
	var/core_to_drop = pick(subtypesof(/obj/item/assembly/signaler/anomaly))
	new core_to_drop (get_step(loc, pick(GLOB.alldirs)))
	new /obj/effect/collapse(loc)

/obj/structure/lavaland/ash_walker/process()
	consume()
	spawn_mob()

/obj/structure/lavaland/ash_walker/proc/consume()
	for(var/mob/living/offeredmob in view(src, 1)) //Only for corpse right next to/on same tile
		if(offeredmob.loc == src)
			continue //Ashwalker Revive in Progress...
		if(IS_UNCONSCIOUS_OR_CRIT(offeredmob))
			offeredmob.unequip_everything()

			if(issilicon(offeredmob)) //no advantage to sacrificing borgs...
				offeredmob.investigate_log("has been gibbed by the necropolis tendril.", INVESTIGATE_DEATHS)
				visible_message(span_notice(LANG("obj.e803c8717dd1ef13", list(offeredmob))))
				offeredmob.gib()
				return

			if(offeredmob.mind?.has_antag_datum(/datum/antagonist/ashwalker) && (offeredmob.ckey || offeredmob.get_ghost(FALSE, TRUE))) //special interactions for dead lava lizards with ghosts attached
				visible_message(span_warning(LANG("obj.e5669b25b3107482", list(offeredmob, src))))
				var/mob/deadmob
				if(offeredmob.ckey)
					deadmob = offeredmob
				else
					deadmob = offeredmob.get_ghost(FALSE, TRUE)
				to_chat(deadmob, LANG("obj.6d3cef375e7f301f", null))
				SEND_SOUND(deadmob, sound('sound/effects/magic/enter_blood.ogg',volume=100))
				addtimer(CALLBACK(src, PROC_REF(remake_walker), offeredmob), 20 SECONDS)
				offeredmob.forceMove(src)
				return

			if(ismegafauna(offeredmob))
				meat_counter += 20
			else
				meat_counter++
			visible_message(span_warning(LANG("obj.76d8a7089723e73f", list(offeredmob, src))))
			playsound(get_turf(src),'sound/effects/magic/demon_consume.ogg', 100, TRUE)
			var/deliverykey = offeredmob.fingerprintslast //ckey of whoever brought the body
			var/mob/living/deliverymob = get_mob_by_key(deliverykey) //mob of said ckey
			//there is a 40% chance that the Lava Lizard unlocks their respawn with each sacrifice
			if(deliverymob && (deliverymob.mind?.has_antag_datum(/datum/antagonist/ashwalker)) && (deliverykey in ashies.players_spawned) && (prob(40)))
				to_chat(deliverymob, span_warning(LANG("obj.224569c8e6a8d3a4", null)))
				ashies.players_spawned -= deliverykey
			offeredmob.investigate_log("has been gibbed by the necropolis tendril.", INVESTIGATE_DEATHS)
			offeredmob.gib(DROP_ALL_REMAINS)
			atom_integrity = min(atom_integrity + max_integrity*0.05,max_integrity)//restores 5% hp of tendril
			for(var/mob/living/L in view(src, 5))
				if(L.mind?.has_antag_datum(/datum/antagonist/ashwalker))
					L.add_mood_event("oogabooga", /datum/mood_event/sacrifice_good)
				else
					L.add_mood_event("oogabooga", /datum/mood_event/sacrifice_bad)
			ashies.sacrifices_made++

/obj/structure/lavaland/ash_walker/proc/remake_walker(mob/living/carbon/oldmob)
	var/mob/living/carbon/human/newwalker = new /mob/living/carbon/human(get_step(loc, pick(GLOB.alldirs)))
	newwalker.set_species(/datum/species/lizard/ashwalker)
	newwalker.real_name = oldmob.real_name
	newwalker.undershirt = "Nude"
	newwalker.underwear = "Nude"
	newwalker.update_body()
	newwalker.remove_language(/datum/language/common)
	oldmob.mind.transfer_to(newwalker)
	newwalker.mind.grab_ghost()
	to_chat(newwalker, LANG("obj.459af3acaa23a866", null))
	playsound(get_turf(newwalker),'sound/effects/magic/exit_blood.ogg', 100, TRUE)
	qdel(oldmob)

/obj/structure/lavaland/ash_walker/proc/spawn_mob()
	if(meat_counter >= ASH_WALKER_SPAWN_THRESHOLD)
		new /obj/effect/mob_spawn/ghost_role/human/ash_walker(get_step(loc, pick(GLOB.alldirs)), ashies)
		visible_message(span_danger(LANG("obj.14a90ae6f4e18765", null)))
		meat_counter -= ASH_WALKER_SPAWN_THRESHOLD
		ashies.eggs_created++

/obj/structure/lavaland/ash_walker_fake
	name = "necropolis tendril nest"
	desc = "A vile tendril of corruption. It's surrounded by a nest of rapidly growing eggs..."
	icon = 'icons/mob/simple/lavaland/nest.dmi'
	icon_state = "ash_walker_nest"
	move_resist = INFINITY
	anchored = TRUE
	resistance_flags = FIRE_PROOF | LAVA_PROOF
	max_integrity = 200

/obj/effect/light_emitter/tendril
	set_luminosity = 4
	set_cap = 2.5
	light_color = LIGHT_COLOR_LAVA

/obj/effect/collapse
	name = "collapsing necropolis tendril"
	desc = "Get your loot and get clear!"
	layer = TABLE_LAYER
	icon = 'icons/mob/simple/lavaland/nest.dmi'
	icon_state = "tendril"
	anchored = TRUE
	density = TRUE
	/// weakref list of which mobs have gotten their loot from this effect.
	var/list/collected = list()
	/// a bit of light as to make less unfair deaths from the chasm
	var/obj/effect/light_emitter/tendril/emitted_light

/obj/effect/collapse/Initialize(mapload)
	. = ..()
	emitted_light = new(loc)
	visible_message(span_bolddanger(LANG("obj.5abfde61e62a6dae", null)))
	balloon_alert_to_viewers(LANG("obj.9dedb4914f4a8464", null), vision_distance = 7)
	playsound(loc,'sound/effects/tendril_destroyed.ogg', 200, FALSE, 50, TRUE, TRUE)
	addtimer(CALLBACK(src, PROC_REF(collapse)), 5 SECONDS)

/obj/effect/collapse/examine(mob/user)
	var/list/examine_messages = ..()
	if(isliving(user))
		if(has_collected(user))
			examine_messages += span_boldnotice(LANG("obj.86ccae07b0b02ce7", null))
		else
			examine_messages += span_boldnotice(LANG("obj.a654af9ed0f5382e", null))
	return examine_messages

/obj/effect/collapse/attack_hand(mob/living/collector, list/modifiers)
	. = ..()
	if(has_collected(collector))
		to_chat(collector, span_danger(LANG("obj.5ac6ed21848d60ad", null)))
		return
	visible_message(span_warning(LANG("obj.fa040f0dd7641419", null)))
	var/obj/structure/closet/crate/necropolis/tendril/loot = new /obj/structure/closet/crate/necropolis/tendril(loc)
	collector.start_pulling(loot)
	collected += WEAKREF(collector)

/obj/effect/collapse/Destroy()
	collected.Cut()
	QDEL_NULL(emitted_light)
	return ..()

///Helper proc that resolves weakrefs to determine if collector is in collected list, returning a boolean.
/obj/effect/collapse/proc/has_collected(mob/collector)
	for(var/datum/weakref/weakref as anything in collected)
		var/mob/living/resolved = weakref.resolve()
		//it could have been collector, it could not have been, we don't care
		if(!resolved)
			continue
		if(resolved == collector)
			return TRUE
	return FALSE

/obj/effect/collapse/proc/collapse()
	for(var/mob/viewer in range(7, src))
		shake_camera(viewer, 15, 1)
	playsound(get_turf(src),'sound/effects/explosion/explosionfar.ogg', 200, TRUE)
	visible_message(span_bolddanger(LANG("obj.d60d68e33bf60aaf", null)))
	for(var/turf/ground in RANGE_TURFS(2, src))
		if(HAS_TRAIT(ground, TRAIT_NO_TERRAFORM))
			continue
		if(!ground.density)
			ground.TerraformTurf(/turf/open/chasm/lavaland, /turf/open/chasm/lavaland, flags = CHANGETURF_INHERIT_AIR)
	qdel(src)

#undef ASH_WALKER_SPAWN_THRESHOLD
