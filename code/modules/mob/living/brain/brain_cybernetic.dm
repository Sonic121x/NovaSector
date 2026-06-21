/obj/item/organ/brain/cybernetic
	name = "赛博格大脑"
	desc = "一种在安卓体内发现的机械大脑。不要与正电子大脑混淆。"
	icon_state = "brain-c"
	organ_flags = ORGAN_ROBOTIC | ORGAN_VITAL
	failing_desc = "seems to be broken, and will not work without repairs."
	shade_color = null

/obj/item/organ/brain/cybernetic/brain_damage_examine()
	if(suicided)
		return span_info("它的电路正微微冒烟。他们肯定没能承受住这一切的压力。")
	if(brainmob && (decoy_override || brainmob.client || brainmob.get_ghost()))
		if(organ_flags & ORGAN_FAILING)
			return span_info("它内部似乎还残留着一点能量，但损坏相当严重... 你或许可以用<b>多功能工具</b>修复它。")
		else if(damage >= BRAIN_DAMAGE_DEATH*0.5)
			return span_info("你能感觉到这一个里面仍有一丝微弱的生命火花，但它有些凹痕。你或许可以用<b>多功能工具</b>修复它。")
		else
			return span_info("你能感觉到这一个里面仍有一丝微弱的生命火花。")
	else
		return span_info("这一个已经完全失去了生命迹象。")

/obj/item/organ/brain/cybernetic/check_for_repair(obj/item/item, mob/user)
	if (item.tool_behaviour == TOOL_MULTITOOL) //attempt to repair the brain
		if (brainmob?.health <= HEALTH_THRESHOLD_DEAD) //if the brain is fucked anyway, do nothing
			to_chat(user, span_warning("[src] 损坏得太严重了，我们无能为力！"))
			return TRUE

		if (DOING_INTERACTION(user, src))
			to_chat(user, span_warning("你已经在修复 [src] 了！"))
			return TRUE

		user.visible_message(span_notice("[user] 开始用 [item] 慢慢修复 [src]。"), span_notice("你开始用 [item] 慢慢修复 [src]。"))
		var/did_repair = FALSE
		while(damage > 0)
			if(item.use_tool(src, user, 3 SECONDS, volume = 50))
				did_repair = TRUE
				set_organ_damage(max(0, damage - 20))
			else
				break

		if (did_repair)
			if (damage > 0)
				user.visible_message(span_notice("[user] 用 [item] 部分修复了 [src]。"), span_notice("你用 [item] 部分修复了 [src]。"))
			else
				user.visible_message(span_notice("[user] 用 [item] 完全修复了 [src]，使其警告灯停止闪烁。"), span_notice("你用 [item] 完全修复了 [src]，使其警告灯停止闪烁。"))
		else
			to_chat(user, span_warning("你未能用[item]修复[src]！"))

		return TRUE
	return FALSE

/obj/item/organ/brain/cybernetic/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	switch(severity)
		if (EMP_HEAVY)
			//apply_organ_damage(20, BRAIN_DAMAGE_SEVERE) // NOVA EDIT REMOVAL
			// NOVA EDIT ADDITION START
			to_chat(owner, span_boldwarning("你感觉[pick("like your brain is being fried", "a sharp pain in your head")]！")) //default alert text for emps
			apply_organ_damage((20*emp_dmg_mult), emp_dmg_max) //implement cap
			// NOVA EDIT ADDITION END
		if (EMP_LIGHT)
			//apply_organ_damage(10, BRAIN_DAMAGE_MILD) // NOVA EDIT REMOVAL
			// NOVA EDIT ADDITION START
			to_chat(owner, span_warning("你感觉[pick("disoriented", "confused", "dizzy")]。")) //default alert text for emps
			apply_organ_damage((10*emp_dmg_mult), emp_dmg_max) //implement cap
			// NOVA EDIT ADDITION END
