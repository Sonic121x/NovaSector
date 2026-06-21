/////////////////////////////////////
//////////Limb Grower Designs ///////
/////////////////////////////////////

/datum/design/leftarm
	name = "左臂"
	id = "arm/left"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 25)
	build_path = /obj/item/bodypart/arm/left
	category = list(RND_CATEGORY_INITIAL, SPECIES_HUMAN, SPECIES_LIZARD, SPECIES_MOTH, SPECIES_PLASMAMAN, SPECIES_ETHEREAL)

/datum/design/rightarm
	name = "右臂"
	id = "arm/right"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 25)
	build_path = /obj/item/bodypart/arm/right
	category = list(RND_CATEGORY_INITIAL, SPECIES_HUMAN, SPECIES_LIZARD, SPECIES_MOTH, SPECIES_PLASMAMAN, SPECIES_ETHEREAL)

/datum/design/leftleg
	name = "左腿"
	id = "leg/left"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 25)
	build_path = /obj/item/bodypart/leg/left
	category = list(RND_CATEGORY_INITIAL, SPECIES_HUMAN, SPECIES_LIZARD, SPECIES_MOTH, SPECIES_PLASMAMAN, SPECIES_ETHEREAL, RND_CATEGORY_LIMBS_DIGITIGRADE)

/datum/design/rightleg
	name = "右腿"
	id = "leg/right"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 25)
	build_path = /obj/item/bodypart/leg/right
	category = list(RND_CATEGORY_INITIAL, SPECIES_HUMAN, SPECIES_LIZARD, SPECIES_MOTH, SPECIES_PLASMAMAN, SPECIES_ETHEREAL, RND_CATEGORY_LIMBS_DIGITIGRADE)

//Non-limb limb designs

/datum/design/heart
	name = "Heart-心脏"
	id = "heart"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 30)
	build_path = /obj/item/organ/heart
	category = list(SPECIES_HUMAN, RND_CATEGORY_INITIAL)

/datum/design/lungs
	name = "Lungs-肺"
	id = "lungs"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 20)
	build_path = /obj/item/organ/lungs
	category = list(SPECIES_HUMAN, RND_CATEGORY_INITIAL)

/datum/design/liver
	name = "Liver-肝"
	id = "liver"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 20)
	build_path = /obj/item/organ/liver
	category = list(SPECIES_HUMAN, RND_CATEGORY_INITIAL)

/datum/design/stomach
	name = "Stomach(胃)"
	id = "stomach"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 15)
	build_path = /obj/item/organ/stomach
	category = list(SPECIES_HUMAN, RND_CATEGORY_INITIAL)

/datum/design/appendix
	name = "Appendix-阑尾"
	id = "appendix"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 5) //why would you need this
	build_path = /obj/item/organ/appendix
	category = list(SPECIES_HUMAN, RND_CATEGORY_INITIAL)

/datum/design/eyes
	name = "Eyes-眼睛"
	id = "eyes"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10)
	build_path = /obj/item/organ/eyes
	category = list(SPECIES_HUMAN, RND_CATEGORY_INITIAL)

/datum/design/ears
	name = "Ears-耳朵"
	id = "ears"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10)
	build_path = /obj/item/organ/ears
	category = list(SPECIES_HUMAN, RND_CATEGORY_INITIAL)

/datum/design/tongue
	name = "Tongue-舌"
	id = "tongue"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10)
	build_path = /obj/item/organ/tongue
	category = list(SPECIES_HUMAN, RND_CATEGORY_INITIAL)

// Grows a fake lizard tail - not usable in lizard wine and other similar recipes.
/datum/design/lizard_tail
	name = "蜥蜴尾"
	id = "liztail"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 20)
	build_path = /obj/item/organ/tail/lizard/fake
	category = list(SPECIES_LIZARD)

/datum/design/lizard_tongue
	name = "分叉的舌头"
	id = "liztongue"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 20)
	build_path = /obj/item/organ/tongue/lizard
	category = list(SPECIES_LIZARD)

/datum/design/monkey_tail
	name = "猴尾"
	id = "monkeytail"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 20)
	build_path = /obj/item/organ/tail/monkey
	category = list(RND_CATEGORY_LIMBS_OTHER, RND_CATEGORY_INITIAL)

/datum/design/cat_tail
	name = "猫尾"
	id = "cattail"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 20)
	build_path = /obj/item/organ/tail/cat
	category = list(SPECIES_HUMAN)

/datum/design/cat_ears
	name = "猫耳"
	id = "catears"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10)
	build_path = /obj/item/organ/ears/cat
	category = list(SPECIES_HUMAN)

/datum/design/cat_tongue
	name = "猫舌"
	id = "cattongue"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10)
	build_path = /obj/item/organ/tongue/cat
	category = list(SPECIES_HUMAN)

/datum/design/plasmaman_lungs
	name = "等离子过滤器"
	id = "plasmamanlungs"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10, /datum/reagent/toxin/plasma = 20)
	build_path = /obj/item/organ/lungs/plasmaman
	category = list(SPECIES_PLASMAMAN)

/datum/design/plasmaman_tongue
	name = "Plasma Bone Tongue等离子骨舌"
	id = "plasmamantongue"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10, /datum/reagent/toxin/plasma = 20)
	build_path = /obj/item/organ/tongue/bone/plasmaman
	category = list(SPECIES_PLASMAMAN)

/datum/design/plasmaman_liver
	name = "试剂处理晶体"
	id = "plasmamanliver"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10, /datum/reagent/toxin/plasma = 20)
	build_path = /obj/item/organ/liver/bone/plasmaman
	category = list(SPECIES_PLASMAMAN)

/datum/design/plasmaman_stomach
	name = "消化晶体"
	id = "plasmamanstomach"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10, /datum/reagent/toxin/plasma = 20)
	build_path = /obj/item/organ/stomach/bone/plasmaman
	category = list(SPECIES_PLASMAMAN)

/datum/design/ethereal_stomach
	name = "生物电池"
	id = "etherealstomach"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10, /datum/reagent/consumable/liquidelectricity/enriched = 20)
	build_path = /obj/item/organ/stomach/ethereal
	category = list(SPECIES_ETHEREAL)

/datum/design/ethereal_tongue
	name = "放电器"
	id = "etherealtongue"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10, /datum/reagent/consumable/liquidelectricity/enriched = 20)
	build_path = /obj/item/organ/tongue/ethereal
	category = list(SPECIES_ETHEREAL)

/datum/design/ethereal_lungs
	name = "通气网"
	id = "ethereallungs"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10, /datum/reagent/consumable/liquidelectricity/enriched = 20)
	build_path = /obj/item/organ/lungs/ethereal
	category = list(SPECIES_ETHEREAL)

// Intentionally not growable by normal means - for balance conerns.
/datum/design/ethereal_heart
	name = "晶体核心"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 10, /datum/reagent/consumable/liquidelectricity/enriched = 20)
	build_path = /obj/item/organ/heart/ethereal
	category = list(SPECIES_ETHEREAL)

/datum/design/armblade
	name = "臂刃"
	id = "armblade"
	build_type = LIMBGROWER
	reagents_list = list(/datum/reagent/medicine/c2/synthflesh = 75)
	build_path = /obj/item/melee/synthetic_arm_blade
	category = list(RND_CATEGORY_LIMBS_OTHER, RND_CATEGORY_HACKED)

/// Design disks and designs - for adding limbs and organs to the limbgrower.
/obj/item/disk/design_disk/limbs
	name = "肢体设计盘"
	desc = "一张包含用于肢体培养器的肢体与器官设计方案的磁盘。"
	icon_state = "datadisk1"
	/// List of all limb designs this disk contains.
	var/list/limb_designs = list()

/obj/item/disk/design_disk/limbs/Initialize(mapload)
	. = ..()
	for(var/design in limb_designs)
		var/datum/design/new_design = design
		blueprints += new new_design

/datum/design/limb_disk
	name = "肢体设计盘"
	desc = "包含各种肢体的设计图。"
	build_type = PROTOLATHE
	materials = list(/datum/material/iron =SMALL_MATERIAL_AMOUNT * 3, /datum/material/glass =SMALL_MATERIAL_AMOUNT)
	build_path = /obj/item/disk/design_disk/limbs
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/obj/item/disk/design_disk/limbs/felinid
	name = "猫人器官设计盘"
	limb_designs = list(/datum/design/cat_tail, /datum/design/cat_ears, /datum/design/cat_tongue)

/datum/design/limb_disk/felinid
	name = "猫人器官设计盘"
	desc = "包含用于肢体生长器的猫人器官设计 - 猫人耳朵、尾巴和舌头。"
	id = "limbdesign_felinid"
	build_path = /obj/item/disk/design_disk/limbs/felinid

/obj/item/disk/design_disk/limbs/lizard
	name = "蜥蜴器官设计盘"
	limb_designs = list(/datum/design/lizard_tail, /datum/design/lizard_tongue)

/datum/design/limb_disk/lizard
	name = "蜥蜴器官设计盘"
	desc = "包含用于肢芽生长蜥蜴的蜥蜴器官设计图——蜥蜴的舌头和尾巴"
	id = "limbdesign_lizard"
	build_path = /obj/item/disk/design_disk/limbs/lizard

/obj/item/disk/design_disk/limbs/plasmaman
	name = "等离子人器官设计盘"
	limb_designs = list(/datum/design/plasmaman_stomach, /datum/design/plasmaman_liver, /datum/design/plasmaman_lungs, /datum/design/plasmaman_tongue)

/datum/design/limb_disk/plasmaman
	name = "等离子人器官设计盘"
	desc = "包含肢体生长机的等离子人器官设计图——等离子人的舌头、肝脏、胃和肺。"
	id = "limbdesign_plasmaman"
	build_path = /obj/item/disk/design_disk/limbs/plasmaman

/obj/item/disk/design_disk/limbs/ethereal
	name = "电气人器官设计盘"
	limb_designs = list(/datum/design/ethereal_stomach, /datum/design/ethereal_tongue, /datum/design/ethereal_lungs)

/datum/design/limb_disk/ethereal
	name = "电气人器官设计盘"
	desc = "包含肢体生长机的电气人器官设计——电气人的舌头和胃。"
	id = "limbdesign_ethereal"
	build_path = /obj/item/disk/design_disk/limbs/ethereal
