// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/*
Charged extracts:
	Have a unique, effect when filled with
	10u plasma and activated in-hand, related to their
	normal extract effect.
*/
/obj/item/slimecross/charged
	name = "charged extract"
	desc = "It sparks with electric power."
	effect = "charged"
	icon_state = "charged"

/obj/item/slimecross/charged/Initialize(mapload)
	. = ..()
	create_reagents(10, INJECTABLE | DRAWABLE)

/obj/item/slimecross/charged/attack_self(mob/user)
	if(!reagents.has_reagent(/datum/reagent/toxin/plasma, 10))
		to_chat(user, span_warning(LANG("obj.883dcdd9caaf3016", null)))
		return
	reagents.remove_reagent(/datum/reagent/toxin/plasma, 10)
	to_chat(user, span_notice(LANG("obj.879f3da7868def2c", null)))
	playsound(src, 'sound/effects/bubbles/bubbles.ogg', 50, TRUE)
	playsound(src, 'sound/effects/light_flicker.ogg', 50, TRUE)
	do_effect(user)

/obj/item/slimecross/charged/proc/do_effect(mob/user) //If, for whatever reason, you don't want to delete the extract, don't do ..()
	qdel(src)
	return

/obj/item/slimecross/charged/grey
	colour = SLIME_TYPE_GREY
	effect_desc = "Produces a slime reviver potion, which revives dead slimes."

/obj/item/slimecross/charged/grey/do_effect(mob/user)
	new /obj/item/slimepotion/slime_reviver(get_turf(user))
	user.visible_message(span_notice(LANG("obj.e857e3d1436b3a27", list(src))))
	..()

/obj/item/slimecross/charged/orange
	colour = SLIME_TYPE_ORANGE
	effect_desc = "Instantly makes a large burst of flame for a moment."

/obj/item/slimecross/charged/orange/do_effect(mob/user)
	var/turf/targetturf = get_turf(user)
	for(var/turf/turf as anything in RANGE_TURFS(5,targetturf))
		if(!locate(/obj/effect/hotspot) in turf)
			new /obj/effect/hotspot(turf)
	..()

/obj/item/slimecross/charged/purple
	colour = SLIME_TYPE_PURPLE
	effect_desc = "Creates a packet of omnizine."

/obj/item/slimecross/charged/purple/do_effect(mob/user)
	new /obj/item/slimecrossbeaker/omnizine(get_turf(user))
	user.visible_message(span_notice(LANG("obj.1dc408234da7db51", list(src))))
	..()

/obj/item/slimecross/charged/blue
	colour = SLIME_TYPE_BLUE
	effect_desc = "Creates a potion that neuters the mutation chance of a slime, which passes on to new generations."

/obj/item/slimecross/charged/blue/do_effect(mob/user)
	new /obj/item/slimepotion/slime/chargedstabilizer(get_turf(user))
	user.visible_message(span_notice(LANG("obj.e857e3d1436b3a27", list(src))))
	..()

/obj/item/slimecross/charged/metal
	colour = SLIME_TYPE_METAL
	effect_desc = "Produces a bunch of metal and plasteel."

/obj/item/slimecross/charged/metal/do_effect(mob/user)
	new /obj/item/stack/sheet/iron(get_turf(user), 25)
	new /obj/item/stack/sheet/plasteel(get_turf(user), 10)
	user.visible_message(span_notice(LANG("obj.c2b8bc03dcfb484a", list(src))))
	..()

/obj/item/slimecross/charged/yellow
	colour = SLIME_TYPE_YELLOW
	effect_desc = "Creates a hypercharged slime cell battery, which has high capacity but takes longer to recharge."

/obj/item/slimecross/charged/yellow/do_effect(mob/user)
	new /obj/item/stock_parts/power_store/cell/high/slime_hypercharged(get_turf(user))
	user.visible_message(span_notice(LANG("obj.f9d9fd8d788205fc", list(src))))
	..()

/obj/item/slimecross/charged/darkpurple
	colour = SLIME_TYPE_DARK_PURPLE
	effect_desc = "Creates several sheets of plasma."

/obj/item/slimecross/charged/darkpurple/do_effect(mob/user)
	new /obj/item/stack/sheet/mineral/plasma(get_turf(user), 10)
	user.visible_message(span_notice(LANG("obj.c2c1b37cb8670deb", list(src))))
	..()

/obj/item/slimecross/charged/darkblue
	colour = SLIME_TYPE_DARK_BLUE
	effect_desc = "Produces a pressure proofing potion."

/obj/item/slimecross/charged/darkblue/do_effect(mob/user)
	new /obj/item/slimepotion/spaceproof(get_turf(user))
	user.visible_message(span_notice(LANG("obj.e857e3d1436b3a27", list(src))))
	..()

/obj/item/slimecross/charged/silver
	colour = SLIME_TYPE_SILVER
	effect_desc = "Creates a slime cake and some drinks."

/obj/item/slimecross/charged/silver/do_effect(mob/user)
	new /obj/item/food/cake/slimecake(get_turf(user))
	for(var/i in 1 to 10)
		var/drink_type = get_random_drink()
		new drink_type(get_turf(user))
	user.visible_message(span_notice(LANG("obj.e6abb9f3649e5934", list(src))))
	..()

/obj/item/slimecross/charged/bluespace
	colour = SLIME_TYPE_BLUESPACE
	effect_desc = "Makes a bluespace polycrystal."

/obj/item/slimecross/charged/bluespace/do_effect(mob/user)
	new /obj/item/stack/sheet/bluespace_crystal(get_turf(user), 10)
	user.visible_message(span_notice(LANG("obj.7b904ea813cdbe0f", list(src))))
	..()

/obj/item/slimecross/charged/sepia
	colour = SLIME_TYPE_SEPIA
	effect_desc = "Creates a camera obscura."

/obj/item/slimecross/charged/sepia/do_effect(mob/user)
	new /obj/item/camera/spooky(get_turf(user))
	user.visible_message(span_notice(LANG("obj.93e1373d198ff49f", list(src))))
	..()

/obj/item/slimecross/charged/cerulean
	colour = SLIME_TYPE_CERULEAN
	effect_desc = "Creates an extract enhancer, giving whatever it's used on five more uses."

/obj/item/slimecross/charged/cerulean/do_effect(mob/user)
	new /obj/item/slimepotion/enhancer/max(get_turf(user))
	user.visible_message(span_notice(LANG("obj.e857e3d1436b3a27", list(src))))
	..()

/obj/item/slimecross/charged/pyrite
	colour = SLIME_TYPE_PYRITE
	effect_desc = "Creates bananium. Oh no."

/obj/item/slimecross/charged/pyrite/do_effect(mob/user)
	new /obj/item/stack/sheet/mineral/bananium(get_turf(user), 10)
	user.visible_message(span_warning(LANG("obj.4340c567fc4e8e19", list(src))))
	..()

/obj/item/slimecross/charged/red
	colour = SLIME_TYPE_RED
	effect_desc = "Produces a lavaproofing potion"

/obj/item/slimecross/charged/red/do_effect(mob/user)
	new /obj/item/slimepotion/lavaproof(get_turf(user))
	user.visible_message(span_notice(LANG("obj.e857e3d1436b3a27", list(src))))
	..()

/obj/item/slimecross/charged/green
	colour = SLIME_TYPE_GREEN
	effect_desc = "Lets you choose what slime species you want to be."

/obj/item/slimecross/charged/green/do_effect(mob/user)
	var/mob/living/carbon/human/human_user = user
	if(!istype(human_user))
		to_chat(user, span_warning(LANG("obj.870ecf30632072c9", null)))
		return
	var/list/choice_list = list()
	for(var/datum/species/species_type as anything in subtypesof(/datum/species/jelly))
		choice_list[initial(species_type.name)] = species_type
	var/racechoice = tgui_input_list(human_user, LANG("obj.03ef49ee79b6d8bc", null), LANG("obj.5006fc5f63d056eb", null), sort_list(choice_list))
	if(isnull(racechoice))
		to_chat(user, span_notice(LANG("obj.1d977070ca35d7e4", null)))
		return
	if(!user.can_perform_action(src))
		return
	human_user.set_species(choice_list[racechoice], icon_update=1)
	human_user.visible_message(span_warning(LANG("obj.42889c00f57bdb9c", list(human_user, src, human_user.p_their()))))
	..()

/obj/item/slimecross/charged/pink
	colour = SLIME_TYPE_PINK
	effect_desc = "Produces a... lovepotion... no ERP."

/obj/item/slimecross/charged/pink/do_effect(mob/user)
	new /obj/item/slimepotion/lovepotion(get_turf(user))
	user.visible_message(span_notice(LANG("obj.e857e3d1436b3a27", list(src))))
	..()

/obj/item/slimecross/charged/gold
	colour = SLIME_TYPE_GOLD
	effect_desc = "Slowly spawns 10 hostile monsters."
	var/max_spawn = 10
	var/spawned = 0

/obj/item/slimecross/charged/gold/do_effect(mob/user)
	user.visible_message(span_warning(LANG("obj.e7abc0c0575b76f0", list(src))))
	addtimer(CALLBACK(src, PROC_REF(startTimer)), 5 SECONDS)

/obj/item/slimecross/charged/gold/proc/startTimer()
	START_PROCESSING(SSobj, src)

/obj/item/slimecross/charged/gold/process()
	visible_message(span_warning(LANG("obj.cd27c50266f0a5f6", list(src))))
	new /obj/effect/particle_effect/sparks(get_turf(src))
	playsound(get_turf(src), SFX_SPARKS, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	create_random_mob(get_turf(src), HOSTILE_SPAWN)
	spawned++
	if(spawned >= max_spawn)
		visible_message(span_warning(LANG("obj.1803b0528297fe8f", list(src))))
		qdel(src)

/obj/item/slimecross/charged/gold/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/slimecross/charged/oil
	colour = SLIME_TYPE_OIL
	effect_desc = "Creates an explosion after a few seconds."

/obj/item/slimecross/charged/oil/do_effect(mob/user)
	user.visible_message(span_danger(LANG("obj.78f622dc343352e3", list(src))))
	addtimer(CALLBACK(src, PROC_REF(boom)), 5 SECONDS)

/obj/item/slimecross/charged/oil/proc/boom()
	explosion(src, devastation_range = 2, heavy_impact_range = 3, light_impact_range = 4, explosion_cause = src) //Much smaller effect than normal oils, but devastatingly strong where it does hit.
	qdel(src)

/obj/item/slimecross/charged/black
	colour = SLIME_TYPE_BLACK
	effect_desc = "Randomizes the user's species."

/obj/item/slimecross/charged/black/do_effect(mob/user)
	var/mob/living/carbon/human/experiment_subject = user
	if(!istype(experiment_subject))
		balloon_alert(experiment_subject, LANG("obj.0590b0bdbfbc4ba6", null))
		return
	var/list/allowed_species = list()
	for(var/stype in subtypesof(/datum/species))
		var/datum/species/try_species = stype
		if(initial(try_species.changesource_flags) & SLIME_EXTRACT)
			allowed_species += stype

	var/datum/species/changed = pick(allowed_species)
	if(isnull(changed))
		visible_message(span_notice(LANG("obj.804be420d4b20da3", list(src))))
		return
	experiment_subject.set_species(changed, icon_update = TRUE)
	to_chat(experiment_subject, span_danger(LANG("obj.9cb4ffb5591821ba", null)))
	return ..()

/obj/item/slimecross/charged/lightpink
	colour = SLIME_TYPE_LIGHT_PINK
	effect_desc = "Produces a pacification potion, which works on monsters and humanoids."

/obj/item/slimecross/charged/lightpink/do_effect(mob/user)
	new /obj/item/slimepotion/peacepotion(get_turf(user))
	user.visible_message(span_notice(LANG("obj.e857e3d1436b3a27", list(src))))
	..()

/obj/item/slimecross/charged/adamantine
	colour = SLIME_TYPE_ADAMANTINE
	effect_desc = "Creates a completed golem shell."

/obj/item/slimecross/charged/adamantine/do_effect(mob/user)
	user.visible_message(span_notice(LANG("obj.1644af48e0f3f44a", list(src))))
	new /obj/effect/mob_spawn/ghost_role/human/golem/servant(get_turf(src), /datum/species/golem, user)
	..()

/obj/item/slimecross/charged/rainbow
	colour = SLIME_TYPE_RAINBOW
	effect_desc = "Produces three living slimes of random colors."

/obj/item/slimecross/charged/rainbow/do_effect(mob/user)
	user.visible_message(span_warning(LANG("obj.635c00fc7c2910b6", list(src))))
	for(var/i in 1 to 3)
		new /mob/living/basic/slime/random(get_turf(user))
	return ..()
