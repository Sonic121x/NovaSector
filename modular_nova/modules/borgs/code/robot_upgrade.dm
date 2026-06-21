/// Use this file to add UPGRADES to borgs, the standard items will go in the modular robot_items.dm

/*
*	ADVANCED MEDICAL CYBORG UPGRADES
*/

/// Advanced Surgery Tools
/obj/item/borg/upgrade/surgerytools
	name = "医疗机械人高级手术工具"
	desc = "对医疗型号机械人手术装备的升级，将非高级工具替换为其高级对应物。"
	icon_state = "module_medical"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/medical)
	model_flags = BORG_MODEL_MEDICAL

/obj/item/borg/upgrade/surgerytools/action(mob/living/silicon/robot/borg)
	. = ..()
	if(.)
		for(var/obj/item/retractor/RT in borg.model.modules)
			borg.model.remove_module(RT)
		for(var/obj/item/hemostat/HS in borg.model.modules)
			borg.model.remove_module(HS)
		for(var/obj/item/cautery/CT in borg.model.modules)
			borg.model.remove_module(CT)
		for(var/obj/item/surgicaldrill/SD in borg.model.modules)
			borg.model.remove_module(SD)
		for(var/obj/item/scalpel/SP in borg.model.modules)
			borg.model.remove_module(SP)
		for(var/obj/item/circular_saw/CS in borg.model.modules)
			borg.model.remove_module(CS)
		for(var/obj/item/healthanalyzer/HA in borg.model.modules)
			borg.model.remove_module(HA)
		for(var/obj/item/blood_filter/BF in borg.model.modules)
			borg.model.remove_module(BF)
		for(var/obj/item/borg/cyborg_omnitool/medical/OMNI in borg.model.modules)
			borg.model.remove_module(OMNI)

		var/obj/item/scalpel/advanced/AS = new /obj/item/scalpel/advanced(borg.model)
		borg.model.basic_modules += AS
		borg.model.add_module(AS, FALSE, TRUE)
		var/obj/item/retractor/advanced/AR = new /obj/item/retractor/advanced(borg.model)
		borg.model.basic_modules += AR
		borg.model.add_module(AR, FALSE, TRUE)
		var/obj/item/cautery/advanced/AC = new /obj/item/cautery/advanced(borg.model)
		borg.model.basic_modules += AC
		borg.model.add_module(AC, FALSE, TRUE)
		var/obj/item/blood_filter/advanced/ABF = new /obj/item/blood_filter/advanced(borg.model)
		borg.model.basic_modules += ABF
		borg.model.add_module(ABF, FALSE, TRUE)
		var/obj/item/healthanalyzer/advanced/AHA = new /obj/item/healthanalyzer/advanced(borg.model)
		borg.model.basic_modules += AHA
		borg.model.add_module(AHA, FALSE, TRUE)
		var/obj/item/surgical_drapes/SDRP = new /obj/item/surgical_drapes(borg.model)
		borg.model.basic_modules += SDRP
		borg.model.add_module(SDRP, FALSE, TRUE)

/obj/item/borg/upgrade/surgerytools/deactivate(mob/living/silicon/robot/borg, user = usr)
	. = ..()
	if(.)
		for(var/obj/item/scalpel/advanced/AS in borg.model.modules)
			borg.model.remove_module(AS)
		for(var/obj/item/retractor/advanced/AR in borg.model.modules)
			borg.model.remove_module(AR)
		for(var/obj/item/cautery/advanced/AC in borg.model.modules)
			borg.model.remove_module(AC)
		for(var/obj/item/blood_filter/advanced/ABF in borg.model.modules)
			borg.model.remove_module(ABF)
		for(var/obj/item/healthanalyzer/advanced/AHA in borg.model.modules)
			borg.model.remove_module(AHA)
		for(var/obj/item/surgical_drapes/SDRP in borg.model.modules)
			borg.model.remove_module(SDRP)

		var/obj/item/retractor/RT = new (borg.model)
		borg.model.basic_modules += RT
		borg.model.add_module(RT, FALSE, TRUE)
		var/obj/item/hemostat/HS = new (borg.model)
		borg.model.basic_modules += HS
		borg.model.add_module(HS, FALSE, TRUE)
		var/obj/item/cautery/CT = new (borg.model)
		borg.model.basic_modules += CT
		borg.model.add_module(CT, FALSE, TRUE)
		var/obj/item/surgicaldrill/SD = new (borg.model)
		borg.model.basic_modules += SD
		borg.model.add_module(SD, FALSE, TRUE)
		var/obj/item/scalpel/SP = new (borg.model)
		borg.model.basic_modules += SP
		borg.model.add_module(SP, FALSE, TRUE)
		var/obj/item/circular_saw/CS = new (borg.model)
		borg.model.basic_modules += CS
		borg.model.add_module(CS, FALSE, TRUE)
		var/obj/item/borg/cyborg_omnitool/medical/OMNI1 = new (borg.model)
		borg.model.basic_modules += OMNI1
		borg.model.add_module(OMNI1, FALSE, TRUE)
		var/obj/item/borg/cyborg_omnitool/medical/OMNI2 = new (borg.model)
		borg.model.basic_modules += OMNI2
		borg.model.add_module(OMNI2, FALSE, TRUE)
		var/obj/item/blood_filter/BF = new (borg.model)
		borg.model.basic_modules += BF
		borg.model.add_module(BF, FALSE, TRUE)
		var/obj/item/healthanalyzer/HA = new (borg.model)
		borg.model.basic_modules += HA
		borg.model.add_module(HA, FALSE, TRUE)

/obj/item/borg/upgrade/autopsy_scanner
	name = "医疗机械人尸检扫描仪"
	desc = "对医疗型号机械人手术装备的升级，增加一个尸检扫描仪。"
	icon_state = "module_medical"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/medical)
	model_flags = BORG_MODEL_MEDICAL
	items_to_add = list(/obj/item/autopsy_scanner)

/obj/item/borg/upgrade/chemistrygripper
	name = "医疗机械人化学夹持器"
	desc = "对医疗型号机械人装备的升级，增加一个材料夹持器，以允许处理与高级化学相关的材料。"
	icon_state = "module_medical"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/medical)
	model_flags = BORG_MODEL_MEDICAL
	items_to_add = list(/obj/item/borg/apparatus/sheet_manipulator/chemistry)

/*
*	ADVANCED ENGINEERING CYBORG UPGRADES
*/

/// Advanced Materials
#define ENGINEERING_CYBORG_CHARGE_PER_STACK 1000

/datum/robot_energy_storage/plasteel
	name = "塑钢处理器"
	recharge_rate = 0
	max_energy = ENGINEERING_CYBORG_CHARGE_PER_STACK * 50

/datum/robot_energy_storage/titanium
	name = "钛处理器"
	recharge_rate = 0
	max_energy = ENGINEERING_CYBORG_CHARGE_PER_STACK * 50

/obj/item/stack/sheet/plasteel/cyborg
	cost = ENGINEERING_CYBORG_CHARGE_PER_STACK
	is_cyborg = TRUE
	source = /datum/robot_energy_storage/plasteel

/obj/item/stack/sheet/titaniumglass/cyborg
	cost = ENGINEERING_CYBORG_CHARGE_PER_STACK
	is_cyborg = TRUE
	source = /datum/robot_energy_storage/titanium

/obj/item/borg/upgrade/advanced_materials
	name = "工程高级材料处理器"
	desc = "允许机械人合成并储存高级材料"
	icon_state = "module_engineer"
	model_type = list(/obj/item/robot_model/engineering)
	model_flags = BORG_MODEL_ENGINEERING

/obj/item/borg/upgrade/advanced_materials/action(mob/living/silicon/robot/borgo, user)
	. = ..()
	if(!.)
		return
	if(borgo.hasAdvanced)
		to_chat(user, span_warning("该单位已安装高级材料！"))
		return FALSE;

	var/obj/item/stack/sheet/plasteel/cyborg/plasteel_holder = new(borgo.model)
	var/obj/item/stack/sheet/titaniumglass/cyborg/titanium_holder = new(borgo.model)
	borgo.model.basic_modules += plasteel_holder
	borgo.model.basic_modules += titanium_holder
	borgo.model.add_module(plasteel_holder, FALSE, TRUE)
	borgo.model.add_module(titanium_holder, FALSE, TRUE)
	borgo.hasAdvanced = TRUE

/obj/item/borg/upgrade/advanced_materials/deactivate(mob/living/silicon/robot/borgo, user)
	. = ..()
	if(!.)
		return
	borgo.hasAdvanced = FALSE
	for(var/obj/item/stack/sheet/plasteel/cyborg/plasteel_holder in borgo.model.modules)
		borgo.model.remove_module(plasteel_holder)
	for(var/obj/item/stack/sheet/titaniumglass/cyborg/titanium_holder in borgo.model.modules)
		borgo.model.remove_module(titanium_holder)
	for(var/datum/robot_energy_storage/plasteel/plasteel_energy in borgo.model.storages)
		qdel(plasteel_energy)
	for(var/datum/robot_energy_storage/titanium/titanium_energy in borgo.model.storages)
		qdel(titanium_energy)

//Bluespace RPED
/obj/item/borg/upgrade/brped
	name = "机械人快速部件交换装置升级"
	desc = "对机械人标准RPED的升级。"
	icon_state = "module_engineer"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/engineering)
	model_flags = BORG_MODEL_ENGINEERING
	items_to_add = list(/obj/item/storage/part_replacer/bluespace)
	items_to_remove = list(/obj/item/storage/part_replacer)

// Engiborg RLD
/obj/item/borg/upgrade/rld
	name = "工程机械人快速照明装置升级"
	desc = "允许机械人使用快速照明装置的升级。"
	icon_state = "module_engineer"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/engineering)
	model_flags = BORG_MODEL_ENGINEERING
	items_to_add = list(/obj/item/construction/rld/cyborg)

/*
*	ADVANCED MINING CYBORG UPGRADES
*/

/// Welder
/obj/item/borg/upgrade/welder
	name = "采矿机械人焊枪升级"
	desc = "为机械人配备的、拥有更大燃料罐的普通焊枪。"
	icon_state = "module_engineer"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/miner)
	model_flags = BORG_MODEL_MINER

/obj/item/borg/upgrade/welder/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		for(var/obj/item/weldingtool/mini/W in R.model)
			R.model.remove_module(W)

		var/obj/item/weldingtool/largetank/cyborg/WW = new /obj/item/weldingtool/largetank/cyborg(R.model)
		R.model.basic_modules += WW
		R.model.add_module(WW, FALSE, TRUE)

/obj/item/borg/upgrade/welder/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/weldingtool/largetank/cyborg/WW in R.model)
			R.model.remove_module(WW)

		var/obj/item/weldingtool/mini/W = new (R.model)
		R.model.basic_modules += W
		R.model.add_module(W, FALSE, TRUE)

/*
*	ADVANCED CARGO CYBORG UPGRADES
*/

/// Better Clamp
/obj/item/borg/hydraulic_clamp/better
	name = "改进型集成液压夹具"
	desc = "一种快速无痛地提起和移动板条箱进行交付的巧妙方法！"
	storage_capacity = 4
	whitelisted_item_types = list(/obj/structure/closet/crate, /obj/item/delivery/big, /obj/item/delivery, /obj/item/bounty_cube) // If they want to carry a small package or a bounty cube instead, so be it, honestly.
	whitelisted_item_description = "wrapped packages"
	item_weight_limit = NONE
	clamp_sound_volume = 50

/obj/item/borg/hydraulic_clamp/better/examine(mob/user)
	. = ..()
	var/crate_count = contents.len
	. += "There is currently <b>[crate_count > 0 ? crate_count : "no"]</b> crate[crate_count > 1 ? "s" : ""] stored in the clamp's internal storage."

/obj/item/borg/hydraulic_clamp/mail
	name = "集成式快速邮件投递装置"
	desc = "允许你携带大量邮件，像优秀的小邮递员一样在空间站各处投递！"
	icon = 'icons/obj/service/library.dmi'
	icon_state = "bookbag"
	storage_capacity = 100
	loading_time = 0.25 SECONDS
	unloading_time = 0.25 SECONDS
	cooldown_duration = 0.25 SECONDS
	whitelisted_item_types = list(/obj/item/mail)
	whitelisted_item_description = "envelopes"
	item_weight_limit = WEIGHT_CLASS_NORMAL
	clamp_sound_volume = 25
	clamp_sound = 'sound/items/pshoom/pshoom.ogg'

/datum/design/borg_upgrade_clamp
	name = "改进型集成液压夹具模块"
	id = "borg_upgrade_clamp"
	build_type = MECHFAB
	build_path = /obj/item/borg/upgrade/better_clamp
	materials = list(
		/datum/material/titanium = SHEET_MATERIAL_AMOUNT * 2,
		/datum/material/gold = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/bluespace = HALF_SHEET_MATERIAL_AMOUNT,
	)
	construction_time = 12 SECONDS
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_CARGO,
	)

/obj/item/borg/upgrade/better_clamp
	name = "改进型集成液压夹具"
	desc = "一种改进的液压夹具，同样允许拾取更大的包裹！"
	icon = 'modular_nova/modules/borgs/icons/robot_items.dmi'
	icon_state = "module_cargo"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/cargo)
	model_flags = BORG_MODEL_CARGO


/obj/item/borg/upgrade/better_clamp/action(mob/living/silicon/robot/cyborg, user = usr)
	. = ..()
	if(!.)
		return
	var/obj/item/borg/hydraulic_clamp/better/big_clamp = locate() in cyborg.model.modules
	if(big_clamp)
		to_chat(user, span_warning("这个机械人已经装备了改进型集成液压夹具！"))
		return FALSE

	big_clamp = new(cyborg.model)
	cyborg.model.basic_modules += big_clamp
	cyborg.model.add_module(big_clamp, FALSE, TRUE)


/obj/item/borg/upgrade/better_clamp/deactivate(mob/living/silicon/robot/cyborg, user = usr)
	. = ..()
	if(!.)
		return
	var/obj/item/borg/hydraulic_clamp/better/big_clamp = locate() in cyborg.model.modules
	if(big_clamp)
		cyborg.model.remove_module(big_clamp)

/obj/item/borg/upgrade/cargo_teleporter
	name = "货运传送器升级模块"
	desc = "允许机械人使用货运传送器的升级。"
	icon = 'modular_nova/modules/borgs/icons/robot_items.dmi'
	icon_state = "module_cargo"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/cargo)
	model_flags = BORG_MODEL_CARGO
	items_to_add = list(/obj/item/cargo_teleporter)

/*
*	UNIVERSAL CYBORG UPGRADES
*/

/// ShapeShifter
/obj/item/borg/upgrade/borg_shapeshifter
	name = "机械人变形模块"
	desc = "一种允许机械人伪装成另一种类型机械人的实验性装置。"
	icon_state = "module_general"

/obj/item/borg/upgrade/borg_shapeshifter/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/borg_shapeshifter/BS = new /obj/item/borg_shapeshifter(R.model)
		R.model.basic_modules += BS
		R.model.add_module(BS, FALSE, TRUE)

/obj/item/borg/upgrade/borg_shapeshifter/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/borg_shapeshifter/BS in R.model)
			R.model.remove_module(BS)

/// Quadborg time
/obj/item/borg/upgrade/affectionmodule
	name = "机械人情感模块"
	desc = "一个升级机械人表达情感能力的模块。"
	icon_state = "module_peace"

/obj/item/borg/upgrade/affectionmodule/action(mob/living/silicon/robot/borg)
	. = ..()
	if(!.)
		return
	if(borg.hasAffection)
		to_chat(usr, span_warning("该单位已安装情感模块！"))
		return FALSE
	if(!(TRAIT_R_WIDE in borg.model.model_features))
		to_chat(usr, span_warning("该单位的底盘不支持此模块。"))
		return FALSE

	var/obj/item/quadborg_tongue/quadtongue = new /obj/item/quadborg_tongue(borg.model)
	borg.model.basic_modules += quadtongue
	borg.model.add_module(quadtongue, FALSE, TRUE)
	var/obj/item/quadborg_nose/quadnose = new /obj/item/quadborg_nose(borg.model)
	borg.model.basic_modules += quadnose
	borg.model.add_module(quadnose, FALSE, TRUE)
	borg.hasAffection = TRUE

/obj/item/borg/upgrade/affectionmodule/deactivate(mob/living/silicon/robot/borg, user = usr)
	. = ..()
	if(.)
		return
	borg.hasAffection = FALSE
	for(var/obj/item/quadborg_tongue/quadtongue in borg.model.modules)
		borg.model.remove_module(quadtongue)
	for(var/obj/item/quadborg_nose/quadnose in borg.model.modules)
		borg.model.remove_module(quadnose)

// Quadruped tongue - lick lick
/obj/item/quadborg_tongue
	name = "合成舌头"
	desc = "用于从地板上吸走污物，然后深情地舔舐船员的脸。"
	icon = 'modular_nova/modules/borgs/icons/robot_items.dmi'
	icon_state = "synthtongue"
	hitsound = 'sound/effects/blob/attackblob.ogg'
	desc = "用于给予深情的亲吻。"
	item_flags = NOBLUDGEON

/obj/item/quadborg_tongue/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	var/mob/living/silicon/robot/borg = user
	var/mob/living/mob = interacting_with
	if(!istype(mob))
		return ITEM_INTERACT_BLOCKING
	if(HAS_TRAIT(interacting_with, TRAIT_AFFECTION_AVERSION)) // Checks for Affection Aversion trait
		to_chat(user, span_warning("错误：[interacting_with] 在禁止舔舐登记表上！"))
		return ITEM_INTERACT_BLOCKING
	if(check_zone(borg.zone_selected) == "head")
		borg.visible_message(span_warning("\the [borg] affectionally licks \the [mob]'s face!"), span_notice("You affectionally lick \the [mob]'s face!"))
	else
		borg.visible_message(span_warning("\the [borg] 深情地舔了舔 \the [mob]！"), span_notice("你深情地舔了舔 \the [mob]！"))
	playsound(borg, 'sound/effects/blob/attackblob.ogg', 50, 1)
	return ITEM_INTERACT_SUCCESS

// Quadruped nose - Boop
/obj/item/quadborg_nose
	name = "轻触模块"
	desc = "轻触模块"
	icon = 'modular_nova/modules/borgs/icons/robot_items.dmi'
	icon_state = "nose"
	obj_flags = CONDUCTS_ELECTRICITY
	item_flags = NOBLUDGEON
	force = 0

/obj/item/quadborg_nose/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(HAS_TRAIT(interacting_with, TRAIT_AFFECTION_AVERSION)) // Checks for Affection Aversion trait
		to_chat(user, span_warning("错误：[interacting_with] 在禁止触碰登记表上！"))
		return ITEM_INTERACT_BLOCKING

	do_attack_animation(interacting_with, null, src)
	user.visible_message(span_notice("[user] [pick("nuzzles", "pushes", "boops")] \the [interacting_with.name] with their nose!"))
	return ITEM_INTERACT_SUCCESS

/// The Shrinkening
/mob/living/silicon/robot
	var/hasShrunk = FALSE
	var/hasAffection = FALSE
	var/hasAdvanced = FALSE

/obj/item/borg/upgrade/shrink
	name = "机械人缩小器"
	desc = "一个机械人尺寸调整器，它能让机械人变小。"
	icon_state = "module_general"

/obj/item/borg/upgrade/shrink/action(mob/living/silicon/robot/borg, user = usr)
	. = ..()
	if(.)

		if(borg.hasShrunk)
			to_chat(usr, span_warning("该单位已安装缩小模块！"))
			return FALSE
		if(TRAIT_R_SMALL in borg.model.model_features)
			to_chat(usr, span_warning("该单位的底盘已无法进一步缩小。"))
			return FALSE
		borg.hasShrunk = TRUE
		ADD_TRAIT(borg, TRAIT_NO_TRANSFORM, REF(src))
		var/prev_lockcharge = borg.lockcharge
		borg.SetLockdown(TRUE)
		borg.set_anchored(TRUE)
		do_smoke(1, borg, get_turf(borg))
		sleep(0.2 SECONDS)
		for(var/i in 1 to 4)
			playsound(borg, pick('sound/items/tools/drill_use.ogg', 'sound/items/tools/jaws_cut.ogg', 'sound/items/tools/jaws_pry.ogg', 'sound/items/tools/welder.ogg', 'sound/items/tools/ratchet.ogg'), 80, TRUE, -1)
			sleep(1.2 SECONDS)
		if(!prev_lockcharge)
			borg.SetLockdown(FALSE)
		borg.set_anchored(FALSE)
		REMOVE_TRAIT(borg, TRAIT_NO_TRANSFORM, REF(src))
		borg.update_transform(0.90)

/obj/item/borg/upgrade/shrink/deactivate(mob/living/silicon/robot/borg, user = usr)
	. = ..()
	if (.)
		if (borg.hasShrunk)
			borg.hasShrunk = FALSE
			borg.update_transform(4/3)

/// Syndijack
/obj/item/borg/upgrade/transform/syndicatejack
	name = "机械人模块选择器（辛迪加）"
	desc = "允许你将一个机械人转变为实验型辛迪加机械人。"
	icon_state = "module_illegal"
	new_model = /obj/item/robot_model/syndicatejack

/obj/item/borg/upgrade/transform/syndicatejack/marauder
	new_model = /obj/item/robot_model/syndicatejack/marauder

/// Dominatrix time
/obj/item/borg/upgrade/dominatrixmodule
	name = "机械人支配者模块"
	desc = "一个能极大提升机械人表达情感能力的模块。"
	icon = 'modular_nova/modules/borgs/icons/robot_items.dmi'
	icon_state = "module_lust"
	custom_price = 0
	obj_flags_nova = ERP_ITEM

/obj/item/borg/upgrade/dominatrixmodule/action(mob/living/silicon/robot/borg)
	. = ..()
	if(!.)
		return
	var/obj/item/kinky_shocker/cur_shocker = locate() in borg.model.modules
	if(cur_shocker)
		to_chat(usr, span_warning("该单位已安装支配者模块！"))
		return FALSE

	var/obj/item/kinky_shocker/shocker = new /obj/item/kinky_shocker()
	borg.model.basic_modules += shocker
	borg.model.add_module(shocker, FALSE, TRUE)
	var/obj/item/clothing/mask/leatherwhip/whipper = new /obj/item/clothing/mask/leatherwhip()
	borg.model.basic_modules += whipper
	borg.model.add_module(whipper, FALSE, TRUE)
	var/obj/item/spanking_pad/spanker = new /obj/item/spanking_pad()
	borg.model.basic_modules += spanker
	borg.model.add_module(spanker, FALSE, TRUE)
	var/obj/item/tickle_feather/tickler = new /obj/item/tickle_feather()
	borg.model.basic_modules += tickler
	borg.model.add_module(tickler, FALSE, TRUE)
	var/obj/item/clothing/sextoy/fleshlight/fleshlight = new /obj/item/clothing/sextoy/fleshlight()
	borg.model.basic_modules += fleshlight
	borg.model.add_module(fleshlight, FALSE, TRUE)

/obj/item/borg/upgrade/dominatrixmodule/deactivate(mob/living/silicon/robot/borg, user = usr)
	. = ..()
	if(!.)
		return

	for(var/obj/item/kinky_shocker/shocker in borg.model.modules)
		borg.model.remove_module(shocker)
	for(var/obj/item/clothing/mask/leatherwhip/whipper in borg.model.modules)
		borg.model.remove_module(whipper)
	for(var/obj/item/spanking_pad/spanker in borg.model.modules)
		borg.model.remove_module(spanker)
	for(var/obj/item/tickle_feather/tickler in borg.model.modules)
		borg.model.remove_module(tickler)
	for(var/obj/item/clothing/sextoy/fleshlight/fleshlight in borg.model.modules)
		borg.model.remove_module(fleshlight)

/obj/item/borg/upgrade/cargo_papermanipulator
	name = "货运机械人操纵器"
	desc = "一种货运型号机械人的升级，用于帮助处理纸张、腰带甚至管道装置等物品。"
	icon_state = "module_miner"
	require_model = TRUE
	model_type = list(/obj/item/robot_model/cargo)
	model_flags = BORG_MODEL_CARGO

	items_to_add = list(/obj/item/borg/apparatus/cargo_papermanipulator)

/obj/item/borg/apparatus/cargo_papermanipulator
	name = "货运装置"
	desc = "一种专为处理纸张、腰带甚至管道装置而设计的、不那么特殊的装置。"
	icon_state = "borg_service_apparatus"
	storable = list(
		/obj/item/paper,
		/obj/item/pipe_dispenser,
		/obj/item/stack/conveyor,
		/obj/item/conveyor_switch_construct,
		/obj/item/assembly/control, // To help rewire bay doors
		/obj/item/stock_parts, // So they can make lathes and such in front of the bay
		/obj/machinery/rnd/production/colony_lathe,
		/obj/item/stack/sheet/iron,
		/obj/item/stack/sheet/glass,
		/obj/item/holochip, // makes sense, idk.
	)

/obj/item/borg/apparatus/cargo_papermanipulator/Initialize(mapload)
	update_appearance()
	return ..()

/obj/item/borg/apparatus/cargo_papermanipulator/update_overlays()
	. = ..()
	var/mutable_appearance/arm = mutable_appearance(icon, "borg_hardware_apparatus_arm1")
	if(stored)
		stored.pixel_w = -3
		stored.pixel_z = 0
		var/mutable_appearance/stored_copy = new /mutable_appearance(stored)
		stored_copy.layer = FLOAT_LAYER
		stored_copy.plane = FLOAT_PLANE
		. += stored_copy
	. += arm

/obj/item/borg/apparatus/cargo_papermanipulator/examine()
	. = ..()
	if(stored)
		. += "The apparatus currently has [stored] secured."
	. += span_notice("<i>Alt-点击</i>将丢弃当前固定的物品。")

#undef ENGINEERING_CYBORG_CHARGE_PER_STACK
