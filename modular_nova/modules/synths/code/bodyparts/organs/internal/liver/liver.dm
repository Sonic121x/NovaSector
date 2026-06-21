/obj/item/organ/liver/synth
	name = "试剂处理单元"
	desc = "一种为合成人用户处理有益化学物质的电子设备。"
	icon = 'modular_nova/master_files/icons/obj/surgery.dmi'
	icon_state = "liver-ipc"
	filterToxins = FALSE //We dont filter them, we're immune to them
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_LIVER
	maxHealth = 1 * STANDARD_ORGAN_THRESHOLD
	organ_flags = ORGAN_ROBOTIC | ORGAN_SYNTHETIC_FROM_SPECIES

/obj/item/organ/liver/synth/emp_act(severity)
	. = ..()

	if(!owner || . & EMP_PROTECT_SELF)
		return

	if(!COOLDOWN_FINISHED(src, severe_cooldown)) //So we cant just spam emp to kill people.
		COOLDOWN_START(src, severe_cooldown, 10 SECONDS)

	switch(severity)
		if(EMP_HEAVY)
			to_chat(owner, span_warning("警报：严重！试剂处理单元故障，请立即前往维护区。错误代码：DR-1k"))
			apply_organ_damage(SYNTH_ORGAN_HEAVY_EMP_DAMAGE, maxHealth, required_organ_flag = ORGAN_ROBOTIC)

		if(EMP_LIGHT)
			to_chat(owner, span_warning("警报：试剂处理单元故障，请前往维护区进行诊断。错误代码：DR-0k"))
			apply_organ_damage(SYNTH_ORGAN_LIGHT_EMP_DAMAGE, maxHealth, required_organ_flag = ORGAN_ROBOTIC)

/datum/design/synth_liver
	name = "试剂处理单元"
	desc = "一种为合成人用户处理有益化学物质的电子设备。"
	id = "synth_liver"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 4 SECONDS
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/organ/liver/synth
	category = list(
		RND_SUBCATEGORY_MECHFAB_ANDROID + RND_SUBCATEGORY_MECHFAB_ANDROID_ORGANS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE
