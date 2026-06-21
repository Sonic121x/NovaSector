/*
 * Job related
 */

//Botanist
/obj/item/clothing/suit/apron
	name = "围裙"
	desc = "一条普通的蓝色围裙。"
	icon_state = "apron"
	icon = 'icons/obj/clothing/suits/utility.dmi'
	worn_icon = 'icons/mob/clothing/suits/utility.dmi'
	inhand_icon_state = null
	blood_overlay_type = "armor"
	body_parts_covered = CHEST|GROIN
	allowed = list(
		/obj/item/cultivator,
		/obj/item/geneshears,
		/obj/item/graft,
		/obj/item/hatchet,
		/obj/item/plant_analyzer,
		/obj/item/reagent_containers/cup/beaker,
		/obj/item/reagent_containers/cup/bottle,
		/obj/item/reagent_containers/cup/tube,
		/obj/item/reagent_containers/spray/pestspray,
		/obj/item/reagent_containers/spray/plantbgone,
		/obj/item/secateurs,
		/obj/item/seeds,
		/obj/item/storage/bag/plants,
		/obj/item/tank/internals/emergency_oxygen,
	)
	species_exception = list(/datum/species/golem)
	armor_type = /datum/armor/suit_apron

/datum/armor/suit_apron
	bio = 50

/obj/item/clothing/suit/apron/waders
	name = "园艺防水靴"
	desc = "一双重型皮革防水靴，完美地将你柔软的肉体与尖刺、泥土和荆棘隔绝开来."
	icon_state = "hort_waders"
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|LEGS

/obj/item/clothing/suit/apron/overalls
	name = "连体工作服"
	desc = "一套连体工作服，适合保护较薄的衣服免受环境影响。"
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/apron/overalls"
	post_init_icon_state = "overalls"
	inhand_icon_state = ""
	body_parts_covered = CHEST|GROIN|LEGS
	gender = PLURAL
	species_exception = list(/datum/species/golem)
	greyscale_config = /datum/greyscale_config/overalls
	greyscale_config_worn = /datum/greyscale_config/overalls/worn
	greyscale_colors = "#313c6e"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/suit/apron/overalls/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -4)

//Captain
/obj/item/clothing/suit/jacket/capjacket
	name = "舰长检阅夹克"
	desc = "舰长为展示他们的身份而穿。"
	icon_state = "capjacket"
	inhand_icon_state = "bio_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	allowed = list(
		/obj/item/assembly/flash/handheld,
		/obj/item/cigarette,
		/obj/item/disk,
		/obj/item/lighter,
		/obj/item/melee,
		/obj/item/reagent_containers/cup/glass/flask,
		/obj/item/stamp,
		/obj/item/storage/box/matches,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/storage/lockbox/medal,
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/tank/internals/plasmaman,
	)

//Chef
/obj/item/clothing/suit/toggle/chef
	name = "主厨围裙"
	desc = "高级厨师用的围裙。"
	icon_state = "chef"
	inhand_icon_state = "chef"
	icon = 'icons/obj/clothing/suits/jacket.dmi'
	worn_icon = 'icons/mob/clothing/suits/jacket.dmi'
	armor_type = /datum/armor/toggle_chef
	body_parts_covered = CHEST|GROIN|ARMS
	allowed = list(
		/obj/item/kitchen,
		/obj/item/knife/kitchen,
		/obj/item/storage/bag/tray,
	)
	toggle_noun = "sleeves"
	species_exception = list(/datum/species/golem)

//Cook
/datum/armor/toggle_chef
	bio = 50

/obj/item/clothing/suit/apron/chef
	name = "厨师围裙"
	desc = "一条普通的、颜色单调的白色主厨围裙。"
	icon_state = "apronchef"
	inhand_icon_state = null
	blood_overlay_type = "armor"
	body_parts_covered = CHEST|GROIN
	allowed = list(
		/obj/item/kitchen,
		/obj/item/knife/kitchen,
		/obj/item/storage/bag/tray,
	)

//Detective
/obj/item/clothing/suit/toggle/jacket/det_trench
	name = "棕色风衣"
	desc = "18世纪的多功能风衣。穿这个的人一定是在干正经活。"
	icon_state = "det_trenchcoat"
	inhand_icon_state = "det_suit"
	blood_overlay_type = "coat"
	armor_type = /datum/armor/jacket_det_suit
	flags_inv = HIDEBELT

/datum/armor/jacket_det_suit
	melee = 25
	bullet = 10
	laser = 25
	energy = 35
	acid = 45

/obj/item/clothing/suit/toggle/jacket/det_trench/Initialize(mapload)
	. = ..()
	allowed = GLOB.detective_vest_allowed

/obj/item/clothing/suit/toggle/jacket/det_trench/noir
	name = "黑色风衣"
	desc = "一件冷硬的私家侦探黑色风衣。"
	icon_state = "noir_trenchcoat"
	inhand_icon_state = null

/obj/item/clothing/suit/jacket/det_suit
	name = "棕色西装外套"
	desc = "一件非常适合约会晚餐和刑事调查的西装外套。"
	icon_state = "det_blazer"
	armor_type = /datum/armor/jacket_det_suit
	inhand_icon_state = null

/obj/item/clothing/suit/jacket/det_suit/Initialize(mapload)
	. = ..()
	allowed = GLOB.detective_vest_allowed

/obj/item/clothing/suit/jacket/det_suit/noir
	name = "黑色电影风格西装外套"
	desc = "一位时髦私家侦探的深色西装外套。"
	icon_state = "noir_blazer"

/obj/item/clothing/suit/jacket/det_suit/kim
	name = "航空轰炸手夹克"
	desc = "革命航空旅在百年革命期间穿过的夹克。里面有很多口袋，主要用来放笔记本和指南针。"
	icon_state = "aerostatic_bomber_jacket"

/obj/item/clothing/suit/jacket/det_suit/disco
	name = "disco背带夹克"
	desc = "看起来这件衣服是由早已灭绝的disco动物的皮料制作而成。背面和右袖上有一个神秘的白色矩形。"
	icon_state = "jamrock_blazer"

//Engineering
/obj/item/clothing/suit/hazardvest
	name = "工作背心"
	desc = "在工作区域使用的高能见度背心。"
	icon_state = "hazard"
	icon = 'icons/obj/clothing/suits/utility.dmi'
	worn_icon = 'icons/mob/clothing/suits/utility.dmi'
	inhand_icon_state = null
	blood_overlay_type = "armor"
	allowed = list(
		/obj/item/fireaxe/metal_h2_axe,
		/obj/item/flashlight,
		/obj/item/radio,
		/obj/item/storage/bag/construction,
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/tank/internals/plasmaman,
		/obj/item/t_scanner,
		/obj/item/gun/ballistic/rifle/boltaction/pipegun,
		/obj/item/storage/bag/rebar_quiver,
		/obj/item/gun/ballistic/rifle/rebarxbow,
	)
	resistance_flags = NONE
	species_exception = list(/datum/species/golem)

/obj/item/clothing/suit/hazardvest/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(!isinhands)
		. += emissive_appearance(icon_file, "[icon_state]-emissive", src, alpha = src.alpha, effect_type = EMISSIVE_SPECULAR)

/obj/item/clothing/suit/hazardvest/press // Variant used by the Curator
	name = "记者反光背心"
	desc = "一件蓝色的高能见度背心，用于区分<i>非战斗人员</i>的“记者”成员，好像有人在乎似的。"
	icon_state = "hazard_press"

//Lawyer
/obj/item/clothing/suit/toggle/lawyer
	name = "蓝色正式西装外套"
	desc = "一件职业性的西装外套。"
	icon_state = "suitjacket_blue"
	icon = 'icons/obj/clothing/suits/jacket.dmi'
	worn_icon = 'icons/mob/clothing/suits/jacket.dmi'
	inhand_icon_state = null
	blood_overlay_type = "coat"
	body_parts_covered = CHEST|ARMS
	species_exception = list(/datum/species/golem)
	clothing_flags = parent_type::clothing_flags | CARP_STYLE_FACTOR

/obj/item/clothing/suit/toggle/lawyer/purple
	name = "紫色正式西装外套"
	icon_state = "suitjacket_purp"
	inhand_icon_state = null

/obj/item/clothing/suit/toggle/lawyer/black
	name = "黑色正式西装外套"
	icon_state = "suitjacket_black"
	inhand_icon_state = "ro_suit"

// Cargo

/obj/item/clothing/suit/toggle/cargo_tech
	name = "货运戈尔卡夹克"
	desc = "一件棕黑相间的蓬松夹克；由合成面料制成。灵感源自古老的东欧设计。"
	icon_state = "cargo_jacket"
	icon = 'icons/obj/clothing/suits/jacket.dmi'
	worn_icon = 'icons/mob/clothing/suits/jacket.dmi'
	inhand_icon_state = null
	blood_overlay_type = "coat"
	body_parts_covered = CHEST|ARMS
	allowed = list(
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/tank/internals/plasmaman,
		/obj/item/boxcutter,
		/obj/item/dest_tagger,
		/obj/item/stamp,
		/obj/item/storage/bag/mail,
		/obj/item/universal_scanner,
	)

// Quartermaster

/obj/item/clothing/suit/jacket/quartermaster
	name = "物资处长的长大衣"
	desc = "一件奢华的棕色双排扣长大衣，由袋鼠皮制成。其金色袖口相互连接，并设计成信用点符号的样式。它让你感觉自己比实际可能的重要得多。"
	icon_state = "qm_coat"
	blood_overlay_type = "coat"
	body_parts_covered = CHEST|GROIN|LEGS|ARMS

/obj/item/clothing/suit/jacket/quartermaster/Initialize(mapload)
	. = ..()
	allowed += list(
		/obj/item/stamp,
		/obj/item/storage/bag/mail,
		/obj/item/universal_scanner,
		/obj/item/melee/baton/telescopic,
	)

/obj/item/clothing/suit/toggle/lawyer/greyscale
	name = "正式西装外套"
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/toggle/lawyer/greyscale"
	post_init_icon_state = "jacket_lawyer"
	inhand_icon_state = ""
	greyscale_config = /datum/greyscale_config/jacket_lawyer
	greyscale_config_worn = /datum/greyscale_config/jacket_lawyer/worn
	greyscale_colors = "#ffffff"
	flags_1 = IS_PLAYER_COLORABLE_1

//Mime
/obj/item/clothing/suit/toggle/suspenders
	name = "吊带裤"
	desc = "他们中止了默剧表演的幻觉。"
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/toggle/suspenders"
	post_init_icon_state = "suspenders"
	worn_icon = 'icons/mob/clothing/suits/utility.dmi'
	worn_icon_state = "suspenders"
	blood_overlay_type = "armor" //it's the less thing that I can put here
	toggle_noun = "straps"
	species_exception = list(/datum/species/golem)
	greyscale_config = /datum/greyscale_config/suspenders
	greyscale_config_worn = /datum/greyscale_config/suspenders/worn
	greyscale_colors = "#972A2A"
	flags_1 = IS_PLAYER_COLORABLE_1

//Security
/obj/item/clothing/suit/jacket/officer/blue
	name = "安保人员夹克"
	desc = "这件夹克是为那些不需要安保人员穿盔甲的特殊场合准备的。"
	icon_state = "officerbluejacket"
	inhand_icon_state = null
	body_parts_covered = CHEST|ARMS

/obj/item/clothing/suit/jacket/officer/tan
	name = "安保人员夹克"
	desc = "这件夹克是为那些不需要安保人员穿盔甲的特殊场合准备的。"
	icon_state = "officertanjacket"
	inhand_icon_state = null
	body_parts_covered = CHEST|ARMS

/obj/item/clothing/suit/jacket/warden/blue
	name = "典狱长的夹克"
	desc = "非常适合想给参观禁闭室的人留下有格调印象的典狱长。"
	icon_state = "wardenbluejacket"
	inhand_icon_state = null
	body_parts_covered = CHEST|ARMS

/obj/item/clothing/suit/jacket/warden/tan
	name = "典狱长的夹克"
	desc = "非常适合想给参观禁闭室的人留下有格调印象的典狱长。"
	icon_state = "wardentanjacket"
	inhand_icon_state = null
	body_parts_covered = CHEST|ARMS

/obj/item/clothing/suit/jacket/hos/blue
	name = "安保部长夹克"
	desc = "这件衣服是专门为维护上级权威而设计的。"
	icon_state = "hosbluejacket"
	inhand_icon_state = null
	body_parts_covered = CHEST|ARMS

/obj/item/clothing/suit/jacket/hos/tan
	name = "安保部长夹克"
	desc = "这件衣服是专门为维护上级权威而设计的。"
	icon_state = "hostanjacket"
	inhand_icon_state = null
	body_parts_covered = CHEST|ARMS

//Surgeon
/obj/item/clothing/suit/apron/surgical
	name = "手术围裙"
	desc = "一条无菌的蓝色外科围裙。"
	icon_state = "surgical"
	allowed = list(
		/obj/item/bonesetter,
		/obj/item/cautery,
		/obj/item/defibrillator/compact,
		/obj/item/flashlight/pen,
		/obj/item/healthanalyzer,
		/obj/item/hemostat,
		/obj/item/reagent_containers/cup/beaker,
		/obj/item/reagent_containers/cup/bottle,
		/obj/item/reagent_containers/cup/tube,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/hypospray,
		/obj/item/reagent_containers/syringe,
		/obj/item/retractor,
		/obj/item/scalpel,
		/obj/item/storage/pill_bottle,
		/obj/item/surgical_drapes,
		/obj/item/tank/internals/emergency_oxygen,
	)

/obj/item/clothing/suit/apron/surgical/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -3) // FISH DOCTOR?!

//Curator
/obj/item/clothing/suit/jacket/curator
	name = "赏金猎手大衣"
	desc = "这款夹克既时尚又轻巧的装甲，深受银河各地赏金猎手的喜爱。"
	icon_state = "curator"
	inhand_icon_state = null
	blood_overlay_type = "coat"
	body_parts_covered = CHEST|ARMS
	allowed = list(
		/obj/item/melee/curator_whip,
		/obj/item/storage/bag/books,
		/obj/item/tank/internals,
	)
	armor_type = /datum/armor/jacket_curator
	cold_protection = CHEST|ARMS
	heat_protection = CHEST|ARMS

/datum/armor/jacket_curator
	melee = 25
	bullet = 10
	laser = 25
	energy = 35
	acid = 45

//Robotocist
/obj/item/clothing/suit/hooded/techpriest
	name = "机械长袍"
	desc = "给那些真的爱烤面包机的人."
	icon_state = "techpriest"
	icon = 'icons/obj/clothing/suits/costume.dmi'
	worn_icon = 'icons/mob/clothing/suits/costume.dmi'
	inhand_icon_state = null
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	hoodtype = /obj/item/clothing/head/hooded/techpriest

/obj/item/clothing/head/hooded/techpriest
	name = "机械兜帽"
	icon = 'icons/obj/clothing/head/costume.dmi'
	worn_icon = 'icons/mob/clothing/head/costume.dmi'
	desc = "一个给那些真的爱烤面包机的人的兜帽."
	icon_state = "techpriesthood"
	inhand_icon_state = null
	body_parts_covered = HEAD
	flags_inv = HIDEHAIR|HIDEEARS

// Atmos
/obj/item/clothing/suit/atmos_overalls
	name = "大气处理工装裤"
	desc = "一套防火工装裤，能有效保护较薄衣物免受气体泄漏影响。"
	icon = 'icons/obj/clothing/suits/utility.dmi'
	worn_icon = 'icons/mob/clothing/suits/utility.dmi'
	icon_state = "atmos_overalls"
	inhand_icon_state = ""
	body_parts_covered = CHEST|GROIN|LEGS
	resistance_flags = FIRE_PROOF
	armor_type = /datum/armor/atmos_overalls
	species_exception = list(/datum/species/golem)
	allowed = list(
		/obj/item/analyzer,
		/obj/item/construction/rcd,
		/obj/item/fireaxe/metal_h2_axe,
		/obj/item/pipe_dispenser,
		/obj/item/storage/bag/construction,
		/obj/item/t_scanner,
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/tank/internals/plasmaman,
		/obj/item/extinguisher,
		/obj/item/construction/rtd,
		/obj/item/gun/ballistic/rifle/rebarxbow,
		/obj/item/storage/bag/rebar_quiver,
	)

/datum/armor/atmos_overalls
	fire = 100
	acid = 50

/obj/item/clothing/suit/atmos_overalls/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(!isinhands)
		. += emissive_appearance(icon_file, "[icon_state]-emissive", src, alpha = src.alpha, effect_type = EMISSIVE_SPECULAR)
