/datum/scripture/create_structure/prosperity_prism
	name = "繁荣棱镜"
	desc = "创造一个棱镜，会随时间移除附近仆从的所有伤害类型，并净化毒素。需要从传输印记获取能量。"
	tip = "Create a prosperity prism to heal servants while defending your base."
	button_icon_state = "Prolonging Prism"
	power_cost = 300
	invocation_time = 8 SECONDS
	invocation_text = list("Your light shall heal the wounds beneath my skin.")
	summoned_structure = /obj/structure/destructible/clockwork/gear_base/powered/prosperity_prism
	cogs_required = 2
	category = SPELLTYPE_STRUCTURES


/datum/scripture/create_structure/prosperity_prism/check_special_requirements(mob/user)
	. = ..()
	if(!.)
		return FALSE

	if(locate(/obj/structure/destructible/clockwork/gear_base/powered/prosperity_prism) in range(3)) // No stacking heals for you
		user.balloon_alert(user, "距离另一座棱镜太近！")
		return FALSE

	return TRUE
