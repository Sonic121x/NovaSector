/obj/item/clothing/head/costume/foilhat
	name = "锡纸帽"
	desc = "脑控电波，wifi传染。别担心,因为我戴了这顶帽子所以有了防护。"
	icon_state = "foilhat"
	inhand_icon_state = null
	armor_type = /datum/armor/costume_foilhat
	equip_delay_other = 14 SECONDS
	clothing_flags = ANTI_TINFOIL_MANEUVER
	clothing_traits = list(TRAIT_DONT_HEAR_PRAYERS) //stops you from hearing prayers as well, yes
	var/datum/brain_trauma/mild/phobia/conspiracies/paranoia
	var/warped = FALSE
	interaction_flags_mouse_drop = NEED_HANDS

/datum/armor/costume_foilhat
	laser = -5
	energy = -15

/obj/item/clothing/head/costume/foilhat/Initialize(mapload)
	. = ..()
	if(warped)
		warp_up()
		return

	AddComponent(
		/datum/component/anti_magic, \
		antimagic_flags = MAGIC_RESISTANCE_MIND, \
		inventory_flags = ITEM_SLOT_HEAD, \
		charges = 6, \
		block_magic = CALLBACK(src, PROC_REF(drain_antimagic)), \
		expiration = CALLBACK(src, PROC_REF(warp_up)) \
	)


/obj/item/clothing/head/costume/foilhat/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(!(slot & ITEM_SLOT_HEAD) || warped)
		return
	if(paranoia)
		QDEL_NULL(paranoia)
	paranoia = new()

	RegisterSignal(user, COMSIG_HUMAN_SUICIDE_ACT, PROC_REF(call_suicide))

	user.gain_trauma(paranoia, TRAUMA_RESILIENCE_MAGIC)
	to_chat(user, span_warning("当你戴上这顶锡箔帽时，一个充斥着阴谋论和看似疯狂想法的世界突然涌入你的脑海。你曾经认为不可信的事情突然变得……无可辩驳。万物皆有联系，没有什么是偶然发生的。你知道得太多了，现在他们要来抓你了。"))

/obj/item/clothing/head/costume/foilhat/mouse_drop_dragged(atom/over_object, mob/user)
	//God Im sorry
	if(!warped && iscarbon(user))
		var/mob/living/carbon/C = user
		if(src == C.head)
			to_chat(C, span_userdanger("你为什么要摘掉它？你想让他们侵入你的思想吗？！"))
			return
	return ..()

/obj/item/clothing/head/costume/foilhat/dropped(mob/user)
	. = ..()
	if(paranoia)
		QDEL_NULL(paranoia)
	UnregisterSignal(user, COMSIG_HUMAN_SUICIDE_ACT)

/// When the foilhat is drained an anti-magic charge.
/obj/item/clothing/head/costume/foilhat/proc/drain_antimagic(mob/user)
	to_chat(user, span_warning("[src]微微皱缩。有什么东西正试图侵入你的思想！"))

/obj/item/clothing/head/costume/foilhat/proc/warp_up()
	name = "烧焦的锡纸帽"
	desc = "一顶严重扭曲变形的帽子。它很可能已经无法再抵御任何它曾经防范过的虚构或真实的危险了。"
	warped = TRUE
	clothing_flags &= ~ANTI_TINFOIL_MANEUVER
	if(!isliving(loc) || !paranoia)
		return
	var/mob/living/target = loc
	UnregisterSignal(target, COMSIG_HUMAN_SUICIDE_ACT)
	if(target.get_item_by_slot(ITEM_SLOT_HEAD) != src)
		return
	QDEL_NULL(paranoia)
	if(target.stat < UNCONSCIOUS)
		to_chat(target, span_warning("当你戴着的帽子扭曲成一团糟时，你狂热的阴谋论思想迅速消散。所有那些理论开始听起来不过是一场可笑的喧嚣。"))

/obj/item/clothing/head/costume/foilhat/attack_hand(mob/user, list/modifiers)
	if(!warped && iscarbon(user))
		var/mob/living/carbon/wearer = user
		if(src == wearer.head)
			to_chat(user, span_userdanger("你为什么要摘掉它？你想让他们侵入你的思想吗？！"))
			return
	return ..()

/obj/item/clothing/head/costume/foilhat/microwave_act(obj/machinery/microwave/microwave_source, mob/microwaver, randomize_pixel_offset)
	. = ..()
	if(warped)
		return

	warp_up()
	return . | COMPONENT_MICROWAVE_SUCCESS

/obj/item/clothing/head/costume/foilhat/proc/call_suicide(datum/source)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(suicide_act), source) //SIGNAL_HANDLER doesn't like things waiting; INVOKE_ASYNC bypasses that
	return OXYLOSS

/obj/item/clothing/head/costume/foilhat/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] gets a crazed look in [user.p_their()] eyes! [capitalize(user.p_they())] [user.p_have()] witnessed the truth, and try to commit suicide!"))
	var/static/list/conspiracy_line = list(
		";THEY'RE HIDING CAMERAS IN THE CEILINGS! THEY WITNESS EVERYTHING WE DO!!",
		";HOW CAN I LIVE IN A WORLD WHERE MY FATE AND EXISTENCE IS DECIDED BY A GROUP OF INDIVIDUALS?!!",
		";THEY'RE TOYING WITH ALL OF YOUR MINDS AND TREATING YOU AS EXPERIMENTS!!",
		";THEY HIRE ASSISTANTS WITHOUT DOING BACKGROUND CHECKS!!",
		";WE LIVE IN A ZOO AND WE ARE THE ONES BEING OBSERVED!!",
		";WE REPEAT OUR LIVES DAILY WITHOUT FURTHER QUESTIONS!!"
	)
	user.say(pick(conspiracy_line), forced=type)
	var/obj/item/organ/brain/brain = user.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(brain)
		brain.set_organ_damage(BRAIN_DAMAGE_DEATH)
	return OXYLOSS
