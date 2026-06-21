//ASH SURGERY
/obj/item/cautery/ashwalker
	name = "原始烧灼器"
	icon = 'modular_nova/modules/ashwalkers/icons/ashwalker_tools.dmi'
	icon_state = "cautery"
	custom_materials = list(/datum/material/bone = SHEET_MATERIAL_AMOUNT)

	greyscale_colors = null
	greyscale_config = null
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null
	greyscale_config_worn = null
	post_init_icon_state = null
	resistance_flags = FIRE_PROOF | LAVA_PROOF

/datum/crafting_recipe/ash_recipe/ash_cautery
	name = "灰烬烧灼器"
	result = /obj/item/cautery/ashwalker

/obj/item/surgicaldrill/ashwalker
	name = "原始手术钻"
	icon = 'modular_nova/modules/ashwalkers/icons/ashwalker_tools.dmi'
	icon_state = "surgical_drill"
	custom_materials = list(/datum/material/bone = SHEET_MATERIAL_AMOUNT)

	greyscale_colors = null
	greyscale_config = null
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null
	greyscale_config_worn = null
	post_init_icon_state = null
	resistance_flags = FIRE_PROOF | LAVA_PROOF

/datum/crafting_recipe/ash_recipe/ash_drill
	name = "灰烬手术钻"
	result = /obj/item/surgicaldrill/ashwalker

/obj/item/scalpel/ashwalker
	name = "原始手术刀"
	icon = 'modular_nova/modules/ashwalkers/icons/ashwalker_tools.dmi'
	icon_state = "scalpel"
	custom_materials = list(/datum/material/bone = SHEET_MATERIAL_AMOUNT)

	greyscale_colors = null
	greyscale_config = null
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null
	greyscale_config_worn = null
	post_init_icon_state = null
	resistance_flags = FIRE_PROOF | LAVA_PROOF

/datum/crafting_recipe/ash_recipe/ash_scalpel
	name = "灰烬手术刀"
	result = /obj/item/scalpel/ashwalker

/obj/item/circular_saw/ashwalker
	name = "原始圆锯"
	icon = 'modular_nova/modules/ashwalkers/icons/ashwalker_tools.dmi'
	icon_state = "surgical_saw"
	custom_materials = list(/datum/material/bone = SHEET_MATERIAL_AMOUNT)

	greyscale_colors = null
	greyscale_config = null
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null
	greyscale_config_worn = null
	post_init_icon_state = null
	resistance_flags = FIRE_PROOF | LAVA_PROOF

/datum/crafting_recipe/ash_recipe/ash_saw
	name = "灰烬圆锯"
	result = /obj/item/circular_saw/ashwalker

/obj/item/retractor/ashwalker
	name = "原始牵开器"
	icon = 'modular_nova/modules/ashwalkers/icons/ashwalker_tools.dmi'
	icon_state = "retractors"
	custom_materials = list(/datum/material/bone = SHEET_MATERIAL_AMOUNT)

	greyscale_colors = null
	greyscale_config = null
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null
	greyscale_config_worn = null
	post_init_icon_state = null
	resistance_flags = FIRE_PROOF | LAVA_PROOF

/datum/crafting_recipe/ash_recipe/ash_retractor
	name = "灰烬牵开器"
	result = /obj/item/retractor/ashwalker

/obj/item/hemostat/ashwalker
	name = "原始止血钳"
	icon = 'modular_nova/modules/ashwalkers/icons/ashwalker_tools.dmi'
	icon_state = "hemostat"
	custom_materials = list(/datum/material/bone = SHEET_MATERIAL_AMOUNT)

	greyscale_colors = null
	greyscale_config = null
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null
	greyscale_config_worn = null
	post_init_icon_state = null
	resistance_flags = FIRE_PROOF | LAVA_PROOF

/datum/crafting_recipe/ash_recipe/ash_hemostat
	name = "灰烬止血钳"
	result = /obj/item/hemostat/ashwalker

/obj/item/bonesetter/ashwalker
	name = "原始接骨器"
	icon = 'modular_nova/modules/ashwalkers/icons/ashwalker_tools.dmi'
	icon_state = "bonesetter"
	custom_materials = list(/datum/material/bone = SHEET_MATERIAL_AMOUNT)

	greyscale_colors = null
	greyscale_config = null
	greyscale_config_inhand_left = null
	greyscale_config_inhand_right = null
	greyscale_config_worn = null
	post_init_icon_state = null
	resistance_flags = FIRE_PROOF | LAVA_PROOF

/datum/crafting_recipe/ash_recipe/ash_bonesetter
	name = "灰烬接骨器"
	result = /obj/item/bonesetter/ashwalker
