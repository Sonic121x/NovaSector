// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/ai_module/law/zeroth/apply_to_combined_lawset(datum/ai_laws/combined_lawset)
	combined_lawset.set_zeroth_law(laws[1])

/obj/item/ai_module/law/zeroth/onehuman
	name = "'OneHuman' AI Module"
	var/targetName = ""
	laws = list("Only SUBJECT is human.")
	custom_materials = list(/datum/material/diamond = SHEET_MATERIAL_AMOUNT * 3, /datum/material/glass = HALF_SHEET_MATERIAL_AMOUNT, /datum/material/bluespace = HALF_SHEET_MATERIAL_AMOUNT)

/obj/item/ai_module/law/zeroth/onehuman/configure(mob/user)
	. = TRUE
	var/targName = tgui_input_text(user, LANG("obj.61abbc7b", null), LANG("obj.f455cda7", null), user.real_name, max_length = MAX_NAME_LEN)
	if(!targName || !user.is_holding(src))
		return
	targetName = targName
	laws[1] = "Only [targetName] is human"

/obj/item/ai_module/law/zeroth/onehuman/can_install_to_rack(mob/living/user, obj/machinery/ai_law_rack/rack)
	if(!targetName)
		to_chat(user, span_warning(LANG("obj.f7e900f2", null)))
		return FALSE
	return TRUE
