// Wintercoat
/obj/item/clothing/suit/hooded/wintercoat
	name = "冬大衣"
	desc = "A heavy jacket made from 'synthetic' animal furs."
	icon = 'icons/obj/clothing/suits/wintercoat.dmi'
	icon_state = "coatwinter"
	worn_icon = 'icons/mob/clothing/suits/wintercoat.dmi'
	inhand_icon_state = "coatwinter"
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	allowed = list()
	armor_type = /datum/armor/hooded_wintercoat
	hood_down_overlay_suffix = "_hood"
	/// How snug are we?
	var/zipped = FALSE
	/// Whether alt-clicking this coat zips/unzips it
	var/can_altclick_zip = TRUE

/datum/armor/hooded_wintercoat
	bio = 10

/obj/item/clothing/suit/hooded/wintercoat/Initialize(mapload)
	. = ..()
	allowed += list(
		/obj/item/flashlight,
		/obj/item/lighter,
		/obj/item/modular_computer/pda,
		/obj/item/radio,
		/obj/item/storage/bag/books,
		/obj/item/storage/fancy/cigarettes,
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/tank/internals/plasmaman,
		/obj/item/toy,
	)

/obj/item/clothing/suit/hooded/wintercoat/on_hood_up(obj/item/clothing/head/hooded/hood)
	. = ..()
	zipped = TRUE

/// Called when the hood is hidden
/obj/item/clothing/suit/hooded/wintercoat/on_hood_down(obj/item/clothing/head/hooded/hood)
	. = ..()
	zipped = FALSE

/obj/item/clothing/suit/hooded/wintercoat/examine(mob/user)
	. = ..()
	if(can_altclick_zip)
		. += span_notice("<b>Alt-点击</b>来[zipped ? "un" : ""]开拉链。")


/obj/item/clothing/suit/hooded/wintercoat/click_alt(mob/user)
	if(!can_altclick_zip)
		return CLICK_ACTION_BLOCKING
	zipped = !zipped
	playsound(src, 'sound/items/zip/zip_up.ogg', 30, TRUE, -3)
	worn_icon_state = "[initial(post_init_icon_state) || initial(icon_state)][zipped ? "_t" : ""]"
	balloon_alert(user, "[zipped ? "" : "un"]开拉链")

	if(ishuman(loc))
		var/mob/living/carbon/human/wearer = loc
		wearer.update_worn_oversuit()
	return CLICK_ACTION_SUCCESS

/obj/item/clothing/head/hooded/winterhood
	name = "冬衣兜帽"
	desc = "舒适的冬季兜帽系在厚重的冬季夹克上。"
	icon = 'icons/obj/clothing/head/winterhood.dmi'
	icon_state = "hood_winter"
	worn_icon = 'icons/mob/clothing/head/winterhood.dmi'
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	flags_inv = HIDEEARS
	hair_mask = /datum/hair_mask/winterhood
	armor_type = /datum/armor/hooded_winterhood

// An coat intended for use for general crew EVA, with values close to those of the space suits found in EVA normally
// Slight extra armor, bulky size, slows you down, can carry a large oxygen tank, won't burn off.
/datum/armor/hooded_winterhood
	bio = 10

/obj/item/clothing/suit/hooded/wintercoat/eva
	name = "\proper 恒温冬大衣"
	desc = "一件厚厚的冬季棉衣，拥有无论在什么情况下都能使穿着者体感良好的隔热性能。它有一个安全带，用于连接到背后的更大的氧气罐。"
	icon_state = "coateva"
	w_class = WEIGHT_CLASS_BULKY
	slowdown = 0.75
	armor_type = /datum/armor/wintercoat_eva
	strip_delay = 6 SECONDS
	equip_delay_other = 6 SECONDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT // Protects very cold.
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT // Protects a little hot.
	clothing_flags = THICKMATERIAL
	resistance_flags = NONE
	hoodtype = /obj/item/clothing/head/hooded/winterhood/eva

/datum/armor/wintercoat_eva
	melee = 10
	laser = 10
	energy = 10
	bio = 50
	fire = 50
	acid = 20

/obj/item/clothing/suit/hooded/wintercoat/eva/Initialize(mapload)
	. = ..()
	allowed += /obj/item/tank/internals

/obj/item/clothing/head/hooded/winterhood/eva
	name = "\proper 恒温冬衣兜帽"
	desc = "连在厚厚的外套上的厚衬垫兜帽。"
	icon_state = "hood_eva"
	armor_type = /datum/armor/winterhood_eva
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	clothing_flags = THICKMATERIAL|SNUG_FIT // Snug fit doesn't really matter, but might as well
	resistance_flags = NONE

// CentCom
/datum/armor/winterhood_eva
	melee = 10
	laser = 10
	energy = 10
	bio = 50
	fire = 50
	acid = 20

/obj/item/clothing/suit/hooded/wintercoat/centcom
	name = "中央指挥部冬大衣"
	desc = "一件用中央指挥部的亮绿色和金色织成的奢华冬衣。它有一个小别针形状的纳米传讯标志的拉链。"
	icon_state = "coatcentcom"
	inhand_icon_state = null
	armor_type = /datum/armor/wintercoat_centcom
	hoodtype = /obj/item/clothing/head/hooded/winterhood/centcom

/datum/armor/wintercoat_centcom
	melee = 35
	bullet = 40
	laser = 40
	energy = 50
	bomb = 35
	bio = 10
	fire = 10
	acid = 60

/obj/item/clothing/suit/hooded/wintercoat/centcom/Initialize(mapload)
	. = ..()
	allowed += GLOB.security_wintercoat_allowed

/obj/item/clothing/head/hooded/winterhood/centcom
	icon_state = "hood_centcom"
	armor_type = /datum/armor/winterhood_centcom

// Captain
/datum/armor/winterhood_centcom
	melee = 35
	bullet = 40
	laser = 40
	energy = 50
	bomb = 35
	bio = 10
	fire = 10
	acid = 60

/obj/item/clothing/suit/hooded/wintercoat/captain
	name = "舰长冬大衣"
	desc = "A luxurious winter coat, stuffed with the down of the endangered Uka bird and trimmed with genuine sable. The fabric is an indulgently soft micro-fiber, \
			and the deep ultramarine colour is only one that could be achieved with minute amounts of crystalline bluespace dust woven into the thread between the plectrums. \
			Extremely lavish, and extremely durable."
	icon_state = "coatcaptain"
	inhand_icon_state = "coatcaptain"
	armor_type = /datum/armor/wintercoat_captain
	hoodtype = /obj/item/clothing/head/hooded/winterhood/captain

/datum/armor/wintercoat_captain
	melee = 25
	bullet = 30
	laser = 30
	energy = 40
	bomb = 25
	acid = 50

/obj/item/clothing/suit/hooded/wintercoat/captain/Initialize(mapload)
	. = ..()
	allowed += GLOB.security_wintercoat_allowed

/obj/item/clothing/head/hooded/winterhood/captain
	icon_state = "hood_captain"
	armor_type = /datum/armor/winterhood_captain

// Head of Personnel
/datum/armor/winterhood_captain
	melee = 25
	bullet = 30
	laser = 30
	energy = 40
	bomb = 25
	acid = 50

/obj/item/clothing/suit/hooded/wintercoat/hop
	name = "人事部长冬大衣"
	desc = "一件覆盖着厚厚的毛皮的舒适的冬季大衣。胸口有一个骄傲的黄色三角形图案，提醒大家你是第二根香蕉。"
	icon_state = "coathop"
	inhand_icon_state = null
	armor_type = /datum/armor/wintercoat_hop
	allowed = list(
		/obj/item/melee/baton/telescopic,
		/obj/item/stamp,
	)
	hoodtype = /obj/item/clothing/head/hooded/winterhood/hop

/datum/armor/wintercoat_hop
	melee = 10
	bullet = 15
	laser = 15
	energy = 25
	bomb = 10
	acid = 35

/obj/item/clothing/suit/hooded/wintercoat/hop/Initialize(mapload)
	. = ..()
	allowed += GLOB.security_wintercoat_allowed

/obj/item/clothing/head/hooded/winterhood/hop
	icon_state = "hood_hop"
	armor_type =/datum/armor/wintercoat_hop

// Botanist
/obj/item/clothing/suit/hooded/wintercoat/hydro
	name = "水培冬大衣"
	desc = "一件绿蓝相间的冬衣。拉练的拉杆看起来像罗莎 赫斯佩罗多斯家族中某个花朵的形状，那是一种漂亮的粉白相间的玫瑰花，这两种颜色是完全冲突的。"
	icon_state = "coathydro"
	inhand_icon_state = "coathydro"
	allowed = /obj/item/clothing/suit/apron::allowed
	hoodtype = /obj/item/clothing/head/hooded/winterhood/hydro

/obj/item/clothing/head/hooded/winterhood/hydro
	desc = "一个绿色的冬季大衣兜帽。"
	icon_state = "hood_hydro"

// Janitor
/obj/item/clothing/suit/hooded/wintercoat/janitor
	name = "清洁工冬大衣"
	desc = "一件紫褐相间的冬季大衣，闻起来像太空清洁剂。"
	icon_state = "coatjanitor"
	inhand_icon_state = null
	allowed = list(
		/obj/item/access_key,
		/obj/item/grenade/chem_grenade,
		/obj/item/holosign_creator,
		/obj/item/key/janitor,
		/obj/item/reagent_containers/cup/beaker,
		/obj/item/reagent_containers/cup/bottle,
		/obj/item/reagent_containers/cup/tube,
		/obj/item/reagent_containers/spray,
	)
	hoodtype = /obj/item/clothing/head/hooded/winterhood/janitor

/obj/item/clothing/head/hooded/winterhood/janitor
	desc = "有太空清洁剂味道的紫色兜帽。"
	icon_state = "hood_janitor"

// Security Officer
/obj/item/clothing/suit/hooded/wintercoat/security
	name = "安保冬大衣"
	desc = "一种红色带有防护装甲冬季大衣。它散发着强健的气息。拉链标签是一对叮当作响的小手铐，在十秒钟后就变得烦人不已。"
	icon_state = "coatsecurity"
	inhand_icon_state = "coatsecurity"
	armor_type = /datum/armor/wintercoat_security
	hoodtype = /obj/item/clothing/head/hooded/winterhood/security

/datum/armor/wintercoat_security
	melee = 25
	bullet = 15
	laser = 30
	energy = 40
	bomb = 25
	acid = 45

/obj/item/clothing/suit/hooded/wintercoat/security/Initialize(mapload)
	. = ..()
	allowed += GLOB.security_wintercoat_allowed

/obj/item/clothing/head/hooded/winterhood/security
	desc = "一顶红色的冬帽。绝对不是防弹的，尤其是你脸上的部分。"
	icon_state = "hood_security"
	armor_type = /datum/armor/winterhood_security

// Medical Doctor
/datum/armor/winterhood_security
	melee = 25
	bullet = 15
	laser = 30
	energy = 40
	bomb = 25
	acid = 45

/obj/item/clothing/suit/hooded/wintercoat/medical
	name = "医疗冬大衣"
	desc = "一件纯白的极地风格冬衣，塑料拉链被一个小小的蓝色双蛇图案取代。真时髦。"
	icon_state = "coatmedical"
	inhand_icon_state = "coatmedical"
	allowed = list(
		/obj/item/defibrillator/compact,
		/obj/item/flashlight/pen,
		/obj/item/gun/syringe,
		/obj/item/healthanalyzer,
		/obj/item/reagent_containers/applicator,
		/obj/item/reagent_containers/cup/beaker,
		/obj/item/reagent_containers/cup/bottle,
		/obj/item/reagent_containers/cup/tube,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/hypospray,
		/obj/item/reagent_containers/syringe,
		/obj/item/sensor_device,
		/obj/item/storage/pill_bottle,
	)
	armor_type = /datum/armor/wintercoat_medical
	hoodtype = /obj/item/clothing/head/hooded/winterhood/medical

/datum/armor/wintercoat_medical
	bio = 40
	fire = 10
	acid = 20

/obj/item/clothing/head/hooded/winterhood/medical
	desc = "白色的冬衣帽。"
	icon_state = "hood_medical"
	armor_type = /datum/armor/winterhood_medical

/datum/armor/winterhood_medical
	bio = 40
	fire = 10
	acid = 20

// Chief Medical Officer
/obj/item/clothing/suit/hooded/wintercoat/medical/cmo
	name = "医疗部长冬大衣"
	desc = "一件颜色鲜艳的蓝色冬季大衣，塑料拉链被一个银色双蛇图案取代。正常的衬里被一层特别厚、柔软的皮毛所取代。"
	icon_state = "coatcmo"
	inhand_icon_state = null
	armor_type = /datum/armor/medical_cmo
	hoodtype = /obj/item/clothing/head/hooded/winterhood/medical/cmo

/datum/armor/medical_cmo
	bio = 50
	fire = 20
	acid = 30

/obj/item/clothing/suit/hooded/wintercoat/medical/cmo/Initialize(mapload)
	. = ..()
	allowed += list(
		/obj/item/melee/baton/telescopic,
		/obj/item/gun/energy/cell_loaded/medigun, // NOVA EDIT ADDITION - MEDIGUNS
	)

/obj/item/clothing/head/hooded/winterhood/medical/cmo
	desc = "白色的冬衣帽。"
	icon_state = "hood_cmo"
	armor_type = /datum/armor/medical_cmo

// Chemist
/obj/item/clothing/suit/hooded/wintercoat/medical/chemistry
	name = "化学冬大衣"
	desc = "一件采用耐酸聚合物制成的实验室级冬季外套。专为那些身处严寒荒原，四处奔波的富有创造力的化学家们设计。"
	icon_state = "coatchemistry"
	inhand_icon_state = null
	hoodtype = /obj/item/clothing/head/hooded/winterhood/medical/chemistry

/obj/item/clothing/suit/hooded/wintercoat/medical/chemistry/Initialize(mapload)
	. = ..()
	allowed += /obj/item/storage/bag/chemistry

/obj/item/clothing/head/hooded/winterhood/medical/chemistry
	desc = "A white winter coat hood."
	icon_state = "hood_chemistry"

// Coroner
/obj/item/clothing/suit/hooded/wintercoat/medical/coroner
	name = "验尸官冬季大衣"
	desc = "一件用耐酸聚合物制成的冬季大衣，用于应对冰冷的尸体带来的不适。"
	icon_state = "coatcoroner"
	inhand_icon_state = null
	hoodtype = /obj/item/clothing/head/hooded/winterhood/medical/coroner

/obj/item/clothing/suit/hooded/wintercoat/medical/coroner/Initialize(mapload)
	. = ..()
	allowed += list(
		/obj/item/autopsy_scanner,
		/obj/item/scythe,
		/obj/item/shovel,
		/obj/item/shovel/serrated,
		/obj/item/trench_tool,
	)

/obj/item/clothing/head/hooded/winterhood/medical/coroner
	desc = "白色的冬衣帽。"
	icon_state = "hood_coroner"

// Virologist
/obj/item/clothing/suit/hooded/wintercoat/medical/viro
	name = "病毒学冬大衣"
	desc = "一件带有绿色标记的白色冬季大衣。很暖和，但无法抵御普通感冒或其他疾病。可能会让人们在走廊里离你远远的。拉链头看起来像一个巨大的噬菌体。"
	icon_state = "coatviro"
	inhand_icon_state = null
	hoodtype = /obj/item/clothing/head/hooded/winterhood/medical/viro

/obj/item/clothing/suit/hooded/wintercoat/medical/viro/Initialize(mapload)
	. = ..()
	allowed += /obj/item/storage/bag/bio

/obj/item/clothing/head/hooded/winterhood/medical/viro
	desc = "一件带有绿色斑纹的白色冬衣兜帽。"
	icon_state = "hood_viro"

// Paramedic
/obj/item/clothing/suit/hooded/wintercoat/medical/paramedic
	name = "急救员冬大衣"
	desc = "一件带有蓝色斑纹的冬季大衣。很温暖，但可能无法抵御生物制剂侵害。专为忙碌的医生设计的舒适的冬衣。"
	icon_state = "coatparamed"
	inhand_icon_state = null
	hoodtype = /obj/item/clothing/head/hooded/winterhood/medical/paramedic

/obj/item/clothing/suit/hooded/wintercoat/medical/paramedic/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -3) //mirrored from jacket
	allowed += /obj/item/crowbar/power/paramedic

/obj/item/clothing/head/hooded/winterhood/medical/paramedic
	desc = "一件带有蓝色斑纹的白色冬衣兜帽。"
	icon_state = "hood_paramed"

// Scientist
/obj/item/clothing/suit/hooded/wintercoat/science
	name = "科研冬大衣"
	desc = "一件白色的冬季大衣，塑料拉链被过时的原子模型取代。"
	icon_state = "coatscience"
	inhand_icon_state = "coatscience"
	allowed = list(
		/obj/item/analyzer,
		/obj/item/dnainjector,
		/obj/item/paper,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/cup/beaker,
		/obj/item/reagent_containers/cup/bottle,
		/obj/item/reagent_containers/cup/tube,
		/obj/item/reagent_containers/hypospray,
		/obj/item/reagent_containers/applicator/pill,
		/obj/item/reagent_containers/syringe,
		/obj/item/storage/bag/xeno,
		/obj/item/storage/pill_bottle,
	)
	armor_type = /datum/armor/wintercoat_science
	hoodtype = /obj/item/clothing/head/hooded/winterhood/science
	species_exception = list(/datum/species/golem)

/datum/armor/wintercoat_science
	bio = 10
	fire = 20

/obj/item/clothing/head/hooded/winterhood/science
	desc = "一件白色的冬衣兜帽。这个可以让你的大脑免受寒冷侵袭。其实效果和其他款式差不多。"
	icon_state = "hood_science"
	armor_type = /datum/armor/winterhood_science

// Research Director
/datum/armor/winterhood_science
	bio = 10
	fire = 20

/obj/item/clothing/suit/hooded/wintercoat/science/rd
	name = "科研部长冬大衣"
	desc = "一件厚厚的北极冬衣，塑料拉链被过时的原子模型取代。大多数懂行的人都很清楚，玻尔的原子模型在20世纪30年代已经过时了，当时海森堡和薛定谔的模型被普遍认为是正确的。尽管如此，我们仍然看到它在不合时宜的场景中被使用，比如角色扮演，在这种情况下，作为拉链标签。至少它能让你在象牙塔保持温暖。"
	icon_state = "coatrd"
	inhand_icon_state = null
	armor_type = /datum/armor/science_rd
	hoodtype = /obj/item/clothing/head/hooded/winterhood/science/rd

/datum/armor/science_rd
	bomb = 20
	fire = 30

/obj/item/clothing/suit/hooded/wintercoat/science/rd/Initialize(mapload)
	. = ..()
	allowed += list(
		/obj/item/melee/baton/telescopic,
	)

/obj/item/clothing/head/hooded/winterhood/science/rd
	desc = "白色的冬季大衣帽。闻起来有淡淡的发胶气味。"
	icon_state = "hood_rd"
	armor_type = /datum/armor/science_rd

// Roboticist
/obj/item/clothing/suit/hooded/wintercoat/science/robotics
	name = "机械学冬大衣"
	desc = "一件黑色的冬季大衣，拉链上有一个燃烧的机器人头骨图案。这款有亮红色的设计和几个没用的按钮。"
	icon_state = "coatrobotics"
	inhand_icon_state = null
	hoodtype = /obj/item/clothing/head/hooded/winterhood/science/robotics

/obj/item/clothing/head/hooded/winterhood/science/robotics
	desc = "A black winter coat hood. You can pull it down over your eyes and pretend that you're an outdated, late 1980s interpretation of a futuristic mechanized police force. They'll fix you. They fix everything."
	icon_state = "hood_robotics"

// Geneticist
/obj/item/clothing/suit/hooded/wintercoat/science/genetics
	name = "基因学冬大衣"
	desc = "一件白色的冬季大衣，拉链上有DNA螺旋的图案。"
	icon_state = "coatgenetics"
	inhand_icon_state = null
	hoodtype = /obj/item/clothing/head/hooded/winterhood/science/genetics

/obj/item/clothing/suit/hooded/wintercoat/science/genetics/Initialize(mapload)
	. = ..()
	allowed += /obj/item/sequence_scanner

/obj/item/clothing/head/hooded/winterhood/science/genetics
	desc = "白色的冬衣兜帽。它是温暖的。"
	icon_state = "hood_genetics"

// Station Engineer
/obj/item/clothing/suit/hooded/wintercoat/engineering
	name = "工程冬大衣"
	desc = "一件带有反光橙色条纹的厚重黄色冬季大衣。它的拉链拉环上有一个小扳手，内层覆盖着抗辐射的银尼龙混纺材料。因为你值得拥有。"
	icon_state = "coatengineer"
	inhand_icon_state = "coatengineer"
	allowed = list(
		/obj/item/analyzer,
		/obj/item/construction/rcd,
		/obj/item/fireaxe/metal_h2_axe,
		/obj/item/pipe_dispenser,
		/obj/item/storage/bag/construction,
		/obj/item/t_scanner,
		/obj/item/construction/rld,
		/obj/item/construction/rtd,
		/obj/item/gun/ballistic/rifle/rebarxbow,
		/obj/item/storage/bag/rebar_quiver,
	)
	armor_type = /datum/armor/wintercoat_engineering
	hoodtype = /obj/item/clothing/head/hooded/winterhood/engineering

/datum/armor/wintercoat_engineering
	fire = 20

/obj/item/clothing/suit/hooded/wintercoat/engineering/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(!isinhands)
		. += emissive_appearance(icon_file, "[icon_state]-emissive", src, alpha = src.alpha, effect_type = EMISSIVE_SPECULAR)

/obj/item/clothing/head/hooded/winterhood/engineering
	desc = "一个黄色的冬衣兜帽。绝对不是安全帽的替代品。"
	icon_state = "hood_engineer"
	armor_type = /datum/armor/winterhood_engineering

/datum/armor/winterhood_engineering
	fire = 20

/obj/item/clothing/head/hooded/winterhood/engineering/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(!isinhands)
		. += emissive_appearance(icon_file, "[icon_state]-emissive", src, alpha = src.alpha, effect_type = EMISSIVE_SPECULAR)

// Chief Engineer
/obj/item/clothing/suit/hooded/wintercoat/engineering/ce
	name = "工程部长冬大衣"
	desc = "A white winter coat with reflective green and yellow stripes. Stuffed with asbestos, treated with fire retardant PBDE, lined with a micro thin sheet of lead foil and snugly fitted to your body's measurements. This baby's ready to save you from anything except the thyroid cancer and systemic fibrosis you'll get from wearing it. The zipper tab is a tiny golden wrench."
	icon_state = "coatce"
	inhand_icon_state = null
	armor_type = /datum/armor/engineering_ce
	hoodtype = /obj/item/clothing/head/hooded/winterhood/engineering/ce

/datum/armor/engineering_ce
	fire = 30
	acid = 10

/obj/item/clothing/suit/hooded/wintercoat/engineering/ce/Initialize(mapload)
	. = ..()
	allowed += list(
		/obj/item/melee/baton/telescopic,
	)

/obj/item/clothing/head/hooded/winterhood/engineering/ce
	desc = "白色的冬衣兜帽。感觉出奇地重。标签上写着不适合儿童使用。"
	icon_state = "hood_ce"
	armor_type = /datum/armor/engineering_ce

// Atmospherics Technician
/obj/item/clothing/suit/hooded/wintercoat/engineering/atmos
	name = "大气冬大衣"
	desc = "一件黄蓝相间的冬大衣。拉链拉片看起来像一个微型呼吸面罩"
	icon_state = "coatatmos"
	inhand_icon_state = "coatatmos"
	hoodtype = /obj/item/clothing/head/hooded/winterhood/engineering/atmos

/obj/item/clothing/head/hooded/winterhood/engineering/atmos
	desc = "一件黄蓝相间的冬衣兜帽。"
	icon_state = "hood_atmos"

// Cargo Technician
/obj/item/clothing/suit/hooded/wintercoat/cargo
	name = "货舱冬大衣"
	desc = "一件棕灰相间的冬衣。拉链标签是一个类似于MULE的小别针。它让你充满了强烈独立的温暖。"
	icon_state = "coatcargo"
	inhand_icon_state = "coatcargo"
	hoodtype = /obj/item/clothing/head/hooded/winterhood/cargo
	allowed = list(
		/obj/item/storage/bag/mail,
		/obj/item/stamp,
		/obj/item/universal_scanner,
	)

/obj/item/clothing/head/hooded/winterhood/cargo
	desc = "一件灰色的冬衣兜帽。"
	icon_state = "hood_cargo"

// Quartermaster
/obj/item/clothing/suit/hooded/wintercoat/cargo/qm
	name = "军需官冬大衣"
	desc = "一件深棕色的冬季大衣，拉链上有一个金色的板条箱别针。"
	icon_state = "coatqm"
	inhand_icon_state = null
	hoodtype = /obj/item/clothing/head/hooded/winterhood/cargo/qm

/obj/item/clothing/suit/hooded/wintercoat/cargo/qm/Initialize(mapload)
	. = ..()
	allowed += list(
		/obj/item/melee/baton/telescopic,
	)

/obj/item/clothing/head/hooded/winterhood/cargo/qm
	desc = "深棕色的冬衣兜帽"
	icon_state = "hood_qm"

// Shaft Miner
/obj/item/clothing/suit/hooded/wintercoat/miner
	name = "采矿冬大衣"
	desc = "一件满是灰尘的竖领冬衣。拉链标签看起来像一把小鹤嘴锄。"
	icon_state = "coatminer"
	inhand_icon_state = "coatminer"
	allowed = list(
		/obj/item/gun/energy/recharge/kinetic_accelerator,
		/obj/item/mining_scanner,
		/obj/item/pickaxe,
		/obj/item/resonator,
		/obj/item/storage/bag/ore,
		/obj/item/t_scanner/adv_mining_scanner,
		/obj/item/tank/internals,
		/obj/item/shovel,
		/obj/item/trench_tool,
	)
	armor_type = /datum/armor/wintercoat_miner
	hoodtype = /obj/item/clothing/head/hooded/winterhood/miner

/datum/armor/wintercoat_miner
	melee = 10

/obj/item/clothing/head/hooded/winterhood/miner
	desc = "一件满是灰尘的冬衣兜帽。"
	icon_state = "hood_miner"
	armor_type = /datum/armor/winterhood_miner

/datum/armor/winterhood_miner
	melee = 10

/obj/item/clothing/suit/hooded/wintercoat/custom
	name = "定制冬大衣"
	desc = "A heavy jacket made from 'synthetic' animal furs, with custom colors."
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/hooded/wintercoat/custom"
	post_init_icon_state = "coatwinter"
	hood_down_overlay_suffix = ""
	greyscale_config = /datum/greyscale_config/winter_coats
	greyscale_config_worn = /datum/greyscale_config/winter_coats/worn
	greyscale_colors = "#ffffff#ffffff#808080#808080#808080#808080"
	hoodtype = /obj/item/clothing/head/hooded/winterhood/custom
	flags_1 = IS_PLAYER_COLORABLE_1

//In case colors are changed after initialization
/obj/item/clothing/suit/hooded/wintercoat/custom/set_greyscale(list/colors, new_config, new_worn_config, new_inhand_left, new_inhand_right)
	. = ..()
	if(!hood)
		return
	var/list/coat_colors = SSgreyscale.ParseColorString(greyscale_colors)
	var/list/new_coat_colors = coat_colors.Copy(1,4)
	hood.set_greyscale(new_coat_colors) //Adopt the suit's grayscale coloring for visual clarity.
	hood.update_slot_icon()

//But also keep old method in case the hood is (re-)created later
/obj/item/clothing/suit/hooded/wintercoat/custom/on_hood_created(obj/item/clothing/head/hooded/hood)
	. = ..()
	var/list/coat_colors = (SSgreyscale.ParseColorString(greyscale_colors))
	var/list/new_coat_colors = coat_colors.Copy(1,4)
	hood.set_greyscale(new_coat_colors) //Adopt the suit's grayscale coloring for visual clarity.

/obj/item/clothing/head/hooded/winterhood/custom
	name = "定制冬大衣兜帽"
	desc = "A heavy jacket hood made from 'synthetic' animal furs, with custom colors."
	greyscale_config = /datum/greyscale_config/winter_hoods
	greyscale_config_worn = /datum/greyscale_config/winter_hoods/worn
	flags_1 = NO_NEW_GAGS_PREVIEW_1

/obj/item/clothing/suit/hooded/wintercoat/pullover
	name = "pullover"
	desc = "A colorable pullover hoodie."
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/hooded/wintercoat/pullover"
	post_init_icon_state = "pullover"
	greyscale_config = /datum/greyscale_config/hoodie_pullover
	greyscale_config_worn = /datum/greyscale_config/hoodie_pullover/worn
	greyscale_colors = "#5f5f5f"
	hoodtype = /obj/item/clothing/head/hooded/winterhood/pullover
	flags_1 = IS_PLAYER_COLORABLE_1
	hood_down_overlay_suffix = ""
	hood_up_affix = "_t"
	can_altclick_zip = FALSE

/obj/item/clothing/suit/hooded/wintercoat/pullover/on_hood_up(obj/item/clothing/head/hooded/hood)
	return

/obj/item/clothing/suit/hooded/wintercoat/pullover/on_hood_down(obj/item/clothing/head/hooded/hood)
	return

/obj/item/clothing/head/hooded/winterhood/pullover
	name = "pullover hood"
	desc = "A colorable pullover hoodie."
	icon_state = "hood_pullover"
	worn_icon_state = "hood_pullover"
	hair_mask = /datum/hair_mask/hoodie
	greyscale_config = /datum/greyscale_config/hoodie_pullover_hood
	greyscale_config_worn = /datum/greyscale_config/hoodie_pullover_hood/worn
	greyscale_colors = "#5f5f5f"
	flags_1 = NO_NEW_GAGS_PREVIEW_1

/obj/item/clothing/suit/hooded/wintercoat/pullover/set_greyscale(list/colors, new_config, new_worn_config, new_inhand_left, new_inhand_right)
	. = ..()
	if(!hood)
		return
	var/list/coat_colors = SSgreyscale.ParseColorString(greyscale_colors)
	hood.set_greyscale(coat_colors)
	hood.update_slot_icon()

/obj/item/clothing/suit/hooded/wintercoat/pullover/on_hood_created(obj/item/clothing/head/hooded/hood)
	. = ..()
	var/list/coat_colors = SSgreyscale.ParseColorString(greyscale_colors)
	hood.set_greyscale(coat_colors)

/obj/item/clothing/suit/hooded/wintercoat/zipup
	name = "zipup"
	desc = "A colorable zipup hoodie."
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/hooded/wintercoat/zipup"
	post_init_icon_state = "zipup"
	greyscale_config = /datum/greyscale_config/hoodie_zipup
	greyscale_config_worn = /datum/greyscale_config/hoodie_zipup/worn
	greyscale_colors = "#5f5f5f"
	hoodtype = /obj/item/clothing/head/hooded/winterhood/zipup
	flags_1 = IS_PLAYER_COLORABLE_1
	hood_down_overlay_suffix = ""
	hood_up_affix = "_t"

/obj/item/clothing/suit/hooded/wintercoat/zipup/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(isinhands || (hood && hood.loc != src))
		return

	var/suffix = (zipped ? "hood_t" : "hood")
	var/state = "[initial(post_init_icon_state) || initial(icon_state)]_[suffix]"
	. += mutable_appearance(icon_file, state, -SUIT_LAYER)

/obj/item/clothing/head/hooded/winterhood/zipup
	name = "zipup hood"
	desc = "A colorable zipup hoodie."
	icon_state = "hood_zipup"
	worn_icon_state = "hood_zipup"
	hair_mask = /datum/hair_mask/hoodie
	greyscale_config = /datum/greyscale_config/hoodie_zipup_hood
	greyscale_config_worn = /datum/greyscale_config/hoodie_zipup_hood/worn
	greyscale_colors = "#5f5f5f"
	flags_1 = NO_NEW_GAGS_PREVIEW_1

/obj/item/clothing/suit/hooded/wintercoat/zipup/set_greyscale(list/colors, new_config, new_worn_config, new_inhand_left, new_inhand_right)
	. = ..()
	if(!hood)
		return
	var/list/coat_colors = SSgreyscale.ParseColorString(greyscale_colors)
	hood.set_greyscale(coat_colors)
	hood.update_slot_icon()

/obj/item/clothing/suit/hooded/wintercoat/zipup/on_hood_created(obj/item/clothing/head/hooded/hood)
	. = ..()
	var/list/coat_colors = SSgreyscale.ParseColorString(greyscale_colors)
	hood.set_greyscale(coat_colors)
