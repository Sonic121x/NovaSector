/obj/item/hhmirror/syndie
	name = "手持镜子"
	desc = "一面可以改变你外貌的手持镜子。不知为何让你想起了旧时光..."
	icon = 'modular_nova/master_files/icons/obj/hhmirror.dmi'
	icon_state = "hhmirror"
	special_desc_requirement = EXAMINE_CHECK_SYNDICATE
	special_desc = "A mirror manufactured by the Syndicate containing barber-nanites that can alter your hair on the spot. Target your head and use it on yourself to activate the nanites."
	w_class = WEIGHT_CLASS_TINY
	// How long does it take to change someone's hairstyle?
	var/haircut_duration = 1 SECONDS
	// How long does it take to change someone's facial hair style?
	var/facial_haircut_duration = 1 SECONDS


/obj/item/hhmirror/syndie/attack(mob/living/attacked_mob, mob/living/user, params)
	if(!ishuman(attacked_mob))
		return

	var/mob/living/carbon/human/target_human = attacked_mob

	var/location = user.zone_selected
	if(!(location in list(BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_HEAD)) && !user.combat_mode)
		balloon_alert(user, "只能用在你的头上！")
		return

	if(user.zone_selected != BODY_ZONE_HEAD)
		return ..()

	var/selected_part = tgui_alert(user, "请选择你想塑造[target_human]的哪个部位！", "雕塑时间到！", list("Hair", "Facial Hair", "Cancel"))

	if(!selected_part || selected_part == "Cancel")
		return

	if(selected_part == "Hair")

		var/hair_id = tgui_input_list(user, "请选择你想要塑造的发型！", "选择杰作", SSaccessories.hairstyles_list)
		if(!hair_id)
			return

		if(hair_id == "Bald")
			to_chat(target_human, span_danger("纳米机器人似乎在分解你所有的头发！"))

		to_chat(user, span_notice("纳米机器人开始重塑[target_human]的头发！"))


		if(do_after(user, haircut_duration, target_human))
			target_human.set_hairstyle(hair_id, update = TRUE)
			user.visible_message(span_notice("[target_human]的头发改变了！"), span_notice("纳米机器人成功改变了[target_human]的头发！"))
	else
		var/facial_hair_id = tgui_input_list(user, "请选择你想雕塑哪种面部毛发造型！", "选择杰作", SSaccessories.facial_hairstyles_list)
		if(!facial_hair_id)
			return

		if(facial_hair_id == "Shaved")
			to_chat(target_human, span_danger("纳米机器人似乎在分解你所有的面部毛发！"))

		to_chat(user, "纳米机器人开始重塑[target_human]的面部毛发！")

		if(do_after(user, facial_haircut_duration, target_human))
			target_human.set_facial_hairstyle(facial_hair_id, update = TRUE)
			user.visible_message(span_notice("[target_human]的面部毛发改变了！"), span_notice("纳米机器人成功改变了[target_human]的面部毛发！"))

/obj/item/storage/box/syndie_kit/chameleon/PopulateContents()
	. = ..()
	new /obj/item/hhmirror/syndie(src)
	new /obj/item/dyespray(src)

