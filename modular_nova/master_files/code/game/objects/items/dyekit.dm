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
	desc = "A spray to dye hair, as well as giving it any gradient you'd like."
	var/uses = 40

/obj/item/dyespray/proc/dye(mob/target, mob/user)
	if(!ishuman(target))
		return

	if(!uses) // Can be set to -1 for infinite uses, basically.
		balloon_alert(user, LANG("obj.76a90f7c0f5ea424", null))
		return

	var/mob/living/carbon/human/human_target = target
	var/static/list/dye_options = list(DYE_OPTION_HAIR_COLOR, DYE_OPTION_GRADIENT)
	var/gradient_or_hair = tgui_alert(user, LANG("obj.ab3c2f647ff1b220", null), LANG("obj.ac2dd580512ca80b", null), dye_options, autofocus = TRUE)
	if(!gradient_or_hair || !user.can_perform_action(src, NEED_DEXTERITY))
		return

	var/dyeing_themselves = target == user
	if(gradient_or_hair == DYE_OPTION_HAIR_COLOR)
		var/new_color = tgui_color_picker(user, "Choose a hair color:", "Character Preference", "#" + human_target.hair_color)

		if(!new_color || !user.can_perform_action(src, NEED_DEXTERITY))
			return

		human_target.visible_message(span_notice(LANG("obj.c2358a12e0b001c8", list(user, dyeing_themselves ? "their own" : "[human_target]'s"))), span_notice(LANG("obj.b7dd0d943e72a4f0", list(dyeing_themselves ? "You start" : "[user] starts", dyeing_themselves ? "your own" : "your"))), ignored_mobs = user)
		if(!dyeing_themselves)
			balloon_alert(user, LANG("obj.87b436e179957446", null))
		if(!do_after(user, 3 SECONDS, target))
			return

		human_target.set_haircolor(sanitize_hexcolor(new_color), update = TRUE)

	else
		var/beard_or_hair = tgui_input_list(user, LANG("obj.104fcb0c9eff7027", null), LANG("obj.78f80c295b6adf9f", null), list("Hair", "Facial Hair"))
		if(!beard_or_hair || !user.can_perform_action(src, NEED_DEXTERITY))
			return

		var/list/choices = beard_or_hair == "Hair" ? SSaccessories.hair_gradients_list : SSaccessories.facial_hair_gradients_list
		var/new_grad_style = tgui_input_list(user, LANG("obj.2b2d093354e09c10", null), LANG("obj.a23f559359e0ffee", null), choices)
		if(!new_grad_style || !user.can_perform_action(src, NEED_DEXTERITY))
			return

		var/hair_key = beard_or_hair == "Hair" ? GRADIENT_HAIR_KEY : GRADIENT_FACIAL_HAIR_KEY
		var/new_grad_color = tgui_color_picker(user, "Choose a secondary hair color:", "Dye Spray", human_target.get_hair_gradient_color(hair_key))
		if(!new_grad_color || !user.can_perform_action(src, NEED_DEXTERITY))
			return

		human_target.visible_message(span_notice(LANG("obj.c2358a12e0b001c8", list(user, dyeing_themselves ? "their own" : "[human_target]'s"))), span_notice(LANG("obj.b7dd0d943e72a4f0", list(dyeing_themselves ? "You start" : "[user] starts", dyeing_themselves ? "your own" : "your"))), ignored_mobs = user)
		if(!dyeing_themselves)
			balloon_alert(user, LANG("obj.87b436e179957446", null))
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
		span_notice(LANG("obj.aa012fccedd6cb13", list(user, dyeing_themselves ? "their own" : "[human_target]'s"))),
		span_notice(LANG("obj.3d5878103c30e9eb", list(dyeing_themselves ? "You finish" : "[user] finishes", dyeing_themselves ? "your own" : "your"))), ignored_mobs = user)
	if(!dyeing_themselves)
		balloon_alert(user, LANG("obj.7fd26f0a72ebd75f", null))

	uses--

/obj/item/dyespray/examine(mob/user)
	. = ..()
	. += LANG("obj.8e201a44af6b290d", list(uses))

#undef DYE_OPTION_HAIR_COLOR
#undef DYE_OPTION_GRADIENT
