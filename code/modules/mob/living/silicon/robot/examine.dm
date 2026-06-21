/mob/living/silicon/robot/examine(mob/user)
	. = list()
	if(desc)
		. += "[desc]"

	var/model_name = model ? "\improper [model.name]" : "\improper Default"
	. += "[p_Theyre()] currently <b>\a [model_name]-type</b> cyborg."

	var/obj/act_module = get_active_held_item()
	if(act_module)
		. += "[p_Theyre()] holding [icon2html(act_module, user)] \a [act_module]."
	. += get_status_effect_examinations()
	if (get_brute_loss())
		if (get_brute_loss() < maxHealth*0.5)
			. += span_warning("[p_They()] 看起来[p_s()]略有凹陷。")
		else
			. += span_boldwarning("[p_They()]看起来[p_s()]严重凹陷了！")
	if (get_fire_loss() || get_tox_loss())
		var/overall_fireloss = get_fire_loss() + get_tox_loss()
		if (overall_fireloss < maxHealth * 0.5)
			. += span_warning("[p_They()]看起来[p_s()]有点烧焦了。")
		else
			. += span_boldwarning("[p_They()]看起来[p_s()]严重烧焦且因高温变形了！")
	if (health < -maxHealth*0.5)
		. += span_warning("[p_They()]看起来[p_s()]勉强还能运作。")
	if (fire_stacks < 0)
		. += span_warning("[p_Theyre()]浑身是水。")
	else if (fire_stacks > 0)
		. += span_warning("[p_Theyre()]表面覆盖着某种易燃物。")

	if(opened)
		. += span_warning("[p_Their()] 外壳已打开，电源电池[cell ? "installed" : "missing"]。")
	else
		. += "[p_Their()] cover is closed[locked ? "" : ", and looks unlocked"]."

	if(cell && cell.charge <= 0)
		. += span_warning("[p_Their()]电池指示灯正闪着红光！")

	switch(stat)
		if(CONSCIOUS)
			if(shell)
				. += "[p_They()] appear[p_s()] to be an [deployed ? "active" : "empty"] AI shell."
			else if(!client)
				. += "[p_They()] appear[p_s()] to be in stand-by mode." //afk
		if(SOFT_CRIT, UNCONSCIOUS, HARD_CRIT)
			. += span_warning("[p_They()]似乎[p_es()]没有反应。")
		if(DEAD)
			. += span_deadsay("[p_They()]看起来[p_s()]像是系统损坏，需要重置。")
	//NOVA EDIT ADDITION BEGIN - CUSTOMIZATION
	. += get_silicon_flavortext(user)
	//NOVA EDIT ADDITION END
	. += ..()

/mob/living/silicon/robot/examine_descriptor(mob/user)
	return "cyborg"
