/datum/action/cooldown/spell/conjure/presents
	name = "魔幻特展！"
	desc = "这个咒语能让你进入超空间并获取礼物！太棒了！"

	school = SCHOOL_CONJURATION
	cooldown_time = 1 MINUTES
	cooldown_reduction_per_rank = 13.75 SECONDS

	invocation = "HO HO HO!"
	invocation_type = INVOCATION_SHOUT

	summon_radius = 3
	summon_type = list(/obj/item/gift)
	summon_amount = 5
