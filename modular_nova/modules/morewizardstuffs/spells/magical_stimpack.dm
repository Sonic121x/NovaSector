/datum/action/cooldown/spell/stimpack
	name = "魔法兴奋剂"
	desc = "这个法术能将兴奋剂直接注入你的血液。对没有化学反应能力的物种无效！"
	school = "transmutation"
	cooldown_time = 10 SECONDS
	cooldown_reduction_per_rank = 1.25 SECONDS
	spell_requirements = NONE
	invocation = "STIMULUS CHEQ'US"
	invocation_type = INVOCATION_SHOUT

/datum/action/cooldown/spell/stimpack/cast(mob/living/cast_on)
	. = ..()
	cast_on.balloon_alert(cast_on, "加速中")
	cast_on.SetKnockdown(0)
	cast_on.set_stamina_loss(0)
	cast_on.set_resting(FALSE)
	cast_on.reagents.add_reagent(/datum/reagent/medicine/stimulants, 3) // Ideally this comes out to a bit less than 30 seconds with tidi taken into account.
	return TRUE
