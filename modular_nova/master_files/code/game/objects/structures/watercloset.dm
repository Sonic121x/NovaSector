/obj/structure/sink/attackby(obj/item/attacking_item, mob/user, list/modifiers, list/attack_modifiers)
	if(busy)
		to_chat(user, span_warning("已经有人在这里清洗了！"))
		return

	if(istype(attacking_item, /obj/item/towel))
		if(reagents.total_volume <= 0)
			to_chat(user, span_notice("\The [src] 是干的。"))
			return FALSE

		busy = TRUE
		user.visible_message(span_notice("[user] 开始在 [attacking_item] 里清洗 [src]。"), span_notice("你开始在[attacking_item]里清洗[src]。"))

		if(!do_after(user, 2 SECONDS, src))
			busy = FALSE
			to_chat(user, span_warning("你在清洗完成前就把[attacking_item]从[src]上拿开了。"))
			return FALSE

		var/obj/item/towel/washed_towel = attacking_item

		washed_towel.reagents.remove_all(washed_towel.reagents.total_volume)
		washed_towel.transfer_reagents_to_towel(reagents, washed_towel.reagents.maximum_volume, user)

		washed_towel.set_wet(TRUE)
		washed_towel.make_used(user, silent = TRUE)

		START_PROCESSING(SSobj, src)
		user.visible_message(span_notice("[user] 在 [attacking_item] 里洗完了 [src]。"), span_notice("你在[washed_towel]里洗完了[src]，把它弄得相当湿。"))
		playsound(loc, 'sound/effects/slosh.ogg', 25, TRUE)

		busy = FALSE

	else
		return ..()

