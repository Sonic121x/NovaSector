/obj/item/organ/eyes/synth
	name = "光学传感器"
	icon_state = "eyes_cyber"
	desc = "一套非常基础的光学传感器，不具备额外的视觉模式或功能。"
	maxHealth = 1 * STANDARD_ORGAN_THRESHOLD
	organ_flags = ORGAN_ROBOTIC | ORGAN_SYNTHETIC_FROM_SPECIES

/obj/item/organ/eyes/synth/emp_act(severity)
	. = ..()

	if(!owner || . & EMP_PROTECT_SELF)
		return

	switch(severity)
		if(EMP_HEAVY)
			to_chat(owner, span_warning("警报：强烈的电磁干扰使你的光学传感器充满静电噪声。错误代码：I-CS6"))
			apply_organ_damage(SYNTH_ORGAN_HEAVY_EMP_DAMAGE, maxHealth, required_organ_flag = ORGAN_ROBOTIC)
		if(EMP_LIGHT)
			to_chat(owner, span_warning("警报：轻微干扰使你的光学传感器布满静电。错误代码：I-CS0"))
			apply_organ_damage(SYNTH_ORGAN_LIGHT_EMP_DAMAGE, maxHealth, required_organ_flag = ORGAN_ROBOTIC)

/datum/design/synth_eyes
	name = "光学传感器"
	desc = "一套非常基础的光学传感器，没有额外的视觉模式或功能。"
	id = "synth_eyes"
	build_type = PROTOLATHE | AWAY_LATHE | MECHFAB
	construction_time = 4 SECONDS
	materials = list(
		/datum/material/iron = HALF_SHEET_MATERIAL_AMOUNT,
		/datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT,
	)
	build_path = /obj/item/organ/eyes/synth
	category = list(
		RND_SUBCATEGORY_MECHFAB_ANDROID + RND_SUBCATEGORY_MECHFAB_ANDROID_ORGANS,
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE
