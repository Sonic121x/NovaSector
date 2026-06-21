/datum/scripture/create_structure/interdiction
	name = "禁制透镜"
	desc = "创造一个装置，会减缓区域内非仆从单位的移动速度，并对机械化外骨骼造成伤害。需要从传输印记获取能量。"
	tip = "Construct interdiction lens to slow down a hostile assault."
	button_icon_state = "Interdiction Lens"
	power_cost = 500
	invocation_time = 8 SECONDS
	invocation_text = list("Oh great lord...", "may your divinity block the outsiders.")
	summoned_structure = /obj/structure/destructible/clockwork/gear_base/powered/interdiction_lens
	cogs_required = 4
	category = SPELLTYPE_STRUCTURES
