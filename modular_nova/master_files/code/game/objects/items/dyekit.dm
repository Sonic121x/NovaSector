#define DYE_OPTION_HAIR_COLOR "Change hair color"
#define DYE_OPTION_GRADIENT "Apply a gradient"

/**
 * Applies a gradient and a gradient color to a mob OR changes their hair color, depending on what they choose.
 *
 * Arguments:
 * * target - The mob who we will apply the hair color / gradient and gradient color to.
 * * user - The mob that is applying the hair color / gradient and gradient color.
 */

/obj/item/dyespray
	desc = "一种用于染发的喷雾，还能为头发添加任何你想要的渐变效果。"
	var/uses = 40

/obj/item/dyespray/proc/dye(mob/target, mob/user)
	if(!ishuman(target))
		return

	if(!uses) // Can be set to -1 for infinite uses, basically.
		balloon_alert(user, "它是空的！")
		return

	var/mob/living/carbon/human/human_target = target
	var/static/list/dye_options = list(DYE_OPTION_HAIR_COLOR, DYE_OPTION_GRADIENT)
	var/gradient_or_hair = tgui_alert(user, "你想做什么？", "染发喷雾", dye_options, autofocus = TRUE)
	if(!gradient_or_hair || !user.can_perform_action(src, NEED_DEXTERITY))
		return

	var/dyeing_themselves = target == user
	if(gradient_or_hair == DYE_OPTION_HAIR_COLOR)
		var/new_color = tgui_color_picker(user, "Choose a hair color:", "Character Preference", "#" + human_target.hair_color)

		if(!new_color || !user.can_perform_action(src, NEED_DEXTERITY))
			return

		human_target.visible_message(span_notice("[user] 开始将染发剂涂抹到[dyeing_themselves ? "their own" : "[human_target]'s"]头发上..."), span_notice("[dyeing_themselves ? "You start" : "[user] starts"]将染发剂涂抹到[dyeing_themselves ? "your own" : "your"]头发上..."), ignored_mobs = user)
		if(!dyeing_themselves)
			balloon_alert(user, "染色中...")
		if(!do_after(user, 3 SECONDS, target))
			return

		human_target.set_haircolor(sanitize_hexcolor(new_color), update = TRUE)

	else
		var/beard_or_hair = tgui_input_list(user, "你想染什么？", "角色偏好", list("Hair", "Facial Hair"))
		if(!beard_or_hair || !user.can_perform_action(src, NEED_DEXTERITY))
			return

		var/list/choices = beard_or_hair == "Hair" ? SSaccessories.hair_gradients_list : SSaccessories.facial_hair_gradients_list
		var/new_grad_style = tgui_input_list(user, "选择颜色样式：", "染发喷雾", choices)
		if(!new_grad_style || !user.can_perform_action(src, NEED_DEXTERITY))
			return

		var/hair_key = beard_or_hair == "Hair" ? GRADIENT_HAIR_KEY : GRADIENT_FACIAL_HAIR_KEY
		var/new_grad_color = tgui_color_picker(user, "Choose a secondary hair color:", "Dye Spray", human_target.get_hair_gradient_color(hair_key))
		if(!new_grad_color || !user.can_perform_action(src, NEED_DEXTERITY))
			return

		human_target.visible_message(span_notice("[user]开始将染发剂涂抹到[dyeing_themselves ? "their own" : "[human_target]'s"]头发上..."), span_notice("[dyeing_themselves ? "You start" : "[user] starts"]将染发剂涂抹到[dyeing_themselves ? "your own" : "your"]头发上..."), ignored_mobs = user)
		if(!dyeing_themselves)
			balloon_alert(user, "染色中...")
		if(!do_after(user, 3 SECONDS, target))
			return

		if(beard_or_hair == "Hair")
			human_target.set_hair_gradient_color(sanitize_hexcolor(new_grad_color), update = FALSE)
			human_target.set_hair_gradient_style(new_grad_style, update = TRUE)
		else
			human_target.set_facial_hair_gradient_color(sanitize_hexcolor(new_grad_color), update = FALSE)
			human_target.set_facial_hair_gradient_style(new_grad_style, update = TRUE)

	playsound(src, 'sound/effects/spray.ogg', 10, vary = TRUE)

	human_target.visible_message(
		span_notice("[user]完成了对[dyeing_themselves ? "their own" : "[human_target]'s"]头发的染色，改变了它的颜色！"),
		span_notice("[dyeing_themselves ? "You finish" : "[user] finishes"]对[dyeing_themselves ? "your own" : "your"]头发完成了染色，改变了它的颜色！"), ignored_mobs = user)
	if(!dyeing_themselves)
		balloon_alert(user, "染色完成！")

	uses--

/obj/item/dyespray/examine(mob/user)
	. = ..()
	. += "It has [uses] uses left."

#undef DYE_OPTION_HAIR_COLOR
#undef DYE_OPTION_GRADIENT
