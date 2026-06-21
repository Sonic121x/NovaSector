/obj/item/xenoarch/core_sampler
	name = "岩芯取样器"
	desc = "用于提取地质岩芯样本。"
	icon = 'modular_nova/modules/xenoarchartifacts/icons/tools.dmi'
	icon_state = "sampler_empty"
	w_class = 1
	// Did we already take the sample?
	var/used = FALSE
	// The sample of the rock we took
	var/obj/structure/boulder/sample = NONE
