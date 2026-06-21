/// This component allows you to judge someone's level of criminal activity by examining them
/datum/component/security_vision
	/// Bitfield containing what things we want to judge based upon
	var/judgement_criteria
	/// Optional callback which will modify the value of `judgement_criteria` before we make the check
	var/datum/callback/update_judgement_criteria

/datum/component/security_vision/Initialize(judgement_criteria, datum/callback/update_judgement_criteria)
	. = ..()
	if (!ismob(parent))
		return COMPONENT_INCOMPATIBLE
	src.judgement_criteria = judgement_criteria
	src.update_judgement_criteria = update_judgement_criteria

/datum/component/security_vision/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOB_EXAMINING, PROC_REF(on_examining))

/datum/component/security_vision/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MOB_EXAMINING)

/// When we examine something, check if we have any extra data to add
/datum/component/security_vision/proc/on_examining(mob/source, atom/target, list/examine_strings, list/examine_overrides)
	SIGNAL_HANDLER
	if (!isliving(target))
		return
	var/mob/living/perp = target
	judgement_criteria = update_judgement_criteria?.Invoke() || judgement_criteria

	var/threat_level = perp.assess_threat(judgement_criteria)
	switch(threat_level)
		if (THREAT_ASSESS_MAXIMUM to INFINITY)
			examine_strings += span_boldwarning("评估威胁等级为 [threat_level]！存在犯罪活动的极端危险！")
		if (THREAT_ASSESS_DANGEROUS to THREAT_ASSESS_MAXIMUM)
			examine_strings += span_warning("评估威胁等级为 [threat_level]。检测到犯罪渣滓！")
		if (1 to THREAT_ASSESS_DANGEROUS)
			examine_strings += span_notice("评估威胁等级为 [threat_level]。可能还不危险...暂时。")
		else
			examine_strings += span_notice("似乎是个值得信赖的人。")
