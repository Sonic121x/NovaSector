/obj/item/virgin_mary
	name = "\proper 圣母玛利亚画像"
	desc = "一个描绘圣母的小巧廉价圣像。"
	icon = 'icons/obj/devices/blackmarket.dmi'
	icon_state = "madonna"
	resistance_flags = FLAMMABLE
	///Has this item been used already.
	var/used_up = FALSE

/obj/item/virgin_mary/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/burn_on_item_ignition, bypass_clumsy = TRUE)
	RegisterSignal(src, COMSIG_ATOM_IGNITED_BY_ITEM, PROC_REF(induct_new_initiate))

#define NICKNAME_CAP (MAX_NAME_LEN/2)

/obj/item/virgin_mary/proc/induct_new_initiate(datum/source, mob/living/user, obj/item/burning_tool)
	SIGNAL_HANDLER

	INVOKE_ASYNC(src, PROC_REF(induct_new_initiate_async), user, burning_tool)

/obj/item/virgin_mary/proc/induct_new_initiate_async(mob/living/user, obj/item/burning_tool)
	if(isnull(user.mind))
		return
	if(HAS_TRAIT(user, TRAIT_MAFIAINITIATE)) //Only one nickname fuckhead
		to_chat(user, span_warning("你已经被引入了黑手党生活。"))
		return
	if(used_up)
		return

	ADD_TRAIT(user, TRAIT_MAFIAINITIATE, TRAIT_GENERIC) // Adding the trait early because you could burn multiple at once for a very long name
	to_chat(user, span_notice("当你烧毁照片时，脑海中浮现出一个绰号..."))
	var/nickname = tgui_input_text(user, "选择一个昵称", "黑手党昵称", max_length = NICKNAME_CAP)
	nickname = reject_bad_name(nickname, allow_numbers = FALSE, max_length = NICKNAME_CAP, ascii_only = TRUE)
	if(!nickname)
		REMOVE_TRAIT(user, TRAIT_MAFIAINITIATE, TRAIT_GENERIC)
		return
	var/new_name
	var/space_position = findtext(user.real_name, " ")
	if(space_position)//Can we find a space?
		new_name = "[copytext(user.real_name, 1, space_position)] \"[nickname]\" [copytext(user.real_name, space_position)]"
	else //Append otherwise
		new_name = "[user.real_name] \"[nickname]\""
	user.real_name = new_name
	used_up = TRUE
	user.say("My soul will burn like this saint if I betray my family. I enter alive and I will have to get out dead.", forced = /obj/item/virgin_mary)
	to_chat(user, span_userdanger("被吸纳进黑手党并不会赋予你反派身份。"))

#undef NICKNAME_CAP

/obj/item/virgin_mary/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] 开始以惊人的速度念诵万福玛利亚！看起来[user.p_theyre()]正试图进入来世！"))
	user.say("Hail Mary, full of grace, the Lord is with thee. Blessed are thou amongst women, and blessed is the fruit of thy womb, Jesus. Holy Mary, mother of God, pray for us sinners, now and at the hour of our death. Amen. ", forced = /obj/item/virgin_mary)
	addtimer(CALLBACK(src, PROC_REF(manual_suicide), user), 7.5 SECONDS)
	addtimer(CALLBACK(user, TYPE_PROC_REF(/atom/movable, say), "O my Mother, preserve me this day from mortal sin..."), 5 SECONDS)
	return MANUAL_SUICIDE

/obj/item/virgin_mary/proc/manual_suicide(mob/living/user)
	user.adjust_oxy_loss(200)
	user.death(FALSE)
