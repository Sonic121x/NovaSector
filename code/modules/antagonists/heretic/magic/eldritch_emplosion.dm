// Given to heretic monsters.
/datum/action/cooldown/spell/emp/eldritch
	name = "未知脉冲"
	desc = "一个在你周围产生大范围电磁脉冲的魔法，使电子设备失效。"
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"

	school = SCHOOL_FORBIDDEN
	cooldown_time = 30 SECONDS

	invocation = "E'P."
	invocation_type = INVOCATION_WHISPER
	spell_requirements = NONE

	emp_heavy = 6
	emp_light = 10
