/datum/experiment/autopsy
	name = "尸检实验"
	description = "一项需要完成尸检手术才能推进的实验"
	exp_tag = "Autopsy"
	performance_hint = "Perform a autopsy surgery while connected to an operating computer."

/datum/experiment/autopsy/is_complete()
	return completed

/datum/experiment/autopsy/perform_experiment_actions(datum/component/experiment_handler/experiment_handler, mob/target)
	if (is_valid_autopsy(target))
		completed = TRUE
		return TRUE
	else
		return FALSE

/datum/experiment/autopsy/proc/is_valid_autopsy(mob/target)
	return TRUE

/datum/experiment/autopsy/human
	name = "人类尸检实验"
	description = "我们不想投资一个连尾骨和耳蜗都分不清的空间站。给我们发回解剖人类的数据以获得更多资金。"

/datum/experiment/autopsy/human/is_valid_autopsy(mob/target)
	return ishumanbasic(target)

/datum/experiment/autopsy/nonhuman
	name = "非人类尸检实验"
	description = "当我们要求尾骨时，我们指的不是……听着，只要给我们发回非人类的数据就行。哪怕是只猴子我们也无所谓，只要把研究发给我们。"

/datum/experiment/autopsy/nonhuman/is_valid_autopsy(mob/target)
	return ishuman(target) && !ishumanbasic(target)

/datum/experiment/autopsy/xenomorph
	name = "异形尸检实验"
	description = "我们对异形的了解仅停留在表面。请发回解剖异形获得的研究数据。"

/datum/experiment/autopsy/xenomorph/is_valid_autopsy(mob/target)
	return isalien(target)
