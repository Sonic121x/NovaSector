/datum/design/jawsoflife/science
	name = "混合切割器"
	desc = "生命之钳的一个分支，缺少了撬开门的力量"
	id = SCIENCE_JAWS_OF_LIFE_DESIGN_ID // added one more requirement since the Jaws of Life are a bit OP
	build_path = /obj/item/crowbar/power/science
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/handdrill/science
	id = SCIENCE_DRILL_DESIGN_ID
	build_type = PROTOLATHE | AWAY_LATHE
	build_path = /obj/item/screwdriver/power/science
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/handdrill/science/New()
	name = ("科研" + name)
	desc += " with a science paintjob"

	return ..()
