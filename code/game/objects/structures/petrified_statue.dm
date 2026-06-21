/obj/structure/statue/petrified
	name = "雕像"
	desc = "一个栩栩如生的大理石雕刻。"
	icon_state = "human_male"
	density = TRUE
	anchored = TRUE
	max_integrity = 200
	///Should we leave a brain behind when the statue is wrecked?
	var/brain = TRUE
	///Time left before the petrification ends and we let the mob free
	var/timer = 8 MINUTES
	///The mob that got medusa'd
	var/mob/living/petrified_mob

/obj/structure/statue/petrified/relaymove()
	return

/obj/structure/statue/petrified/Initialize(mapload, mob/living/living, statue_timer, save_brain)
	. = ..()
	if(statue_timer)
		timer = statue_timer
	if(save_brain)
		brain = save_brain
	if(!living)
		return
	petrified_mob = living
	if(living.buckled)
		living.buckled.unbuckle_mob(living, force = TRUE)
	living.visible_message(span_warning("[living]的皮肤迅速变成了大理石！"), span_userdanger("你的身体僵住了！动不了……也……无法思考……"))
	living.forceMove(src)
	living.add_traits(list(TRAIT_GODMODE, TRAIT_MUTE, TRAIT_NOBLOOD), STATUE_MUTE)
	living.add_faction(FACTION_MIMIC) //Stops mimics from instaqdeling people in statues
	atom_integrity = living.health + 100 //stoning damaged mobs will result in easier to shatter statues
	max_integrity = atom_integrity
	START_PROCESSING(SSobj, src)

/obj/structure/statue/petrified/process(seconds_per_tick)
	if(!petrified_mob)
		STOP_PROCESSING(SSobj, src)
	timer -= seconds_per_tick SECONDS
	petrified_mob.Stun(4 SECONDS) //So they can't do anything while petrified
	if(timer <= 0)
		STOP_PROCESSING(SSobj, src)
		qdel(src)

/obj/structure/statue/petrified/contents_explosion(severity, target)
	return

/obj/structure/statue/petrified/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == petrified_mob)
		petrified_mob.remove_traits(list(TRAIT_GODMODE, TRAIT_MUTE, TRAIT_NOBLOOD), STATUE_MUTE)
		petrified_mob.Paralyze(10 SECONDS)
		petrified_mob.take_overall_damage((petrified_mob.health - atom_integrity + 100)) //any new damage the statue incurred is transferred to the mob
		petrified_mob.remove_faction(FACTION_MIMIC)
		petrified_mob = null

/obj/structure/statue/petrified/Destroy()
	var/turf/dropoff_turf = drop_location()
	if(istype(loc, /mob/living/basic/statue))
		var/mob/living/basic/statue/statue_mob = loc
		forceMove(dropoff_turf)
		if(statue_mob.mind)
			if(petrified_mob)
				statue_mob.mind.transfer_to(petrified_mob)
				to_chat(petrified_mob, span_notice("你慢慢恢复了知觉。你重新掌控了自己的身体！"))
		qdel(statue_mob)

	for(var/obj/statue_contents in src)
		statue_contents.forceMove(dropoff_turf)

	petrified_mob?.forceMove(dropoff_turf)
	return ..()

/obj/structure/statue/petrified/atom_deconstruct(disassembled = TRUE)
	var/destruction_message = "[src] shatters!"
	if(!disassembled)
		if(petrified_mob)
			petrified_mob.investigate_log("has been dusted by statue deconstruction.", INVESTIGATE_DEATHS)
			if(iscarbon(petrified_mob) && brain)
				var/mob/living/carbon/petrified_carbon = petrified_mob
				var/obj/item/organ/brain/carbon_brain = petrified_carbon.get_organ_slot(ORGAN_SLOT_BRAIN)
				carbon_brain.Remove(petrified_carbon)
				carbon_brain.forceMove(get_turf(src))
				carbon_brain.name = "石化的[carbon_brain.name]"
				carbon_brain.desc = "[carbon_brain.desc] 这一个看起来比普通大脑更……光滑一些。可能还能用。"
				carbon_brain.add_atom_colour(list(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0)), FIXED_COLOUR_PRIORITY)
				destruction_message = "[src] shatters, a solid brain tumbling out!"
			petrified_mob.dust()
	visible_message(span_danger(destruction_message))

/obj/structure/statue/petrified/animate_atom_living(mob/living/owner)
	if(isnull(petrified_mob))
		return ..()
	var/mob/living/basic/statue/new_statue = new(drop_location())
	new_statue.name = "[petrified_mob.name]的雕像"
	if(owner)
		new_statue.befriend(owner)
	new_statue.icon = 'icons/blanks/32x32.dmi'
	new_statue.icon_state = "nothing"
	new_statue.appearance_flags |= KEEP_TOGETHER
	new_statue.copy_overlays(src, cut_old = TRUE)
	new_statue.atom_colours = atom_colours.Copy()
	new_statue.update_atom_colour()
	petrified_mob.mind?.transfer_to(new_statue)
	to_chat(new_statue, span_userdanger("你是一个活化的雕像。在被注视时无法移动，但在不被观察时几乎无敌且致命！[owner ? "Do not harm [owner], your creator" : ""]。"))
	forceMove(new_statue)
	return new_statue

/mob/proc/petrify(statue_timer)
	return

/mob/living/carbon/human/petrify(statue_timer, save_brain, colorlist)
	if(!isturf(loc))
		return FALSE
	var/obj/structure/statue/petrified/new_statue = new(loc, src, statue_timer, save_brain)
	new_statue.name = "[name] 的雕像"
	new_statue.icon = 'icons/blanks/32x32.dmi'
	new_statue.icon_state = "nothing"
	new_statue.appearance_flags |= KEEP_TOGETHER
	new_statue.copy_overlays(src, cut_old = TRUE)
	new_statue.add_atom_colour(colorlist || list(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0)), FIXED_COLOUR_PRIORITY)
	return TRUE

/mob/living/basic/pet/dog/corgi/petrify(statue_timer)
	if(!isturf(loc))
		return FALSE
	var/obj/structure/statue/petrified/new_statue = new (loc, src, statue_timer)
	new_statue.name = "柯基的雕像"
	new_statue.icon_state = "corgi"
	new_statue.desc = "如果要永远等下去，我会等你……"
	return TRUE
