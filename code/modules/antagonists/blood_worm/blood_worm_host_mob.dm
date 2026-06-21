/mob/living/blood_worm_host
	name = "宿主"
	desc = "...你是怎么检查这个的？这东西甚至没有实体。"

	var/datum/action/changeling_expel_worm/expel_worm_action

/mob/living/blood_worm_host/Login()
	. = ..()
	if (!.)
		return

	if (IS_CHANGELING(src))
		to_chat(src, span_good("你体内的血蠕虫无法抵抗你的基因优势！"))

		if (!expel_worm_action)
			expel_worm_action = new(src)
			expel_worm_action.Grant(src)
