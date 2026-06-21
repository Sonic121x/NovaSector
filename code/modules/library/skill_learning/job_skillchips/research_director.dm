/obj/item/skillchip/research_director
	name = "R.D.S.P.L.X. 技能卡"
	desc = "关于如何解决古老难题的知识：当不可阻挡之力遇到不可移动之物时会发生什么。"
	auto_traits = list(TRAIT_ROD_SUPLEX, TRAIT_STRENGTH)
	skill_name = "True Strength"
	skill_description = "The knowledge and strength to resolve the most ancient conundrum: what happens when an unstoppable force meets an immovable object."
	skill_icon = "dumbbell"
	activate_message = span_notice("你意识到，如果以正确的角度施加正确的力，就有可能让不可移动之物永久移动。而且……该死，你看起来真壮。")
	deactivate_message = span_notice("你忘记了如何永久锚定一个悖论物体。另外，你真该去健身房了……")
	chip_category = SKILLCHIP_CATEGORY_GENERAL
	skillchip_flags = NONE
	slot_use = 1
