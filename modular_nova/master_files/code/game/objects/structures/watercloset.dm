/obj/structure/sink/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(busy)
		to_chat(user, span_warning(LANG("obj.d5ba1f8cb2273d77", null)))
		return ITEM_INTERACT_BLOCKING

	if(istype(tool, /obj/item/towel))
		if(reagents.total_volume <= 0)
			to_chat(user, span_notice(LANG("obj.9043fdab29ed6609", list(src))))
			return ITEM_INTERACT_BLOCKING

		busy = TRUE
		user.visible_message(span_notice(LANG("obj.34cb5eb06431759b", list(user, tool, src))), span_notice(LANG("obj.4ee1043eeb0ca6b2", list(tool, src))))

		if(!do_after(user, 2 SECONDS, src))
			busy = FALSE
			to_chat(user, span_warning(LANG("obj.1153ba60ee68a0b3", list(tool, src))))
			return ITEM_INTERACT_BLOCKING

		var/obj/item/towel/washed_towel = tool

		washed_towel.reagents.remove_all(washed_towel.reagents.total_volume)
		washed_towel.transfer_reagents_to_towel(reagents, washed_towel.reagents.maximum_volume, user)

		washed_towel.set_wet(TRUE)
		washed_towel.make_used(user, silent = TRUE)

		START_PROCESSING(SSobj, src)
		user.visible_message(span_notice(LANG("obj.dd8be228c0009b34", list(user, tool, src))), span_notice(LANG("obj.7f3444e9aaf0375c", list(washed_towel, src))))
		playsound(loc, 'sound/effects/slosh.ogg', 25, TRUE)

		busy = FALSE
		return ITEM_INTERACT_SUCCESS

	else
		return ..()

