/datum/scripture/integration_cog
	name = "整合齿轮"
	desc = "制造一个整合齿轮，可插入APC以汲取电力并解锁经文。"
	tip = "Install integration cogs into APCs to increase your energy stores and unlock new scriptures."
	button_icon_state = "Integration Cog"
	invocation_time = 1 SECONDS
	invocation_text = list("Tick tock Eng'Ine...")
	category = SPELLTYPE_SERVITUDE

/datum/scripture/integration_cog/invoke_success()
	if(invoker.put_in_hands(new /obj/item/clockwork/integration_cog))
		to_chat(invoker, span_brass("你将一个整合齿轮召唤到手中。"))
		playsound(src, 'sound/machines/click.ogg', 50)
		return TRUE

	else
		to_chat(invoker, span_brass("你在地板上召唤了一个整合齿轮。"))
		playsound(src, 'sound/machines/click.ogg', 50)
		return FALSE
