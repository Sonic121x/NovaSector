/* Backpacks
 * Contains:
 * Backpack
 * Backpack Types
 * Satchel Types
 */

/*
 * Backpack
 */

/obj/item/storage/backpack
	name = "背包"
	desc = "你把它背在背上，然后把东西放进去。"
	icon = 'icons/obj/storage/backpack.dmi'
	worn_icon = 'icons/mob/clothing/back/backpack.dmi'
	icon_state = "backpack"
	inhand_icon_state = "backpack"
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK //ERROOOOO
	resistance_flags = NONE
	max_integrity = 300
	storage_type = /datum/storage/backpack
	pickup_sound = 'sound/items/handling/backpack/backpack_pickup1.ogg'
	drop_sound = 'sound/items/handling/backpack/backpack_drop1.ogg'
	equip_sound = 'sound/items/equip/backpack_equip.ogg'
	sound_vary = TRUE

/obj/item/storage/backpack/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/attack_equip)

/*
 * Backpack Types
 */

/obj/item/bag_of_holding_inert
	name = "惰性次元袋"
	desc = "目前这只是一个笨重的金属块，上面有个插槽，随时可以接入蓝空异常核心。"
	icon = 'icons/obj/storage/backpack.dmi'
	worn_icon = 'icons/mob/clothing/back/backpack.dmi'
	icon_state = "bag_of_holding-inert"
	inhand_icon_state = "brokenpack"
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = FIRE_PROOF
	item_flags = NO_MAT_REDEMPTION

/obj/item/bag_of_holding_inert/Initialize(mapload)
	. = ..()
	var/static/list/recipes = list(/datum/crafting_recipe/boh)
	AddElement(/datum/element/slapcrafting, recipes)

/obj/item/storage/backpack/holding
	name = "次元袋"
	desc = "一个能打开通往局部蓝空口袋的背包。"
	icon_state = "bag_of_holding"
	inhand_icon_state = "holdingpack"
	resistance_flags = FIRE_PROOF
	item_flags = NO_MAT_REDEMPTION | BLUESPACE_INTERFERENCE
	armor_type = /datum/armor/backpack_holding
	storage_type = /datum/storage/bag_of_holding
	pickup_sound = null
	drop_sound = null

/datum/armor/backpack_holding
	fire = 60
	acid = 50

/obj/item/storage/backpack/holding/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]正跳进[src]！看起来[user.p_theyre()]想自杀。"))
	user.dropItemToGround(src, TRUE)
	user.Stun(100, ignore_canstun = TRUE)
	sleep(2 SECONDS)
	playsound(src, SFX_RUSTLE, 50, TRUE, -5)
	user.suicide_log()
	qdel(user)


/obj/item/storage/backpack/santabag
	name = "圣诞老人的礼物袋"
	desc = "太空圣诞老人用这个在圣诞节给太空里所有乖孩子送礼物！哇，它可真大！"
	icon_state = "giftbag0"
	inhand_icon_state = "giftbag"
	w_class = WEIGHT_CLASS_BULKY
	storage_type = /datum/storage/backpack/santabag

/obj/item/storage/backpack/santabag/Initialize(mapload)
	. = ..()
	regenerate_presents()

/obj/item/storage/backpack/santabag/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user]把[src]套在[user.p_their()]头上并拉紧！看起来[user.p_they()][user.p_are()]没有圣诞精神……"))
	return OXYLOSS

/obj/item/storage/backpack/santabag/proc/regenerate_presents()
	addtimer(CALLBACK(src, PROC_REF(regenerate_presents)), 30 SECONDS)

	var/mob/user = get(loc, /mob)
	if(!istype(user))
		return
	if(HAS_MIND_TRAIT(user, TRAIT_CANNOT_OPEN_PRESENTS))
		var/turf/floor = get_turf(src)
		var/obj/item/thing = new /obj/item/gift/anything(floor)
		if(!atom_storage.attempt_insert(thing, user, override = TRUE, force = STORAGE_SOFT_LOCKED))
			qdel(thing)


/obj/item/storage/backpack/cultpack
	name = "战利品架"
	desc = "它既能用来携带额外装备，也能自豪地宣告你的疯狂。"
	icon_state = "backpack-cult"
	inhand_icon_state = "backpack"
	alternate_worn_layer = ABOVE_BODY_FRONT_HEAD_LAYER

/obj/item/storage/backpack/clown
	name = "咯咯笑·冯·轰克顿"
	desc = "这是一个由Honk!公司制造的背包。"
	icon_state = "backpack-clown"
	inhand_icon_state = "clownpack"

/obj/item/storage/backpack/explorer
	name = "探险者背包"
	desc = "一个坚固的背包，用于存放你的战利品。"
	icon_state = "backpack-explorer"
	inhand_icon_state = "explorerpack"

/obj/item/storage/backpack/mime
	name = "Parcel Parceaux"
	desc = "为那些沉默的工人设计的无声背包。Silence公司出品。"
	icon_state = "backpack-mime"
	inhand_icon_state = "mimepack"

/obj/item/storage/backpack/medic
	name = "医疗背包"
	desc = "这是一个专为无菌环境使用而设计的背包。"
	icon_state = "backpack-medical"
	inhand_icon_state = "medicalpack"

/obj/item/storage/backpack/chief_medic
	name = "首席医疗官的背包"
	desc = "一个口袋刚好够装下首席医疗官装备的背包。"
	icon_state = "backpack-chiefmedical"
	inhand_icon_state = "medicalpack"

/obj/item/storage/backpack/coroner
	name = "验尸官背包"
	desc = "这是一个专为不死生物环境使用而设计的背包。"
	icon_state = "backpack-coroner"
	inhand_icon_state = "coronerpack"

/obj/item/storage/backpack/security
	name = "安保背包"
	desc = "这是一个非常坚固的背包。"
	icon_state = "backpack-security"
	inhand_icon_state = "securitypack"

/obj/item/storage/backpack/captain
	name = "船长的背包"
	desc = "这是一个专为纳米特拉森军官制造的特别背包。"
	icon_state = "backpack-captain"
	inhand_icon_state = "captainpack"

/obj/item/storage/backpack/industrial
	name = "工业背包"
	desc = "这是一个为空间站日常苦差事准备的耐用背包。"
	icon_state = "backpack-engineering"
	inhand_icon_state = "engiepack"
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/botany
	name = "植物学背包"
	desc = "这是一个由全天然纤维制成的背包。"
	icon_state = "backpack-hydroponics"
	inhand_icon_state = "botpack"

/obj/item/storage/backpack/chemistry
	name = "化学背包"
	desc = "一款专门设计用于防污渍和危险液体的背包。"
	icon_state = "backpack-chemistry"
	inhand_icon_state = "chempack"

/obj/item/storage/backpack/genetics
	name = "遗传学背包"
	desc = "一款设计得超级坚固的包，以防有人对你绿巨人化。"
	icon_state = "backpack-genetics"
	inhand_icon_state = "genepack"

/obj/item/storage/backpack/science
	name = "科学背包"
	desc = "一款特别设计的背包。它防火，并带有一丝等离子体的气味。"
	icon_state = "backpack-science"
	inhand_icon_state = "scipack"

/obj/item/storage/backpack/virology
	name = "病毒学背包"
	desc = "一款由低过敏性纤维制成的背包。它旨在帮助防止疾病传播。闻起来像猴子。"
	icon_state = "backpack-virology"
	inhand_icon_state = "viropack"

/obj/item/storage/backpack/floortile
	name = "地砖背包"
	desc = "这是一款专为地砖使用而设计的背包..."
	icon_state = "floortile_backpack"
	inhand_icon_state = "backpack"

/obj/item/storage/backpack/ert
	name = "应急响应队指挥官背包"
	desc = "一款宽敞、带多个口袋的背包，由应急响应队的指挥官佩戴。"
	icon_state = "ert_commander"
	inhand_icon_state = "securitypack"
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/ert/security
	name = "应急响应队安保背包"
	desc = "一款宽敞、带多个口袋的背包，由应急响应队的安保官员佩戴。"
	icon_state = "ert_security"

/obj/item/storage/backpack/ert/medical
	name = "应急响应队医疗背包"
	desc = "一款宽敞、带多个口袋的背包，由应急响应队的医疗官员佩戴。"
	icon_state = "ert_medical"

/obj/item/storage/backpack/ert/engineer
	name = "应急响应队工程师背包"
	desc = "一款宽敞、带多个口袋的背包，由应急响应队的工程师佩戴。"
	icon_state = "ert_engineering"

/obj/item/storage/backpack/ert/janitor
	name = "应急响应队清洁工背包"
	desc = "一款宽敞、带多个口袋的背包，由应急响应队的清洁工佩戴。"
	icon_state = "ert_janitor"

/obj/item/storage/backpack/ert/clown
	name = "应急响应队小丑背包"
	desc = "一个宽敞的背包，带有许多口袋，由应急响应队的小丑穿着。"
	icon_state = "ert_clown"

/obj/item/storage/backpack/saddlepack
	name = "鞍囊"
	desc = "一种设计用于驮在坐骑上或背在背上的背包，并能随时在两者间切换。它相当宽敞，代价是让你感觉自己像一头真正的驮兽。"
	icon = 'icons/obj/storage/ethereal.dmi'
	worn_icon = 'icons/mob/clothing/back/ethereal.dmi'
	icon_state = "saddlepack"
	storage_type = /datum/storage/backpack/saddle

// MEAT MEAT MEAT MEAT MEAT

/obj/item/storage/backpack/meat
	name = "\improper 肉"
	desc = "肉 肉 肉 肉 肉 肉"
	icon_state = "meatmeatmeat"
	inhand_icon_state = "meatmeatmeat"
	force = 15
	throwforce = 15
	material_flags = MATERIAL_EFFECTS | MATERIAL_AFFECT_STATISTICS
	attack_verb_continuous = list("MEATS", "MEAT MEATS")
	attack_verb_simple = list("MEAT", "MEAT MEAT")
	custom_materials = list(/datum/material/meat = SHEET_MATERIAL_AMOUNT * 15) // MEAT
	///Sounds used in the squeak component
	var/list/meat_sounds = list('sound/effects/blob/blobattack.ogg' = 1)
	///Reagents added to the edible component on top of the meat material, ingested when you EAT the MEAT
	var/list/meat_reagents = list(
		/datum/reagent/consumable/nutriment/vitamin = 15,
	)
	///Eating verbs when consuming the MEAT
	var/list/eatverbs = list("MEAT", "absorb", "gnaw", "consume")

/obj/item/storage/backpack/meat/Initialize(mapload)
	. = ..()
	AddComponentFrom(
		SOURCE_EDIBLE_INNATE, \
		/datum/component/edible,\
		initial_reagents = meat_reagents,\
		tastes = list("meat" = 1),\
		eatverbs = eatverbs,\
	)

	AddComponent(/datum/component/squeak, meat_sounds)

/obj/item/storage/backpack/meat/change_material_strength(datum/material/material, mat_amount, multiplier, remove)
	// Our base 15 force includes the implied meat force
	if (!istype(material, /datum/material/meat))
		return ..()

/*
 * Satchel Types
 */

/obj/item/storage/backpack/satchel
	name = "挎包"
	desc = "一款看起来时髦的挎包。"
	icon_state = "satchel-norm"
	inhand_icon_state = "satchel-norm"

/obj/item/storage/backpack/satchel/leather
	name = "皮革挎包"
	desc = "这是一款用优质皮革制成的非常精致的挎包。"
	icon_state = "satchel-leather"
	inhand_icon_state = "satchel"

/obj/item/storage/backpack/satchel/leather/withwallet/PopulateContents()
	new /obj/item/storage/wallet/random(src)

/obj/item/storage/backpack/satchel/fireproof
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/satchel/eng
	name = "工业挎包"
	desc = "一个带有额外口袋的耐用挎包。"
	icon_state = "satchel-engineering"
	inhand_icon_state = "satchel-eng"
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/satchel/med
	name = "医疗挎包"
	desc = "医疗部门使用的无菌挎包。"
	icon_state = "satchel-medical"
	inhand_icon_state = "satchel-med"

/obj/item/storage/backpack/satchel/chief_medic
	name = "首席医疗官的挎包"
	desc = "一个口袋勉强够装下首席医疗官装备的挎包。"
	icon_state = "satchel-chiefmedical"
	inhand_icon_state = "satchel-med"

/obj/item/storage/backpack/satchel/vir
	name = "病毒学家挎包"
	desc = "带有病毒学家颜色的无菌挎包。"
	icon_state = "satchel-virology"
	inhand_icon_state = "satchel-vir"

/obj/item/storage/backpack/satchel/chem
	name = "化学家挎包"
	desc = "带有化学家颜色的无菌挎包。"
	icon_state = "satchel-chemistry"
	inhand_icon_state = "satchel-chem"

/obj/item/storage/backpack/satchel/coroner
	name = "验尸官挎包"
	desc = "一个用来装运人体残骸的挎包。"
	icon_state = "satchel-coroner"
	inhand_icon_state = "satchel-coroner"

/obj/item/storage/backpack/satchel/gen
	name = "遗传学家挎包"
	desc = "一个带有遗传学家颜色的无菌挎包。"
	icon_state = "satchel-genetics"
	inhand_icon_state = "satchel-gen"

/obj/item/storage/backpack/satchel/science
	name = "科学家挎包"
	desc = "用于存放研究材料。"
	icon_state = "satchel-science"
	inhand_icon_state = "satchel-sci"

/obj/item/storage/backpack/satchel/hyd
	name = "植物学家挎包"
	desc = "一个由全天然纤维制成的挎包。"
	icon_state = "satchel-hydroponics"
	inhand_icon_state = "satchel-hyd"

/obj/item/storage/backpack/satchel/sec
	name = "安保挎包"
	desc = "一个用于满足安保相关需求的坚固挎包。"
	icon_state = "satchel-security"
	inhand_icon_state = "satchel-sec"

/obj/item/storage/backpack/satchel/explorer
	name = "探险家挎包"
	desc = "一个用于藏匿战利品的坚固挎包。"
	icon_state = "satchel-explorer"
	inhand_icon_state = "satchel-explorer"

/obj/item/storage/backpack/satchel/cap
	name = "船长挎包"
	desc = "专为纳米特拉森军官设计的独家挎包。"
	icon_state = "satchel-captain"
	inhand_icon_state = "satchel-cap"

/obj/item/storage/backpack/satchel/flat
	name = "走私者挎包"
	desc = "一个非常纤薄的挎包，可以轻松放入狭窄空间。其内容物无法被违禁品扫描仪检测到。"
	icon_state = "satchel-flat"
	inhand_icon_state = "satchel-flat"
	w_class = WEIGHT_CLASS_NORMAL //Can fit in backpacks itself.
	storage_type = /datum/storage/backpack/satchel_flat

/obj/item/storage/backpack/satchel/flat/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/undertile, TRAIT_T_RAY_VISIBLE, INVISIBILITY_MAXIMUM, use_anchor = TRUE) // NOVA EDIT CHANGE - Original: AddElement(/datum/element/undertile, TRAIT_T_RAY_VISIBLE, INVISIBILITY_OBSERVER, use_anchor = TRUE)
	ADD_TRAIT(src, TRAIT_CONTRABAND_BLOCKER, INNATE_TRAIT)

/obj/item/storage/backpack/satchel/flat/PopulateContents()
	for(var/items in 1 to 4)
		new /obj/effect/spawner/random/contraband(src)

/obj/item/storage/backpack/satchel/flat/with_tools/PopulateContents()
	new /obj/item/stack/tile/iron/base(src)
	new /obj/item/crowbar(src)

	..()

/obj/item/storage/backpack/satchel/flat/empty/PopulateContents()
	return


/// Messenger Bag Types
/obj/item/storage/backpack/messenger
	name = "邮差包"
	desc = "一款时尚的邮差包；有时也称为信使包。既时尚又便携。"
	icon_state = "messenger"
	inhand_icon_state = "messenger"
	icon = 'icons/obj/storage/backpack.dmi'
	worn_icon = 'icons/mob/clothing/back/backpack.dmi'
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'

/obj/item/storage/backpack/messenger/eng
	name = "工业邮差包"
	desc = "一个由先进处理皮革制成的坚固邮差包，具有防火功能。它也比通常有更多的口袋。"
	icon_state = "messenger_engineering"
	inhand_icon_state = "messenger_engineering"
	resistance_flags = FIRE_PROOF

/obj/item/storage/backpack/messenger/med
	name = "医疗邮差包"
	desc = "一款无菌邮差包，因其便携性和流线型外观深受医疗人员喜爱。"
	icon_state = "messenger_medical"
	inhand_icon_state = "messenger_medical"

/obj/item/storage/backpack/messenger/chief_medic
	name = "首席医疗官的邮差包"
	desc = "一款纤薄的邮差包，深受首席医疗官青睐，因为它在工作时不会碍事——不像他们的药剂师那样。"
	icon_state = "messenger_chiefmedical"
	inhand_icon_state = "messenger_medical"

/obj/item/storage/backpack/messenger/vir
	name = "病毒学家邮差包"
	desc = "一款带有病毒学家配色的无菌邮差包，有助于以创纪录的速度部署生物危害物。"
	icon_state = "messenger_virology"
	inhand_icon_state = "messenger_virology"

/obj/item/storage/backpack/messenger/chem
	name = "药剂师邮差包"
	desc = "一款带有药剂师配色的无菌邮差包，适合准时赴约进行小巷交易。"
	icon_state = "messenger_chemistry"
	inhand_icon_state = "messenger_chemistry"

/obj/item/storage/backpack/messenger/coroner
	name = "验尸官邮差包"
	desc = "一款用于快速悄悄溜出墓地的邮差包。"
	icon_state = "messenger_coroner"
	inhand_icon_state = "messenger_coroner"

/obj/item/storage/backpack/messenger/gen
	name = "遗传学家邮差包"
	desc = "一款带有遗传学家配色的无菌邮差包，对绿巨人来说是个相当可爱的配饰。"
	icon_state = "messenger_genetics"
	inhand_icon_state = "messenger_genetics"

/obj/item/storage/backpack/messenger/science
	name = "科学家邮差包"
	desc = "可用于存放研究材料，并帮助你快速前往不同的扫描目标。"
	icon_state = "messenger_science"
	inhand_icon_state = "messenger_science"

/obj/item/storage/backpack/messenger/hyd
	name = "植物学家邮差包"
	desc = "一款由全天然纤维制成的邮差包，非常适合准时参加聚会。"
	icon_state = "messenger_hydroponics"
	inhand_icon_state = "messenger_hydroponics"

/obj/item/storage/backpack/messenger/sec
	name = "安保邮差包"
	desc = "一款坚固的邮差包，满足安保相关需求。"
	icon_state = "messenger_security"
	inhand_icon_state = "messenger_security"

/obj/item/storage/backpack/messenger/explorer
	name = "探险家邮差包"
	desc = "一款坚固的邮差包，用于存放你的战利品，同时也是你龙骨盔甲上一个相当可爱的配饰。"
	icon_state = "messenger_explorer"
	inhand_icon_state = "messenger_explorer"

/obj/item/storage/backpack/messenger/cap
	name = "船长的邮差包"
	desc = "一款专为纳米特拉森军官设计的独家信使包，采用真正的鲸鱼皮革制成。"
	icon_state = "messenger_captain"
	inhand_icon_state = "messenger_captain"

/obj/item/storage/backpack/messenger/clown
	name = "咯咯·冯·霍克顿二世"
	desc = "The latest in storage 'technology' from Honk Co. Hey, how does this fit so much with such a small profile anyway? The wearer will definitely never tell you."
	icon_state = "messenger_clown"
	inhand_icon_state = "messenger_clown"
