/datum/augment_item/organ
	abstract_type = /datum/augment_item/organ
	category = AUGMENT_CATEGORY_INTERNAL_IMPLANTS
	/// Whether this organ augment is visible from outside or not
	var/is_visible
	/// Any icon to display (for internal implant categories)
	var/icon

/datum/augment_item/organ/New()
	// Figure out if we should visually apply or not

	// Cyberimp overlays - yes!
	if(ispath(path, /obj/item/organ/cyberimp))
		var/obj/item/organ/cyberimp/cybernetic_path = path
		is_visible = !isnull(cybernetic_path::aug_overlay)
		return ..()

	// otherwise go by the organ's visual var
	var/obj/item/organ/organ_path = path
	is_visible = organ_path::visual
	return ..()

/datum/augment_item/organ/apply(mob/living/carbon/human/human_holder, character_setup = FALSE, datum/preferences/prefs)
	if(character_setup && !is_visible)
		return

	var/obj/item/organ/organ_path = path // cast this to an organ so we can get the slot from it using initial()
	var/obj/item/organ/new_organ = new path()
	new_organ.copy_traits_from(human_holder.get_organ_slot(initial(organ_path.slot)))
	new_organ.Insert(human_holder, special = TRUE, movement_flags = DELETE_IF_REPLACED)

//BRAINS
/datum/augment_item/organ/brain
	abstract_type = /datum/augment_item/organ/brain
	slot = AUGMENT_SLOT_BRAIN
	icon = FA_ICON_BRAIN
	species_blacklist = list(SPECIES_PROTEAN = 1)

/datum/augment_item/organ/brain/apply(mob/living/carbon/human/human_holder, character_setup = FALSE, datum/preferences/prefs)
	if(character_setup)
		return

	if(slot == AUGMENT_SLOT_BRAIN)
		var/obj/item/organ/brain/old_brain = human_holder.get_organ_slot(ORGAN_SLOT_BRAIN)
		var/obj/item/organ/brain/new_brain = new path

		var/datum/mind/holder_mind = human_holder.mind

		new_brain.modular_persistence = old_brain.modular_persistence
		old_brain.modular_persistence = null
		new_brain.modular_persistence?.owner_brain = WEAKREF(new_brain)

		new_brain.copy_traits_from(old_brain)
		new_brain.Insert(human_holder, special = TRUE)
		old_brain.moveToNullspace()  //for some reason it doesn't want to be deleted. So I'm using this hack method until it can be figured out why. But, it works!
		STOP_PROCESSING(SSobj, old_brain)

		if(!holder_mind)
			return

		holder_mind.transfer_to(human_holder, TRUE)

/datum/augment_item/organ/brain/cortical
	name = "皮层增强大脑"
	slot = AUGMENT_SLOT_BRAIN
	path = /obj/item/organ/brain/cybernetic/cortical

//HEARTS
/datum/augment_item/organ/heart
	abstract_type = /datum/augment_item/organ/heart
	slot = AUGMENT_SLOT_HEART
	icon = "tg-znova-heart-organ"
	species_blacklist = list(SPECIES_HEMOPHAGE = 1)

/datum/augment_item/organ/heart/normal
	name = "有机心脏"
	path = /obj/item/organ/heart

/datum/augment_item/organ/heart/cybernetic
	name = "赛博格心脏"
	path = /obj/item/organ/heart/cybernetic

/datum/augment_item/organ/heart/synth
	name = "液压泵引擎"
	path =/obj/item/organ/heart/synth

//LUNGS
/datum/augment_item/organ/lungs
	abstract_type = /datum/augment_item/organ/lungs
	slot = AUGMENT_SLOT_LUNGS
	icon = FA_ICON_LUNGS

/datum/augment_item/organ/lungs/normal
	name = "有机肺"
	path = /obj/item/organ/lungs

/datum/augment_item/organ/lungs/cybernetic
	name = "赛博格肺"
	path = /obj/item/organ/lungs/cybernetic

//LIVERS
/datum/augment_item/organ/liver
	abstract_type = /datum/augment_item/organ/liver
	slot = AUGMENT_SLOT_LIVER
	icon = "tg-znova-liver"

/datum/augment_item/organ/liver/normal
	name = "有机肝脏"
	path = /obj/item/organ/liver

/datum/augment_item/organ/liver/cybernetic
	name = "赛博格肝脏"
	path = /obj/item/organ/liver/cybernetic

/datum/augment_item/organ/liver/synth
	name = "试剂处理单元"
	path = /obj/item/organ/liver/synth

//STOMACHES
/datum/augment_item/organ/stomach
	abstract_type = /datum/augment_item/organ/stomach
	slot = AUGMENT_SLOT_STOMACH
	icon = "tg-znova-stomach"

/datum/augment_item/organ/stomach/normal
	name = "有机胃"
	path = /obj/item/organ/stomach

/datum/augment_item/organ/stomach/cybernetic
	name = "赛博格胃"
	path = /obj/item/organ/stomach/cybernetic

/datum/augment_item/organ/stomach/lithovore
	name = "石食胃"
	path = /obj/item/organ/stomach/lithovore

/datum/augment_item/organ/stomach/lithovore/apply(mob/living/carbon/human/H, character_setup = FALSE, datum/preferences/prefs)
	if(prefs && ("Oversized" in prefs.all_quirks))
		path = /obj/item/organ/stomach/lithovore/oversized
	return ..()

//EYES
/datum/augment_item/organ/eyes
	abstract_type = /datum/augment_item/organ/eyes
	slot = AUGMENT_SLOT_EYES
	icon = FA_ICON_EYE

/datum/augment_item/organ/eyes/normal
	name = "有机眼"
	path = /obj/item/organ/eyes

/datum/augment_item/organ/eyes/cybernetic
	name = "赛博格眼"
	path = /obj/item/organ/eyes/robotic

/datum/augment_item/organ/eyes/cybernetic/moth
	name = "赛博化蛾眼"
	path = /obj/item/organ/eyes/robotic/moth

/datum/augment_item/organ/eyes/highlumi
	name = "高亮度眼睛"
	path = /obj/item/organ/eyes/robotic/glow
	cost = 1

/datum/augment_item/organ/eyes/highlumi/moth
	name = "高亮度蛾眼"
	path = /obj/item/organ/eyes/robotic/glow/moth
	cost = 1

/datum/augment_item/organ/eyes/binoculars
	name = "数字放大光学镜片 (x3)"
	cost = 4
	path = /obj/item/organ/eyes/robotic/binoculars


//MOUTH IMPLANTS
/datum/augment_item/organ/mouth
	abstract_type = /datum/augment_item/organ/mouth
	slot = AUGMENT_SLOT_MOUTH_IMPLANT
	icon = "tg-znova-lips"

/datum/augment_item/organ/mouth/breathing_tube
	name = "Breathing Tube"
	cost = 2
	path = /obj/item/organ/cyberimp/mouth/breathing_tube

/datum/augment_item/organ/mouth/breathing_tube/hidden
	name = "Integrated Breathing Tube (Hidden)"
	cost = 2
	path = /obj/item/organ/cyberimp/mouth/breathing_tube/hidden

//TONGUES
/datum/augment_item/organ/tongue
	abstract_type = /datum/augment_item/organ/tongue
	slot = AUGMENT_SLOT_TONGUE
	icon = "tg-znova-tongue"

/datum/augment_item/organ/tongue/normal
	name = "有机舌头"
	path = /obj/item/organ/tongue/human

/datum/augment_item/organ/tongue/robo
	name = "机械发声器"
	path = /obj/item/organ/tongue/robot

/datum/augment_item/organ/tongue/robo/forked
	name = "机械蜥蜴发声器"
	path = /obj/item/organ/tongue/lizard/robot

/datum/augment_item/organ/tongue/cybernetic
	name = "赛博化舌头"
	path = /obj/item/organ/tongue/cybernetic

/datum/augment_item/organ/tongue/cybernetic/forked
	name = "分叉赛博化舌头"
	path = /obj/item/organ/tongue/lizard/cybernetic

/datum/augment_item/organ/tongue/forked
	name = "分叉舌头"
	path = /obj/item/organ/tongue/lizard

/datum/augment_item/organ/tongue/forked/filterless
	name = "分叉舌头 (无TTS过滤器)"
	path = /obj/item/organ/tongue/lizard/filterless

//EARS
/datum/augment_item/organ/ears
	abstract_type = /datum/augment_item/organ/ears
	slot = AUGMENT_SLOT_EARS
	icon = "tg-znova-ear"

/datum/augment_item/organ/ears/normal
	name = "有机耳朵"
	path = /obj/item/organ/ears

/datum/augment_item/organ/ears/cybernetic
	name = "赛博化耳朵"
	path = /obj/item/organ/ears/cybernetic

/// Cyber cat ears - Cosmetic types for augments only

/obj/item/organ/ears/cat/cybernetic/blue
	icon_state = "ears-c-cat-blue"
	bodypart_overlay = /datum/bodypart_overlay/mutant/cat_ears/cybernetic/blue

/obj/item/organ/ears/cat/cybernetic/green
	icon_state = "ears-c-cat-green"
	bodypart_overlay = /datum/bodypart_overlay/mutant/cat_ears/cybernetic/green

/datum/augment_item/organ/ears/cybernetic/cat
	name = "赛博化猫耳"
	path = /obj/item/organ/ears/cat/cybernetic

/datum/augment_item/organ/ears/cybernetic/cat/blue
	name = "赛博化猫耳 (蓝色)"
	path = /obj/item/organ/ears/cat/cybernetic/blue

/datum/augment_item/organ/ears/cybernetic/cat/green
	name = "赛博化猫耳 (绿色)"
	path = /obj/item/organ/ears/cat/cybernetic/green
