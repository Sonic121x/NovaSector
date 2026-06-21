/obj/item/crowbar/power/science
	name = "混合切割器" // hybrid between crowbar and wirecutters
	desc = "与生命之钳非常相似，这种工具结合了撬棍和钢丝钳的实用性，但不需要撬开门所需的液压力量。"
	icon = 'modular_nova/modules/aesthetics/tools/icons/tools.dmi'
	icon_state = "jaws_sci"
	lefthand_file = 'modular_nova/modules/aesthetics/tools/icons/tools_lefthand.dmi'
	righthand_file = 'modular_nova/modules/aesthetics/tools/icons/tools_righthand.dmi'
	inhand_icon_state = "jaws_sci"
	force_opens = FALSE

/obj/item/screwdriver/power/science
	icon_state = "drill_sci"

/obj/item/screwdriver/power/science/Initialize(mapload)
	. = ..()

	desc += " This one sports a nifty science paintjob, but is otherwise normal."
