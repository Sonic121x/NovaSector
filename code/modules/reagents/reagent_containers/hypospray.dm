/obj/item/reagent_containers/hypospray
	name = "无针注射器"
	desc = "德福雷斯特医疗公司的无针注射器是一种无菌的空气针式自动注射器，用于快速向患者注射药物。"
	icon = 'icons/obj/medical/syringe.dmi'
	inhand_icon_state = "hypo"
	worn_icon_state = "hypo"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	icon_state = "hypo"
	amount_per_transfer_from_this = 5
	volume = 30
	possible_transfer_amounts = list(5)
	resistance_flags = ACID_PROOF
	initial_reagent_flags = OPENCONTAINER | NO_SPLASH
	slot_flags = ITEM_SLOT_BELT
	var/ignore_flags = NONE
	var/infinite = FALSE
	/// If TRUE, won't play a noise when injecting.
	var/stealthy = FALSE
	/// If TRUE, the hypospray will be permanently unusable.
	var/used_up = FALSE

/obj/item/reagent_containers/hypospray/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/item/reagent_containers/hypospray/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isliving(interacting_with))
		return NONE
	return inject(interacting_with, user) ? ITEM_INTERACT_SUCCESS : ITEM_INTERACT_BLOCKING

/obj/item/reagent_containers/hypospray/interact_with_atom_secondary(atom/target, mob/living/user, list/modifiers)
	if (!target.reagents)
		return NONE

	if(isliving(target))
		to_chat(user, span_warning("[src] can't be used to draw blood!"))
		return ITEM_INTERACT_BLOCKING

	if(reagents.holder_full())
		to_chat(user, span_notice("[src] is full."))
		return ITEM_INTERACT_BLOCKING

	if(!target.reagents.total_volume)
		to_chat(user, span_warning("[target] is empty!"))
		return ITEM_INTERACT_BLOCKING

	if(!target.is_drawable(user))
		to_chat(user, span_warning("You cannot directly remove reagents from [target]!"))
		return ITEM_INTERACT_BLOCKING

	var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this, transferred_by = user)
	if(trans)
		to_chat(user, span_notice("You fill [src] with [trans] units of the solution. It now contains [reagents.total_volume] units."))
	return ITEM_INTERACT_SUCCESS

///Handles all injection checks, injection and logging.
/obj/item/reagent_containers/hypospray/proc/inject(mob/living/affected_mob, mob/user)
	if(used_up)
		to_chat(user, span_warning("[src]的针头坏了，现在无法使用！"))
		return FALSE
	if(!iscarbon(affected_mob))
		return FALSE

	//Always log attemped injects for admins
	var/list/injected = list()
	for(var/datum/reagent/injected_reagent in reagents.reagent_list)
		injected += injected_reagent.name
	var/contained = english_list(injected)
	log_combat(user, affected_mob, "attempted to inject", src, "([contained])")
	user.changeNext_move(CLICK_CD_MELEE)

	if(!used_up && (ignore_flags || affected_mob.try_inject(user, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE))) // Ignore flag should be checked first or there will be an error message.
		to_chat(affected_mob, span_warning("你感到一阵轻微的刺痛！"))
		to_chat(user, span_notice("你用[src]给[affected_mob]注射了。"))
		if(!stealthy)
			playsound(affected_mob, 'sound/items/hypospray.ogg', 50, TRUE)
		var/fraction = min(amount_per_transfer_from_this/reagents.total_volume, 1)


		if(affected_mob.reagents)
			var/trans = 0
			if(!infinite)
				trans = reagents.trans_to(affected_mob, amount_per_transfer_from_this, transferred_by = user, methods = INJECT)
			else
				reagents.expose(affected_mob, INJECT, fraction)
				trans = reagents.trans_to(affected_mob, amount_per_transfer_from_this, methods = INJECT, copy_only = TRUE)
			to_chat(user, span_notice("已注入[trans] unit\s 。[reagents.total_volume] unit\s 剩余在[src]中。"))
			log_combat(user, affected_mob, "injected", src, "([contained])")
		return TRUE
	return FALSE


/obj/item/reagent_containers/hypospray/cmo
	volume = 60
	possible_transfer_amounts = list(1,3,5)
	list_reagents = list(/datum/reagent/medicine/omnizine = 30)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

//combat

/obj/item/reagent_containers/hypospray/combat
	name = "战斗兴奋剂注射器"
	desc = "一种改进的空气针式自动注射器，用于支援人员在战斗中快速治疗伤员。"
	amount_per_transfer_from_this = 10
	inhand_icon_state = "combat_hypo"
	icon_state = "combat_hypo"
	volume = 90
	possible_transfer_amounts = list(5,10)
	ignore_flags = 1 // So they can heal their comrades.
	list_reagents = list(/datum/reagent/medicine/epinephrine = 30, /datum/reagent/medicine/omnizine = 30, /datum/reagent/medicine/leporazine = 15, /datum/reagent/medicine/atropine = 15)

/obj/item/reagent_containers/hypospray/combat/empty
	list_reagents = null

/obj/item/reagent_containers/hypospray/combat/nanites
	name = "实验用战斗兴奋剂注射器"
	desc = "一种经过改造的空针自动注射器，适用于战斗场合。预装了实验性医疗纳米机器人及兴奋剂，可实现快速治疗并提升战斗能力。"
	inhand_icon_state = "nanite_hypo"
	icon_state = "nanite_hypo"
	base_icon_state = "nanite_hypo"
	volume = 100
	list_reagents = list(/datum/reagent/medicine/adminordrazine/quantum_heal = 80, /datum/reagent/medicine/synaptizine = 20)

/obj/item/reagent_containers/hypospray/combat/nanites/update_icon_state()
	icon_state = "[base_icon_state][(reagents.total_volume > 0) ? null : 0]"
	return ..()

/obj/item/reagent_containers/hypospray/combat/heresypurge
	name = "圣水穿刺注射器"
	desc = "一种用于战斗情况的改进空气针式自动喷射器。预先装满5剂圣水和安抚剂的混合物。此物品不得用在队友身上。"
	inhand_icon_state = "holy_hypo"
	icon_state = "holy_hypo"
	volume = 250
	possible_transfer_amounts = list(25,50)
	list_reagents = list(/datum/reagent/water/holywater = 150, /datum/reagent/peaceborg/tire = 50, /datum/reagent/peaceborg/confuse = 50)
	amount_per_transfer_from_this = 50

//MediPens

/obj/item/reagent_containers/hypospray/medipen
	name = "肾上腺素医疗笔"
	desc = "一种可以快速而安全地稳定危重病人体征的方案，适用于没有专业医疗知识的人员.含有强效防腐剂，可以延迟尸体的腐败过程，并在过敏反应中阻止身体组织产生组胺."
	icon_state = "medipen"
	inhand_icon_state = "medipen"
	worn_icon_state = "medipen"
	base_icon_state = "medipen"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	amount_per_transfer_from_this = 15
	has_variable_transfer_amount = FALSE
	volume = 15
	ignore_flags = 1 //so you can medipen through spacesuits
	initial_reagent_flags = NONE
	flags_1 = null
	list_reagents = list(/datum/reagent/medicine/epinephrine = 10, /datum/reagent/toxin/formaldehyde = 3, /datum/reagent/medicine/coagulant = 2)
	custom_price = PAYCHECK_CREW
	custom_premium_price = PAYCHECK_COMMAND
	var/label_examine = TRUE
	var/label_text

/obj/item/reagent_containers/hypospray/medipen/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user]开始被\the [src]呛到！看起来[user.p_theyre()]试图自杀！"))
	return OXYLOSS//ironic. he could save others from oxyloss, but not himself.

/obj/item/reagent_containers/hypospray/medipen/inject(mob/living/affected_mob, mob/user)
	. = ..()
	if(. && !reagents.total_volume)
		used_up = TRUE //Makes them useless afterwards
		reagents.flags = NONE
		update_appearance()

/obj/item/reagent_containers/hypospray/medipen/attack_self(mob/user)
	if(user.can_perform_action(src, FORBID_TELEKINESIS_REACH|ALLOW_RESTING))
		inject(user, user)

/obj/item/reagent_containers/hypospray/medipen/update_icon_state()
	icon_state = "[base_icon_state][(reagents.total_volume > 0) ? null : 0]"
	return ..()

/obj/item/reagent_containers/hypospray/medipen/Initialize(mapload)
	. = ..()
	label_text = span_notice("侧面贴着一张标签，上面写着：'警告：此医疗笔含有[pretty_string_from_reagent_list(reagents.reagent_list, names_only = TRUE, join_text = ", ", final_and = TRUE, capitalize_names = TRUE)]，若对所列化学品过敏请勿使用。")

/obj/item/reagent_containers/hypospray/medipen/examine()
	. = ..()
	if (label_examine)
		. += label_text
	if(length(reagents?.reagent_list))
		. += span_notice("它已装载。")
	else
		. += span_notice("它已耗尽。")

/obj/item/reagent_containers/hypospray/medipen/stimpack //goliath kiting
	name = "亢奋笔"
	desc = "快速刺激身体肾上腺素分泌，使穿着束缚性盔甲也能活动自如。"
	icon_state = "stimpen"
	inhand_icon_state = "stimpen"
	base_icon_state = "stimpen"
	volume = 20
	amount_per_transfer_from_this = 20
	list_reagents = list(/datum/reagent/medicine/ephedrine = 10, /datum/reagent/consumable/coffee = 10)

/obj/item/reagent_containers/hypospray/medipen/stimpack/traitor
	desc = "一种改良型兴奋剂自动注射器，适用于战斗情况。具有轻微的治疗效果。"
	list_reagents = list(/datum/reagent/medicine/stimulants = 10, /datum/reagent/medicine/omnizine = 10)
	volume = 20

/obj/item/reagent_containers/hypospray/medipen/stimulants
	name = "兴奋笔"
	desc = "含有非常大量的令人难以置信的强大兴奋剂，在大约5分钟时间内极大地提高你的移动速度，减少眩晕，。孕妇请勿服用。"
	icon_state = "syndipen"
	inhand_icon_state = "tbpen"
	base_icon_state = "syndipen"
	volume = 50
	amount_per_transfer_from_this = 50
	list_reagents = list(/datum/reagent/medicine/stimulants = 50)

/obj/item/reagent_containers/hypospray/medipen/methamphetamine
	name = "甲基苯丙胺医疗笔"
	volume = 24
	amount_per_transfer_from_this = 24
	desc = "含有相对安全的甲基苯丙胺剂量，以及甘露醇以确保将脑损伤降至最低。"
	list_reagents = list(/datum/reagent/drug/methamphetamine = 10, /datum/reagent/medicine/mannitol = 14)

/obj/item/reagent_containers/hypospray/medipen/morphine
	name = "吗啡医疗笔"
	desc = "能让你迅速摆脱困境！不过，你会感到有点昏昏欲睡。"
	icon_state = "morphen"
	inhand_icon_state = "morphen"
	base_icon_state = "morphen"
	list_reagents = list(/datum/reagent/medicine/morphine = 10)
	volume = 10

/obj/item/reagent_containers/hypospray/medipen/oxandrolone
	name = "氧雄龙医疗笔"
	desc = "一种含有氧雄龙的自动注射器，用于治疗严重烧伤."
	icon_state = "oxapen"
	inhand_icon_state = "oxapen"
	base_icon_state = "oxapen"
	list_reagents = list(/datum/reagent/medicine/oxandrolone = 10)
	volume = 10

/obj/item/reagent_containers/hypospray/medipen/penacid
	name = "喷替酸医疗笔"
	desc = "一种含有喷替酸的自动注射器，用于降低高水平的辐射和适量的毒素."
	icon_state = "penacid"
	inhand_icon_state = "penacid"
	base_icon_state = "penacid"
	list_reagents = list(/datum/reagent/medicine/pen_acid = 10)
	volume = 10

/obj/item/reagent_containers/hypospray/medipen/salacid
	name = "水杨酸医疗笔"
	desc = "一种含有水杨酸的自动注射器，用于治疗严重创伤."
	icon_state = "salacid"
	inhand_icon_state = "salacid"
	base_icon_state = "salacid"
	list_reagents = list(/datum/reagent/medicine/sal_acid = 10)
	volume = 10

/obj/item/reagent_containers/hypospray/medipen/salbutamol
	name = "舒喘宁医疗笔"
	desc = "一种含有舒喘宁的自动注射器，用于快速治疗窒息伤."
	icon_state = "salpen"
	inhand_icon_state = "salpen"
	base_icon_state = "salpen"
	list_reagents = list(/datum/reagent/medicine/salbutamol = 10)
	volume = 10

/obj/item/reagent_containers/hypospray/medipen/tuberculosiscure
	name = "BVAK(真菌性结核病疫苗)自动注射器"
	desc = "生物病毒解毒剂套装自动注射器。包含两份使用量，一份供自己使用，一份供他人使用。感染时注射。"
	icon_state = "tbpen"
	inhand_icon_state = "tbpen"
	base_icon_state = "tbpen"
	volume = 20
	amount_per_transfer_from_this = 10
	list_reagents = list(/datum/reagent/vaccine/fungal_tb = 20)

/obj/item/reagent_containers/hypospray/medipen/tuberculosiscure/update_icon_state()
	. = ..()
	if(reagents.total_volume >= volume)
		icon_state = base_icon_state
		return
	icon_state = "[base_icon_state][(reagents.total_volume > 0) ? 1 : 0]"

/obj/item/reagent_containers/hypospray/medipen/survival
	name = "生存急救医疗笔"
	desc = "一种用于恶劣环境中生存的医疗笔，治疗最常见的伤害类型。警告:可能导致器官损伤."
	icon_state = "stimpen"
	inhand_icon_state = "stimpen"
	base_icon_state = "stimpen"
	volume = 30
	amount_per_transfer_from_this = 30
	list_reagents = list( /datum/reagent/medicine/epinephrine = 8, /datum/reagent/medicine/c2/aiuri = 8, /datum/reagent/medicine/c2/libital = 8, /datum/reagent/medicine/leporazine = 6)

/obj/item/reagent_containers/hypospray/medipen/survival/inject(mob/living/affected_mob, mob/user)
	if(lavaland_equipment_pressure_check(get_turf(user)))
		amount_per_transfer_from_this = initial(amount_per_transfer_from_this)
		return ..()

	if(DOING_INTERACTION(user, DOAFTER_SOURCE_SURVIVALPEN))
		to_chat(user,span_notice("你太忙了，无法使用\the [src]！"))
		return

	to_chat(user,span_notice("你开始手动释放低压表..."))
	if(!do_after(user, 10 SECONDS, affected_mob, interaction_key = DOAFTER_SOURCE_SURVIVALPEN))
		return

	amount_per_transfer_from_this = initial(amount_per_transfer_from_this) * 0.5
	return ..()


/obj/item/reagent_containers/hypospray/medipen/survival/luxury
	name = "奢华医疗笔"
	desc = "尖端的蓝空技术使纳米传讯能将60单位的容量压缩进一支医疗笔中。含有用于辅助探索极端恶劣环境的稀有且强效的化学品。警告：请勿与肾上腺素或阿托品混合使用。"
	icon_state = "luxpen"
	inhand_icon_state = "atropen"
	base_icon_state = "luxpen"
	volume = 60
	amount_per_transfer_from_this = 60
	list_reagents = list(/datum/reagent/medicine/salbutamol = 10, /datum/reagent/medicine/c2/penthrite = 10, /datum/reagent/medicine/oxandrolone = 10, /datum/reagent/medicine/sal_acid = 10 ,/datum/reagent/medicine/omnizine = 10 ,/datum/reagent/medicine/leporazine = 10)

/obj/item/reagent_containers/hypospray/medipen/atropine
	name = "阿托品自动注射器"
	desc = "一种将人从重伤状态中快速拯救出来的方法！此外还含有强效凝血剂以防止失血。"
	icon_state = "atropen"
	inhand_icon_state = "atropen"
	base_icon_state = "atropen"
	list_reagents = list(/datum/reagent/medicine/atropine = 10, /datum/reagent/medicine/coagulant = 2)
	volume = 12

/obj/item/reagent_containers/hypospray/medipen/snail
	name = "snail shot-蜗牛药"
	desc = "万能蜗牛药！请勿用于非蜗牛动物！"
	icon_state = "snail"
	inhand_icon_state = "snail"
	base_icon_state = "snail"
	list_reagents = list(/datum/reagent/snail = 10)
	label_examine = FALSE
	volume = 10

/obj/item/reagent_containers/hypospray/medipen/magillitis
	name = "实验性自动注射器"
	desc = "一种定制框架的自动注射器，带有一次性小型储液器，内含实验性血清.与更常见的医疗笔不同，它无法穿透装甲或太空服，也无法提取内部的化学物质."
	icon_state = "gorillapen"
	inhand_icon_state = "gorillapen"
	base_icon_state = "gorillapen"
	volume = 5
	ignore_flags = 0
	list_reagents = list(/datum/reagent/magillitis = 5)

/obj/item/reagent_containers/hypospray/medipen/pumpup
	name = "维修兴奋剂"
	desc = "一个看起来像贫民区的自动注射器，里面装满了廉价的肾上腺素注射剂，对于摆脱警棍的影响非常有用。"
	volume = 15
	amount_per_transfer_from_this = 15
	list_reagents = list(/datum/reagent/drug/pumpup = 15)
	icon_state = "maintenance"
	base_icon_state = "maintenance"
	label_examine = FALSE

/obj/item/reagent_containers/hypospray/medipen/ekit
	name = "紧急急救自动注射器"
	desc = "一支含有额外凝血剂和抗生素的肾上腺素医疗笔，能够帮助稳定严重的创伤和烧伤."
	icon_state = "firstaid"
	base_icon_state = "firstaid"
	volume = 15
	amount_per_transfer_from_this = 15
	list_reagents = list(/datum/reagent/medicine/epinephrine = 12, /datum/reagent/medicine/coagulant = 2.5, /datum/reagent/medicine/spaceacillin = 0.5)

/obj/item/reagent_containers/hypospray/medipen/blood_loss
	name = "低血容应答自动注射器"
	desc = "一种用于稳定和快速逆转严重失血的医疗笔。"
	icon_state = "hypovolemic"
	base_icon_state = "hypovolemic"
	volume = 15
	amount_per_transfer_from_this = 15
	list_reagents = list(/datum/reagent/medicine/epinephrine = 5, /datum/reagent/medicine/coagulant = 2.5, /datum/reagent/iron = 3.5, /datum/reagent/medicine/salglu_solution = 4)

/obj/item/reagent_containers/hypospray/medipen/mutadone
	name = "突变定自动注射器"
	desc = "一种突变矫正素医疗笔，用于在一个注射器中辅助治愈基因错误。"
	icon_state = "penacid"
	inhand_icon_state = "penacid"
	base_icon_state = "penacid"
	volume = 15
	amount_per_transfer_from_this = 15
	list_reagents = list(/datum/reagent/medicine/mutadone = 15)

/obj/item/reagent_containers/hypospray/medipen/penthrite
	name = "季戊四醇四硝酸酯自动注射器"
	desc = "实验性心脏药物。"
	icon_state = "atropen"
	inhand_icon_state = "atropen"
	base_icon_state = "atropen"
	list_reagents = list(/datum/reagent/medicine/c2/penthrite = 10)
	volume = 10
