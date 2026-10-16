// ZH EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_zh/modules/i18n/readme.md
// Magic Mirror Character Application
/obj/structure/mirror/magic/attack_hand(mob/living/carbon/human/user)
	var/user_input = tgui_alert(user, LANG("obj.fc2b5f8757eab372", null),LANG("obj.3c1da715a16e1d9e", null), list("Yes!", "No"))

	if(user_input == "Yes!")
		user?.client?.prefs?.safe_transfer_prefs_to(user)
		return TRUE

	return ..()
