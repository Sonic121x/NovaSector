/// The wizard's teleport SPELL
/datum/action/cooldown/spell/teleport/area_teleport/wizard
	name = "传送"
	desc = "这个咒语将你传送到你所选择的区域。"
	button_icon_state = "teleport"
	sound = 'sound/effects/magic/teleport_diss.ogg'

	school = SCHOOL_TRANSLOCATION
	cooldown_time = 1 MINUTES
	cooldown_reduction_per_rank = 20 SECONDS
	spell_max_level = 3

	invocation = "SCYAR NILA" // gets punctuation auto applied
	invocation_type = INVOCATION_SHOUT

	smoke_type = /datum/effect_system/fluid_spread/smoke
	smoke_amt = 2

	post_teleport_sound = 'sound/effects/magic/teleport_app.ogg'

// Santa's teleport, themed as such
/datum/action/cooldown/spell/teleport/area_teleport/wizard/santa
	name = "圣诞传送术"

	invocation = "HO HO HO!"
	spell_requirements = NONE
	antimagic_flags = NONE

	invocation_says_area = FALSE // Santa moves in mysterious ways

/// Used by the wizard's teleport scroll
/datum/action/cooldown/spell/teleport/area_teleport/wizard/scroll
	name = "传送（滚动条）"
	cooldown_time = 0 SECONDS

	invocation = null
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE

	invocation_says_area = FALSE

/datum/action/cooldown/spell/teleport/area_teleport/wizard/scroll/IsAvailable(feedback = FALSE)
	return ..() && owner.is_holding(target)

/datum/action/cooldown/spell/teleport/area_teleport/wizard/scroll/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	var/mob/living/carbon/caster = cast_on
	if(caster.incapacitated || !caster.is_holding(target))
		return . | SPELL_CANCEL_CAST
