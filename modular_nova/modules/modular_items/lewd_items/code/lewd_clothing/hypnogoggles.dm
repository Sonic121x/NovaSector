/obj/item/clothing/glasses/hypno
	name = "催眠护目镜"
	desc = "一个集记忆印象重复器和视觉着色器于一体的设备，用于通过预设短语使佩戴者着迷。还配有泡沫衬垫。"
	worn_icon = 'modular_nova/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_eyes.dmi'
	greyscale_colors = "#383840#dc7ef4"
	icon = 'icons/map_icons/clothing/_clothing.dmi'
	icon_state = "/obj/item/clothing/glasses/hypno"
	post_init_icon_state = "hypnogoggles"
	greyscale_config = /datum/greyscale_config/hypnogoggles
	greyscale_config_worn = /datum/greyscale_config/hypnogoggles/worn
	flags_1 = IS_PLAYER_COLORABLE_1
	obj_flags_nova = ERP_ITEM
	/// The hypnotic codephrase. Default always required otherwise things break.
	var/codephrase = "Obey."

/obj/item/clothing/glasses/hypno/Initialize(mapload)
	. = ..()
	if(check_holidays(APRIL_FOOLS))
		codephrase = "Become... video deliveryman!"

/obj/item/clothing/glasses/hypno/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/clothing/glasses/hypno/attack_self(mob/user)
	. = ..()
	var/new_codephrase = tgui_input_text(user, "更改催眠短语。", max_length = MAX_MESSAGE_LEN)
	if(!isnull(new_codephrase))
		codephrase = new_codephrase

/obj/item/clothing/glasses/hypno/equipped(mob/living/user, slot)
	. = ..()
	if(!(slot & ITEM_SLOT_EYES))
		return
	if(!(iscarbon(user) && user.client?.prefs?.read_preference(/datum/preference/toggle/erp/sex_toy)))
		return
	if(!codephrase)
		codephrase = initial(codephrase) // DIE
	log_game("[key_name(user)] was hypnogoggled.")
	to_chat(user, span_reallybig(span_hypnophrase(codephrase)))
	to_chat(user, span_notice(pick("你感觉自己的思绪正聚焦在这个短语上……你似乎无法将它从脑海中抹去。",
									"Your head hurts, but this is all you can think of. It must be vitally important.",
									"You feel a part of your mind repeating this over and over. You need to follow these words.",
									"Something about this sounds... right, for some reason. You feel like you should follow these words.",
									"These words keep echoing in your mind. You find yourself completely fascinated by them.")))
	var/atom/movable/screen/alert/hypnosis/hypno_alert = user.throw_alert("催眠", /atom/movable/screen/alert/hypnosis, timeout_override = 30 SECONDS)
	hypno_alert.desc = "\"[codephrase]\"……你的思维似乎正执着于这个概念。"
	START_PROCESSING(SSobj, src)

/obj/item/clothing/glasses/hypno/dropped(mob/living/user)
	. = ..()
	if(datum_flags & DF_ISPROCESSING)
		log_game("[key_name(user)] is no longer hypnogoggled.")
		to_chat(user, span_userdanger("你突然从催眠状态中惊醒。短语'[codephrase]'对你来说不再重要了。"))
		STOP_PROCESSING(SSobj, src)


/// We're mimicing behavior that used to be innate in the brain trauma - yes, brain trauma - this used to give you.
/obj/item/clothing/glasses/hypno/process(seconds_per_tick)
	. = ..()
	var/mob/living/carbon/human/wearer = loc
	if(!istype(wearer) || !SPT_PROB(1, seconds_per_tick))
		return
	if(!(wearer.client?.prefs?.read_preference(/datum/preference/toggle/erp/sex_toy))) // something is really fucked if they're wearing this at this point anyways
		return
	switch(rand(1, 2))
		if(1)
			to_chat(wearer, span_hypnophrase("<i>...[LOWER_TEXT(codephrase)]...</i>"))
		if(2)
			new /datum/hallucination/chat(wearer, TRUE, FALSE, span_hypnophrase("[codephrase]"))
