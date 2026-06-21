/* First aid storage
 * Contains:
 * First Aid Kits
 * Pill Bottles
 * Dice Pack (in a pill bottle)
 */

/*
 * First Aid Kits
 */
/obj/item/storage/medkit
	name = "医疗包"
	desc = "这是一个用于处理严重伤口的紧急医疗包。"
	icon = 'icons/obj/storage/medkit.dmi'
	icon_state = "medkit"
	inhand_icon_state = "medkit"
	worn_icon_state = "nothing" // NOVA EDIT ADDITION - Removes 'no texture' state from medkit worn sprite
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	throw_speed = 3
	throw_range = 7
	drop_sound = 'sound/items/handling/medkit/medkit_drop.ogg'
	pickup_sound = 'sound/items/handling/medkit/medkit_pick_up.ogg'
	sound_vary = TRUE
	storage_type = /datum/storage/medkit

	var/empty = FALSE
	/// Defines damage type of the medkit. General ones stay null. Used for medibot healing bonuses
	var/damagetype_healed

/obj/item/storage/medkit/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/cuffable_item)

/obj/item/storage/medkit/regular
	icon_state = "medkit"
	desc = "一个能够治疗常见类型伤害的急救包。"

/obj/item/storage/medkit/regular/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins giving [user.p_them()]self aids with \the [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return BRUTELOSS

/obj/item/storage/medkit/regular/PopulateContents()
	if(empty)
		return
	var/list/items_inside = list(
		/obj/item/stack/medical/wrap/gauze = 1,
		/obj/item/stack/medical/suture = 2,
		/obj/item/stack/medical/mesh = 2,
		/obj/item/reagent_containers/hypospray/medipen = 1,
		/obj/item/healthanalyzer/simple = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/emergency
	icon_state = "medbriefcase"
	inhand_icon_state = "medkit-emergency"
	name = "紧急医疗包"
	desc = "一个非常简单的急救包，旨在固定和稳定严重伤口以便后续治疗。"

/obj/item/storage/medkit/emergency/PopulateContents()
	if(empty)
		return
	var/list/items_inside = list(
		/obj/item/healthanalyzer/simple = 1,
		/obj/item/stack/medical/wrap/gauze = 1,
		/obj/item/stack/medical/bandage = 1,
		/obj/item/stack/medical/ointment = 1,
		/obj/item/reagent_containers/hypospray/medipen/ekit = 2,
		/obj/item/storage/pill_bottle/iron = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/surgery
	name = "外科医疗包"
	icon_state = "medkit_surgery"
	inhand_icon_state = "medkit-surgical"
	desc = "一个为医生准备的高容量急救包，装满了医疗用品和基本外科设备。"
	storage_type = /datum/storage/medkit/surgery

/obj/item/storage/medkit/surgery/PopulateContents()
	if(empty)
		return
	var/list/items_inside = list(
		/obj/item/healthanalyzer = 1,
		/obj/item/stack/medical/wrap/gauze/twelve = 1,
		/obj/item/stack/medical/suture = 2,
		/obj/item/stack/medical/mesh = 2,
		/obj/item/reagent_containers/hypospray/medipen = 1,
		/obj/item/surgical_drapes = 1,
		/obj/item/scalpel = 1,
		/obj/item/hemostat = 1,
		/obj/item/cautery = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/surgery_syndie
	name = "可疑的外科医疗包"
	desc = "一个颜色可疑的医疗包，装满了先进的医疗设备。"
	icon_state = "medkit_tactical_lite"
	inhand_icon_state = "medkit-tactical-lite"
	damagetype_healed = HEAL_ALL_DAMAGE
	storage_type = /datum/storage/medkit/surgery

/obj/item/storage/medkit/surgery_syndie/PopulateContents()
	if(empty)
		return
	var/list/items_inside = list(
		/obj/item/scalpel/advanced = 1,
		/obj/item/retractor/advanced = 1,
		/obj/item/cautery/advanced = 1,
		/obj/item/surgical_drapes = 1,
		/obj/item/stack/medical/wrap/gauze/twelve = 1,
		/obj/item/reagent_containers/medigel/sterilizine = 1,
		/obj/item/bonesetter = 1,
		/obj/item/blood_filter = 1,
		/obj/item/stack/medical/bone_gel = 1,
		/obj/item/stack/medical/wrap/sticky_tape/surgical = 1,
		/obj/item/reagent_containers/syringe = 1,
		/obj/item/reagent_containers/cup/bottle/sodium_thiopental = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/surgery_syndie/get_medbot_skin()
	return "bezerk"

/obj/item/storage/medkit/ancient
	icon_state = "oldfirstaid"
	desc = "一个能够治疗常见类型伤害的急救包。"

/obj/item/storage/medkit/ancient/PopulateContents()
	if(empty)
		return
	var/list/items_inside = list(
		/obj/item/stack/medical/wrap/gauze = 1,
		/obj/item/stack/medical/bruise_pack = 3,
		/obj/item/stack/medical/ointment= 3)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/ancient/heirloom
	desc = "一个能够治疗常见类型伤害的急救包。光是看着它，你就开始怀念起过去的美好时光。"
	empty = TRUE // long since been ransacked by hungry powergaming assistants breaking into med storage

/obj/item/storage/medkit/fire
	name = "烧伤治疗包"
	desc = "当军械实验室<i>-自发-</i>起火时使用的专用医疗包。"
	icon_state = "medkit_burn"
	inhand_icon_state = "medkit-ointment"
	damagetype_healed = BURN

/obj/item/storage/medkit/fire/get_medbot_skin()
	return "burn"

/obj/item/storage/medkit/fire/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] begins rubbing \the [src] against [user.p_them()]self! It looks like [user.p_theyre()] trying to start a fire!"))
	return FIRELOSS

/obj/item/storage/medkit/fire/PopulateContents()
	if(empty)
		return
	var/list/items_inside = list(
		/obj/item/reagent_containers/applicator/patch/aiuri = 3,
		/obj/item/reagent_containers/spray/hercuri = 1,
		/obj/item/reagent_containers/hypospray/medipen/oxandrolone = 1,
		/obj/item/reagent_containers/hypospray/medipen = 1)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/toxin
	name = "毒素治疗包"
	desc = "用于治疗血液毒素含量过高和辐射中毒。"
	icon_state = "medkit_toxin"
	inhand_icon_state = "medkit-toxin"
	damagetype_healed = TOX

/obj/item/storage/medkit/toxin/get_medbot_skin()
	return "tox"

/obj/item/storage/medkit/toxin/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] 开始舔 \the [src] 上的铅漆！看起来 [user.p_theyre()] 想自杀！"))
	return TOXLOSS


/obj/item/storage/medkit/toxin/PopulateContents()
	if(empty)
		return
	var/list/items_inside = list(
		/obj/item/storage/pill_bottle/multiver/less = 1,
		/obj/item/reagent_containers/syringe/syriniver = 3,
		/obj/item/storage/pill_bottle/potassiodide = 1,
		/obj/item/reagent_containers/hypospray/medipen/penacid = 1,
		/obj/item/healthanalyzer/simple/disease = 1,
		)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/o2
	name = "缺氧治疗包"
	desc = "一盒满满的氧气好物。"
	icon_state = "medkit_o2"
	inhand_icon_state = "medkit-o2"
	damagetype_healed = OXY

/obj/item/storage/medkit/o2/get_medbot_skin()
	return "oxy"

/obj/item/storage/medkit/o2/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] 开始用\the [user.p_their()]猛击[src]的脖子！看起来[user.p_theyre()]想要自杀！"))
	return OXYLOSS

/obj/item/storage/medkit/o2/PopulateContents()
	if(empty)
		return
	var/list/items_inside = list(
		/obj/item/reagent_containers/syringe/convermol = 3,
		/obj/item/reagent_containers/hypospray/medipen/salbutamol = 1,
		/obj/item/reagent_containers/hypospray/medipen = 1,
		/obj/item/storage/pill_bottle/iron = 1)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/brute
	name = "钝器创伤治疗包"
	desc = "当你被工具箱砸到时使用的急救包。"
	icon_state = "medkit_brute"
	inhand_icon_state = "medkit-brute"
	damagetype_healed = BRUTE

/obj/item/storage/medkit/brute/get_medbot_skin()
	return "brute"

/obj/item/storage/medkit/brute/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] 开始用\the [user.p_them()]猛击[src]自己的头部！看起来[user.p_theyre()]想要自杀！"))
	return BRUTELOSS

/obj/item/storage/medkit/brute/PopulateContents()
	if(empty)
		return
	var/list/items_inside = list(
		/obj/item/reagent_containers/applicator/patch/libital = 3,
		/obj/item/stack/medical/wrap/gauze = 1,
		/obj/item/storage/pill_bottle/probital = 1,
		/obj/item/reagent_containers/hypospray/medipen/salacid = 1,
		/obj/item/healthanalyzer/simple = 1,
		)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/advanced
	name = "高级急救包"
	desc = "一个用于处理高级创伤的高级医疗包。"
	icon_state = "medkit_advanced"
	inhand_icon_state = "medkit-advanced"
	custom_premium_price = PAYCHECK_COMMAND * 6
	damagetype_healed = HEAL_ALL_DAMAGE

/obj/item/storage/medkit/advanced/get_medbot_skin()
	return "adv"

/obj/item/storage/medkit/advanced/PopulateContents()
	if(empty)
		return
	var/list/items_inside = list(
		/obj/item/reagent_containers/applicator/patch/synthflesh = 3,
		/obj/item/reagent_containers/hypospray/medipen/atropine = 2,
		/obj/item/stack/medical/wrap/gauze = 1,
		/obj/item/storage/pill_bottle/penacid = 1)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/tactical_lite
	name = "战斗急救包"
	icon_state = "medkit_tactical_lite"
	inhand_icon_state = "medkit-tactical-lite"
	damagetype_healed = HEAL_ALL_DAMAGE

/obj/item/storage/medkit/tactical_lite/get_medbot_skin()
	return "bezerk"

/obj/item/storage/medkit/tactical_lite/PopulateContents()
	if(empty)
		return
	var/list/items_inside = list(
		/obj/item/healthanalyzer/advanced = 1,
		/obj/item/reagent_containers/hypospray/medipen/atropine = 1,
		/obj/item/stack/medical/wrap/gauze = 1,
		/obj/item/stack/medical/suture/medicated = 2,
		/obj/item/stack/medical/mesh/advanced = 2,
	)
	generate_items_inside(items_inside, src)

/obj/item/storage/medkit/tactical
	name = "战斗医疗包"
	desc = "希望你买了保险。"
	icon_state = "medkit_tactical"
	inhand_icon_state = "medkit-tactical"
	damagetype_healed = HEAL_ALL_DAMAGE
	storage_type = /datum/storage/medkit/tactical

/obj/item/storage/medkit/tactical/get_medbot_skin()
	return "bezerk"

/obj/item/storage/medkit/tactical/PopulateContents()
	if(empty)
		return
	var/list/items_inside = list(
		/obj/item/cautery = 1,
		/obj/item/scalpel = 1,
		/obj/item/healthanalyzer/advanced = 1,
		/obj/item/hemostat = 1,
		/obj/item/reagent_containers/medigel/sterilizine = 1,
		/obj/item/storage/box/bandages = 1,
		/obj/item/surgical_drapes = 1,
		/obj/item/reagent_containers/hypospray/medipen/atropine = 2,
		/obj/item/stack/medical/wrap/gauze = 2,
		/obj/item/stack/medical/suture/medicated = 2,
		/obj/item/stack/medical/mesh/advanced = 2,
		/obj/item/reagent_containers/applicator/patch/libital = 4,
		/obj/item/reagent_containers/applicator/patch/aiuri = 4,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/tactical/premium
	name = "高级战斗医疗包"
	desc = "可能含有微量铅。"
	icon_state = "medkit_tactical_premium"
	inhand_icon_state = "medkit-tactical-premium"
	storage_type = /datum/storage/medkit/tactical/premium

/obj/item/storage/medkit/tactical/premium/grind_results()
	return list(/datum/reagent/lead = 10)

/obj/item/storage/medkit/tactical/premium/PopulateContents()
	if(empty)
		return
	var/list/items_inside = list(
		/obj/item/stack/medical/suture/medicated = 2,
		/obj/item/stack/medical/mesh/advanced = 2,
		/obj/item/reagent_containers/applicator/patch/libital = 3,
		/obj/item/reagent_containers/applicator/patch/aiuri = 3,
		/obj/item/healthanalyzer/advanced = 1,
		/obj/item/stack/medical/wrap/gauze = 2,
		/obj/item/mod/module/thread_ripper = 1,
		/obj/item/mod/module/surgical_processor/preloaded = 1,
		/obj/item/mod/module/defibrillator/combat = 1,
		/obj/item/mod/module/health_analyzer = 1,
		/obj/item/autosurgeon/syndicate/emaggedsurgerytoolset = 1,
		/obj/item/reagent_containers/hypospray/combat/empty = 1,
		/obj/item/storage/box/bandages = 1,
		/obj/item/storage/box/evilmeds = 1,
		/obj/item/reagent_containers/medigel/sterilizine = 1,
		/obj/item/clothing/glasses/hud/health/night/science = 1,
	)
	generate_items_inside(items_inside,src)

/obj/item/storage/medkit/coroner
	name = "紧凑型验尸官医疗包"
	desc = "一种较小的医疗包，主要设计用于协助解剖死者，而非治疗活人。"
	icon = 'icons/obj/storage/medkit.dmi'
	icon_state = "compact_coronerkit"
	inhand_icon_state = "coronerkit"
	storage_type = /datum/storage/medkit/coroner

/obj/item/storage/medkit/coroner/PopulateContents()
	if(empty)
		return
	var/list/items_inside = list(
		/obj/item/reagent_containers/cup/bottle/formaldehyde = 1,
		/obj/item/reagent_containers/medigel/sterilizine = 1,
		/obj/item/reagent_containers/blood = 1,
		/obj/item/bodybag = 2,
		/obj/item/reagent_containers/syringe = 1,
	)
	generate_items_inside(items_inside,src)

//medibot assembly
/obj/item/storage/medkit/tool_act(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/bodypart/arm/left/robot) && !istype(tool, /obj/item/bodypart/arm/right/robot))
		return ..()
	//Making a medibot!
	if(contents.len >= 1)
		balloon_alert(user, "里面有物品！")
		return ITEM_INTERACT_BLOCKING

	var/obj/item/bot_assembly/medbot/medbot_assembly = new(drop_location())
	medbot_assembly.set_skin(get_medbot_skin())
	medbot_assembly.balloon_alert(user, "手臂已添加")
	medbot_assembly.robot_arm = tool.type
	medbot_assembly.medkit_type = type
	qdel(tool)
	var/held_index = user.is_holding(src)
	qdel(src)
	if (held_index)
		user.put_in_hand(medbot_assembly, held_index)
	return ITEM_INTERACT_SUCCESS

/// Gets what skin (icon_state) this medkit uses for a medbot
/obj/item/storage/medkit/proc/get_medbot_skin()
	return "generic"

/// A box which takes in coolant and uses it to preserve organs and body parts
/obj/item/storage/organbox
	name = "器官运输箱"
	desc = "一种先进的箱子，带有冷却机制，使用冷冻苯乙烯或其他冷试剂来保存内部的器官或身体部位。"
	icon = 'icons/obj/storage/case.dmi'
	icon_state = "organbox"
	base_icon_state = "organbox"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	throw_speed = 3
	throw_range = 7
	custom_premium_price = PAYCHECK_CREW * 4
	storage_type = /datum/storage/organ_box
	/// var to prevent it freezing the same things over and over
	var/cooling = FALSE

/obj/item/storage/organbox/Initialize(mapload)
	. = ..()

	create_reagents(100, TRANSPARENT)

	START_PROCESSING(SSobj, src)

/obj/item/storage/organbox/process(seconds_per_tick)
	///if there is enough coolant var
	var/using_coolant = coolant_to_spend()
	if (isnull(using_coolant))
		if (cooling)
			cooling = FALSE
			update_appearance()
			for(var/obj/stored in contents)
				stored.unfreeze()
		return

	var/amount_used = 0.05 * seconds_per_tick
	if (using_coolant != /datum/reagent/cryostylane)
		amount_used *= 2
	reagents.remove_reagent(using_coolant, amount_used)

	if(cooling)
		return
	cooling = TRUE
	update_appearance()
	for(var/obj/stored in contents)
		stored.freeze()

/// Returns which coolant we are about to use, or null if there isn't any
/obj/item/storage/organbox/proc/coolant_to_spend()
	if (reagents.get_reagent_amount(/datum/reagent/cryostylane))
		return /datum/reagent/cryostylane
	if (reagents.get_reagent_amount(/datum/reagent/consumable/ice))
		return /datum/reagent/consumable/ice
	return null

/obj/item/storage/organbox/update_icon_state()
	icon_state = "[base_icon_state][cooling ? "-working" : null]"
	return ..()

/obj/item/storage/organbox/tool_act(mob/living/user, obj/item/tool, list/modifiers)
	if(is_reagent_container(tool) && tool.is_open_container())
		var/obj/item/reagent_containers/RC = tool
		var/units = RC.reagents.trans_to(src, RC.amount_per_transfer_from_this, transferred_by = user)
		if(units)
			balloon_alert(user, "已转移[units]单位")
			return ITEM_INTERACT_SUCCESS
		return ITEM_INTERACT_BLOCKING
	if(istype(tool, /obj/item/plunger))
		balloon_alert(user, "正在推注...")
		if(do_after(user, 1 SECONDS, target = src))
			balloon_alert(user, "已推注")
			reagents.clear_reagents()
		return ITEM_INTERACT_SUCCESS
	return ..()

/obj/item/storage/organbox/suicide_act(mob/living/carbon/user)
	if(HAS_TRAIT(user, TRAIT_RESISTCOLD)) //if they're immune to cold, just do the box suicide
		var/obj/item/bodypart/head/myhead = user.get_bodypart(BODY_ZONE_HEAD)
		if(myhead)
			user.visible_message(span_suicide("[user] 把[user.p_their()]的头塞进\the [src]并开始合上它！看起来[user.p_theyre()]想要自杀！"))
			if (myhead.dismember())
				myhead.forceMove(src) //force your enemies to kill themselves with your head collection box!
			playsound(user, "desecration-01.ogg", 50, TRUE, -1)
			return BRUTELOSS
		user.visible_message(span_suicide("[user] 正在用\the [user.p_them()]猛击[src]自己！看起来[user.p_theyre()]想要自杀！"))
		return BRUTELOSS
	user.visible_message(span_suicide("[user]正将[user.p_their()]头伸进[src]里，看起来[user.p_theyre()]试图自杀！"))
	user.adjust_bodytemperature(-300)
	user.apply_status_effect(/datum/status_effect/freon)
	return FIRELOSS

/// A subtype of organ storage box which starts with a full coolant tank
/obj/item/storage/organbox/preloaded

/obj/item/storage/organbox/preloaded/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/cryostylane, reagents.maximum_volume)

/obj/item/storage/test_tube_rack
	name = "试管架"
	desc = "一个用于存放试管的木制架子。"
	icon_state = "rack"
	base_icon_state = "rack"
	icon = 'icons/obj/medical/chemical.dmi'
	inhand_icon_state = "contsolid"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	storage_type = /datum/storage/test_tube_rack
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT)

/obj/item/storage/test_tube_rack/update_icon_state()
	icon_state = "[base_icon_state][contents.len > 0 ? contents.len : null]"
	return ..()

/obj/item/storage/test_tube_rack/full/PopulateContents()
	for(var/i in 1 to atom_storage.max_slots)
		new /obj/item/reagent_containers/cup/tube(src)
	update_appearance(UPDATE_ICON_STATE)
