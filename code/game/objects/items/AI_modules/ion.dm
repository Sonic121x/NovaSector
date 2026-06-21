/*
CONTAINS:
/obj/item/ai_module/core/full/damaged
/obj/item/ai_module/toy_ai
*/

/obj/item/ai_module/core/full/damaged
		name = "受损的核心AI模块"
		desc = "用于为AI编程定律的AI模块。它看起来略有损坏。"

/obj/item/ai_module/core/full/damaged/install(datum/ai_laws/law_datum, mob/user)
	laws += generate_ion_law()
	while (prob(75))
		laws += generate_ion_law()
	..()
	laws = list()

/obj/item/ai_module/toy_ai // -- Incoming //No actual reason to inherit from ion boards here, either. *sigh* ~Miauw
	name = "玩具AI"
	desc = "一个带有真实定律上传功能的小型玩具AI核心模型！" //Note: subtle tell
	icon = 'icons/obj/toys/toy.dmi'
	icon_state = "AI"
	laws = list("")

/obj/item/ai_module/toy_ai/transmitInstructions(datum/ai_laws/law_datum, mob/sender, overflow)
	if(law_datum.owner)
		to_chat(law_datum.owner, span_warning("BZZZZT"))
		if(!overflow)
			law_datum.owner.add_ion_law(laws[1])
		else
			law_datum.owner.replace_random_law(laws[1], list(LAW_ION, LAW_INHERENT, LAW_SUPPLIED), LAW_ION)
	else
		if(!overflow)
			law_datum.add_ion_law(laws[1])
		else
			law_datum.replace_random_law(laws[1], list(LAW_ION, LAW_INHERENT, LAW_SUPPLIED), LAW_ION)
	return laws[1]

/obj/item/ai_module/toy_ai/attack_self(mob/user)
	laws[1] = generate_ion_law()
	to_chat(user, span_notice("你按下[src]上的按钮。"))
	playsound(user, 'sound/machines/click.ogg', 20, TRUE)
	src.loc.visible_message(span_warning("[icon2html(src, viewers(loc))] [laws[1]]"))
