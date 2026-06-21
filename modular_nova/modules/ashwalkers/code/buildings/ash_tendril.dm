#define REQUIRED_OBSERVERS 2
#define MEGAFAUNA_MEAT_AMOUNT 20

//this is for revitalizing/preserving regen cores
/obj/structure/lavaland/ash_walker/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(!istype(attacking_item, /obj/item/organ/monster_core/regenerative_core))
		return ..()

	if(!user.mind.has_antag_datum(/datum/antagonist/ashwalker))
		balloon_alert(user, "必须是灰烬行者！")
		return

	var/obj/item/organ/monster_core/regenerative_core/regen_core = attacking_item

	if(!regen_core.decay_timer)
		balloon_alert(user, "器官已经恢复活力了！")
		return
	if(!regen_core.preserve())
		balloon_alert(user, "器官已腐烂！")
		return
	playsound(src, 'sound/effects/magic/demon_consume.ogg', 50, TRUE)
	balloon_alert_to_viewers("[src] revitalizes [regen_core]!")
	return

//this is for logging the destruction of the tendril
/obj/structure/lavaland/ash_walker/Destroy()
	var/compiled_string = "The [src] has been destroyed at [loc_name(src.loc)], nearest mobs are "
	var/found_anyone = FALSE

	for(var/mob/living/carbon/carbons_nearby in range(7))
		compiled_string += "[key_name(carbons_nearby)],"
		found_anyone = TRUE

	if(!found_anyone)
		compiled_string += "nobody."

	log_game(compiled_string)
	return ..()

//this is for transforming a person into an ashwalker
/obj/structure/lavaland/ash_walker/attack_hand(mob/living/user, list/modifiers)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/human_user = user
	if(istype(human_user.dna.species, /datum/species/lizard/ashwalker))
		return

	var/allow_transform = 0

	for(var/mob/living/carbon/human/count_human in range(2, src))
		if(!istype(count_human.dna.species, /datum/species/lizard/ashwalker))
			continue

		allow_transform++

	if(allow_transform < REQUIRED_OBSERVERS)
		balloon_alert_to_viewers("[src] rejects the request, not enough viewers!")
		playsound(src, 'sound/effects/magic/demon_consume.ogg', 50, TRUE)
		human_user.adjust_brute_loss(10)
		return

	else
		balloon_alert_to_viewers("[src] reaches out to [human_user]...")
		var/choice = tgui_alert(human_user, "成为灰烬行者？你将抛弃你之前的生活和身体。", "重大抉择", list("Yes", "No"))

		if(choice != "Yes")
			balloon_alert_to_viewers("[src] feels rejected and punishes [human_user]!")
			playsound(src, 'sound/effects/magic/demon_consume.ogg', 50, TRUE)
			human_user.adjust_brute_loss(50)
			return

		balloon_alert_to_viewers("[src] rejoices and transforms [human_user]!")
		human_user.unequip_everything()
		human_user.set_species(/datum/species/lizard/ashwalker)
		human_user.underwear = "Nude"
		human_user.update_body()
		human_user.mind.add_antag_datum(/datum/antagonist/ashwalker)

		if(SSmapping.level_trait(human_user.z, ZTRAIT_ICE_RUINS) || SSmapping.level_trait(human_user.z, ZTRAIT_ICE_RUINS_UNDERGROUND))
			ADD_TRAIT(human_user, TRAIT_NOBREATH, ROUNDSTART_TRAIT)
			ADD_TRAIT(human_user, TRAIT_RESISTCOLD, ROUNDSTART_TRAIT)

		ADD_TRAIT(human_user, TRAIT_PRIMITIVE, ROUNDSTART_TRAIT)
		playsound(src, 'sound/effects/magic/demon_dies.ogg', 50, TRUE)
		meat_counter++

	return ..()

//this is the nova override
/obj/structure/lavaland/ash_walker/consume()
	for(var/mob/living/viewable_living in view(src, 1)) //Only for corpse right next to/on same tile
		if(!viewable_living.stat)
			continue

		viewable_living.unequip_everything()

		if(issilicon(viewable_living)) //no advantage to sacrificing borgs...
			viewable_living.investigate_log("has been gibbed via ashwalker sacrifice as a borg.", INVESTIGATE_DEATHS)
			viewable_living.gib()
			return

		if(viewable_living.mind?.has_antag_datum(/datum/antagonist/ashwalker) && (viewable_living.ckey || viewable_living.get_ghost(FALSE, TRUE))) //special interactions for dead lava lizards with ghosts attached
			revive_ashwalker(viewable_living)
			return

		if(ismegafauna(viewable_living))
			meat_counter += MEGAFAUNA_MEAT_AMOUNT

		else
			meat_counter++

		playsound(get_turf(src),'sound/effects/magic/demon_consume.ogg', 100, TRUE)
		var/delivery_key = viewable_living.fingerprintslast //key of whoever brought the body
		var/mob/living/delivery_mob = get_mob_by_key(delivery_key) //mob of said key

		//there is a 40% chance that the Lava Lizard unlocks their respawn with each sacrifice
		if(delivery_mob && (delivery_mob.mind?.has_antag_datum(/datum/antagonist/ashwalker)) && (delivery_key in ashies.players_spawned) && prob(40))
			to_chat(delivery_mob, span_boldwarning("死灵圣殿对你的献祭感到满意。你确信自己死后的存在是安稳的。"))
			ashies.players_spawned -= delivery_key

		viewable_living.investigate_log("has been gibbed via ashwalker sacrifice.", INVESTIGATE_DEATHS)
		viewable_living.gib()
		atom_integrity = min(atom_integrity + max_integrity * 0.05, max_integrity) //restores 5% hp of tendril

		for(var/mob/living/living_observers in view(src, 5))
			if(living_observers.mind?.has_antag_datum(/datum/antagonist/ashwalker))
				living_observers.add_mood_event("oogabooga", /datum/mood_event/sacrifice_good)

			else
				living_observers.add_mood_event("oogabooga", /datum/mood_event/sacrifice_bad)

		ashies.sacrifices_made++

/**
 * Proc that will spawn the egg that will revive the ashwalker
 * This is also the Nova replacement for /proc/remake_walker
 */
/obj/structure/lavaland/ash_walker/proc/revive_ashwalker(mob/living/carbon/human/revived_ashwalker)
	var/obj/structure/reviving_ashwalker_egg/spawned_egg = new(get_step(loc, pick(GLOB.alldirs)))
	revived_ashwalker.forceMove(spawned_egg)
	to_chat(revived_ashwalker, span_warning("触须决定仁慈一些，将在一分钟内复活你，请耐心等待。"))

/obj/structure/reviving_ashwalker_egg
	name = "已被占据的灰烬行者卵"
	desc = "除了通常那种黄色的、人一般大小的卵的外观之外，里面似乎还漂浮着一具躯体！"
	icon = 'icons/mob/simple/lavaland/lavaland_monsters.dmi'
	icon_state = "large_egg"
	resistance_flags = LAVA_PROOF | FIRE_PROOF | FREEZE_PROOF
	max_integrity = 80

/obj/structure/reviving_ashwalker_egg/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(do_revive)), 30 SECONDS)

/**
 * Proc that will fully revive the living content inside and then destroy itself
 */
/obj/structure/reviving_ashwalker_egg/proc/do_revive()
	var/mob/living/living_inside = locate() in contents

	if(!living_inside)
		qdel(src)
		return

	living_inside.revive(ADMIN_HEAL_ALL)
	living_inside.forceMove(get_turf(src))
	living_inside.mind.grab_ghost()
	living_inside.balloon_alert_to_viewers("[living_inside] breaks out of [src]!")
	qdel(src)

#undef REQUIRED_OBSERVERS
#undef MEGAFAUNA_MEAT_AMOUNT
