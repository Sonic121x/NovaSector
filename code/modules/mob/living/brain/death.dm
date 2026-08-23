// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/mob/living/brain/death(gibbed)
	if(stat == DEAD)
		return
	set_stat(DEAD)

	if(!gibbed && container)//If not gibbed but in a container.
		var/obj/item/mmi = container
		mmi.visible_message(span_warning(LANG("mob.234ce8afaaaffb86", list(src))), \
					span_hear(LANG("mob.642a3a82e9c54493", null)))
		mmi.update_appearance()

	return ..()

/mob/living/brain/gib()
	if(container)
		qdel(container)//Gets rid of the MMI if there is one
	if(loc)
		if(istype(loc, /obj/item/organ/brain))
			qdel(loc)//Gets rid of the brain item
	..()
