// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/teleportation_scroll
	name = "scroll of teleportation"
	desc = "A scroll for moving around."
	icon = 'icons/obj/scrolls.dmi'
	icon_state = "scroll"
	worn_icon_state = "scroll"
	w_class = WEIGHT_CLASS_SMALL
	inhand_icon_state = "paper"
	throw_speed = 3
	throw_range = 7
	resistance_flags = FLAMMABLE
	actions_types = list(/datum/action/cooldown/spell/teleport/area_teleport/wizard/scroll)
	action_slots = ITEM_SLOT_HANDS
	/// Number of uses the scroll gets.
	var/uses = 4

/obj/item/teleportation_scroll/Initialize(mapload)
	. = ..()
	// In the future, this can be generalized into just "magic scrolls that give you a specific spell".
	var/datum/action/cooldown/spell/teleport/area_teleport/wizard/scroll/teleport = locate() in actions
	if(!teleport)
		return
	teleport.name = name
	teleport.button_icon = icon
	teleport.button_icon_state = icon_state
	RegisterSignal(teleport, COMSIG_SPELL_AFTER_CAST, PROC_REF(on_spell_cast))

/// Deplete charges if spell is cast successfully
/obj/item/teleportation_scroll/proc/on_spell_cast(datum/action/cooldown/spell/cast_spell, mob/living/cast_on)
	SIGNAL_HANDLER
	uses--
	if(uses > 0)
		return
	to_chat(cast_on, span_warning(LANG("obj.8d5fb08c0cdef281", list(src))))
	qdel(src)

/obj/item/teleportation_scroll/apprentice
	name = "lesser scroll of teleportation"
	uses = 1

/obj/item/teleportation_scroll/examine(mob/user)
	. = ..()
	if(uses > 0)
		. += LANG("obj.4b3096b554bb3ee7", list(uses))

/obj/item/teleportation_scroll/attack_self(mob/user)
	. = ..()
	if(.)
		return

	if(!uses)
		return
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/human_user = user
	if(human_user.incapacitated || !human_user.is_holding(src))
		return
	var/datum/action/cooldown/spell/teleport/area_teleport/wizard/scroll/teleport = locate() in actions
	if(!teleport)
		to_chat(user, span_warning(LANG("obj.06e0c8d7d623d269", list(src))))
		return
	if(!teleport.Activate(user))
		return
	return TRUE
