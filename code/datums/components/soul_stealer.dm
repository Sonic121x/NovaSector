/**
 * ### Soul Stealer component!
 *
 * Component that attaches to items, making lethal swings with them steal the victims soul, storing it inside the item.
 * Used in the cult bastard sword!
 */
/datum/component/soul_stealer
	var/obj/item/soulstone/soulstone_type
	/// List of soulstones captured by this item.
	var/list/obj/item/soulstone/soulstones = list()

/datum/component/soul_stealer/Initialize(soulstone_type = /obj/item/soulstone/anybody/purified)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	src.soulstone_type = soulstone_type

/datum/component/soul_stealer/Destroy()
	QDEL_LIST(soulstones) // We own these, so we'll also just get rid of them. Any souls inside will die, this is fine.
	return ..()

/datum/component/soul_stealer/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_ITEM_AFTERATTACK, PROC_REF(on_afterattack))
	RegisterSignal(parent, COMSIG_ITEM_INTERACTING_WITH_ATOM, PROC_REF(try_transfer_soul))

/datum/component/soul_stealer/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ATOM_EXAMINE, COMSIG_ITEM_AFTERATTACK, COMSIG_ITEM_INTERACTING_WITH_ATOM))

///signal called on parent being examined
/datum/component/soul_stealer/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	examine_list += span_notice("它将在战斗中窃取任何被其击败者的灵魂。")

	var/num_souls = length(soulstones)
	switch(num_souls)
		if(0)
			examine_list += span_notice("它尚未吞噬任何灵魂。")
		if(1 to 9)
			examine_list += span_notice("其中有<b>[num_souls]</b>个灵魂被困其中。")
		if(10 to INFINITY)
			examine_list += span_notice("它已夺取了惊人的<b>[num_souls]</b>个灵魂！并且它渴望更多！")

/datum/component/soul_stealer/proc/on_afterattack(obj/item/source, atom/target, mob/living/user, list/modifiers)
	SIGNAL_HANDLER

	if(ishuman(target))
		INVOKE_ASYNC(src, PROC_REF(try_capture), target, user)

/datum/component/soul_stealer/proc/try_transfer_soul(obj/item/source, mob/user, atom/target, list/modifiers)
	SIGNAL_HANDLER

	if(istype(target, /obj/structure/constructshell) && length(soulstones))
		var/obj/item/soulstone/soulstone = soulstones[1]
		INVOKE_ASYNC(soulstone, TYPE_PROC_REF(/obj/item/soulstone, transfer_to_construct), target, user)
		if(QDELETED(soulstone)) // successful transfer (transfer deletes us)
			soulstones -= soulstone
		else if(!length(soulstone.contents)) // something fucky happened
			qdel(soulstone)
			soulstones -= soulstone
		return ITEM_INTERACT_SUCCESS

/datum/component/soul_stealer/proc/try_capture(mob/living/carbon/human/victim, mob/living/captor)
	if(victim.stat == CONSCIOUS)
		return
	var/obj/item/soulstone/soulstone = new soulstone_type(parent)
	soulstone.attack(victim, captor)
	if(!length(soulstone.contents)) // failed
		qdel(soulstone)
		return
	soulstones += soulstone
