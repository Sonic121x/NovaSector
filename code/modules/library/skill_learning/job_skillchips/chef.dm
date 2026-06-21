/obj/item/skillchip/job/chef
	name = "B0RK-X3 技能卡" // bork bork bork
	desc = "这种生物芯片有一股大蒜的味道，对于通常被植入用户大脑的东西来说，这种味道很奇怪。使用前请咨询营养师。"
	skill_name = "Close Quarters Cooking"
	skill_description = "A specialised form of self defence, developed by skilled sous-chef de cuisines. No man fights harder than a chef to defend his kitchen."
	skill_icon = "utensils"
	activate_message = span_notice("你能想象出如何用武术来保卫你的厨房。")
	deactivate_message = span_notice("你忘记了如何在厨房环境中控制肌肉来执行踢击、猛摔和擒拿。")
	/// The Chef CQC given by the skillchip.
	var/datum/martial_art/cqc/under_siege/style

/obj/item/skillchip/job/chef/Initialize(mapload)
	. = ..()
	style = new(src)
	style.refresh_valid_areas()

/obj/item/skillchip/job/chef/on_activate(mob/living/carbon/user, silent = FALSE)
	. = ..()
	style.teach(user)

/obj/item/skillchip/job/chef/on_deactivate(mob/living/carbon/user, silent = FALSE)
	style.unlearn(user)
	return ..()
