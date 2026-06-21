/datum/action/changeling/digitalcamo
	name = "数码伪装"
	desc = "通过进化我们失真自我形态与比例的能力，我们战胜了用摄像头探测生命形式的常规计算程序"
	helptext = "We cannot be tracked by camera or seen by AI units while using this skill. However, humans looking at us will find us... uncanny."
	button_icon_state = "digital_camouflage"
	category = "stealth"
	dna_cost = 1
	active = FALSE

//Prevents AIs tracking you but makes you easily detectable to the human-eye.
/datum/action/changeling/digitalcamo/sting_action(mob/user)
	..()
	if(active)
		to_chat(user, span_notice("我们恢复正常。"))
		user.RemoveElement(/datum/element/digitalcamo)
	else
		to_chat(user, span_notice("我们扭曲形态以躲避AI。"))
		user.AddElement(/datum/element/digitalcamo)
	active = !active
	return TRUE

/datum/action/changeling/digitalcamo/Remove(mob/user)
	user.RemoveElement(/datum/element/digitalcamo)
	..()
