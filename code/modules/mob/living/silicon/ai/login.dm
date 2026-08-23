// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/mob/living/silicon/ai/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	if(stat != DEAD)
		if(lacks_power() && apc_override) //Placing this in Login() in case the AI doesn't have this link for whatever reason.
			to_chat(usr, LANG("mob.5c7523863786e1a4", list(span_warning("Main power is unavailable, backup power in use. Diagnostics scan complete."), REF(src), TRUE)))
	set_eyeobj_visible(TRUE)
	if(multicam_on)
		end_multicam()
	view_core()
