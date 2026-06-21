/obj/item/scanner_wand
	name = "自助终端扫描棒"
	icon = 'icons/obj/devices/scanner.dmi'
	icon_state = "scanner_wand"
	inhand_icon_state = "healthanalyzer"
	icon_angle = -45
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	desc = "一种用于医疗扫描人的棒状设备。将其插入医疗自助终端后，即可对患者进行健康扫描。"
	force = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_BULKY
	var/selected_target = null

/obj/item/scanner_wand/attack(mob/living/M, mob/living/carbon/human/user)
	flick("[icon_state]_active", src) //nice little visual flash when scanning someone else.

	if((HAS_TRAIT(user, TRAIT_CLUMSY) || HAS_TRAIT(user, TRAIT_DUMB)) && prob(25))
		user.visible_message(span_warning("[user]将自己设为扫描目标。"), \
		to_chat(user, span_info("你试图扫描[M]，然后发现自己把扫描棒拿反了。哎呀。")))
		selected_target = user
		return

	if(!ishuman(M))
		to_chat(user, span_info("你只能扫描类人、非机械的生物。"))
		selected_target = null
		return

	user.visible_message(span_notice("[user]将[M]设为扫描目标。"), \
						span_notice("你锁定了[M]的生命体征。"))
	selected_target = M
	return

/obj/item/scanner_wand/attack_self(mob/user)
	to_chat(user, span_info("你清除了扫描器的目标。"))
	selected_target = null

/obj/item/scanner_wand/proc/return_patient()
	var/returned_target = selected_target
	return returned_target
