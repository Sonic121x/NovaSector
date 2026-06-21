// Giant 3x3 tile warning hologram that tells people they should probably stand outside of it

/obj/structure/holosign/treatment_zone_warning
	name = "治疗区域指示器"
	desc = "一个巨大的发光全息标志，警告你远离它，里面可能正在进行一些重要的事情！"
	icon = 'modular_nova/modules/deforest_medical_items/icons/telegraph_96x96.dmi'
	icon_state = "treatment_zone"
	layer = BELOW_OBJ_LAYER
	pixel_x = -32
	pixel_y = -32
	use_vis_overlay = FALSE

// Projector for the above mentioned treatment zone signs

/obj/item/holosign_creator/medical/treatment_zone
	name = "紧急治疗区域投影仪"
	desc = "一种全息投影仪，可创建一个大型、标记清晰的区域全息图，警告外部人员应远离该区域。"
	holosign_type = /obj/structure/holosign/treatment_zone_warning
	creation_time = 1 SECONDS
	max_signs = 1

// Tech design for printing the projectors

/datum/design/treatment_zone_projector
	name = "紧急治疗区域投影仪"
	desc = "一种全息投影仪，可创建一个大型、标记清晰的区域全息图，警告外部人员应远离该区域。"
	build_type = PROTOLATHE | AWAY_LATHE
	build_path = /obj/item/holosign_creator/medical/treatment_zone
	materials = list(
		/datum/material/iron = SMALL_MATERIAL_AMOUNT * 5,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT * 5,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT,
	)
	id = "treatment_zone_projector"
	category = list(
		RND_CATEGORY_TOOLS + RND_SUBCATEGORY_TOOLS_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/datum/techweb_node/holographics/New()
	. = ..()
	design_ids.Add("treatment_zone_projector")

// Adds the funny projector to medical borgs

/obj/item/robot_model/medical/Initialize(mapload)
	basic_modules += /obj/item/holosign_creator/medical/treatment_zone
	return ..()
