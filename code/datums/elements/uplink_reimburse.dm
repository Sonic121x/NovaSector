/**
 * Uplink Reimburse element.
 * When element is applied onto items, it allows them to be reimbursed if an user pokes an item with a uplink component with them.
 *
 * Element is only compatible with items.
 */

/datum/element/uplink_reimburse
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 1
	/// TC to refund!
	var/refundable_tc = 1

/datum/element/uplink_reimburse/Attach(datum/target, refundable_tc = 1)
	. = ..()

	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE

	src.refundable_tc = refundable_tc

	RegisterSignal(target, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(target, COMSIG_ITEM_ATTEMPT_TC_REIMBURSE, PROC_REF(reimburse))
	RegisterSignal(target,COMSIG_TRAITOR_ITEM_USED(target.type), PROC_REF(used))

/datum/element/uplink_reimburse/Detach(datum/target)
	UnregisterSignal(target, list(COMSIG_ATOM_EXAMINE, COMSIG_TRAITOR_ITEM_USED(target.type), COMSIG_ITEM_ATTEMPT_TC_REIMBURSE))


	return ..()

///signal called on parent being examined
/datum/element/uplink_reimburse/proc/on_examine(datum/target, mob/user, list/examine_list)
	SIGNAL_HANDLER

	if(!IS_TRAITOR(user) && !IS_NUKE_OP(user))
		examine_list += span_warning("侧面贴着一张标签，但上面写的是难以辨认的乱码。你完全不明白它的意思！")
		return

	examine_list += span_notice("侧面有一张用暗语写的标签，说明此物品可通过将其应用于上行链路退还[refundable_tc]点数。")

/datum/element/uplink_reimburse/proc/reimburse(obj/item/refund_item, mob/user, datum/component/uplink/uplink_comp)
	SIGNAL_HANDLER

	if(!uplink_comp)
		CRASH("No uplink component in arguments detected")

	to_chat(user, span_notice("你用[refund_item]轻敲[uplink_comp.parent]，片刻之后[refund_item]在一阵红色烟雾中消失了！"))
	do_sparks(2, source = uplink_comp.parent)
	uplink_comp.uplink_handler.add_telecrystals(refundable_tc)
	SEND_SIGNAL(refund_item, COMSIG_ITEM_TC_REIMBURSED)
	qdel(refund_item)

/// If the item is used, it needs to no longer be refundable
/datum/element/uplink_reimburse/proc/used(datum/target)
	SIGNAL_HANDLER

	Detach(target)
