// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/fake_identity_kit
	name = "fake identity kit"
	desc = "All of the paperwork you need to get a fresh start and a perfect alibi, plus a little digital assistance to insert you into crew records."
	icon = 'icons/obj/service/bureaucracy.dmi'
	icon_state = "docs_mulligan"
	w_class = WEIGHT_CLASS_TINY
	interaction_flags_click = NEED_LITERACY|NEED_LIGHT|NEED_DEXTERITY|NEED_HANDS|ALLOW_RESTING
	/// What do we set up our "new arrival" as?
	var/assigned_job = JOB_ASSISTANT

/obj/item/fake_identity_kit/examine_more(mob/user)
	. = ..()
	. += span_info(LANG("obj.d1375bb613a60651", null))
	. += span_info(LANG("obj.cf1c63c70bca2927", null))

/obj/item/fake_identity_kit/attack_self(mob/living/carbon/human/user, modifiers)
	. = ..()
	if (!ishuman(user))
		balloon_alert(user, LANG("obj.421f65c9eca4f8b1", null))
		return
	if (find_record(user.real_name))
		balloon_alert(user, LANG("obj.78bfa2b80dcba0a4", null))
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
		to_chat(user, span_warning(LANG("obj.b7cb726fb76461c9", null)))
	else
		to_chat(user, span_notice(LANG("obj.97b6466553c625c1", list(placed_in))))

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
			to_chat(user, span_warning(LANG("obj.ee1b188f88564790", null)))
		else
			to_chat(user, span_notice(LANG("obj.2ff2ba2a2a7a0341", list(returned_to))))

	var/obj/item/arrival_announcer/announcer = new(user.drop_location())
	user.put_in_hands(announcer)
	to_chat(user, span_notice(LANG("obj.7fd7addd8bfd2619", null)))
	qdel(src)

/obj/item/arrival_announcer
	name = "arrivals announcement signaller"
	desc = "A radio signaller which uses a backdoor in the NT announcement system to trigger a fake announcement that you have just arrived there, then self-destructs."
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
		balloon_alert(user, LANG("obj.fc25e5c833e0f167", null))
		return
	var/job = manifest_data.rank
	if (tgui_alert(user, LANG("obj.32b6fbe25f6913ce", list(name, job)), LANG("obj.cae34731b05d2a6f", null), list("Yes", "No"), timeout = 30 SECONDS) != "Yes")
		return
	if (QDELETED(src) || !user.can_perform_action(src, interaction_flags_click))
		return

	announce_arrival(user, job, announce_to_ghosts = FALSE)
	do_sparks(1, FALSE, user)
	new /obj/effect/decal/cleanable/ash(user.drop_location())
	user.temporarilyRemoveItemFromInventory(src)
	qdel(src)
