/obj/item/storage/lockbox/timeclock
	name = "船员装备锁箱"
	desc = "用于存放船员在临时调离岗位期间的受限装备。纳米传讯合同规定，公司配发的警棍、面罩、约束装置及其他装备不得用于娱乐目的。打卡上班后，可解锁锁箱取回受限物品。"
	icon = 'modular_nova/modules/plexagon_selfserve/icons/shame_box.dmi'
	icon_state = "crewbox+l"
	icon_locked = "crewbox+l"
	icon_closed = "crewbox"
	icon_broken = "crewbox+b"
	w_class = WEIGHT_CLASS_NORMAL
	req_access = list(ACCESS_ALL_PERSONAL_LOCKERS)
	/// The ID card associated with the box
	var/datum/weakref/associated_card
	/// A display formatted list of the locked contents
	var/locked_contents = null

/obj/item/storage/lockbox/timeclock/Initialize(mapload, obj/item/card/id/crew_id)
	. = ..()
	if(!istype(crew_id) || QDELETED(crew_id))
		return INITIALIZE_HINT_QDEL
	atom_storage.allow_big_nesting = TRUE
	atom_storage.max_slots = 99
	atom_storage.max_specific_storage = WEIGHT_CLASS_GIGANTIC
	atom_storage.max_total_storage = 99
	associated_card = WEAKREF(crew_id)
	if(crew_id.registered_name)
		name = "[initial(name)] - [crew_id.registered_name]"

/obj/item/storage/lockbox/timeclock/examine(mob/user)
	. = ..()
	if(!isnull(locked_contents))
		. += span_notice("内容标签显示：[locked_contents]。")

/obj/item/storage/lockbox/timeclock/can_unlock(mob/living/user, obj/item/card/id/id_card)
	. = ..()
	if(!.)
		to_chat(user, span_warning("[src] 只能在值班期间，或由人事主管、安保主管或舰长解锁！"))

/// Timeclock boxes can only be opened while the crew member is on duty, or by a command member with the proper access.
/obj/item/storage/lockbox/timeclock/check_access(obj/item/crew_id)
	if(isnull(crew_id))
		return FALSE

	var/obj/item/card/id/access_card
	if(istype(crew_id, /obj/item/modular_computer/pda))
		var/obj/item/modular_computer/pda/crew_pda = crew_id
		access_card = crew_pda.stored_id
	else
		access_card = crew_id

	if(isnull(access_card))
		return FALSE
	if(!istype(access_card))
		return FALSE
	if(check_access_list(access_card.GetAccess()))
		release_contents()
		return TRUE

	var/obj/item/card/id/allowed_card = associated_card?.resolve()
	if(isnull(allowed_card))
		associated_card = null
		return FALSE
	if(access_card != allowed_card)
		return FALSE

	var/datum/id_trim/job/current_trim = access_card.trim
	if(isnull(current_trim))
		return FALSE
	if(istype(current_trim, /datum/id_trim/job/assistant))
		return FALSE

	release_contents()
	return TRUE

/// Timeclock boxes are one time use. When unlocked, release the contents and go away.
/obj/item/storage/lockbox/timeclock/proc/release_contents()
	emptyStorage()
	usr.visible_message(span_notice("[usr] 激活了锁箱机制，释放其内容物后，锁箱便在一阵蓝空烟雾中消失了！"))
	associated_card = null
	qdel(src)

/obj/item/storage/lockbox/timeclock/toggle_locked(mob/living/user)
	return
