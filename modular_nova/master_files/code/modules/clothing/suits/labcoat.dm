/obj/item/clothing/suit/toggle/labcoat/paramedic/Initialize(mapload)
	. = ..()
	allowed += list(
		/obj/item/storage/medkit,
	)

/obj/item/clothing/suit/toggle/labcoat
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/suit/toggle/labcoat/nova
	name = "SR 实验服 套装 调试"
	desc = "发现此物品请上报"
	icon = 'modular_nova/master_files/icons/obj/clothing/suits/labcoat.dmi'
	worn_icon = 'modular_nova/master_files/icons/mob/clothing/suits/labcoat.dmi'
	worn_icon_teshari = 'modular_nova/master_files/icons/mob/clothing/suits/labcoat_teshari.dmi'
	icon_state = null //Keeps this from showing up under the chameleon hat

/obj/item/clothing/suit/toggle/labcoat/nova/fancy
	name = "灰阶花式实验服"
	desc = "在决心的考验中，许多人曾追寻这样一件花式实验服，一件充满多种色彩与磨损痕迹的实验服。"
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/toggle/labcoat/nova/fancy"
	post_init_icon_state = "fancy_labcoat"
	greyscale_config = /datum/greyscale_config/fancy_labcoat
	greyscale_config_worn = /datum/greyscale_config/fancy_labcoat/worn
	greyscale_config_worn_teshari = /datum/greyscale_config/fancy_labcoat/worn/teshari
	greyscale_colors = "#EEEEEE#4A77A1"
	gets_cropped_on_taurs = FALSE
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/suit/toggle/labcoat/nova/fancy/rd
	name = "研究主管的实验服"
	desc = "一件纳米传讯公司为认证研究主管准备的标准实验服。其外部有一层额外的塑料-乳胶衬里，以提供更多针对化学和病毒危害的防护。"
	icon_state = "/obj/item/clothing/suit/toggle/labcoat/nova/fancy/rd"
	greyscale_colors = "#620B73#EEEEEE"
	gets_cropped_on_taurs = FALSE
	body_parts_covered = CHEST|ARMS|LEGS
	armor_type = /datum/armor/nova_rd

/datum/armor/nova_rd
	melee = 5
	bio = 80
	fire = 80
	acid = 70

/obj/item/clothing/suit/toggle/labcoat/nova/fancy/regular
	name = "研究员的实验服"
	desc = "一件纳米传讯公司为科学领域的研究员准备的标准实验服。"
	icon_state = "/obj/item/clothing/suit/toggle/labcoat/nova/fancy/regular"
	greyscale_colors = "#EEEEEE#B347A1"
	gets_cropped_on_taurs = FALSE

/obj/item/clothing/suit/toggle/labcoat/nova/fancy/regular/Initialize(mapload)
	. = ..()
	allowed += /obj/item/storage/bag/xeno

/obj/item/clothing/suit/toggle/labcoat/nova/lalunevest
	name = "无袖纽扣外套"
	desc = "一件时尚的夹克，内衬印有拉鲁恩的标志。其设计和材质看起来与实验服相似，但标签警告其不能替代实验服。"
	icon_state = "/obj/item/clothing/suit/toggle/labcoat/nova/lalunevest"
	icon_state = "labcoat_lalunevest"
	gets_cropped_on_taurs = FALSE

/obj/item/clothing/suit/toggle/labcoat/nova/fancy/pharmacist
	name = "药剂师的实验服"
	desc = "一件用于化学实验的标准实验服，可保护穿着者免受酸液泼溅。"
	icon_state = "/obj/item/clothing/suit/toggle/labcoat/nova/fancy/pharmacist"
	greyscale_colors = "#EEEEEE#E6935C"
	gets_cropped_on_taurs = FALSE

/obj/item/clothing/suit/toggle/labcoat/nova/fancy/geneticist
	name = "遗传学家的实验服"
	desc = "一件标准的遗传学家实验服。"
	icon_state = "/obj/item/clothing/suit/toggle/labcoat/nova/fancy/geneticist"
	greyscale_colors = "#EEEEEE#7497C0"
	gets_cropped_on_taurs = FALSE

/obj/item/clothing/suit/toggle/labcoat/nova/fancy/roboticist
	name = "机器人专家的实验服"
	desc = "一件标准的机器人专家实验服。"
	icon_state = "/obj/item/clothing/suit/toggle/labcoat/nova/fancy/roboticist"
	greyscale_colors = "#2F2E31#A52F29"
	gets_cropped_on_taurs = FALSE

/obj/item/clothing/suit/toggle/labcoat/nova/fancy/pharmacist/Initialize(mapload)
	. = ..()
	allowed += /obj/item/storage/bag/chemistry

/obj/item/clothing/suit/toggle/labcoat/nova/highvis
	name = "高能见度实验服"
	desc = "一件为应急响应人员设计的高能见度背心，旨在将注意力从血迹上引开。"
	icon_state = "labcoat_highvis"
	blood_overlay_type = "armor"

/obj/item/clothing/suit/toggle/labcoat/nova/highvis/worn_overlays(mutable_appearance/standing, isinhands, icon_file)
	. = ..()
	if(!isinhands)
		. += emissive_appearance(icon_file, "[icon_state]-emissive", src, alpha = src.alpha)

/obj/item/clothing/suit/toggle/labcoat/nova/surgical_gown //Intended to keep patients modest while still allowing for surgeries
	name = "手术袍"
	desc = "一种配有多种魔术贴和系带的复杂罩袍，旨在让患者在住院和手术期间保持体面。"
	icon_state = "hgown"
	toggle_noun = "drapes"
	body_parts_covered = NONE //Allows surgeries despite wearing it; hiding genitals is handled in /datum/sprite_accessory/genital/is_hidden() (Only place it'd work sadly)
	armor_type = /datum/armor/none
	equip_delay_other = 8

/obj/item/clothing/suit/toggle/labcoat/nova/surgical_gown/examine_tags(mob/user)
	. = ..()
	.["surgical"] = "Does not block surgery on covered bodyparts."
	// Same note as /obj/item/clothing/mask/muzzle/breath

/obj/item/clothing/suit/toggle/labcoat/roboticist //Overwrite the TG Roboticist labcoat to Black and Red (not the Interdyne labcoat though)
	icon_state = "/obj/item/clothing/suit/toggle/labcoat/roboticist"
	greyscale_colors = "#2D2D33#88242D#88242D#88242D"

/obj/item/clothing/suit/toggle/labcoat/medical //Renamed version of the Genetics labcoat for more generic medical purposes; just a subtype of /labcoat/ for the TG files
	name = "医疗实验服"
	desc = "一套能防护轻微化学泄漏的防护服，肩部饰有一条蓝色条纹。"
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/toggle/labcoat/medical"
	post_init_icon_state = "labcoat_job"
	greyscale_config = /datum/greyscale_config/labcoat
	greyscale_config_worn = /datum/greyscale_config/labcoat/worn
	greyscale_colors = "#EEEEEE#4A77A1#4A77A1#7095C2"

/obj/item/clothing/suit/toggle/labcoat/Initialize(mapload)
	. = ..()
	allowed += list(
		/obj/item/handheld_soulcatcher,
	)
