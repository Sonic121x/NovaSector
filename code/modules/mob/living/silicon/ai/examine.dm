/mob/living/silicon/ai/examine(mob/user)
	. = list()
	if(stat == DEAD)
		. += span_warning("[p_They()] 看[p_s()]起来无法运作。")
	. += span_notice("[p_Their()] 地板<b>螺栓</b>是[is_anchored ? "tightened" : "loose"]。")
	if(is_anchored)
		if(!opened)
			if(!emagged)
				. += span_notice("[p_Their()] access panel is [stat == DEAD ? "damaged" : "closed and locked"], but could be <b>pried</b> open.")
			else
				. += span_warning("[p_Their()] 检修面板锁正在冒火花，盖板可以<b>撬</b>开。")
		else
			. += span_notice("[p_Their()] 神经网络连接可以被<b>切断</b>，检修面板盖板可以<b>撬</b>回原位。")
	if(stat != DEAD)
		if (get_brute_loss())
			if (get_brute_loss() < 30)
				. += span_warning("[p_They()] 看[p_s()]起来有点凹陷。")
			else
				. += span_warning("<B>[p_They()] 看[p_s()]起来严重凹陷！</B>")
		if (get_fire_loss())
			if (get_fire_loss() < 30)
				. += span_warning("[p_They()] 看[p_s()]起来有点烧焦。")
			else
				. += span_warning("<B>[p_Their()] 外壳已熔化并热变形！</B>")
		if(deployed_shell)
			. += "The wireless networking light is blinking."
		else if (!shunted && !client)
			. += "[src]Core.exe has stopped responding! NTOS is searching for a solution to the problem..."
	//NOVA EDIT ADDITION BEGIN - CUSTOMIZATION
	. += get_silicon_flavortext(user)
	//NOVA EDIT ADDITION END

	. += ..()
