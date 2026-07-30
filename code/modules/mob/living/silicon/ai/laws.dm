// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md

GAME_VERB_PROC_DESC(/mob/living/silicon/ai, show_laws_verb, "显示法则", "Check what your laws are privately. Also ensures all synced cyborgs are up to date with your laws, reminds them of your laws.", "AI Commands")
	if(usr.stat == DEAD)
		return //won't work if dead
	src.show_laws()

/mob/living/silicon/ai/try_sync_laws()
	for(var/mob/living/silicon/robot/borgo in connected_robots)
		if(borgo.try_sync_laws())
			to_chat(borgo, span_bold(LANG("mob.781c9581", null)))
			borgo.show_laws()
