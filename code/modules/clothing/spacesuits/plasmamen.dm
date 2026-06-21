//Suits for the pink and grey skeletons! //EVA version no longer used in favor of the Jumpsuit version

/obj/item/clothing/suit/space/eva/plasmaman
	name = "等离子环境EVA服"
	desc = "一套特殊的等离子防护服，旨在适用于太空环境，并且可穿在其他服装之上。类似于较小的同类产品，它可以在紧急情况下给穿戴者自动灭火，并具有两倍的电池电量。"
	allowed = list(/obj/item/gun, /obj/item/ammo_casing, /obj/item/ammo_casing, /obj/item/melee/baton, /obj/item/melee/energy/sword, /obj/item/restraints/handcuffs, /obj/item/tank)
	armor_type = /datum/armor/eva_plasmaman
	resistance_flags = FIRE_PROOF
	icon_state = "plasmaman_suit"
	inhand_icon_state = "plasmaman_suit"
	fishing_modifier = 0
	COOLDOWN_DECLARE(extinguish_timer)
	var/extinguish_cooldown = 100
	var/extinguishes_left = 10

/datum/armor/eva_plasmaman
	bio = 100
	fire = 100
	acid = 75

/obj/item/clothing/suit/space/eva/plasmaman/examine(mob/user)
	. = ..()
	. += span_notice("There [extinguishes_left == 1 ? "is" : "are"] [extinguishes_left] extinguisher charge\s left in this suit.")

/obj/item/clothing/suit/space/eva/plasmaman/equipped(mob/living/user, slot)
	. = ..()
	if (slot & ITEM_SLOT_OCLOTHING)
		RegisterSignals(user, list(COMSIG_MOB_EQUIPPED_ITEM, COMSIG_LIVING_IGNITED, SIGNAL_ADDTRAIT(TRAIT_HEAD_ATMOS_SEALED)), PROC_REF(check_fire_state))
		check_fire_state()

/obj/item/clothing/suit/space/eva/plasmaman/dropped(mob/living/user)
	. = ..()
	UnregisterSignal(user, list(COMSIG_MOB_EQUIPPED_ITEM, COMSIG_LIVING_IGNITED, SIGNAL_ADDTRAIT(TRAIT_HEAD_ATMOS_SEALED)))

/obj/item/clothing/suit/space/eva/plasmaman/proc/check_fire_state(datum/source)
	SIGNAL_HANDLER

	if (!ishuman(loc))
		return

	// This is weird but basically we're calling this proc once the cooldown ends in case our wearer gets set on fire again during said cooldown
	// This is why we're ignoring source and instead checking by loc
	var/mob/living/carbon/human/owner = loc
	if (!owner.on_fire || !owner.is_atmos_sealed(additional_flags = PLASMAMAN_PREVENT_IGNITION, check_hands = TRUE))
		return

	if (!extinguishes_left || !COOLDOWN_FINISHED(src, extinguish_timer))
		return

	extinguishes_left -= 1
	COOLDOWN_START(src, extinguish_timer, extinguish_cooldown)
	// Check if our (possibly other) wearer is on fire once the cooldown ends
	addtimer(CALLBACK(src, PROC_REF(check_fire_state)), extinguish_cooldown)
	owner.visible_message(span_warning("[owner]'s suit automatically extinguishes [owner.p_them()]!"), span_warning("Your suit automatically extinguishes you."))
	owner.extinguish_mob()
	new /obj/effect/particle_effect/water(get_turf(owner))

/obj/item/clothing/suit/space/eva/plasmaman/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if (!istype(tool, /obj/item/extinguisher_refill))
		return

	if (extinguishes_left == initial(extinguishes_left))
		to_chat(user, span_notice("The inbuilt extinguisher is full."))
		return ITEM_INTERACT_BLOCKING

	extinguishes_left = initial(extinguishes_left)
	to_chat(user, span_notice("You refill the suit's built-in extinguisher, using up the cartridge."))
	check_fire_state()
	qdel(tool)
	return ITEM_INTERACT_SUCCESS

//I just want the light feature of helmets
/obj/item/clothing/head/helmet/space/plasmaman
	name = "等离子环境头盔"
	desc = "一种特殊的防护头盔，可以让等离子体生命在含氧环境下安全生存。它适用于太空环境，并可与其他舱外活动装备配合使用。"
	icon = 'icons/obj/clothing/head/plasmaman_hats.dmi'
	worn_icon = 'icons/mob/clothing/head/plasmaman_head.dmi'
	clothing_flags = parent_type::clothing_flags | PLASMAMAN_PREVENT_IGNITION
	icon_state = "plasmaman-helm"
	inhand_icon_state = "plasmaman-helm"
	strip_delay = 8 SECONDS
	flash_protect = FLASH_PROTECTION_WELDER
	tint = 2
	armor_type = /datum/armor/space_plasmaman
	resistance_flags = FIRE_PROOF
	light_system = OVERLAY_LIGHT_DIRECTIONAL
	light_range = 4
	light_power = 0.8
	light_color = "#ffcc99"
	light_on = FALSE
	fishing_modifier = 0
	actions_types = list(/datum/action/item_action/toggle_helmet_light, /datum/action/item_action/toggle_welding_screen)
	visor_flags = NONE
	visor_flags_inv = HIDEEYES|HIDEFACE|HIDESNOUT
	visor_flags_cover = NONE
	visor_dirt = null
	var/helmet_on = FALSE
	var/smile = FALSE
	var/smile_color = COLOR_RED
	var/visor_icon = "envisor"
	var/smile_state = "envirohelm_smile"

/datum/armor/space_plasmaman
	bio = 100
	fire = 100
	acid = 75

/obj/item/clothing/head/helmet/space/plasmaman/Initialize(mapload)
	. = ..()
	visor_toggling()
	update_appearance()
	register_context()

/obj/item/clothing/head/helmet/space/plasmaman/add_stabilizer(loose_hat = FALSE)
	..()

/obj/item/clothing/head/helmet/space/plasmaman/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	context[SCREENTIP_CONTEXT_ALT_LMB] = "Toggle Welding Screen"
	if(istype(held_item, /obj/item/toy/crayon))
		context[SCREENTIP_CONTEXT_LMB] = "Vandalize"

	return CONTEXTUAL_SCREENTIP_SET

/obj/item/clothing/head/helmet/space/plasmaman/click_alt(mob/user)
	adjust_visor(user)
	return CLICK_ACTION_SUCCESS

/obj/item/clothing/head/helmet/space/plasmaman/ui_action_click(mob/user, action)
	if(istype(action, /datum/action/item_action/toggle_welding_screen))
		adjust_visor(user)
		return

	return ..()

/obj/item/clothing/head/helmet/space/plasmaman/adjust_visor(mob/living/user)
	. = ..()
	if(!.)
		return
	if(helmet_on)
		to_chat(user, span_notice("Your helmet's torch can't pass through your welding visor!"))
		set_light_on(FALSE)
		helmet_on = FALSE
	update_appearance()

/obj/item/clothing/head/helmet/space/plasmaman/update_icon_state()
	. = ..()
	icon_state = "[initial(icon_state)][helmet_on ? "-light":""]"
	inhand_icon_state = icon_state

/obj/item/clothing/head/helmet/space/plasmaman/update_overlays()
	. = ..()
	if(!up)
		. += visor_icon
	if(smile)
		var/mutable_appearance/smiley = mutable_appearance(icon, smile_state)
		smiley.color = smile_color
		. += smiley

/obj/item/clothing/head/helmet/space/plasmaman/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/toy/crayon))
		return NONE

	if(smile)
		to_chat(user, span_warning("Seems like someone already drew something on [src]'s visor!"))
		return ITEM_INTERACT_BLOCKING

	var/obj/item/toy/crayon/crayon = tool
	to_chat(user, span_notice("You start drawing a smiley face on [src]'s visor..."))
	if(!do_after(user, 2.5 SECONDS, target = src))
		return ITEM_INTERACT_BLOCKING

	smile = TRUE
	smile_color = crayon.paint_color
	to_chat(user, "You draw a smiley on [src] visor.")
	update_appearance()
	return ITEM_INTERACT_SUCCESS

///By the by, helmets have the update_icon_updates_onmob element, so we don't have to call mob.update_worn_head()
/obj/item/clothing/head/helmet/space/plasmaman/worn_overlays(mutable_appearance/standing, isinhands)
	. = ..()
	if(!isinhands && !up)
		. += mutable_appearance('icons/mob/clothing/head/plasmaman_head.dmi', visor_icon)

/obj/item/clothing/head/helmet/space/plasmaman/separate_worn_overlays(mutable_appearance/standing, mutable_appearance/draw_target, isinhands = FALSE, icon_file, mutant_styles) // NOVA EDIT CHANGE - ORIGINAL: separate_worn_overlays(mutable_appearance/standing, mutable_appearance/draw_target, isinhands = FALSE, icon_file)
	. = ..()
	if(!isinhands && smile)
		var/mutable_appearance/smiley = mutable_appearance('icons/mob/clothing/head/plasmaman_head.dmi', smile_state)
		smiley.color = smile_color
		. += smiley

/obj/item/clothing/head/helmet/space/plasmaman/wash(clean_types)
	. = NONE
	if(smile && (clean_types & CLEAN_TYPE_HARD_DECAL))
		smile = FALSE
		update_appearance(UPDATE_OVERLAYS)
		. |= COMPONENT_CLEANED|COMPONENT_CLEANED_GAIN_XP
	. |= ..()

/obj/item/clothing/head/helmet/space/plasmaman/attack_self(mob/user)
	helmet_on = !helmet_on
	update_appearance()

	if(helmet_on)
		if(!up)
			to_chat(user, span_notice("Your helmet's torch can't pass through your welding visor!"))
			set_light_on(FALSE)
		else
			set_light_on(TRUE)
	else
		set_light_on(FALSE)

	update_item_action_buttons()

/obj/item/clothing/head/helmet/space/plasmaman/on_saboteur(datum/source, disrupt_duration)
	. = ..()
	if(!helmet_on)
		return FALSE
	helmet_on = FALSE
	update_appearance()
	return TRUE

/obj/item/clothing/head/helmet/space/plasmaman/security
	name = "安保等离子环境头盔"
	desc = "为安全人员设计的等离子防护头盔，保护他们不被活活烧死，以及其他暴徒的侵害。"
	icon_state = "security_envirohelm"
	inhand_icon_state = null
	armor_type = /datum/armor/head_helmet/plasmaman

/datum/armor/head_helmet/plasmaman
	bio = 100
	fire = 100
	acid = 75

/obj/item/clothing/head/helmet/space/plasmaman/security/detective
	name = "detective's plasma envirosuit helmet"
	desc = "A special containment helmet designed for detectives, protecting them from burning alive, alongside other undesirables."
	icon_state = "white_envirohelm"
	inhand_icon_state = null
	armor_type = /datum/armor/fedora_det_hat/plasmaman

/datum/armor/fedora_det_hat/plasmaman
	bio = 100
	fire = 100
	acid = 75

/obj/item/clothing/head/helmet/space/plasmaman/security/warden
	name = "典狱长等离子环境头盔"
	desc = "一个为典狱长而设计的等离子防护头盔，上面添有一对白色条纹以方便和其他安保人员区分开来。"
	icon_state = "warden_envirohelm"
	inhand_icon_state = null
	armor_type = /datum/armor/hats_warden/plasmaman

/datum/armor/hats_warden/plasmaman
	bio = 100
	fire = 100
	acid = 75

/obj/item/clothing/head/helmet/space/plasmaman/security/head_of_security
	name = "安保部长的等离子环境头盔"
	desc = "一个为安保部长而设计的等离子防护头盔。上面添有一对金色条纹以方便和其他安保人员区分开来。"
	icon_state = "hos_envirohelm"
	inhand_icon_state = null
	armor_type = /datum/armor/hats_hos/plasmaman

/datum/armor/hats_hos/plasmaman
	bio = 100
	fire = 100
	acid = 75

/obj/item/clothing/head/helmet/space/plasmaman/prisoner
	name = "囚犯的等离子环境头盔"
	desc = "一个为囚犯而设计的等离子防护头盔。"
	icon_state = "prisoner_envirohelm"
	inhand_icon_state = null

/obj/item/clothing/head/helmet/space/plasmaman/medical
	name = "医生的等离子环境头盔"
	desc = "一款为等离子人医生设计的头盔，其上标有两条纵贯的条纹以表明其所属部门。"
	icon_state = "doctor_envirohelm"
	inhand_icon_state = null

/obj/item/clothing/head/helmet/space/plasmaman/coroner
	name = "coroners's plasma envirosuit helmet"
	desc = "An envirohelmet designed for plasmaman coroners, having more edge than the usual model."
	icon_state = "coroner_envirohelm"
	inhand_icon_state = null

/obj/item/clothing/head/helmet/space/plasmaman/paramedic
	name = "急救员等离子环境头盔"
	desc = "一个为等离子人急救员而设计的头盔，上面的蓝色条纹比起医生型的要更深。"
	icon_state = "paramedic_envirohelm"
	inhand_icon_state = null

/obj/item/clothing/head/helmet/space/plasmaman/viro
	name = "病毒学家等离子环境头盔"
	desc = "这是空间站里最安全的人戴的头盔，他们对自己制造的灾难完全免疫。"
	icon_state = "virologist_envirohelm"
	inhand_icon_state = null

/obj/item/clothing/head/helmet/space/plasmaman/chemist
	name = "化学家等离子环境头盔"
	desc = "一个为等离子人化学家而设计的头盔，两条黄色条纹沿着头盔表面向下延伸。"
	icon_state = "chemist_envirohelm"
	inhand_icon_state = null

/obj/item/clothing/head/helmet/space/plasmaman/chief_medical_officer
	name = "首席医疗官的等离子环境头盔"
	desc = "一个为医疗部长而设计的特殊防护头盔。上面添有一对金色条纹以方便和其他医疗人员区分开来。"
	icon_state = "cmo_envirohelm"
	inhand_icon_state = null

/obj/item/clothing/head/helmet/space/plasmaman/science
	name = "科研等离子环境头盔"
	desc = "一个为等离子人科学家而设计的头盔。"
	icon_state = "scientist_envirohelm"
	inhand_icon_state = null

/obj/item/clothing/head/helmet/space/plasmaman/robotics
	name = "机械学家等离子环境头盔"
	desc = "一个为等离子人机械学家而设计的头盔。"
	icon_state = "roboticist_envirohelm"
	inhand_icon_state = null

/obj/item/clothing/head/helmet/space/plasmaman/genetics
	name = "基因学家的等离子环境头盔"
	desc = "一个为等离子人基因学家而设计的头盔。"
	icon_state = "geneticist_envirohelm"
	inhand_icon_state = null

/obj/item/clothing/head/helmet/space/plasmaman/research_director
	name = "科研部长的等离子环境头盔"
	desc = "一个为科研部长而设计的特殊防护头盔。上面采用了浅棕色设计以方便和其他安保人员区分开来。"
	icon_state = "rd_envirohelm"
	inhand_icon_state = null

/obj/item/clothing/head/helmet/space/plasmaman/engineering
	name = "工程等离子环境头盔"
	desc = "一个为等离子人工程师而设计的太空头盔，常见的紫色条纹被代表工程部的橙色取而代之。"
	icon_state = "engineer_envirohelm"
	inhand_icon_state = null
	armor_type = /datum/armor/space_plasmaman/engineering_atmos

/datum/armor/space_plasmaman/engineering_atmos
	acid = 95

/obj/item/clothing/head/helmet/space/plasmaman/atmospherics
	name = "大气等离子环境头盔"
	desc = "A space-worthy helmet specially designed for atmos technician plasmamen, the usual purple stripes being replaced by atmos' blue. Has improved thermal shielding."
	icon_state = "atmos_envirohelm"
	inhand_icon_state = null
	armor_type = /datum/armor/space_plasmaman/engineering_atmos
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT // Same protection as the Atmospherics Hardhat

/obj/item/clothing/head/helmet/space/plasmaman/chief_engineer
	name = "工程部长的等离子环境服头盔"
	desc = "一个为工程部长而设计的特殊防护头盔。常见的紫色条纹被绿色的部长颜色取而代之。增强了热屏蔽功能。"
	icon_state = "ce_envirohelm"
	inhand_icon_state = null
	armor_type = /datum/armor/space_plasmaman/engineering_atmos
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT // Same protection as the Atmospherics Hardhat

/obj/item/clothing/head/helmet/space/plasmaman/cargo
	name = "货舱等离子环境头盔"
	desc = "为货运技术员和军需官设计的等离子环境头盔。"
	icon_state = "cargo_envirohelm"
	inhand_icon_state = null

/obj/item/clothing/head/helmet/space/plasmaman/mining
	name = "采矿等离子环境服头盔"
	desc = "一顶卡其色头盔，发给在拉瓦兰上作业的等离子矿工。"
	icon_state = "explorer_envirohelm"
	inhand_icon_state = null
	visor_icon = "explorer_envisor"

/obj/item/clothing/head/helmet/space/plasmaman/chaplain
	name = "牧师的等离子环境服头盔"
	desc = "这顶等离子防护头盔专门设计给最虔诚的等离子人。"
	icon_state = "chap_envirohelm"
	inhand_icon_state = null

/obj/item/clothing/head/helmet/space/plasmaman/white
	name = "白色等离子环境服头盔"
	desc = "一顶普通的白色等离子防护头盔。"
	icon_state = "white_envirohelm"
	inhand_icon_state = null

/obj/item/clothing/head/helmet/space/plasmaman/curator
	name = "馆长的等离子环境头盔"
	desc = "A slight modification on a traditional voidsuit helmet, this helmet was Nanotrasen's first solution to the *logistical problems* that come with employing plasmamen. Despite their limitations, these helmets still see use by historians and old-school plasmamen alike."
	icon_state = "prototype_envirohelm"
	inhand_icon_state = "void_helmet"
	actions_types = list(/datum/action/item_action/toggle_welding_screen)
	smile_state = "prototype_smile"
	visor_icon = "prototype_envisor"

/obj/item/clothing/head/helmet/space/plasmaman/botany
	name = "植物学等离子环境头盔"
	desc = "一款绿蓝相间的环保头盔，表明佩戴者是一名植物学家。虽然并非专门为此设计，但能防护轻微的植物相关伤害。"
	icon_state = "botany_envirohelm"
	inhand_icon_state = null

/obj/item/clothing/head/helmet/space/plasmaman/janitor
	name = "清洁工等离子环境头盔"
	desc = "一个灰色的头盔，上面有两条紫色的条纹，这表明佩戴者是清洁工。"
	icon_state = "janitor_envirohelm"
	inhand_icon_state = null

/obj/item/clothing/head/helmet/space/plasmaman/mime
	name = "默剧等离子环境头盔"
	desc = "妆都画好了，不脱落真是奇迹。不过颜色不是很鲜艳。"
	icon_state = "mime_envirohelm"
	inhand_icon_state = null
	visor_icon = "mime_envisor"

/obj/item/clothing/head/helmet/space/plasmaman/clown
	name = "小丑等离子环境头盔"
	desc = "妆都画好了，不脱落真是奇迹。<i>'HONK!'</i>"
	icon_state = "clown_envirohelm"
	inhand_icon_state = null
	visor_icon = "clown_envisor"
	smile_state = "clown_smile"

/obj/item/clothing/head/helmet/space/plasmaman/clown/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_CLOWN, CELL_VIRUS_TABLE_GENERIC, rand(2,3), 0)

/obj/item/clothing/head/helmet/space/plasmaman/head_of_personnel
	name = "人事部长的等离子环境头盔"
	desc = "为人事主管设计的特殊安全帽。令人尴尬的是，除了红色条纹外，它看起来太像舰长的设计了。"
	icon_state = "hop_envirohelm"
	inhand_icon_state = null
	armor_type = /datum/armor/hats_hopcap/plasmaman

/datum/armor/hats_hopcap/plasmaman
	bio = 100
	fire = 100
	acid = 75

/obj/item/clothing/head/helmet/space/plasmaman/captain
	name = "舰长的等离子环境头盔"
	desc = "为船长设计的特殊安全帽。令人尴尬的是，除了金色的条纹，它看起来太像人事主管的设计了。我是说，拜托。金色条纹可以弥补任何东西。"
	icon_state = "captain_envirohelm"
	inhand_icon_state = null
	armor_type = /datum/armor/hats_caphat/plasmaman

/datum/armor/hats_caphat/plasmaman
	bio = 100
	fire = 100
	acid = 75

/obj/item/clothing/head/helmet/space/plasmaman/centcom_commander
	name = "中央指挥司令等离子环境头盔"
	desc = "一种专为中央指挥部高层人员设计的特殊防护头盔。这类头盔数量稀少，因为指挥部通常不会因等离子人的复杂性而将其聘用至高层职位。"
	icon_state = "commander_envirohelm"
	inhand_icon_state = null
	armor_type = /datum/armor/hats_centhat/plasmaman

/datum/armor/hats_centhat/plasmaman
	bio = 100
	fire = 100
	acid = 75

/obj/item/clothing/head/helmet/space/plasmaman/centcom_official
	name = "中央指挥官员等离子环境头盔"
	desc = "一种为中央指挥部人员设计的特殊防护头盔。他们可真是钟爱自己的绿色。"
	icon_state = "official_envirohelm"
	inhand_icon_state = null

/obj/item/clothing/head/helmet/space/plasmaman/centcom_intern
	name = "中央指挥实习生等离子环境头盔"
	desc = "一种为中央指挥部人员设计的特殊防护头盔。你懂的，这样就算咖啡洒出来也不会要了那可怜家伙的命。"
	icon_state = "intern_envirohelm"
	inhand_icon_state = null

/obj/item/clothing/head/helmet/space/plasmaman/syndie
	name = "tacticool envirosuit helmet"
	desc = "There's no doubt about it, this helmet puts you above ALL of the other plasmamen. If you see another plasmaman wearing a helmet like this, it's either because they're a fellow badass, \
		or they've murdered one of your fellow badasses and have taken it from them as a trophy. Either way, anyone wearing this deserves at least a cursory nod of respect."
	icon_state = "syndie_envirohelm"
	inhand_icon_state = null

/obj/item/clothing/head/helmet/space/plasmaman/bitrunner
	name = "bitrunner's plasma envirosuit helmet"
	desc = "An envirohelmet with extended blue light filters for bitrunning plasmamen."
	icon_state = "bitrunner_envirohelm"
