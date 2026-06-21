/obj/item/clothing/suit/toggle/labcoat
	name = "长袍"
	desc = "抵御轻微化学物质泄漏的防护服。"
	icon_state = "labcoat"
	icon = 'icons/obj/clothing/suits/labcoat.dmi'
	worn_icon = 'icons/mob/clothing/suits/labcoat.dmi'
	inhand_icon_state = "labcoat"
	blood_overlay_type = "coat"
	body_parts_covered = CHEST|ARMS
	allowed = list(
		/obj/item/analyzer,
		/obj/item/biopsy_tool,
		/obj/item/defibrillator/compact,
		/obj/item/dnainjector,
		/obj/item/flashlight/pen,
		/obj/item/gun/syringe,
		/obj/item/healthanalyzer,
		/obj/item/paper,
		/obj/item/reagent_containers/applicator,
		/obj/item/reagent_containers/cup/beaker,
		/obj/item/reagent_containers/cup/bottle,
		/obj/item/reagent_containers/cup/tube,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/hypospray,
		/obj/item/reagent_containers/syringe,
		/obj/item/sensor_device,
		/obj/item/soap,
		/obj/item/stack/medical,
		/obj/item/storage/pill_bottle,
		/obj/item/tank/internals/emergency_oxygen,
		/obj/item/tank/internals/plasmaman,
		/obj/item/gun/energy/cell_loaded/medigun, //NOVA EDIT ADDITION - MEDIGUNS
		/obj/item/storage/medkit, //NOVA EDIT ADDITION
	)
	armor_type = /datum/armor/toggle_labcoat
	species_exception = list(/datum/species/golem)

/obj/item/clothing/suit/toggle/labcoat/cmo
	name = "医疗部长长袍"
	desc = "比标准型号更蓝。"
	icon_state = "labcoat_cmo"
	inhand_icon_state = null

/obj/item/clothing/suit/toggle/labcoat/cmo/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -3) //FISH DOCTOR?!

/datum/armor/toggle_labcoat
	bio = 50
	fire = 50
	acid = 50

/obj/item/clothing/suit/toggle/labcoat/cmo/Initialize(mapload)
	. = ..()
	allowed += list(
		/obj/item/melee/baton/telescopic,
		/obj/item/gun/energy/cell_loaded/medigun, //NOVA EDIT ADDITION - MEDIGUNS
		/obj/item/storage/medkit, //NOVA EDIT ADDITION
	)

/obj/item/clothing/suit/toggle/labcoat/paramedic
	name = "急救员夹克"
	desc = "一件有反光条纹的深蓝色医护人员夹克。"
	icon_state = "labcoat_paramedic"
	inhand_icon_state = null

/obj/item/clothing/suit/toggle/labcoat/paramedic/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, -3) //FISH DOCTOR?!
	allowed += /obj/item/crowbar/power/paramedic

/obj/item/clothing/suit/toggle/labcoat/mad
	name = "\proper 医疗长袍"
	desc = "它让你看起来有能力打爆某人的头，然后把他们发射到太空。"
	icon_state = "labgreen"
	inhand_icon_state = null

/obj/item/clothing/suit/toggle/labcoat/genetics
	name = "基因长袍"
	desc = "一套能防护轻微化学泄漏的防护服，肩部饰有一条蓝色条纹。"
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/toggle/labcoat/genetics"
	post_init_icon_state = "labcoat_job"
	greyscale_config = /datum/greyscale_config/labcoat
	greyscale_config_worn = /datum/greyscale_config/labcoat/worn
	greyscale_colors = "#EEEEEE#4A77A1#4A77A1#7095C2"

/obj/item/clothing/suit/toggle/labcoat/genetics/Initialize(mapload)
	. = ..()
	allowed += /obj/item/sequence_scanner

/obj/item/clothing/suit/toggle/labcoat/chemist
	name = "化学长袍"
	desc = "一套能防护轻微化学泄漏的防护服，肩部饰有一条橙色条纹。"
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/toggle/labcoat/chemist"
	post_init_icon_state = "labcoat_job"
	greyscale_config = /datum/greyscale_config/labcoat
	greyscale_config_worn = /datum/greyscale_config/labcoat/worn
	greyscale_colors = "#EEEEEE#F17420#F17420#EB6F2C"

/obj/item/clothing/suit/toggle/labcoat/chemist/Initialize(mapload)
	. = ..()
	allowed += /obj/item/storage/bag/chemistry

/obj/item/clothing/suit/toggle/labcoat/virologist
	name = "病毒长袍"
	desc = "一套能防护轻微化学泄漏的防护服，肩部饰有一条绿色条纹。"
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/toggle/labcoat/virologist"
	post_init_icon_state = "labcoat_job"
	greyscale_config = /datum/greyscale_config/labcoat
	greyscale_config_worn = /datum/greyscale_config/labcoat/worn
	greyscale_colors = "#EEEEEE#198019#198019#40992E"

/obj/item/clothing/suit/toggle/labcoat/virologist/Initialize(mapload)
	. = ..()
	allowed += /obj/item/storage/bag/bio

/obj/item/clothing/suit/toggle/labcoat/coroner
	name = "验尸官实验服"
	desc = "一种能防护轻微化学泼溅的服装。肩部有一条黑色条纹。"
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/toggle/labcoat/coroner"
	post_init_icon_state = "labcoat_job"
	greyscale_config = /datum/greyscale_config/labcoat
	greyscale_config_worn = /datum/greyscale_config/labcoat/worn
	greyscale_colors = "#EEEEEE#2D2D33#2D2D33#39393F"

/obj/item/clothing/suit/toggle/labcoat/coroner/Initialize(mapload)
	. = ..()
	allowed += list(
		/obj/item/autopsy_scanner,
		/obj/item/scythe,
		/obj/item/shovel,
		/obj/item/shovel/serrated,
		/obj/item/trench_tool,
	)

/obj/item/clothing/suit/toggle/labcoat/science
	name = "科研长袍"
	desc = "一套能防护轻微化学泄漏的防护服，肩部饰有一条紫色条纹。"
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/toggle/labcoat/science"
	post_init_icon_state = "labcoat_job"
	greyscale_config = /datum/greyscale_config/labcoat
	greyscale_config_worn = /datum/greyscale_config/labcoat/worn
	greyscale_colors = "#EEEEEE#7E1980#7E1980#B347A1"

/obj/item/clothing/suit/toggle/labcoat/science/Initialize(mapload)
	. = ..()
	allowed += /obj/item/storage/bag/xeno

/obj/item/clothing/suit/toggle/labcoat/roboticist
	name = "机械长袍"
	desc = "更像是一件古怪的外套而非实验工作服，有助于将血迹混成整体设计的一部分。还配有红色的护肩。"
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/toggle/labcoat/roboticist"
	post_init_icon_state = "labcoat_job"
	greyscale_config = /datum/greyscale_config/labcoat
	greyscale_config_worn = /datum/greyscale_config/labcoat/worn
	greyscale_colors = "#EEEEEE#88242D#88242D#39393F"

/obj/item/clothing/suit/toggle/labcoat/interdyne
	name = "英特达因长袍"
	desc = "更像是一件古怪的外套而非实验工作服，有助于将血迹混成整体设计的一部分。还配有红色的护肩。"
	icon = 'icons/map_icons/clothing/suit/_suit.dmi'
	icon_state = "/obj/item/clothing/suit/toggle/labcoat/interdyne"
	post_init_icon_state = "labcoat_job"
	greyscale_config = /datum/greyscale_config/labcoat
	greyscale_config_worn = /datum/greyscale_config/labcoat/worn
	greyscale_colors = "#EEEEEE#88242D#88242D#39393F"

// Research Director

/obj/item/clothing/suit/toggle/labcoat/research_director
	name = "研究主管的外套"
	desc = "介于实验服和普通外套之间的混合款式。由一种特殊的抗菌、抗酸、抗生物危害的合成面料制成。"
	icon_state = "labcoat_rd"
	armor_type = /datum/armor/jacket_research_director
	body_parts_covered = CHEST|GROIN|ARMS

/datum/armor/jacket_research_director
	bio = 75
	fire = 75
	acid = 75

/obj/item/clothing/suit/toggle/labcoat/research_director/Initialize(mapload)
	. = ..()
	allowed += list(
		/obj/item/storage/bag/xeno,
		/obj/item/melee/baton/telescopic,
	)
