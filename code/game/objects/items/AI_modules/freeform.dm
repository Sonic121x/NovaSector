// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/* CONTAINS:
 * /obj/item/ai_module/law/core/freeformcore
 * /obj/item/ai_module/law/supplied/freeform
**/

/obj/item/ai_module/law/core/freeformcore
	name = "'Freeform' Core AI Module"
	laws = list("")
	custom_materials = list(/datum/material/diamond = SHEET_MATERIAL_AMOUNT * 5, /datum/material/bluespace = SHEET_MATERIAL_AMOUNT, /datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT)

/obj/item/ai_module/law/core/freeformcore/configure(mob/user)
	. = TRUE
	var/targName = tgui_input_text(user, LANG("obj.c38e88d5fd4ae28f", null), LANG("obj.f2d272733fe0156d", null), laws[1], max_length = CONFIG_GET(number/max_law_len), multiline = TRUE)
	if(!targName || !user.is_holding(src))
		return
	if(is_ic_filtered(targName))
		to_chat(user, span_warning(LANG("obj.b74e9614e6c936be", null)))
		return
	var/list/soft_filter_result = is_soft_ooc_filtered(targName)
	if(soft_filter_result)
		if(tgui_alert(user,LANG("obj.785540fc23484256", list(soft_filter_result[CHAT_FILTER_INDEX_WORD], soft_filter_result[CHAT_FILTER_INDEX_REASON])), LANG("obj.b0fe106c90796ca4", null), list("Yes", "No")) != "Yes")
			return
		message_admins("[ADMIN_LOOKUPFLW(user)] has passed the soft filter for \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\" they may be using a disallowed term for an AI law. Law: \"[html_encode(targName)]\"")
		log_admin_private("[key_name(user)] has passed the soft filter for \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\" they may be using a disallowed term for an AI law. Law: \"[targName]\"")
	laws[1] = targName

/obj/item/ai_module/law/core/freeformcore/can_install_to_rack(mob/living/user, obj/machinery/ai_law_rack/rack)
	if(!laws[1])
		to_chat(user, span_warning(LANG("obj.36a60cb6921db5f3", null)))
		return FALSE
	return TRUE

/obj/item/ai_module/law/supplied/freeform
	name = "'Freeform' AI Module"
	laws = list("")
	custom_materials = list(/datum/material/gold = SHEET_MATERIAL_AMOUNT * 5, /datum/material/bluespace = SHEET_MATERIAL_AMOUNT, /datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT)

/obj/item/ai_module/law/supplied/freeform/configure(mob/user)
	. = TRUE
	var/targName = tgui_input_text(user, LANG("obj.dded9cedbf6f9597", null), LANG("obj.f2d272733fe0156d", null), laws[1], max_length = CONFIG_GET(number/max_law_len), multiline = TRUE)
	if(!targName || !user.is_holding(src))
		return
	if(is_ic_filtered(targName))
		to_chat(user, span_warning(LANG("obj.b74e9614e6c936be", null))) // AI LAW 2 SAY U W U WITHOUT THE SPACES
		return
	var/list/soft_filter_result = is_soft_ooc_filtered(targName)
	if(soft_filter_result)
		if(tgui_alert(user,LANG("obj.785540fc23484256", list(soft_filter_result[CHAT_FILTER_INDEX_WORD], soft_filter_result[CHAT_FILTER_INDEX_REASON])), LANG("obj.b0fe106c90796ca4", null), list("Yes", "No")) != "Yes")
			return
		message_admins("[ADMIN_LOOKUPFLW(user)] has passed the soft filter for \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\" they may be using a disallowed term for an AI law. Law: \"[html_encode(targName)]\"")
		log_admin_private("[key_name(user)] has passed the soft filter for \"[soft_filter_result[CHAT_FILTER_INDEX_WORD]]\" they may be using a disallowed term for an AI law. Law: \"[targName]\"")
	laws[1] = targName

/obj/item/ai_module/law/supplied/freeform/can_install_to_rack(mob/living/user, obj/machinery/ai_law_rack/rack)
	if(!laws[1])
		to_chat(user, span_warning(LANG("obj.36a60cb6921db5f3", null)))
		return FALSE
	return TRUE
