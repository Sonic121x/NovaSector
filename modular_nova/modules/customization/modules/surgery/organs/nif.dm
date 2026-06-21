// A surgery that repairs the patient's NIF
/datum/surgery_operation/organ/repair_nif
	name = "修复NIF"
	desc = "一种恢复已安装NIF完整性的外科手术。"
	implements = list(
		TOOL_MULTITOOL = 1,
		TOOL_HEMOSTAT = 2.85,
		TOOL_SCREWDRIVER = 6.67,
	)
	target_type = /obj/item/organ/cyberimp/brain/nif
	time = 12 SECONDS
	all_surgery_states_required = SURGERY_SKIN_OPEN | SURGERY_BONE_SAWED | SURGERY_ORGANS_CUT
	any_surgery_states_blocked = SURGERY_VESSELS_UNCLAMPED

/datum/surgery_operation/organ/repair_nif/on_preop(obj/item/organ/cyberimp/brain/nif/installed_nif, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		installed_nif.owner,
		span_notice("你开始恢复[FORMAT_ORGAN_OWNER(installed_nif)]的NIF完整性..."),
		span_notice("[surgeon]开始修复[FORMAT_ORGAN_OWNER(installed_nif)]的NIF。"),
		span_notice("[surgeon]开始对[FORMAT_ORGAN_OWNER(installed_nif)]的NIF进行维修。"),
	)

/datum/surgery_operation/organ/repair_nif/on_success(obj/item/organ/cyberimp/brain/nif/installed_nif, mob/living/surgeon, tool, list/operation_args)
	display_results(
		surgeon,
		installed_nif.owner,
		span_notice("你成功恢复了[FORMAT_ORGAN_OWNER(installed_nif)]的NIF完整性。"),
		span_notice("[surgeon]成功修复了[FORMAT_ORGAN_OWNER(installed_nif)]的NIF！"),
		span_notice("[surgeon]完成了对[FORMAT_ORGAN_OWNER(installed_nif)]的NIF的维修。"),
	)
	installed_nif.durability = installed_nif.max_durability
	installed_nif.send_message("Restored to full integrity!")

	return ..()

/datum/surgery_operation/organ/repair_nif/on_failure(obj/item/organ/cyberimp/brain/nif/installed_nif, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		installed_nif.owner,
		span_warning("你搞砸了，导致[FORMAT_ORGAN_OWNER(installed_nif)]脑损伤！"),
		span_warning("[surgeon]在尝试修复[FORMAT_ORGAN_OWNER(installed_nif)]的NIF时搞砸了！"),
		span_notice("[surgeon]完成了对[FORMAT_ORGAN_OWNER(installed_nif)]的NIF的修复。"),
	)
	installed_nif.owner.adjust_organ_loss(ORGAN_SLOT_BRAIN, 20)
	return FALSE

