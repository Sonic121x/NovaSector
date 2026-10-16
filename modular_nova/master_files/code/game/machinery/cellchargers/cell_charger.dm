// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
/obj/machinery/cell_charger/Initialize(mapload)
	. = ..()
	register_context()

/obj/machinery/cell_charger/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	context[SCREENTIP_CONTEXT_ALT_LMB] = "Remove cell"
	return CONTEXTUAL_SCREENTIP_SET

/obj/machinery/cell_charger/click_alt(mob/user, list/modifiers)
	if(. || !charging)
		return CLICK_ACTION_BLOCKING
	to_chat(user, span_notice(LANG("obj.aba7bd73c693c3fc", null)))
	removecell(charging.forceMove(drop_location()))
	return CLICK_ACTION_SUCCESS

/obj/machinery/cell_charger/examine(mob/user)
	. = ..()
	. += span_notice(LANG("obj.44eddf6a74d7144f", null))
