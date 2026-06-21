/obj/item/reagent_containers/syringe
	name = "注射器"
	desc = "可容纳15个单位的注射器。"
	icon = 'icons/obj/medical/syringe.dmi'
	base_icon_state = "syringe"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	icon_state = "syringe_0"
	inhand_icon_state = "syringe_0"
	worn_icon_state = "pen"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5, 10, 15)
	volume = 15
	custom_materials = list(/datum/material/iron=SMALL_MATERIAL_AMOUNT, /datum/material/glass=SMALL_MATERIAL_AMOUNT*0.2)
	initial_reagent_flags = TRANSPARENT
	custom_price = PAYCHECK_CREW * 0.5
	sharpness = SHARP_POINTY
	embed_type = /datum/embedding/syringe
	/// Flags used by the injection
	var/inject_flags = NONE
	/// Icon and states used when inserted into toy darts
	var/dart_insert_icon = 'icons/obj/weapons/guns/toy.dmi'
	var/dart_insert_casing_icon_state = "overlay_syringe"
	var/dart_insert_projectile_icon_state = "overlay_syringe_proj"

/obj/item/reagent_containers/syringe/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	AddComponent(/datum/component/dart_insert, \
		dart_insert_icon, \
		dart_insert_casing_icon_state, \
		dart_insert_icon, \
		dart_insert_projectile_icon_state, \
		CALLBACK(src, PROC_REF(get_dart_var_modifiers))\
	)
	RegisterSignal(src, COMSIG_ITEM_IN_UNWRAPPED_TRAITOR_MAIL, PROC_REF(on_mail_unwrap))

/obj/item/reagent_containers/syringe/proc/try_syringe(atom/target, mob/user)
	if(!target.reagents)
		return FALSE

	if(isliving(target))
		var/mob/living/living_target = target
		if(!living_target.try_inject(user, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE|inject_flags))
			return FALSE

	return TRUE

/obj/item/reagent_containers/syringe/interact_with_atom(atom/target, mob/living/user, list/modifiers)
	if(!target.reagents)
		return NONE
	if(!try_syringe(target, user))
		return ITEM_INTERACT_BLOCKING

	SEND_SIGNAL(target, COMSIG_LIVING_TRY_SYRINGE_INJECT, user)

	var/contained = reagents.get_reagent_log_string()
	log_combat(user, target, "attempted to inject", src, addition="which had [contained]")

	if(!reagents.total_volume)
		to_chat(user, span_warning("[src] 是空的！右键点击抽取。"))
		return ITEM_INTERACT_BLOCKING

	if(!isliving(target) && !target.is_injectable(user))
		to_chat(user, span_warning("你不能直接填充[target]！"))
		return ITEM_INTERACT_BLOCKING

	if(target.reagents.holder_full())
		to_chat(user, span_notice("[target] 已满。"))
		return ITEM_INTERACT_BLOCKING

	if(isliving(target))
		var/mob/living/living_target = target
		if(living_target != user)
			living_target.visible_message(
				span_danger("[user] 正试图给 [living_target] 注射！"),
				span_userdanger("[user]正试图给你注射！"),
			)
			if(!do_after(user, CHEM_INTERACT_DELAY(3 SECONDS, user), living_target, extra_checks = CALLBACK(src, PROC_REF(try_syringe), living_target, user)))
				return ITEM_INTERACT_BLOCKING
			if(!reagents.total_volume)
				return ITEM_INTERACT_BLOCKING
			if(living_target.reagents.holder_full())
				return ITEM_INTERACT_BLOCKING
			living_target.visible_message(
				span_danger("[user]用注射器给[living_target]注射了！"),
				span_userdanger("[user]用注射器给你注射了！"),
			)

		if(living_target == user)
			living_target.log_message("injected themselves ([contained]) with [name]", LOG_ATTACK, color="orange")
		else
			log_combat(user, living_target, "injected", src, addition="which had [contained]")

	if(reagents.trans_to(target, amount_per_transfer_from_this, transferred_by = user, methods = INJECT))
		to_chat(user, span_notice("你注射了[amount_per_transfer_from_this]单位溶液。注射器现在含有[reagents.total_volume]单位。"))
		target.update_appearance()
		return ITEM_INTERACT_SUCCESS

	return ITEM_INTERACT_BLOCKING

/obj/item/reagent_containers/syringe/interact_with_atom_secondary(atom/target, mob/living/user, list/modifiers)
	if (!target.reagents)
		return NONE
	if (!try_syringe(target, user))
		return ITEM_INTERACT_BLOCKING

	SEND_SIGNAL(target, COMSIG_LIVING_TRY_SYRINGE_WITHDRAW, user)

	if(reagents.holder_full())
		to_chat(user, span_notice("[src]已满。"))
		return ITEM_INTERACT_BLOCKING

	if(isliving(target))
		var/mob/living/living_target = target
		var/drawn_amount = reagents.maximum_volume - reagents.total_volume
		if(target != user)
			target.visible_message(
				span_danger("[user]正试图从[target]身上抽取血样！"),
				span_userdanger("[user]正试图从你身上抽取血样！"),
			)
			if(!do_after(user, CHEM_INTERACT_DELAY(3 SECONDS, user), target, extra_checks = CALLBACK(src, PROC_REF(try_syringe), living_target, user)))
				return ITEM_INTERACT_BLOCKING
			if(reagents.holder_full())
				return ITEM_INTERACT_BLOCKING
		if(living_target.transfer_blood_to(src, drawn_amount))
			user.visible_message(span_notice("[user]从[living_target]身上抽取了血样。"))
		else
			to_chat(user, span_warning("你无法从[living_target]身上抽取任何血液！"))
		return ITEM_INTERACT_SUCCESS

	if(!target.reagents.total_volume)
		to_chat(user, span_warning("[target]是空的！"))
		return ITEM_INTERACT_BLOCKING

	if(!target.is_drawable(user))
		to_chat(user, span_warning("你不能直接从[target]中移除试剂！"))
		return ITEM_INTERACT_BLOCKING

	var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this, transferred_by = user) // transfer from, transfer to - who cares?
	if(trans)
		to_chat(user, span_notice("你向[src]中注入了[trans]单位溶液。它现在含有[reagents.total_volume]单位。"))
	target.update_appearance()
	return ITEM_INTERACT_SUCCESS

/*
 * On accidental consumption, inject the eater with 2/3rd of the syringe and reveal it
 */
/obj/item/reagent_containers/syringe/on_accidental_consumption(mob/living/carbon/victim, mob/living/carbon/user, obj/item/source_item,  discover_after = TRUE)
	if(source_item)
		to_chat(victim, span_boldwarning("There's \a [src] in [source_item]!!"))
	else
		to_chat(victim, span_boldwarning("[src]注射了你！"))

	victim.apply_damage(5, BRUTE, BODY_ZONE_HEAD)
	reagents?.trans_to(victim, round(reagents.total_volume*(2/3)), transferred_by = user, methods = INJECT)

	return discover_after

/obj/item/reagent_containers/syringe/update_icon_state()
	var/rounded_vol = get_rounded_vol()
	icon_state = inhand_icon_state = "[base_icon_state]_[rounded_vol]"
	return ..()

/obj/item/reagent_containers/syringe/update_overlays()
	. = ..()
	var/list/reagent_overlays = update_reagent_overlay()
	if(reagent_overlays)
		. += reagent_overlays

/// Returns a list of overlays to add that relate to the reagents inside the syringe
/obj/item/reagent_containers/syringe/proc/update_reagent_overlay()
	if(reagents?.total_volume)
		var/mutable_appearance/filling_overlay = mutable_appearance('icons/obj/medical/reagent_fillings.dmi', "syringe[get_rounded_vol()]")
		filling_overlay.color = mix_color_from_reagents(reagents.reagent_list)
		. += filling_overlay

///Used by update_appearance() and update_overlays()
/obj/item/reagent_containers/syringe/proc/get_rounded_vol()
	if(!reagents?.total_volume)
		return 0
	return clamp(round((reagents.total_volume / volume * 15), 5), 1, 15)

/obj/item/reagent_containers/syringe/proc/get_dart_var_modifiers(obj/projectile/projectile)
	var/datum/embedding/embed_data = get_embed().create_copy()
	embed_data.rip_time += projectile.get_embed()?.rip_time
	return list(
		"damage" = max(6, volume / 5), // Scales with size?
		"speed" = max(0, throw_speed - 3),
		"embedding" = embed_data,
		"armour_penetration" = armour_penetration,
		"wound_bonus" = wound_bonus,
		"exposed_wound_bonus" = exposed_wound_bonus,
		"demolition_mod" = demolition_mod,
	)

/obj/item/reagent_containers/syringe/proc/on_mail_unwrap(atom/source, mob/living/user, obj/item/mail/traitor/letter)
	SIGNAL_HANDLER
	if(!reagents.total_volume || !user.reagents || !user.try_inject(user, user.get_active_hand()))
		return
	to_chat(user, span_danger("As you open [letter], you prick yourself on a syringe inside!"))
	reagents.trans_to(user, min(reagents.total_volume, 5))
	forceMove(user.loc)
	return COMPONENT_TRAITOR_MAIL_HANDLED

/datum/embedding/syringe
	embed_chance = 85
	fall_chance = 2
	jostle_chance = 2
	pain_stam_pct = 0.75
	pain_mult = 3
	jostle_pain_mult = 3
	rip_time = 0.5 SECONDS
	/// How much reagents are transferred per second
	var/transfer_per_second = 1.5

/datum/embedding/syringe/process_effect(seconds_per_tick)
	var/obj/item/reagent_containers/syringe = parent
	if (!istype(syringe))
		syringe = locate() in parent
		if (!istype(syringe) && isammocasing(parent))
			var/obj/item/ammo_casing/casing = parent
			syringe = locate() in casing.loaded_projectile
		if (!istype(syringe))
			return

	if (!IS_ORGANIC_LIMB(owner_limb))
		return

	if (!owner.reagents || !syringe.reagents.total_volume)
		return

	// Only show message at a small chance, otherwise this'll get spammy
	syringe.reagents.trans_to(owner, transfer_per_second * seconds_per_tick, methods = INJECT, show_message = SPT_PROB(15, seconds_per_tick))

// For syringe guns, syringe itself becomes the shrapnel
/datum/embedding/syringe/setup_shrapnel(obj/projectile/source, mob/living/carbon/victim)
	if (!istype(source, /obj/projectile/bullet/dart/syringe))
		return ..()
	var/obj/projectile/bullet/dart/syringe/syringe_dart = source
	var/obj/item/reagent_containers/syringe/syringe = syringe_dart.inner_syringe
	if (!syringe)
		return ..()
	syringe_dart.inner_syringe = null
	source.set_embed(null, dont_delete = TRUE)
	register_on(syringe)
	syringe.set_embed(src)

/datum/embedding/syringe/fall_out()
	. = ..()
	// Nothing should modify this directly (hopefully), and this makes sure that ones fired from a syringe gun don't have 100% embedding later down the line
	embed_chance = initial(embed_chance)

/obj/item/reagent_containers/syringe/epinephrine
	name = "注射器（肾上腺素）-'Epinephrine'"
	desc = "含有肾上腺素——用于稳定患者病情。"
	list_reagents = list(/datum/reagent/medicine/epinephrine = 15)

/obj/item/reagent_containers/syringe/multiver
	name = "注射器（木太尔）-'Multiver'"
	desc = "含有木太尔成分。用格拉尼比塔鲁里稀释。"
	list_reagents = list(/datum/reagent/medicine/c2/multiver = 6, /datum/reagent/medicine/granibitaluri = 9)

/obj/item/reagent_containers/syringe/calomel
	name = "注射器（甘汞）-'Calomel'"
	desc = "含有甘汞——一种用于快速清除体内化学物质的有毒药物。"
	list_reagents = list(/datum/reagent/medicine/calomel = 15)

/obj/item/reagent_containers/syringe/convermol
	name = "注射器(肯尔莫)-'Convermol'"
	desc = "含有康维莫尔。用格拉尼比塔鲁里稀释。"
	list_reagents = list(/datum/reagent/medicine/c2/convermol = 6, /datum/reagent/medicine/granibitaluri = 9)

/obj/item/reagent_containers/syringe/antiviral
	name = "注射器(太空西林)-'Spaceacillin'"
	desc = "装有抗病毒剂。"
	list_reagents = list(/datum/reagent/medicine/spaceacillin = 15)

/obj/item/reagent_containers/syringe/bioterror
	name = "生化武器注射器"
	desc = "含有多种麻痹剂。"
	list_reagents = list(/datum/reagent/consumable/ethanol/neurotoxin = 5, /datum/reagent/toxin/mutetoxin = 5, /datum/reagent/toxin/sodium_thiopental = 5)

/obj/item/reagent_containers/syringe/calomel
	name = "syringe (calomel)"
	desc = "装有甘汞。"
	list_reagents = list(/datum/reagent/medicine/calomel = 15)

/obj/item/reagent_containers/syringe/plasma
	name = "注射器（等离子体）-'Plasma'"
	desc = "装有等离子体。"
	list_reagents = list(/datum/reagent/toxin/plasma = 15)

/obj/item/reagent_containers/syringe/lethal
	name = "致命注射注射器"
	desc = "用于注射死刑的注射器，最多可容纳50单位药物。"
	amount_per_transfer_from_this = 50
	has_variable_transfer_amount = FALSE
	volume = 50

/obj/item/reagent_containers/syringe/lethal/choral
	list_reagents = list(/datum/reagent/toxin/chloralhydrate = 50)

/obj/item/reagent_containers/syringe/lethal/execution
	list_reagents = list(/datum/reagent/toxin/plasma = 15, /datum/reagent/toxin/formaldehyde = 15, /datum/reagent/toxin/cyanide = 10, /datum/reagent/toxin/acid/fluacid = 10)

/obj/item/reagent_containers/syringe/mulligan
	name = "穆利根"
	desc = "一种用于彻底改变使用者身份的注射器。"
	amount_per_transfer_from_this = 1
	has_variable_transfer_amount = FALSE
	volume = 1
	list_reagents = list(/datum/reagent/mulligan = 1)

/obj/item/reagent_containers/syringe/gluttony
	name = "暴食的祝福"
	desc = "从一个可怕的地方找到的注射器。最好不要用它。"
	amount_per_transfer_from_this = 1
	has_variable_transfer_amount = FALSE
	volume = 1
	list_reagents = list(/datum/reagent/gluttonytoxin = 1)

/obj/item/reagent_containers/syringe/bluespace
	name = "蓝空注射器"
	desc = "一种高级注射器，可容纳60单位化学药剂。"
	icon_state = "bluespace_0"
	inhand_icon_state = "bluespace_0"
	base_icon_state = "bluespace"
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(10, 20, 30, 40, 50, 60)
	volume = 60
	dart_insert_casing_icon_state = "overlay_syringe_bluespace"
	dart_insert_projectile_icon_state = "overlay_syringe_bluespace_proj"

/obj/item/reagent_containers/syringe/piercing
	name = "穿刺型注射器"
	desc = "一种尖端镶嵌钻石的注射器，高速发射时可穿透装甲。它最多可容纳10个单位的钻石。"
	icon_state = "piercing_0"
	inhand_icon_state = "piercing_0"
	base_icon_state = "piercing"
	volume = 10
	possible_transfer_amounts = list(5, 10)
	inject_flags = INJECT_CHECK_PENETRATE_THICK
	armour_penetration = 40
	dart_insert_casing_icon_state = "overlay_syringe_piercing"
	dart_insert_projectile_icon_state = "overlay_syringe_piercing_proj"
	embed_type = /datum/embedding/syringe/piercing

/datum/embedding/syringe/piercing
	embed_chance = 100
	fall_chance = 1.5
	pain_stam_pct = 0.6
	transfer_per_second = 1

/obj/item/reagent_containers/syringe/crude
	name = "粗制注射器"
	desc = "一个做工粗糙的注射器。由于木质结构单薄，它只能容纳极少量的试剂，但它是一次性的。"
	icon_state = "crude_0"
	base_icon_state = "crude"
	possible_transfer_amounts = list(1,5)
	volume = 5
	dart_insert_casing_icon_state = "overlay_syringe_crude"
	dart_insert_projectile_icon_state = "overlay_syringe_crude_proj"
	embed_type = /datum/embedding/syringe/crude
	custom_materials = list(/datum/material/bamboo = SHEET_MATERIAL_AMOUNT * 5)

/datum/embedding/syringe/crude
	embed_chance = 75
	fall_chance = 3.5
	jostle_chance = 4
	pain_stam_pct = 0.5
	pain_mult = 5
	jostle_pain_mult = 5
	rip_time = 1 SECONDS
	transfer_per_second = 0.5

/obj/item/reagent_containers/syringe/crude/update_reagent_overlay()
	return

// Used by monkeys from the elemental plane of bananas. Reagents come from bungo pit, death berries, destroying angel, jupiter cups, and jumping beans.
/obj/item/reagent_containers/syringe/crude/tribal
	name = "部落注射器"
	desc = "一个粗制滥造的注射器。闻起来有香蕉味。"

/obj/item/reagent_containers/syringe/crude/tribal/Initialize(mapload)
	var/toxin_to_get = pick(/datum/reagent/toxin/bungotoxin, /datum/reagent/toxin/coniine, /datum/reagent/toxin/amanitin, /datum/reagent/consumable/liquidelectricity/enriched, /datum/reagent/ants)
	list_reagents = list((toxin_to_get) = 5)
	return ..()

/obj/item/reagent_containers/syringe/crude/mushroom
	list_reagents = list(/datum/reagent/drug/mushroomhallucinogen = 5)

/obj/item/reagent_containers/syringe/crude/blastoff
	list_reagents = list(/datum/reagent/drug/blastoff = 5)

/obj/item/reagent_containers/syringe/spider_extract
	name = "蜘蛛提取物注射器"
	desc = "含有克里克汁液——可使任何金核创造出世界上最致命的伙伴。"
	list_reagents = list(/datum/reagent/spider_extract = 1)

/obj/item/reagent_containers/syringe/oxandrolone
	name = "注射器（氧雄龙）-'Oxandrolone'"
	desc = "装有氧雄龙，可用于治疗严重烧伤。"
	list_reagents = list(/datum/reagent/medicine/oxandrolone = 15)

/obj/item/reagent_containers/syringe/salacid
	name = "注射器（水杨酸）-'Salicylic Acid'"
	desc = "装有水杨酸，可用于治疗严重创伤。"
	list_reagents = list(/datum/reagent/medicine/sal_acid = 15)

/obj/item/reagent_containers/syringe/penacid
	name = "注射器（喷替酸）-'pentetic acid'"
	desc = "含有喷替酸，用于降低高剂量辐射和治疗严重毒素。"
	list_reagents = list(/datum/reagent/medicine/pen_acid = 15)

/obj/item/reagent_containers/syringe/syriniver
	name = "注射器（塞维尔）-'Syriniver'"
	desc = "内含塞维尔，用于治疗毒素与清除体内化学物质。注射器标签注明：“每分钟仅限注射一次”。"
	list_reagents = list(/datum/reagent/medicine/c2/syriniver = 15)

/obj/item/reagent_containers/syringe/contraband
	name = "未贴标签的注射器"
	desc = "一支装有某种未知化学混合物的注射器。"

/obj/item/reagent_containers/syringe/contraband/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_CONTRABAND, INNATE_TRAIT)

/obj/item/reagent_containers/syringe/contraband/space_drugs
	list_reagents = list(/datum/reagent/drug/space_drugs = 15)

/obj/item/reagent_containers/syringe/contraband/krokodil
	list_reagents = list(/datum/reagent/drug/krokodil = 15)

/obj/item/reagent_containers/syringe/contraband/saturnx
	list_reagents = list(/datum/reagent/drug/saturnx = 15)

/obj/item/reagent_containers/syringe/contraband/methamphetamine
	list_reagents = list(/datum/reagent/drug/methamphetamine = 15)

/obj/item/reagent_containers/syringe/contraband/bath_salts
	list_reagents = list(/datum/reagent/drug/bath_salts = 15)

/obj/item/reagent_containers/syringe/contraband/fentanyl
	list_reagents = list(/datum/reagent/toxin/fentanyl = 15)

/obj/item/reagent_containers/syringe/contraband/morphine
	list_reagents = list(/datum/reagent/medicine/morphine = 15)
