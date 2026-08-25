// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/scanner_wand
	name = "kiosk scanner wand"
	icon = 'icons/obj/devices/scanner.dmi'
	icon_state = "scanner_wand"
	inhand_icon_state = "healthanalyzer"
	icon_angle = -45
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	desc = "A wand that medically scans people. Inserting it into a medical kiosk makes it able to perform a health scan on the patient."
	force = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_BULKY
	var/selected_target = null

/obj/item/scanner_wand/attack(mob/living/M, mob/living/carbon/human/user)
	flick("[icon_state]_active", src) //nice little visual flash when scanning someone else.

	if((HAS_TRAIT(user, TRAIT_CLUMSY) || HAS_TRAIT(user, TRAIT_DUMB)) && prob(25))
		user.visible_message(span_warning(LANG("obj.6b85a607118fb563", list(user))), \
		to_chat(user, span_info(LANG("obj.ab22ee8f6ec31423", list(M)))))
		selected_target = user
		return

	if(!ishuman(M))
		to_chat(user, span_info(LANG("obj.9634e1888bcd86d6", null)))
		selected_target = null
		return

	user.visible_message(span_notice(LANG("obj.b66c65fa9138bbcf", list(user, M))), \
						span_notice(LANG("obj.d207c2010c57a6aa", list(M))))
	selected_target = M
	return

/obj/item/scanner_wand/attack_self(mob/user)
	to_chat(user, span_info(LANG("obj.5cda02406a341beb", null)))
	selected_target = null

/obj/item/scanner_wand/proc/return_patient()
	var/returned_target = selected_target
	return returned_target
