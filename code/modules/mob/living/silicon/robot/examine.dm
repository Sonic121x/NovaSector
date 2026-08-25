// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/mob/living/silicon/robot/examine(mob/user)
	. = list()
	if(desc)
		. += "[desc]"

	var/model_name = model ? "\improper [model.name]" : "\improper Default"
	. += LANG("mob.6d297d48d72379e4", list(p_Theyre(), model_name))

	var/obj/act_module = get_active_held_item()
	if(act_module)
		. += LANG("mob.49de57985408e2cb", list(p_Theyre(), icon2html(act_module, user), act_module))
	. += get_status_effect_examinations(user)
	if (get_brute_loss())
		if (get_brute_loss() < maxHealth*0.5)
			. += span_warning(LANG("mob.c487477b1d7f722c", list(p_They(), p_s())))
		else
			. += span_boldwarning(LANG("mob.a3853f194e0d5c16", list(p_They(), p_s())))
	if (get_fire_loss() || get_tox_loss())
		var/overall_fireloss = get_fire_loss() + get_tox_loss()
		if (overall_fireloss < maxHealth * 0.5)
			. += span_warning(LANG("mob.822ee81430e55a34", list(p_They(), p_s())))
		else
			. += span_boldwarning(LANG("mob.189102d394f20457", list(p_They(), p_s())))
	if (health < -maxHealth*0.5)
		. += span_warning(LANG("mob.a6985b41426c874f", list(p_They(), p_s())))
	if (fire_stacks < 0)
		. += span_warning(LANG("mob.6d7c684c38c2b9f7", list(p_Theyre())))
	else if (fire_stacks > 0)
		. += span_warning(LANG("mob.6f469a95bfa7f296", list(p_Theyre())))

	if(opened)
		. += span_warning(LANG("mob.2d2c85ca4c9d081e", list(p_Their(), cell ? "installed" : "missing")))
	else
		var/cover_message = LANG("mob.5b9a280a662d88cf", list(p_Their())) // NOVA EDIT CHANGE - I18N - ORIGINAL: var/cover_message = "[p_Their()] cover is closed"
		if(locked)
			if(user == src)
				cover_message += LANG("mob.4b3e867884ce0e28", list(REF(src)))
		else
			cover_message += LANG("mob.d62571f4ddc8d506", null)
		. += span_notice("[cover_message].")

	if(cell && cell.charge <= 0)
		. += span_warning(LANG("mob.1269489e36a154ec", list(p_Their())))

	if(IS_UNCONSCIOUS_AND_ALIVE(src))
		. += span_warning(LANG("mob.1959200f4f5021c5", list(p_They(), p_es())))

	switch(stat)
		if(STABLE)
			if(shell)
				. += LANG("mob.e65160d9a85246ea", list(p_They(), p_s(), deployed ? "active" : "empty"))
			else if(!client)
				. += LANG("mob.76e341a19f00dce9", list(p_They(), p_s())) //afk
		if(DEAD)
			. += span_deadsay(LANG("mob.2daf9e8b3491929a", list(p_They(), p_s())))
	//NOVA EDIT ADDITION BEGIN - CUSTOMIZATION
	. += get_silicon_flavortext(user)
	//NOVA EDIT ADDITION END
	. += ..()

/mob/living/silicon/robot/examine_descriptor(mob/user)
	return "cyborg"
