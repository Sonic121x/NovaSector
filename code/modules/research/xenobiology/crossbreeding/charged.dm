/*
Charged extracts:
	Have a unique, effect when filled with
	10u plasma and activated in-hand, related to their
	normal extract effect.
*/
/obj/item/slimecross/charged
	name = "充电提取物"
	desc = "它散发着强大的电能。"
	effect = "charged"
	icon_state = "charged"

/obj/item/slimecross/charged/Initialize(mapload)
	. = ..()
	create_reagents(10, INJECTABLE | DRAWABLE)

/obj/item/slimecross/charged/attack_self(mob/user)
	if(!reagents.has_reagent(/datum/reagent/toxin/plasma, 10))
		to_chat(user, span_warning("这个提取物需要充满等离子体才能激活！"))
		return
	reagents.remove_reagent(/datum/reagent/toxin/plasma, 10)
	to_chat(user, span_notice("你挤压提取物，它吸收了等离子体！"))
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
	user.visible_message(span_notice("[src]蒸馏成了一瓶药水！"))
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
	user.visible_message(span_notice("[src] 迸发出火花，并涌出再生溶液！"))
	..()

/obj/item/slimecross/charged/blue
	colour = SLIME_TYPE_BLUE
	effect_desc = "Creates a potion that neuters the mutation chance of a slime, which passes on to new generations."

/obj/item/slimecross/charged/blue/do_effect(mob/user)
	new /obj/item/slimepotion/slime/chargedstabilizer(get_turf(user))
	user.visible_message(span_notice("[src] 蒸馏成了一瓶药水！"))
	..()

/obj/item/slimecross/charged/metal
	colour = SLIME_TYPE_METAL
	effect_desc = "Produces a bunch of metal and plasteel."

/obj/item/slimecross/charged/metal/do_effect(mob/user)
	new /obj/item/stack/sheet/iron(get_turf(user), 25)
	new /obj/item/stack/sheet/plasteel(get_turf(user), 10)
	user.visible_message(span_notice("[src] 生长出大量金属！"))
	..()

/obj/item/slimecross/charged/yellow
	colour = SLIME_TYPE_YELLOW
	effect_desc = "Creates a hypercharged slime cell battery, which has high capacity but takes longer to recharge."

/obj/item/slimecross/charged/yellow/do_effect(mob/user)
	new /obj/item/stock_parts/power_store/cell/high/slime_hypercharged(get_turf(user))
	user.visible_message(span_notice("[src] 剧烈地迸发火花，并充满了电能！"))
	..()

/obj/item/slimecross/charged/darkpurple
	colour = SLIME_TYPE_DARK_PURPLE
	effect_desc = "Creates several sheets of plasma."

/obj/item/slimecross/charged/darkpurple/do_effect(mob/user)
	new /obj/item/stack/sheet/mineral/plasma(get_turf(user), 10)
	user.visible_message(span_notice("[src] 产生了大量等离子体！"))
	..()

/obj/item/slimecross/charged/darkblue
	colour = SLIME_TYPE_DARK_BLUE
	effect_desc = "Produces a pressure proofing potion."

/obj/item/slimecross/charged/darkblue/do_effect(mob/user)
	new /obj/item/slimepotion/spaceproof(get_turf(user))
	user.visible_message(span_notice("[src] 蒸馏成了一瓶药水！"))
	..()

/obj/item/slimecross/charged/silver
	colour = SLIME_TYPE_SILVER
	effect_desc = "Creates a slime cake and some drinks."

/obj/item/slimecross/charged/silver/do_effect(mob/user)
	new /obj/item/food/cake/slimecake(get_turf(user))
	for(var/i in 1 to 10)
		var/drink_type = get_random_drink()
		new drink_type(get_turf(user))
	user.visible_message(span_notice("[src] 变出了足够开派对的蛋糕和饮料！"))
	..()

/obj/item/slimecross/charged/bluespace
	colour = SLIME_TYPE_BLUESPACE
	effect_desc = "Makes a bluespace polycrystal."

/obj/item/slimecross/charged/bluespace/do_effect(mob/user)
	new /obj/item/stack/sheet/bluespace_crystal(get_turf(user), 10)
	user.visible_message(span_notice("[src] 产生了数张多晶板材！"))
	..()

/obj/item/slimecross/charged/sepia
	colour = SLIME_TYPE_SEPIA
	effect_desc = "Creates a camera obscura."

/obj/item/slimecross/charged/sepia/do_effect(mob/user)
	new /obj/item/camera/spooky(get_turf(user))
	user.visible_message(span_notice("[src] 以一种奇异、空灵的方式闪烁，并变出了一台相机！"))
	..()

/obj/item/slimecross/charged/cerulean
	colour = SLIME_TYPE_CERULEAN
	effect_desc = "Creates an extract enhancer, giving whatever it's used on five more uses."

/obj/item/slimecross/charged/cerulean/do_effect(mob/user)
	new /obj/item/slimepotion/enhancer/max(get_turf(user))
	user.visible_message(span_notice("[src] 蒸馏成了一瓶药水！"))
	..()

/obj/item/slimecross/charged/pyrite
	colour = SLIME_TYPE_PYRITE
	effect_desc = "Creates bananium. Oh no."

/obj/item/slimecross/charged/pyrite/do_effect(mob/user)
	new /obj/item/stack/sheet/mineral/bananium(get_turf(user), 10)
	user.visible_message(span_warning("[src] 凝固了，并散发出可怕的香蕉臭味！"))
	..()

/obj/item/slimecross/charged/red
	colour = SLIME_TYPE_RED
	effect_desc = "Produces a lavaproofing potion"

/obj/item/slimecross/charged/red/do_effect(mob/user)
	new /obj/item/slimepotion/lavaproof(get_turf(user))
	user.visible_message(span_notice("[src] 蒸馏成了一瓶药水！"))
	..()

/obj/item/slimecross/charged/green
	colour = SLIME_TYPE_GREEN
	effect_desc = "Lets you choose what slime species you want to be."

/obj/item/slimecross/charged/green/do_effect(mob/user)
	var/mob/living/carbon/human/human_user = user
	if(!istype(human_user))
		to_chat(user, span_warning("你必须是人形生物才能使用这个！"))
		return
	var/list/choice_list = list()
	for(var/datum/species/species_type as anything in subtypesof(/datum/species/jelly))
		choice_list[initial(species_type.name)] = species_type
	var/racechoice = tgui_input_list(human_user, "选择你的史莱姆亚种", "史莱姆选择", sort_list(choice_list))
	if(isnull(racechoice))
		to_chat(user, span_notice("你决定暂时不变成史莱姆。"))
		return
	if(!user.can_perform_action(src))
		return
	human_user.set_species(choice_list[racechoice], icon_update=1)
	human_user.visible_message(span_warning("[human_user] 的形态突然转变，同时 [src] 溶解进了 [human_user.p_their()] 的皮肤！"))
	..()

/obj/item/slimecross/charged/pink
	colour = SLIME_TYPE_PINK
	effect_desc = "Produces a... lovepotion... no ERP."

/obj/item/slimecross/charged/pink/do_effect(mob/user)
	new /obj/item/slimepotion/lovepotion(get_turf(user))
	user.visible_message(span_notice("[src] 蒸馏成了一瓶药水！"))
	..()

/obj/item/slimecross/charged/gold
	colour = SLIME_TYPE_GOLD
	effect_desc = "Slowly spawns 10 hostile monsters."
	var/max_spawn = 10
	var/spawned = 0

/obj/item/slimecross/charged/gold/do_effect(mob/user)
	user.visible_message(span_warning("[src] 开始剧烈地震动！"))
	addtimer(CALLBACK(src, PROC_REF(startTimer)), 5 SECONDS)

/obj/item/slimecross/charged/gold/proc/startTimer()
	START_PROCESSING(SSobj, src)

/obj/item/slimecross/charged/gold/process()
	visible_message(span_warning("[src] 迸发出一道火花，并创造出了一个活生生的生物！"))
	new /obj/effect/particle_effect/sparks(get_turf(src))
	playsound(get_turf(src), SFX_SPARKS, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	create_random_mob(get_turf(src), HOSTILE_SPAWN)
	spawned++
	if(spawned >= max_spawn)
		visible_message(span_warning("[src] 坍缩成了一滩粘液。"))
		qdel(src)

/obj/item/slimecross/charged/gold/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/slimecross/charged/oil
	colour = SLIME_TYPE_OIL
	effect_desc = "Creates an explosion after a few seconds."

/obj/item/slimecross/charged/oil/do_effect(mob/user)
	user.visible_message(span_danger("[src] 开始以迅速增强的力量震动！"))
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
		balloon_alert(experiment_subject, "生物结构不兼容！")
		return
	var/list/allowed_species = list()
	for(var/stype in subtypesof(/datum/species))
		var/datum/species/try_species = stype
		if(initial(try_species.changesource_flags) & SLIME_EXTRACT)
			allowed_species += stype

	var/datum/species/changed = pick(allowed_species)
	if(isnull(changed))
		visible_message(span_notice("[src] 发出无用的嘶嘶声。"))
		return
	experiment_subject.set_species(changed, icon_update = TRUE)
	to_chat(experiment_subject, span_danger("你感觉非常不同！"))
	return ..()

/obj/item/slimecross/charged/lightpink
	colour = SLIME_TYPE_LIGHT_PINK
	effect_desc = "Produces a pacification potion, which works on monsters and humanoids."

/obj/item/slimecross/charged/lightpink/do_effect(mob/user)
	new /obj/item/slimepotion/peacepotion(get_turf(user))
	user.visible_message(span_notice("[src] 蒸馏成了一瓶药水！"))
	..()

/obj/item/slimecross/charged/adamantine
	colour = SLIME_TYPE_ADAMANTINE
	effect_desc = "Creates a completed golem shell."

/obj/item/slimecross/charged/adamantine/do_effect(mob/user)
	user.visible_message(span_notice("[src] 产生了一个完全成型的魔像外壳！"))
	new /obj/effect/mob_spawn/ghost_role/human/golem/servant(get_turf(src), /datum/species/golem, user)
	..()

/obj/item/slimecross/charged/rainbow
	colour = SLIME_TYPE_RAINBOW
	effect_desc = "Produces three living slimes of random colors."

/obj/item/slimecross/charged/rainbow/do_effect(mob/user)
	user.visible_message(span_warning("[src] 膨胀并分裂成三个新的史莱姆！"))
	for(var/i in 1 to 3)
		new /mob/living/basic/slime/random(get_turf(user))
	return ..()
