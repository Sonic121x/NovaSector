#define ASH_WALKER_SPAWN_THRESHOLD 2
//The ash walker den consumes corpses or unconscious mobs to create ash walker eggs. For more info on those, check ghost_role_spawners.dm
/obj/structure/lavaland/ash_walker
	name = "灰烬墓地触须巢"
	desc = "邪恶的腐败卷须。它周围是一窝快速生长的蛋"
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
		if(offeredmob.stat)
			offeredmob.unequip_everything()

			if(issilicon(offeredmob)) //no advantage to sacrificing borgs...
				offeredmob.investigate_log("has been gibbed by the necropolis tendril.", INVESTIGATE_DEATHS)
				visible_message(span_notice("锯齿状的触须急切地将 [offeredmob] 撕开，但没发现什么有趣的东西。"))
				offeredmob.gib()
				return

			if(offeredmob.mind?.has_antag_datum(/datum/antagonist/ashwalker) && (offeredmob.ckey || offeredmob.get_ghost(FALSE, TRUE))) //special interactions for dead lava lizards with ghosts attached
				visible_message(span_warning("锯齿状的触须小心地将 [offeredmob] 拉向 [src]，吸收其身体并重塑一新。"))
				var/mob/deadmob
				if(offeredmob.ckey)
					deadmob = offeredmob
				else
					deadmob = offeredmob.get_ghost(FALSE, TRUE)
				to_chat(deadmob, "你的身体已被送回巢穴。你正在被重塑，很快就会醒来。</br><b>你的记忆将在新身体中保留，因为你的灵魂正在被回收</b>")
				SEND_SOUND(deadmob, sound('sound/effects/magic/enter_blood.ogg',volume=100))
				addtimer(CALLBACK(src, PROC_REF(remake_walker), offeredmob), 20 SECONDS)
				offeredmob.forceMove(src)
				return

			if(ismegafauna(offeredmob))
				meat_counter += 20
			else
				meat_counter++
			visible_message(span_warning("锯齿状的触须急切地将 [offeredmob] 拉向 [src]，将身体撕碎，鲜血渗入蛋中。"))
			playsound(get_turf(src),'sound/effects/magic/demon_consume.ogg', 100, TRUE)
			var/deliverykey = offeredmob.fingerprintslast //ckey of whoever brought the body
			var/mob/living/deliverymob = get_mob_by_key(deliverykey) //mob of said ckey
			//there is a 40% chance that the Lava Lizard unlocks their respawn with each sacrifice
			if(deliverymob && (deliverymob.mind?.has_antag_datum(/datum/antagonist/ashwalker)) && (deliverykey in ashies.players_spawned) && (prob(40)))
				to_chat(deliverymob, span_warning("<b>死寂之城对你的献祭感到满意。你确信自己死后的存在是安全的。</b>"))
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
	to_chat(newwalker, "<b>你已从坟墓之外被拉回，获得了一具新的身体和崭新的目标。荣耀归于死寂之城！</b>")
	playsound(get_turf(newwalker),'sound/effects/magic/exit_blood.ogg', 100, TRUE)
	qdel(oldmob)

/obj/structure/lavaland/ash_walker/proc/spawn_mob()
	if(meat_counter >= ASH_WALKER_SPAWN_THRESHOLD)
		new /obj/effect/mob_spawn/ghost_role/human/ash_walker(get_step(loc, pick(GLOB.alldirs)), ashies)
		visible_message(span_danger("其中一颗蛋膨胀到不自然的尺寸并滚落下来。它准备好孵化了！"))
		meat_counter -= ASH_WALKER_SPAWN_THRESHOLD
		ashies.eggs_created++

/obj/structure/lavaland/ash_walker_fake
	name = "灰烬墓地触须巢"
	desc = "邪恶的腐败卷须。它周围是一窝快速生长的蛋"
	icon = 'icons/mob/simple/lavaland/nest.dmi'
	icon_state = "ash_walker_nest"
	move_resist = INFINITY
	anchored = TRUE
	resistance_flags = FIRE_PROOF | LAVA_PROOF
	max_integrity = 200

#undef ASH_WALKER_SPAWN_THRESHOLD
