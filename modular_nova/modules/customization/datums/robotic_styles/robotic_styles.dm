/datum/robotic_style
	var/name = "无"
	/// The .dmi path for this robotic style
	var/icon = "None"
	/// If this style should override the  it is applied to's limb_id
	var/limb_id_override
	/// If this style should override the limb it is applied to's bodyshape
	var/bodyshape_override
	/// What slots this style work on
	var/supported_slots = ALL
	/// Whether this style supports digi
	var/has_digi
	/// If this style's source utilizes a dimorphic bodypart, it goes in this list assoc list keyed to the body_zone
	var/list/dimorphic_overrides

/datum/robotic_style/New()
	if(LAZYLEN(dimorphic_overrides))
		dimorphic_overrides = string_assoc_list(dimorphic_overrides)
	return ..()

/datum/robotic_style/scrappyipc
	name = "拼凑式"
	icon = 'modular_nova/master_files/icons/mob/augmentation/scrappyipc.dmi' // for ones that don't have associated limb atoms just setting icon works fine
	bodyshape_override = BODYSHAPE_HUMANOID
	has_digi = TRUE

/datum/robotic_style/scrappyipc_greyscale
	name = "拼凑式（灰度）"
	icon = 'modular_nova/master_files/icons/mob/augmentation/scrappyipc_greyscale.dmi'
	bodyshape_override = BODYSHAPE_HUMANOID
	has_digi = TRUE

/datum/robotic_style/surplus
	name = "剩余物资式"
	icon = 'icons/mob/augmentation/surplus_augments.dmi'
	bodyshape_override = BODYSHAPE_HUMANOID
	has_digi = TRUE

/datum/robotic_style/cyborg
	name = "机械人"
	icon = 'icons/mob/augmentation/augments.dmi'
	bodyshape_override = BODYSHAPE_HUMANOID
	has_digi = TRUE

/datum/robotic_style/engineering
	name = "工程"
	icon = 'icons/mob/augmentation/augments_engineer.dmi'
	bodyshape_override = BODYSHAPE_HUMANOID
	has_digi = TRUE

/datum/robotic_style/mining
	name = "矿业"
	icon = 'icons/mob/augmentation/augments_mining.dmi'
	bodyshape_override = BODYSHAPE_HUMANOID
	has_digi = TRUE

/datum/robotic_style/security
	name = "安保"
	icon = 'icons/mob/augmentation/augments_security.dmi'
	bodyshape_override = BODYSHAPE_HUMANOID
	has_digi = TRUE

/datum/robotic_style/mcgipc
	name = "墨菲斯赛博动力学"
	icon = 'modular_nova/master_files/icons/mob/augmentation/mcgipc.dmi'
	bodyshape_override = BODYSHAPE_HUMANOID
	has_digi = TRUE

/datum/robotic_style/bshipc
	name = "毕晓普赛博动力学"
	icon = 'modular_nova/master_files/icons/mob/augmentation/bshipc.dmi'
	bodyshape_override = BODYSHAPE_HUMANOID
	has_digi = TRUE

/datum/robotic_style/bs2ipc
	name = "毕晓普赛博动力学 2.0"
	icon = 'modular_nova/master_files/icons/mob/augmentation/bs2ipc.dmi'
	bodyshape_override = BODYSHAPE_HUMANOID
	has_digi = TRUE

/datum/robotic_style/e3n
	name = "E3N 人工智能"
	icon = 'modular_nova/master_files/icons/mob/augmentation/e3n.dmi'
	bodyshape_override = BODYSHAPE_HUMANOID
	has_digi = TRUE

/datum/robotic_style/hsiipc
	name = "赫菲斯托斯工业"
	icon = 'modular_nova/master_files/icons/mob/augmentation/hsiipc.dmi'
	bodyshape_override = BODYSHAPE_HUMANOID
	has_digi = TRUE

/datum/robotic_style/hi2ipc
	name = "赫菲斯托斯工业 2.0"
	icon = 'modular_nova/master_files/icons/mob/augmentation/hi2ipc.dmi'
	bodyshape_override = BODYSHAPE_HUMANOID
	has_digi = TRUE

/datum/robotic_style/sgmipc
	name = "壳卫军械标准系列"
	icon = 'modular_nova/master_files/icons/mob/augmentation/sgmipc.dmi'
	bodyshape_override = BODYSHAPE_HUMANOID
	has_digi = TRUE

/datum/robotic_style/wtmipc
	name = "沃德-高桥制造"
	icon = 'modular_nova/master_files/icons/mob/augmentation/wtmipc.dmi'
	bodyshape_override = BODYSHAPE_HUMANOID
	has_digi = TRUE

/datum/robotic_style/xmgipc
	name = "希昂制造集团"
	icon = 'modular_nova/master_files/icons/mob/augmentation/xmgipc.dmi'
	bodyshape_override = BODYSHAPE_HUMANOID
	has_digi = TRUE

/datum/robotic_style/xm2ipc
	name = "希昂制造集团 2.0"
	icon ='modular_nova/master_files/icons/mob/augmentation/xm2ipc.dmi'
	bodyshape_override = BODYSHAPE_HUMANOID
	has_digi = TRUE

/datum/robotic_style/zhpipc
	name = "正和制药"
	icon = 'modular_nova/master_files/icons/mob/augmentation/zhpipc.dmi'
	bodyshape_override = BODYSHAPE_HUMANOID
	has_digi = TRUE

/datum/robotic_style/mariinskyipc
	name = "马林斯基芭蕾舞团"
	icon = 'modular_nova/master_files/icons/mob/augmentation/mariinskyipc.dmi'
	bodyshape_override = BODYSHAPE_HUMANOID
	has_digi = TRUE

/datum/robotic_style/zhenkovipc
	name = "真科夫联合铸造厂"
	icon = 'modular_nova/master_files/icons/mob/augmentation/zhenkovipc.dmi'
	supported_slots = LEGS
	bodyshape_override = BODYSHAPE_HUMANOID
	has_digi = TRUE

/datum/robotic_style/zhenkovipc_dark
	name = "真科夫联合铸造厂 - 暗色"
	icon = 'modular_nova/master_files/icons/mob/augmentation/zhenkovipc_dark.dmi'
	supported_slots = LEGS
	bodyshape_override = BODYSHAPE_HUMANOID
	has_digi = TRUE

/datum/robotic_style/dimorphic // subtype so we don't have to define dimorphic head+chest every single time
	abstract_type = /datum/robotic_style/dimorphic
	dimorphic_overrides = list(
		BODY_ZONE_HEAD = TRUE,
		BODY_ZONE_CHEST = TRUE,
	)

/datum/robotic_style/dimorphic/akula
	name = "阿库拉"
	icon = BODYPART_ICON_AKULA
	limb_id_override = /obj/item/bodypart/chest/mutant/akula::limb_id

/datum/robotic_style/dimorphic/anthro
	name = "拟人"
	icon = BODYPART_ICON_MAMMAL
	limb_id_override = /obj/item/bodypart/chest/mutant::limb_id
	has_digi = TRUE

/datum/robotic_style/dimorphic/lizard
	name = "蜥蜴"
	icon = BODYPART_ICON_LIZARD
	limb_id_override = /obj/item/bodypart/chest/lizard::limb_id
	dimorphic_overrides = list(
		BODY_ZONE_HEAD = FALSE,
		BODY_ZONE_CHEST = TRUE,
	)
	has_digi = TRUE

/datum/robotic_style/dimorphic/moth
	name = "飞蛾"
	icon = BODYPART_ICON_MOTH
	limb_id_override = /obj/item/bodypart/chest/moth::limb_id

/datum/robotic_style/dimorphic/ramatan
	name = "拉玛坦"
	icon = BODYPART_ICON_RAMATAE
	limb_id_override = /obj/item/bodypart/chest/mutant/ramatae::limb_id
	has_digi = TRUE

/datum/robotic_style/dimorphic/vox
	name = "沃克斯"
	icon = BODYPART_ICON_VOX
	limb_id_override = /obj/item/bodypart/chest/mutant/vox::limb_id
	has_digi = TRUE

/datum/robotic_style/dimorphic/xenohybrid
	name = "异种混成体"
	icon = BODYPART_ICON_XENO
	limb_id_override = /obj/item/bodypart/chest/mutant/xenohybrid::limb_id
	has_digi = TRUE
