/obj/item/fake_identity_kit
	name = "伪造身份工具包"
	desc = "包含获得全新开始和完美不在场证明所需的所有文书，外加一点数字辅助，可将你插入船员记录中。"
	icon = 'icons/obj/service/bureaucracy.dmi'
	icon_state = "docs_mulligan"
	w_class = WEIGHT_CLASS_TINY
	interaction_flags_click = NEED_LITERACY|NEED_LIGHT|NEED_DEXTERITY|NEED_HANDS|ALLOW_RESTING
	/// What do we set up our "new arrival" as?
	var/assigned_job = JOB_ASSISTANT

/obj/item/fake_identity_kit/examine_more(mob/user)
	. = ..()
	. += span_info("接触马利根血清后使用此工具包，将为你新的外貌创建一个伪造身份。")
	. += span_info("这会将你添加到各个空间站名单中，创建一张助理级别的ID卡，并通过无线电宣布你的抵达。")

/obj/item/fake_identity_kit/attack_self(mob/living/carbon/human/user, modifiers)
	. = ..()
	if (!ishuman(user))
		balloon_alert(user, "无法冒充员工！")
		return
	if (find_record(user.real_name))
		balloon_alert(user, "记录已存在！")
		return

	user.temporarilyRemoveItemFromInventory(src)
	user.playsound_local(user, 'sound/items/cards/cardshuffle.ogg', 50, TRUE)

	var/obj/item/card/id/advanced/original_id = user.get_idcard(hand_first = FALSE)
	if (original_id)
		user.temporarilyRemoveItemFromInventory(original_id)

	var/datum/job/job = SSjob.get_job(assigned_job)
	user.mind.set_assigned_role(job)

	var/datum/outfit/job_outfit = job.outfit
	var/id_trim = job_outfit::id_trim
	var/obj/item/card/id/advanced/fake_id = new()

	if (id_trim)
		SSid_access.apply_trim_to_card(fake_id, id_trim)
		shuffle_inplace(fake_id.access)

	fake_id.registered_name = user.real_name
	if(user.age)
		fake_id.registered_age = user.age
	fake_id.update_label()
	fake_id.update_icon()

	var/placed_in = user.equip_in_one_of_slots(fake_id, list(
			LOCATION_ID,
			LOCATION_LPOCKET,
			LOCATION_RPOCKET,
			LOCATION_BACKPACK,
			LOCATION_HANDS,
		), qdel_on_fail = FALSE, indirect_action = TRUE)
	if (isnull(placed_in))
		fake_id.forceMove(user.drop_location())
		to_chat(user, span_warning("你将新的ID卡丢在地上。"))
	else
		to_chat(user, span_notice("你迅速将新的ID卡放入[placed_in]。"))

	user.update_ID_card()

	var/mob/living/carbon/human/dummy/consistent/dummy = new() // For manifest rendering, unfortunately
	dummy.physique = user.physique
	user.dna.copy_dna(dummy.dna, COPY_DNA_SE|COPY_DNA_SPECIES)
	user.copy_clothing_prefs(dummy)
	dummy.updateappearance(icon_update = TRUE, mutcolor_update = TRUE, mutations_overlay_update = TRUE)
	dummy.dress_up_as_job(job, visual_only = TRUE, player_client = user.client)

	GLOB.manifest.inject(user, appearance_proxy = dummy)
	QDEL_NULL(dummy)

	if (original_id)
		var/returned_to = user.equip_in_one_of_slots(original_id, list(
			LOCATION_BACKPACK,
			LOCATION_LPOCKET,
			LOCATION_RPOCKET,
			LOCATION_HANDS,
		), qdel_on_fail = FALSE, indirect_action = TRUE)
		if (isnull(returned_to))
			fake_id.forceMove(user.drop_location())
			to_chat(user, span_warning("你将旧的ID卡丢在地上。"))
		else
			to_chat(user, span_notice("你将旧的ID卡藏入[returned_to]。"))

	var/obj/item/arrival_announcer/announcer = new(user.drop_location())
	user.put_in_hands(announcer)
	to_chat(user, span_notice("你迅速吃掉剩余的文书，只留下用于在空间站宣布你抵达的信号器。"))
	qdel(src)

/obj/item/arrival_announcer
	name = "抵达通知信号器"
	desc = "一种无线电信号器，利用NT通知系统的后门触发虚假通知，宣布你刚刚抵达那里，然后自毁。"
	icon_state = "signaller"
	inhand_icon_state = "signaler"
	icon = 'icons/obj/devices/new_assemblies.dmi'
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
	interaction_flags_click = NEED_DEXTERITY|NEED_HANDS|ALLOW_RESTING

/obj/item/arrival_announcer/attack_self(mob/living/user, modifiers)
	. = ..()
	if (!isliving(user))
		return

	var/name = user.real_name
	var/datum/record/manifest_data = find_record(name)
	if (isnull(manifest_data))
		balloon_alert(user, "未找到记录！")
		return
	var/job = manifest_data.rank
	if (tgui_alert(user, "宣布 [name] 以 [job] 身份抵达？", "你准备好了吗？", list("Yes", "No"), timeout = 30 SECONDS) != "Yes")
		return
	if (QDELETED(src) || !user.can_perform_action(src, interaction_flags_click))
		return

	announce_arrival(user, job, announce_to_ghosts = FALSE)
	do_sparks(1, FALSE, user)
	new /obj/effect/decal/cleanable/ash(user.drop_location())
	user.temporarilyRemoveItemFromInventory(src)
	qdel(src)
