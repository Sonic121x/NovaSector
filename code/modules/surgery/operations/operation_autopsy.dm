/datum/surgery_operation/limb/autopsy
	name = "尸检"
	rnd_name = "Androtomy (Dissection and Autopsy)"
	desc = "对已故患者的身体进行详细分析。"
	implements = list(/obj/item/autopsy_scanner = 1)
	time = 10 SECONDS
	success_sound = 'sound/machines/printer.ogg'
	required_bodytype = (~BODYTYPE_ROBOTIC & ~BODYTYPE_SYNTHETIC) // NOVA EDIT CHANGE - SYNTH FLAGS - ORIGINAL: required_bodytype = ~BODYTYPE_ROBOTIC
	operation_flags = OPERATION_MORBID | OPERATION_IGNORE_CLOTHES
	all_surgery_states_required = SURGERY_SKIN_OPEN

/datum/surgery_operation/limb/autopsy/get_default_radial_image()
	return image(/obj/item/autopsy_scanner)

/datum/surgery_operation/limb/autopsy/all_required_strings()
	. = list()
	. += "operate on chest (target chest)"
	. += ..()
	. += "患者必须已死亡"
	. += "患者之前必须未进行过尸检"

/datum/surgery_operation/limb/autopsy/state_check(obj/item/bodypart/limb)
	if(limb.body_zone != BODY_ZONE_CHEST)
		return FALSE
	if(limb.owner.stat != DEAD)
		return FALSE
	if(HAS_TRAIT_FROM(limb.owner, TRAIT_DISSECTED, AUTOPSY_TRAIT))
		return FALSE
	return TRUE

/datum/surgery_operation/limb/autopsy/on_preop(obj/item/bodypart/limb, mob/living/surgeon, obj/item/autopsy_scanner/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("You begin performing an autopsy on [limb.owner]..."),
		span_notice("[surgeon] uses [tool] to perform an autopsy on [limb.owner]."),
		span_notice("[surgeon] uses [tool] on [limb.owner]'s chest."),
	)

/datum/surgery_operation/limb/autopsy/on_success(obj/item/bodypart/limb, mob/living/surgeon, obj/item/autopsy_scanner/tool, list/operation_args)
	ADD_TRAIT(limb.owner, TRAIT_DISSECTED, AUTOPSY_TRAIT)
	ADD_TRAIT(limb.owner, TRAIT_SURGICALLY_ANALYZED, AUTOPSY_TRAIT)
	tool.scan_cadaver(surgeon, limb.owner)
	var/obj/machinery/computer/operating/operating_computer = locate_operating_computer(limb)
	if (!isnull(operating_computer))
		SEND_SIGNAL(operating_computer, COMSIG_OPERATING_COMPUTER_AUTOPSY_COMPLETE, limb.owner)
	if(HAS_MIND_TRAIT(surgeon, TRAIT_MORBID))
		surgeon.add_mood_event("morbid_dissection_success", /datum/mood_event/morbid_dissection_success)
	return ..()

/datum/surgery_operation/limb/autopsy/mechanic
	name = "系统故障分析"
	rnd_name = "System Failure Analysis (Dissection and Autopsy)"
	desc = "对机器人患者已停机的系统进行详细分析。"
	required_bodytype = BODYTYPE_ROBOTIC
	operation_flags = parent_type::operation_flags | OPERATION_MECHANIC
