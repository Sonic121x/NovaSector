/datum/surgery_operation/limb/bioware
	abstract_type = /datum/surgery_operation/limb/bioware
	implements = list(
		IMPLEMENT_HAND = 1,
	)
	operation_flags = OPERATION_AFFECTS_MOOD | OPERATION_NOTABLE | OPERATION_MORBID | OPERATION_LOCKED
	required_bodytype = (~BODYTYPE_ROBOTIC & ~BODYTYPE_SYNTHETIC) // NOVA EDIT CHANGE - SYNTH FLAGS - ORIGINAL: required_bodytype = ~BODYTYPE_ROBOTIC
	time = 12.5 SECONDS
	all_surgery_states_required = SURGERY_SKIN_OPEN|SURGERY_BONE_SAWED|SURGERY_ORGANS_CUT
	/// What status effect is gained when the surgery is successful?
	/// Used to check against other bioware types to prevent stacking.
	var/datum/status_effect/status_effect_gained = /datum/status_effect/bioware
	/// Zone to operate on for this bioware
	var/required_zone = BODY_ZONE_CHEST

/datum/surgery_operation/limb/bioware/get_default_radial_image()
	return image('icons/hud/implants.dmi', "lighting_bolt")

/datum/surgery_operation/limb/bioware/all_required_strings()
	return list("operate on [parse_zone(required_zone)] (target [parse_zone(required_zone)])") + ..()

/datum/surgery_operation/limb/bioware/all_blocked_strings()
	var/list/incompatible_surgeries = list()
	for(var/datum/surgery_operation/limb/bioware/other_bioware as anything in subtypesof(/datum/surgery_operation/limb/bioware))
		if(other_bioware::status_effect_gained::id != status_effect_gained::id)
			continue
		if(other_bioware::required_bodytype != required_bodytype)
			continue
		incompatible_surgeries += (other_bioware.rnd_name || other_bioware.name)

	return ..() + list("the patient must not have undergone [english_list(incompatible_surgeries, and_text = " OR ")] prior")

/datum/surgery_operation/limb/bioware/state_check(obj/item/bodypart/limb)
	if(limb.body_zone != required_zone)
		return FALSE
	if(limb.owner.has_status_effect(status_effect_gained))
		return FALSE
	return TRUE

/datum/surgery_operation/limb/bioware/on_success(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	limb.owner.apply_status_effect(status_effect_gained)
	if(limb.owner.ckey)
		SSblackbox.record_feedback("tally", "bioware", 1, status_effect_gained)

/datum/surgery_operation/limb/bioware/vein_threading
	name = "血管编织"
	rnd_name = "Symvasculodesis (Vein Threading)" // "together vessel fusion"
	desc = "将患者的静脉编织成强化网状结构，减少受伤时的失血量。"
	status_effect_gained = /datum/status_effect/bioware/heart/threaded_veins

/datum/surgery_operation/limb/bioware/vein_threading/on_preop(obj/item/bodypart/limb, mob/living/surgeon, tool)
	display_results(
		surgeon,
		limb.owner,
		span_notice("你开始编织[limb.owner]的血管。"),
		span_notice("[surgeon] 开始编织 [limb.owner] 的血管。"),
		span_notice("[surgeon] 开始操作 [limb.owner] 的血管。"),
	)
	display_pain(limb.owner, "Your entire body burns in agony!")

/datum/surgery_operation/limb/bioware/vein_threading/on_success(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	. = ..()
	display_results(
		surgeon,
		limb.owner,
		span_notice("你将 [limb.owner] 的血管编织成了一张坚韧的网！"),
		span_notice("[surgeon] 将 [limb.owner] 的血管编织成了一张坚韧的网！"),
		span_notice("[surgeon] 完成了对 [limb.owner] 血管的操作。"),
	)
	display_pain(limb.owner, "You can feel your blood pumping through reinforced veins!")

/datum/surgery_operation/limb/bioware/vein_threading/mechanic
	rnd_name = "Hydraulics Routing Optimization (Threaded Veins)"
	desc = "优化机器人患者的液压系统管路，减少泄漏造成的液体流失。"
	required_bodytype = BODYTYPE_ROBOTIC
	operation_flags = parent_type::operation_flags | OPERATION_MECHANIC

/datum/surgery_operation/limb/bioware/muscled_veins
	name = "肌肉化血管"
	rnd_name = "Myovasculoplasty (Muscled Veins)" // "muscle vessel reshaping"
	desc = "在患者的血管上添加肌肉膜，使其无需心脏也能泵血。"
	status_effect_gained = /datum/status_effect/bioware/heart/muscled_veins

/datum/surgery_operation/limb/bioware/muscled_veins/on_preop(obj/item/bodypart/limb, mob/living/surgeon, tool)
	display_results(
		surgeon,
		limb.owner,
		span_notice("你开始将肌肉包裹在 [limb.owner] 的血管周围。"),
		span_notice("[surgeon] 开始将肌肉包裹在 [limb.owner] 的血管周围。"),
		span_notice("[surgeon] 开始操作 [limb.owner] 的血管。"),
	)
	display_pain(limb.owner, "Your entire body burns in agony!")

/datum/surgery_operation/limb/bioware/muscled_veins/on_success(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	. = ..()
	display_results(
		surgeon,
		limb.owner,
		span_notice("你重塑了 [limb.owner] 的血管，添加了一层肌肉膜！"),
		span_notice("[surgeon]重塑了[limb.owner]的血管，添加了一层肌肉膜！"),
		span_notice("[surgeon]完成了对[limb.owner]血管的操控。"),
	)
	display_pain(limb.owner, "You can feel your heartbeat's powerful pulses ripple through your body!")

/datum/surgery_operation/limb/bioware/muscled_veins/mechanic
	rnd_name = "Hydraulics Redundancy Subroutine (Muscled Veins)"
	desc = "为机械患者的液压系统增加冗余，使其无需引擎或泵即可输送流体。"
	required_bodytype = BODYTYPE_ROBOTIC
	operation_flags = parent_type::operation_flags | OPERATION_MECHANIC

/datum/surgery_operation/limb/bioware/nerve_splicing
	name = "神经接合"
	rnd_name = "Symneurodesis (Spliced Nerves)" // "together nerve fusion"
	desc = "将患者的神经接合在一起，使其对击晕效果更具抵抗力。"
	time = 15.5 SECONDS
	status_effect_gained = /datum/status_effect/bioware/nerves/spliced

/datum/surgery_operation/limb/bioware/nerve_splicing/on_preop(obj/item/bodypart/limb, mob/living/surgeon, tool)
	display_results(
		surgeon,
		limb.owner,
		span_notice("你开始接合[limb.owner]的神经。"),
		span_notice("[surgeon]开始接合[limb.owner]的神经。"),
		span_notice("[surgeon]开始操控[limb.owner]的神经系统。"),
	)
	display_pain(limb.owner, "Your entire body goes numb!")

/datum/surgery_operation/limb/bioware/nerve_splicing/on_success(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	. = ..()
	display_results(
		surgeon,
		limb.owner,
		span_notice("你成功接合了[limb.owner]的神经系统！"),
		span_notice("[surgeon]成功接合了[limb.owner]的神经系统！"),
		span_notice("[surgeon]完成了对[limb.owner]神经系统的操控。"),
	)
	display_pain(limb.owner, "You regain feeling in your body; It feels like everything's happening around you in slow motion!")

/datum/surgery_operation/limb/bioware/nerve_splicing/mechanic
	rnd_name = "System Automatic Reset Subroutine (Spliced Nerves)"
	desc = "升级机械患者的自动系统，使其能更好地抵抗击晕效果。"
	required_bodytype = BODYTYPE_ROBOTIC
	operation_flags = parent_type::operation_flags | OPERATION_MECHANIC

/datum/surgery_operation/limb/bioware/nerve_grounding
	name = "神经接地"
	rnd_name = "Xanthoneuroplasty (Grounded Nerves)" // "yellow nerve reshaping". see: yellow gloves
	desc = "将患者的神经重新布线，使其充当接地棒，保护其免受电击。"
	time = 15.5 SECONDS
	status_effect_gained = /datum/status_effect/bioware/nerves/grounded

/datum/surgery_operation/limb/bioware/nerve_grounding/on_preop(obj/item/bodypart/limb, mob/living/surgeon, tool)
	display_results(
		surgeon,
		limb.owner,
		span_notice("你开始重新布线[limb.owner]的神经。"),
		span_notice("[surgeon]开始重新布线[limb.owner]的神经。"),
		span_notice("[surgeon]开始操纵[limb.owner]的神经系统。"),
	)
	display_pain(limb.owner, "Your entire body goes numb!")

/datum/surgery_operation/limb/bioware/nerve_grounding/on_success(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	. = ..()
	display_results(
		surgeon,
		limb.owner,
		span_notice("你成功重新布线了[limb.owner]的神经系统！"),
		span_notice("[surgeon]成功重新布线了[limb.owner]的神经系统！"),
		span_notice("[surgeon]完成了对[limb.owner]神经系统的操纵。"),
	)
	display_pain(limb.owner, "You regain feeling in your body! You feel energized!")

/datum/surgery_operation/limb/bioware/nerve_grounding/mechanic
	rnd_name = "System Shock Dampening (Grounded Nerves)"
	desc = "将接地棒安装到机器人患者的神经系统中，保护其免受电击。"
	required_bodytype = BODYTYPE_ROBOTIC
	operation_flags = parent_type::operation_flags | OPERATION_MECHANIC

/datum/surgery_operation/limb/bioware/ligament_hook
	name = "重塑韧带"
	rnd_name = "Arthroplasty (Ligament Hooks)" // "joint reshaping"
	desc = "重塑患者的韧带，允许肢体在切断后手动重新连接——代价是使其更容易脱落。"
	status_effect_gained = /datum/status_effect/bioware/ligaments/hooked

/datum/surgery_operation/limb/bioware/ligament_hook/on_preop(obj/item/bodypart/limb, mob/living/surgeon, tool)
	display_results(
		surgeon,
		limb.owner,
		span_notice("你开始将[limb.owner]的韧带重塑成钩状。"),
		span_notice("[surgeon] 开始将 [limb.owner] 的韧带重塑成钩状。"),
		span_notice("[surgeon] 开始操纵 [limb.owner] 的韧带。"),
	)
	display_pain(limb.owner, "Your limbs burn with severe pain!")

/datum/surgery_operation/limb/bioware/ligament_hook/on_success(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	. = ..()
	display_results(
		surgeon,
		limb.owner,
		span_notice("你将 [limb.owner] 的韧带重塑成了一个连接钩！"),
		span_notice("[surgeon] 将 [limb.owner] 的韧带重塑成了一个连接钩！"),
		span_notice("[surgeon] 完成了对 [limb.owner] 韧带的操纵。"),
	)
	display_pain(limb.owner, "Your limbs feel... strangely loose.")

/datum/surgery_operation/limb/bioware/ligament_hook/mechanic
	rnd_name = "Anchor Point Snaplocks (Ligament Hooks)"
	desc = "Refactor a robotic patient's limb joints to allow for rapid deatchment, allowing limbs to be manually reattached if severed - \
		at the cost of making them easier to detach as well."
	required_bodytype = BODYTYPE_ROBOTIC
	operation_flags = parent_type::operation_flags | OPERATION_MECHANIC

/datum/surgery_operation/limb/bioware/ligament_reinforcement
	name = "强化韧带"
	rnd_name = "Arthrorrhaphy (Ligament Reinforcement)" // "joint strengthening" / "joint stitching"
	desc = "强化患者的韧带，使其更难被肢解，但代价是神经连接更容易被中断。"
	status_effect_gained = /datum/status_effect/bioware/ligaments/reinforced

/datum/surgery_operation/limb/bioware/ligament_reinforcement/on_preop(obj/item/bodypart/limb, mob/living/surgeon, tool)
	display_results(
		surgeon,
		limb.owner,
		span_notice("你开始加固 [limb.owner] 的韧带。"),
		span_notice("[surgeon] 开始加固 [limb.owner] 的韧带。"),
		span_notice("[surgeon] 开始操纵 [limb.owner] 的韧带。"),
	)
	display_pain(limb.owner, "Your limbs burn with severe pain!")

/datum/surgery_operation/limb/bioware/ligament_reinforcement/on_success(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	. = ..()
	display_results(
		surgeon,
		limb.owner,
		span_notice("你加固了 [limb.owner] 的韧带！"),
		span_notice("[surgeon] 加固了 [limb.owner] 的韧带！"),
		span_notice("[surgeon] 完成了对[limb.owner]韧带的操作。"),
	)
	display_pain(limb.owner, "Your limbs feel more secure, but also more frail.")

/datum/surgery_operation/limb/bioware/ligament_reinforcement/mechanic
	rnd_name = "Anchor Point Reinforcement (Ligament Reinforcement)"
	desc = "加固机械病人的肢体关节以防止截肢，代价是使神经连接更容易中断。"
	required_bodytype = BODYTYPE_ROBOTIC
	operation_flags = parent_type::operation_flags | OPERATION_MECHANIC

/datum/surgery_operation/limb/bioware/cortex_folding
	name = "皮层折叠"
	rnd_name = "Encephalofractoplasty (Cortex Folding)" // it's a stretch - "brain fractal reshaping"
	desc = "一种生物升级，将病人的大脑皮层折叠成分形图案，增加神经密度和灵活性。"
	operation_flags = OPERATION_AFFECTS_MOOD | OPERATION_NOTABLE | OPERATION_MORBID | OPERATION_LOCKED | OPERATION_NO_PATIENT_REQUIRED
	status_effect_gained = /datum/status_effect/bioware/cortex // Not actually applied, simply for compatibility checks
	required_zone = BODY_ZONE_HEAD

/datum/surgery_operation/limb/bioware/cortex_folding/state_check(obj/item/bodypart/limb)
	. = ..()
	if (!.)
		return
	var/obj/item/organ/brain/brain = locate() in limb
	if(isnull(brain))
		return FALSE
	return !HAS_TRAIT_FROM(brain, TRAIT_SPECIAL_TRAUMA_BOOST, BIOWARE_TRAIT)

/datum/surgery_operation/limb/bioware/cortex_folding/on_success(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	. = ..()
	var/obj/item/organ/brain/brain = locate() in limb
	if(!isnull(brain))
		ADD_TRAIT(brain, TRAIT_SPECIAL_TRAUMA_BOOST, BIOWARE_TRAIT)

/datum/surgery_operation/limb/bioware/cortex_folding/on_preop(obj/item/bodypart/limb, mob/living/surgeon, tool)
	display_results(
		surgeon,
		limb.owner,
		span_notice("你开始折叠[limb.owner]的大脑皮层。"),
		span_notice("[surgeon] 开始折叠[limb.owner]的大脑皮层。"),
		span_notice("[surgeon] 开始对[limb.owner]的大脑进行手术。"),
	)
	display_pain(limb.owner, "Your head throbs with gruesome pain, it's nearly too much to handle!")

/datum/surgery_operation/limb/bioware/cortex_folding/on_success(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	. = ..()
	display_results(
		surgeon,
		limb.owner,
		span_notice("你将[limb.owner]的大脑皮层折叠成了分形图案！"),
		span_notice("[surgeon] 将[limb.owner]的大脑皮层折叠成了分形图案！"),
		span_notice("[surgeon] 完成了对[limb.owner]大脑的手术。"),
	)
	display_pain(limb.owner, "Your brain feels stronger... and more flexible!")

/datum/surgery_operation/limb/bioware/cortex_folding/on_failure(obj/item/bodypart/limb, mob/living/surgeon, tool)
	var/obj/item/organ/brain/brain = locate() in limb
	if(isnull(brain))
		return ..()
	display_results(
		surgeon,
		limb.owner,
		span_warning("你搞砸了，损伤了大脑！"),
		span_warning("[surgeon] 搞砸了，损伤了大脑！"),
		span_notice("[surgeon] 完成了对[limb.owner]大脑的手术。"),
	)
	display_pain(limb.owner, "Your head throbs with excruciating pain!")
	brain.apply_organ_damage(60)
	brain.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_LOBOTOMY)

/datum/surgery_operation/limb/bioware/cortex_folding/mechanic
	rnd_name = "Wetware OS Labyrinthian Programming (Cortex Folding)"
	desc = "用一种极其诡异的编程语言重新编程机器人患者的神经网络，为非标准神经模式腾出空间。"
	required_bodytype = BODYTYPE_ROBOTIC
	operation_flags = parent_type::operation_flags | OPERATION_MECHANIC

/datum/surgery_operation/limb/bioware/cortex_imprint
	name = "皮层印记"
	rnd_name = "Encephalopremoplasty (Cortex Imprinting)" // it's a stretch - "brain print reshaping"
	desc = "一种生物升级，将患者的大脑皮层雕刻成自我印记模式，增加神经密度和韧性。"
	status_effect_gained = /datum/status_effect/bioware/cortex/imprinted
	required_zone = BODY_ZONE_HEAD

/datum/surgery_operation/limb/bioware/cortex_imprint/on_preop(obj/item/bodypart/limb, mob/living/surgeon, tool)
	display_results(
		surgeon,
		limb.owner,
		span_notice("你开始将[limb.owner]的外层大脑皮层雕刻成自我印记模式。"),
		span_notice("[surgeon] 开始将[limb.owner]的外层大脑皮层雕刻成自我印记模式。"),
		span_notice("[surgeon] 开始对[limb.owner]的大脑进行手术。"),
	)
	display_pain(limb.owner, "Your head throbs with gruesome pain, it's nearly too much to handle!")

/datum/surgery_operation/limb/bioware/cortex_imprint/on_success(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	. = ..()
	display_results(
		surgeon,
		limb.owner,
		span_notice("你将[limb.owner]的外层大脑皮层重塑成了自我印记模式！"),
		span_notice("[surgeon] 将[limb.owner]的外层大脑皮层重塑成了自我印记模式！"),
		span_notice("[surgeon] 完成了对[limb.owner]大脑的手术。"),
	)
	display_pain(limb.owner, "Your brain feels stronger... and more resilient!")

/datum/surgery_operation/limb/bioware/cortex_imprint/on_failure(obj/item/bodypart/limb, mob/living/surgeon, tool)
	if(!limb.owner.get_organ_slot(ORGAN_SLOT_BRAIN))
		return ..()
	display_results(
		surgeon,
		limb.owner,
		span_warning("你搞砸了，损伤了大脑！"),
		span_warning("[surgeon] 搞砸了，损伤了大脑！"),
		span_notice("[surgeon] 完成了对 [limb.owner] 大脑的手术。"),
	)
	display_pain(limb.owner, "Your brain throbs with intense pain; Thinking hurts!")
	limb.owner.adjust_organ_loss(ORGAN_SLOT_BRAIN, 60)
	limb.owner.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_LOBOTOMY)

/datum/surgery_operation/limb/bioware/cortex_imprint/mechanic
	rnd_name = "Wetware OS Ver 2.0 (Cortex Imprinting)"
	desc = "Update a robotic patient's operating system to a \"newer version\", improving overall performance and resilience. \
		Shame about all the adware."
	required_bodytype = BODYTYPE_ROBOTIC
	operation_flags = parent_type::operation_flags | OPERATION_MECHANIC
