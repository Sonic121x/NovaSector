// Basic operations for moving back and forth between surgery states
/// First step of every surgery, makes an incision in the skin
/datum/surgery_operation/limb/incise_skin
	name = "切开皮肤"
	// rnd_name = "Laparotomy / Craniotomy / Myotomy (Make Incision)" // Maybe we keep this one simple
	desc = "Make an incision in the patient's skin to access internal organs. \
		Causes \"cut skin\" surgical state."
	required_bodytype = (~BODYTYPE_ROBOTIC & ~BODYTYPE_SYNTHETIC) // NOVA EDIT CHANGE - SYNTH FLAGS - ORIGINAL: required_bodytype = ~BODYTYPE_ROBOTIC
	replaced_by = /datum/surgery_operation/limb/incise_skin/abductor
	implements = list(
		TOOL_SCALPEL = 1,
		/obj/item/melee/energy/sword = 1.33,
		/obj/item/knife = 1.5,
		/obj/item/shard = 2.25,
		/obj/item/screwdriver = 5,
		/obj/item/pen = 5,
		/obj/item = 3.33,
	)
	time = 1.6 SECONDS
	preop_sound = 'sound/items/handling/surgery/scalpel1.ogg'
	success_sound = 'sound/items/handling/surgery/scalpel2.ogg'
	operation_flags = OPERATION_AFFECTS_MOOD | OPERATION_NO_PATIENT_REQUIRED
	any_surgery_states_blocked = ALL_SURGERY_SKIN_STATES
	allow_stumps = TRUE
	/// We can't cut mobs with this biostate
	var/biostate_blacklist = BIO_CHITIN

/datum/surgery_operation/limb/incise_skin/get_any_tool()
	return "任何锋利的物品"

/datum/surgery_operation/limb/incise_skin/get_default_radial_image()
	return image('icons/hud/surgery_radial.dmi', "make_incision")

/datum/surgery_operation/limb/incise_skin/tool_check(obj/item/tool)
	// Require edged sharpness OR a tool behavior match
	if((tool.get_sharpness() & SHARP_EDGED) || implements[tool.tool_behaviour])
		return TRUE
	// these are here by popular demand, even though they don't fit the above criteria
	if(istype(tool, /obj/item/pen) || istype(tool, /obj/item/screwdriver))
		return TRUE
	return FALSE

/datum/surgery_operation/limb/incise_skin/state_check(obj/item/bodypart/limb)
	return !(limb.biological_state & biostate_blacklist)

/datum/surgery_operation/limb/incise_skin/on_preop(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("你开始在[FORMAT_LIMB_OWNER(limb)]上切开一个口子..."),
		span_notice("[surgeon]开始在[FORMAT_LIMB_OWNER(limb)]上切开一个口子。"),
		span_notice("[surgeon]开始在[FORMAT_LIMB_OWNER(limb)]上切开一个口子。"),
	)
	display_pain(limb.owner, "You feel a stabbing in your [limb.plaintext_zone].")

/datum/surgery_operation/limb/incise_skin/on_success(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	. = ..() // default success message
	limb.add_surgical_state(SURGERY_SKIN_CUT|SURGERY_VESSELS_UNCLAMPED) // ouch, cuts the vessels
	if(!limb.can_bleed())
		return

	var/blood_name = limb.owner?.get_bloodtype()?.get_blood_name()
	if(!blood_name && length(limb.blood_dna_info))
		var/datum/blood_type/blood_type = limb.blood_dna_info[limb.blood_dna_info[1]]
		blood_name = blood_type?.get_blood_name()
	if(!blood_name)
		blood_name = "Blood"

	display_results(
		surgeon,
		limb.owner,
		span_notice("[blood_name]在[FORMAT_LIMB_OWNER(limb)]的切口周围积聚。"),
		span_notice("[blood_name]在[FORMAT_LIMB_OWNER(limb)]的切口周围积聚。"),
		span_notice("[blood_name]在[FORMAT_LIMB_OWNER(limb)]的切口周围积聚。"),
	)

/// Subtype for thick skinned creatures (Xenomorphs)
/datum/surgery_operation/limb/incise_skin/thick
	name = "切开厚皮肤"
	implements = list(
		TOOL_SAW = 1,
		/obj/item/melee/energy/sword = 1.25,
		/obj/item/fireaxe = 1.5,
		/obj/item/knife/butcher = 2.5,
		/obj/item = 5,
	)
	biostate_blacklist = BIO_FLESH|BIO_METAL

/datum/surgery_operation/limb/incise_skin/thick/get_any_tool()
	return "任何具有足够力量的锋利物品"

/datum/surgery_operation/limb/incise_skin/thick/tool_check(obj/item/tool)
	return ..() && tool.force >= 10

/datum/surgery_operation/limb/incise_skin/abductor
	operation_flags = parent_type::operation_flags | OPERATION_IGNORE_CLOTHES | OPERATION_LOCKED | OPERATION_NO_WIKI
	required_bodytype = NONE
	biostate_blacklist = NONE // they got laser scalpels

/// Pulls the skin back to access internals
/datum/surgery_operation/limb/retract_skin
	name = "牵开皮肤"
	desc = "Retract the patient's skin to access their internal organs. \
		Causes \"skin open\" surgical state."
	operation_flags = OPERATION_NO_PATIENT_REQUIRED
	required_bodytype = (~BODYTYPE_ROBOTIC & ~BODYTYPE_SYNTHETIC) // NOVA EDIT CHANGE - SYNTH FLAGS - ORIGINAL: required_bodytype = ~BODYTYPE_ROBOTIC
	replaced_by = /datum/surgery_operation/limb/retract_skin/abductor
	implements = list(
		TOOL_RETRACTOR = 1,
		TOOL_SCREWDRIVER = 2.25,
		TOOL_WIRECUTTER = 2.85,
		/obj/item/stack/rods = 2.85,
		/obj/item/kitchen/fork = 2.85,
	)
	time = 2.4 SECONDS
	preop_sound = 'sound/items/handling/surgery/retractor1.ogg'
	success_sound = 'sound/items/handling/surgery/retractor2.ogg'
	all_surgery_states_required = SURGERY_SKIN_CUT
	allow_stumps = TRUE

/datum/surgery_operation/limb/retract_skin/get_default_radial_image()
	return image('icons/hud/surgery_radial.dmi', "retract_skin")

/datum/surgery_operation/limb/retract_skin/on_preop(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("你开始牵开[FORMAT_LIMB_OWNER(limb)]的皮肤..."),
		span_notice("[surgeon] 开始收缩 [FORMAT_LIMB_OWNER(limb)] 的皮肤。"),
		span_notice("[surgeon] 开始收缩 [FORMAT_LIMB_OWNER(limb)] 的皮肤。"),
	)
	display_pain(limb.owner, "You feel a severe stinging pain spreading across your [limb.plaintext_zone] as the skin is pulled back.")

/datum/surgery_operation/limb/retract_skin/on_success(obj/item/bodypart/limb)
	. = ..()
	// the limb SHOULD either have unclamped or clamped vessels if we're retracting skin
	// if it doesn't, some shenanigans happened (likely due to wounds), so we add unclamped if needed - just to be thorough
	limb.add_surgical_state(SURGERY_SKIN_OPEN | (LIMB_HAS_SURGERY_STATE(limb, SURGERY_VESSELS_CLAMPED) ? NONE : SURGERY_VESSELS_UNCLAMPED))
	limb.remove_surgical_state(SURGERY_SKIN_CUT)

/datum/surgery_operation/limb/retract_skin/abductor
	operation_flags = parent_type::operation_flags | OPERATION_IGNORE_CLOTHES | OPERATION_LOCKED  | OPERATION_NO_WIKI
	required_bodytype = NONE

/// Closes the skin
/datum/surgery_operation/limb/close_skin
	name = "缝合皮肤切口"
	desc = "Mend the incision in the patient's skin, closing it up. \
		Clears most surgical states."
	required_bodytype = (~BODYTYPE_ROBOTIC & ~BODYTYPE_SYNTHETIC) // NOVA EDIT CHANGE - SYNTH FLAGS - ORIGINAL: required_bodytype = ~BODYTYPE_ROBOTIC
	operation_flags = OPERATION_PRIORITY_NEXT_STEP | OPERATION_NO_PATIENT_REQUIRED
	replaced_by = /datum/surgery_operation/limb/close_skin/abductor
	implements = list(
		TOOL_CAUTERY = 1,
		/obj/item/stack/medical/suture = 1,
		/obj/item/gun/energy/laser = 1.15,
		TOOL_WELDER = 1.5,
		/obj/item = 3.33,
	)
	time = 2.4 SECONDS
	preop_sound = list(
		/obj/item/stack/medical/suture = SFX_SUTURE_BEGIN,
		/obj/item = 'sound/items/handling/surgery/cautery1.ogg',
	)
	success_sound = list(
		/obj/item/stack/medical/suture = SFX_SUTURE_END,
		/obj/item = 'sound/items/handling/surgery/cautery2.ogg',
	)
	any_surgery_states_required = ALL_SURGERY_SKIN_STATES
	allow_stumps = TRUE

/datum/surgery_operation/limb/close_skin/get_any_tool()
	return "任何热源"

/datum/surgery_operation/limb/close_skin/get_default_radial_image()
	return image('icons/hud/surgery_radial.dmi', "mend_incision")

/datum/surgery_operation/limb/close_skin/all_required_strings()
	return ..() + list("该肢体必须有皮肤")

/datum/surgery_operation/limb/close_skin/state_check(obj/item/bodypart/limb)
	return LIMB_HAS_SKIN(limb)

/datum/surgery_operation/limb/close_skin/tool_check(obj/item/tool)
	if(istype(tool, /obj/item/stack/medical/suture))
		return TRUE

	if(istype(tool, /obj/item/gun/energy/laser))
		var/obj/item/gun/energy/laser/lasergun = tool
		return lasergun.cell?.charge > 0

	return tool.get_temperature() >= FIRE_MINIMUM_TEMPERATURE_TO_EXIST

/datum/surgery_operation/limb/close_skin/on_preop(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("你开始缝合 [FORMAT_LIMB_OWNER(limb)] 的切口..."),
		span_notice("[surgeon] 开始缝合 [FORMAT_LIMB_OWNER(limb)] 的切口。"),
		span_notice("[surgeon] 开始缝合 [FORMAT_LIMB_OWNER(limb)] 的切口。"),
	)
	display_pain(limb.owner, "Your [limb.plaintext_zone] is being [istype(tool, /obj/item/stack/medical/suture) ? "pinched" : "burned"]!")

/datum/surgery_operation/limb/close_skin/on_success(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	. = ..()
	if(LIMB_HAS_SURGERY_STATE(limb, SURGERY_BONE_SAWED))
		limb.heal_damage(40)
	limb.remove_surgical_state(ALL_SURGERY_STATES_UNSET_ON_CLOSE)

/datum/surgery_operation/limb/close_skin/abductor
	operation_flags = parent_type::operation_flags | OPERATION_IGNORE_CLOTHES | OPERATION_LOCKED  | OPERATION_NO_WIKI
	required_bodytype = NONE

/// Clamps bleeding blood vessels to prevent blood loss
/datum/surgery_operation/limb/clamp_bleeders
	name = "夹住出血点"
	desc = "Clamp bleeding blood vessels in the patient's body to prevent blood loss. \
		Causes \"vessels clamped\" surgical state."
	required_bodytype = (~BODYTYPE_ROBOTIC & ~BODYTYPE_SYNTHETIC) // NOVA EDIT CHANGE - SYNTH FLAGS - ORIGINAL: required_bodytype = ~BODYTYPE_ROBOTIC
	operation_flags = OPERATION_PRIORITY_NEXT_STEP | OPERATION_NO_PATIENT_REQUIRED
	replaced_by = /datum/surgery_operation/limb/clamp_bleeders/abductor
	implements = list(
		TOOL_HEMOSTAT = 1,
		TOOL_WIRECUTTER = 1.67,
		/obj/item/stack/package_wrap = 2.85,
		/obj/item/stack/cable_coil = 6.67,
	)
	time = 2.4 SECONDS
	preop_sound = 'sound/items/handling/surgery/hemostat1.ogg'
	all_surgery_states_required = SURGERY_SKIN_OPEN|SURGERY_VESSELS_UNCLAMPED
	allow_stumps = TRUE

/datum/surgery_operation/limb/clamp_bleeders/get_default_radial_image()
	return image('icons/hud/surgery_radial.dmi', "clamp_bleeders")

/datum/surgery_operation/limb/clamp_bleeders/on_preop(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("你开始夹住 [FORMAT_LIMB_OWNER(limb)] 的出血点..."),
		span_notice("[surgeon] 开始夹住 [FORMAT_LIMB_OWNER(limb)] 的出血点。"),
		span_notice("[surgeon] 开始夹住 [FORMAT_LIMB_OWNER(limb)] 的出血点。"),
	)
	display_pain(limb.owner, "You feel a pinch as the bleeding in your [limb.plaintext_zone] is slowed.")

/datum/surgery_operation/limb/clamp_bleeders/on_success(obj/item/bodypart/limb)
	. = ..()
	// free brute healing if you do it after sawing bones
	if(LIMB_HAS_SURGERY_STATE(limb, SURGERY_BONE_SAWED))
		limb.heal_damage(20)
	limb.add_surgical_state(SURGERY_VESSELS_CLAMPED)
	limb.remove_surgical_state(SURGERY_VESSELS_UNCLAMPED)

/datum/surgery_operation/limb/clamp_bleeders/abductor
	operation_flags = parent_type::operation_flags | OPERATION_IGNORE_CLOTHES | OPERATION_LOCKED  | OPERATION_NO_WIKI
	required_bodytype = NONE

/// Unclamps blood vessels to allow blood flow again
/datum/surgery_operation/limb/unclamp_bleeders
	name = "松开止血钳"
	desc = "Unclamp blood vessels in the patient's body to allow blood flow again. \
		Clears \"vessels clamped\" surgical state."
	required_bodytype = (~BODYTYPE_ROBOTIC & ~BODYTYPE_SYNTHETIC) // NOVA EDIT CHANGE - SYNTH FLAGS - ORIGINAL: required_bodytype = ~BODYTYPE_ROBOTIC
	operation_flags = OPERATION_NO_PATIENT_REQUIRED
	replaced_by = /datum/surgery_operation/limb/unclamp_bleeders/abductor
	implements = list(
		TOOL_HEMOSTAT = 1,
		TOOL_WIRECUTTER = 1.67,
		/obj/item/stack/package_wrap = 2.85,
		/obj/item/stack/cable_coil = 6.67,
	)
	time = 2.4 SECONDS
	preop_sound = 'sound/items/handling/surgery/hemostat1.ogg'
	all_surgery_states_required = SURGERY_SKIN_OPEN|SURGERY_VESSELS_CLAMPED
	allow_stumps = TRUE

/datum/surgery_operation/limb/unclamp_bleeders/get_default_radial_image()
	return image('icons/hud/surgery_radial.dmi', "unclamp_bleeders")

/datum/surgery_operation/limb/unclamp_bleeders/all_required_strings()
	return ..() + list("该肢体必须有血管")

/datum/surgery_operation/limb/unclamp_bleeders/state_check(obj/item/bodypart/limb)
	return LIMB_HAS_VESSELS(limb)

/datum/surgery_operation/limb/unclamp_bleeders/on_preop(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("你开始松开[FORMAT_LIMB_OWNER(limb)]的止血钳..."),
		span_notice("[surgeon]开始松开[FORMAT_LIMB_OWNER(limb)]的止血钳。"),
		span_notice("[surgeon]开始松开[FORMAT_LIMB_OWNER(limb)]的止血钳。"),
	)
	display_pain(limb.owner, "You feel a pressure release as blood starts flowing in your [limb.plaintext_zone] again.")

/datum/surgery_operation/limb/unclamp_bleeders/on_success(obj/item/bodypart/limb)
	. = ..()
	limb.add_surgical_state(SURGERY_VESSELS_UNCLAMPED)
	limb.remove_surgical_state(SURGERY_VESSELS_CLAMPED)

/datum/surgery_operation/limb/unclamp_bleeders/abductor
	operation_flags = parent_type::operation_flags | OPERATION_IGNORE_CLOTHES | OPERATION_LOCKED  | OPERATION_NO_WIKI
	required_bodytype = NONE

/// Saws through bones to access organs
/datum/surgery_operation/limb/saw_bones
	name = "锯开肢体骨骼"
	desc = "Saw through the patient's bones to access their internal organs. \
		Causes \"bone sawed\" surgical state."
	required_bodytype = (~BODYTYPE_ROBOTIC & ~BODYTYPE_SYNTHETIC) // NOVA EDIT CHANGE - SYNTH FLAGS - ORIGINAL: required_bodytype = ~BODYTYPE_ROBOTIC
	implements = list(
		TOOL_SAW = 1,
		/obj/item/shovel/serrated = 1.33,
		/obj/item/melee/arm_blade = 1.33,
		/obj/item/fireaxe = 2,
		/obj/item/hatchet = 2.85,
		/obj/item/knife/butcher = 2.85,
		/obj/item = 4,
	)
	time = 5.4 SECONDS
	preop_sound = list(
		/obj/item/circular_saw = 'sound/items/handling/surgery/saw.ogg',
		/obj/item/melee/arm_blade = 'sound/items/handling/surgery/scalpel1.ogg',
		/obj/item/fireaxe = 'sound/items/handling/surgery/scalpel1.ogg',
		/obj/item/hatchet = 'sound/items/handling/surgery/scalpel1.ogg',
		/obj/item/knife/butcher = 'sound/items/handling/surgery/scalpel1.ogg',
		/obj/item = 'sound/items/handling/surgery/scalpel1.ogg',
	)
	success_sound = 'sound/items/handling/surgery/organ2.ogg'
	operation_flags = OPERATION_AFFECTS_MOOD | OPERATION_NO_PATIENT_REQUIRED
	all_surgery_states_required = SURGERY_SKIN_OPEN
	any_surgery_states_blocked = SURGERY_BONE_SAWED|SURGERY_BONE_DRILLED
	allow_stumps = TRUE

/datum/surgery_operation/limb/saw_bones/get_any_tool()
	return "任何具有足够力量的锋利边缘物品"

/datum/surgery_operation/limb/saw_bones/get_default_radial_image()
	return image('icons/hud/surgery_radial.dmi', "saw_bones")

/datum/surgery_operation/limb/saw_bones/tool_check(obj/item/tool)
	// Require edged sharpness and sufficient force OR a tool behavior match
	return (((tool.get_sharpness() & SHARP_EDGED) && tool.force >= 10) || implements[tool.tool_behaviour])

/datum/surgery_operation/limb/saw_bones/on_preop(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("你开始锯开[FORMAT_LIMB_OWNER(limb)]的骨骼..."),
		span_notice("[surgeon]开始锯开[FORMAT_LIMB_OWNER(limb)]的骨骼。"),
		span_notice("[surgeon]开始锯开[FORMAT_LIMB_OWNER(limb)]的骨骼。"),
	)
	display_pain(limb.owner, "You feel a horrid ache spread through the inside of your [limb.plaintext_zone]!")

/datum/surgery_operation/limb/saw_bones/on_success(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	. = ..()
	limb.add_surgical_state(SURGERY_BONE_SAWED)
	limb.receive_damage(50, sharpness = tool.get_sharpness(), wound_bonus = CANT_WOUND, damage_source = tool)
	display_results(
		surgeon,
		limb.owner,
		span_notice("你锯开了[FORMAT_LIMB_OWNER(limb)]。"),
		span_notice("[surgeon] 锯开了 [FORMAT_LIMB_OWNER(limb)]！"),
		span_notice("[surgeon]锯开了[FORMAT_LIMB_OWNER(limb)]！"),
	)
	display_pain(limb.owner, "It feels like something just broke in your [limb.plaintext_zone]!")

/// Fixes sawed bones back together
/datum/surgery_operation/limb/fix_bones
	name = "修复肢体骨骼"
	desc = "Repair a patient's cut or broken bones. \
		Clears \"bone sawed\" and \"bone drilled\" surgical states."
	required_bodytype = (~BODYTYPE_ROBOTIC & ~BODYTYPE_SYNTHETIC) // NOVA EDIT CHANGE - SYNTH FLAGS - ORIGINAL: required_bodytype = ~BODYTYPE_ROBOTIC
	operation_flags = OPERATION_NO_PATIENT_REQUIRED
	implements = list(
		/obj/item/stack/medical/bone_gel = 1,
		/obj/item/stack/medical/wrap/sticky_tape/surgical = 1,
		/obj/item/stack/medical/wrap/sticky_tape/super = 2,
		/obj/item/stack/medical/wrap/sticky_tape = 3.33,
	)
	preop_sound = list(
		/obj/item/stack/medical/bone_gel = 'sound/misc/soggy.ogg',
		/obj/item/stack/medical/wrap/sticky_tape/surgical = 'sound/items/duct_tape/duct_tape_rip.ogg',
		/obj/item/stack/medical/wrap/sticky_tape/super = 'sound/items/duct_tape/duct_tape_rip.ogg',
		/obj/item/stack/medical/wrap/sticky_tape = 'sound/items/duct_tape/duct_tape_rip.ogg',
	)
	time = 4 SECONDS
	all_surgery_states_required = SURGERY_SKIN_OPEN
	any_surgery_states_required = SURGERY_BONE_SAWED|SURGERY_BONE_DRILLED
	allow_stumps = TRUE

/datum/surgery_operation/limb/fix_bones/get_default_radial_image()
	return image('icons/hud/surgery_radial.dmi', "fix_bones")

/datum/surgery_operation/limb/fix_bones/all_required_strings()
	return ..() + list("该肢体必须有骨骼")

/datum/surgery_operation/limb/fix_bones/state_check(obj/item/bodypart/limb)
	if(!LIMB_HAS_BONES(limb))
		return FALSE

	// if a wound has given us the broken bone state, don't show this surgery as an option, to prevent confusion
	for(var/datum/wound/wound as anything in limb.wounds)
		if(wound.surgery_states & any_surgery_states_required)
			return FALSE

	return TRUE

/datum/surgery_operation/limb/fix_bones/on_preop(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("你开始修复 [FORMAT_LIMB_OWNER(limb)] 的骨骼..."),
		span_notice("[surgeon] 开始修复 [FORMAT_LIMB_OWNER(limb)] 的骨骼。"),
		span_notice("[surgeon] 开始修复 [FORMAT_LIMB_OWNER(limb)] 的骨骼。"),
	)
	display_pain(limb.owner, "You feel a grinding sensation in your [limb.plaintext_zone] as the bones are set back in place.")

/datum/surgery_operation/limb/fix_bones/on_success(obj/item/bodypart/limb)
	. = ..()
	limb.remove_surgical_state(SURGERY_BONE_SAWED|SURGERY_BONE_DRILLED)
	limb.heal_damage(40)

/datum/surgery_operation/limb/drill_bones
	name = "钻入肢体骨骼"
	desc = "Drill through a patient's bones. \
		Causes \"bone drilled\" surgical state."
	required_bodytype = (~BODYTYPE_ROBOTIC & ~BODYTYPE_SYNTHETIC) // NOVA EDIT CHANGE - SYNTH FLAGS - ORIGINAL: required_bodytype = ~BODYTYPE_ROBOTIC
	operation_flags = OPERATION_NO_PATIENT_REQUIRED
	implements = list(
		TOOL_DRILL = 1,
		/obj/item/screwdriver/power = 1.25,
		/obj/item/pickaxe/drill = 1.67,
		TOOL_SCREWDRIVER = 4,
		/obj/item/kitchen/spoon = 5,
		/obj/item = 6.67,
	)
	time = 3 SECONDS
	preop_sound = 'sound/items/handling/surgery/saw.ogg'
	success_sound = 'sound/items/handling/surgery/organ2.ogg'
	all_surgery_states_required = SURGERY_SKIN_OPEN
	any_surgery_states_blocked = SURGERY_BONE_SAWED|SURGERY_BONE_DRILLED
	allow_stumps = TRUE

/datum/surgery_operation/limb/drill_bones/get_any_tool()
	return "任何具有足够力度的尖锐带尖物品"

/datum/surgery_operation/limb/drill_bones/get_default_radial_image()
	return image('icons/hud/surgery_radial.dmi', "drill_bones")

/datum/surgery_operation/limb/drill_bones/tool_check(obj/item/tool)
	// Require pointy sharpness and sufficient force OR a tool behavior match
	return (((tool.get_sharpness() & SHARP_POINTY) && tool.force >= 10) || implements[tool.tool_behaviour])

/datum/surgery_operation/limb/drill_bones/on_preop(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("你开始钻入 [FORMAT_LIMB_OWNER(limb)] 的骨骼..."),
		span_notice("[surgeon] 开始钻入 [FORMAT_LIMB_OWNER(limb)] 的骨骼。"),
		span_notice("[surgeon] 开始钻入 [FORMAT_LIMB_OWNER(limb)] 的骨骼。"),
	)
	display_pain(limb.owner, "You feel a horrible piercing pain in your [limb.plaintext_zone]!")

/datum/surgery_operation/limb/drill_bones/on_success(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	. = ..()
	limb.add_surgical_state(SURGERY_BONE_DRILLED)
	display_results(
		surgeon,
		limb.owner,
		span_notice("你钻入了 [FORMAT_LIMB_OWNER(limb)]。"),
		span_notice("[surgeon] 钻入了 [FORMAT_LIMB_OWNER(limb)]！"),
		span_notice("[surgeon] 钻入了 [FORMAT_LIMB_OWNER(limb)]！"),
	)

/datum/surgery_operation/limb/incise_organs
	name = "切开器官"
	desc = "Make an incision in the patient's internal organ tissue to allow for manipulation or repair. \
		Causes \"organs cut\" surgical state."
	required_bodytype = (~BODYTYPE_ROBOTIC & ~BODYTYPE_SYNTHETIC) // NOVA EDIT CHANGE - SYNTH FLAGS - ORIGINAL: required_bodytype = ~BODYTYPE_ROBOTIC
	operation_flags = OPERATION_NO_PATIENT_REQUIRED
	replaced_by = /datum/surgery_operation/limb/incise_organs/abductor
	implements = list(
		TOOL_SCALPEL = 1,
		/obj/item/melee/energy/sword = 1.33,
		/obj/item/knife = 1.5,
		/obj/item/shard = 2.25,
		/obj/item/pen = 5,
		/obj/item = 3.33,
	)
	time = 2.4 SECONDS
	preop_sound = 'sound/items/handling/surgery/scalpel1.ogg'
	success_sound = 'sound/items/handling/surgery/organ1.ogg'
	all_surgery_states_required = SURGERY_SKIN_OPEN
	any_surgery_states_blocked = SURGERY_ORGANS_CUT
	allow_stumps = TRUE

/datum/surgery_operation/limb/incise_organs/get_any_tool()
	return "任何带锋利边缘的物品"

/datum/surgery_operation/limb/incise_organs/get_default_radial_image()
	return image('icons/hud/surgery_radial.dmi', "incise_organs")

/datum/surgery_operation/limb/incise_organs/tool_check(obj/item/tool)
	// Require edged sharpness OR a tool behavior match. Also saws are a no-go, you'll rip up the organs!
	return ((tool.get_sharpness() & SHARP_EDGED) || implements[tool.tool_behaviour]) && tool.tool_behaviour != TOOL_SAW

/datum/surgery_operation/limb/incise_organs/on_preop(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("你开始在 [FORMAT_LIMB_OWNER(limb)] 内的器官上做切口..."),
		span_notice("[surgeon] 开始在 [FORMAT_LIMB_OWNER(limb)] 内的器官上做切口。"),
		span_notice("[surgeon] 开始在 [FORMAT_LIMB_OWNER(limb)] 内的器官上做切口。"),
	)
	display_pain(limb.owner, "You feel a stabbing in your [limb.plaintext_zone].")

/datum/surgery_operation/limb/incise_organs/on_success(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	. = ..()
	limb.add_surgical_state(SURGERY_ORGANS_CUT)
	limb.receive_damage(10, sharpness = tool.get_sharpness(), wound_bonus = CANT_WOUND, damage_source = tool)
	display_results(
		surgeon,
		limb.owner,
		span_notice("你在 [FORMAT_LIMB_OWNER(limb)] 内的器官上切开了口子。"),
		span_notice("[surgeon] 在 [FORMAT_LIMB_OWNER(limb)] 内的器官上切开了口子！"),
		span_notice("[surgeon] 在 [FORMAT_LIMB_OWNER(limb)] 内的器官上切开了口子！"),
	)
	display_pain(limb.owner, "You feel a sharp pain from inside your [limb.plaintext_zone]!")

/datum/surgery_operation/limb/incise_organs/abductor
	operation_flags = parent_type::operation_flags | OPERATION_IGNORE_CLOTHES | OPERATION_LOCKED  | OPERATION_NO_WIKI
	required_bodytype = NONE

/datum/surgery_operation/limb/incise_organs/abductor/state_check(obj/item/bodypart/limb)
	return TRUE // You can incise chests without sawing ribs
