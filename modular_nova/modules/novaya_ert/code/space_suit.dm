/obj/item/clothing/suit/space/voskhod
	name = "\proper Voskhod-P depowered combat armor"
	desc = "A hybrid set of space-resistant armor built on a modified mass-produced 'Dawn' space suit, polyurea coated durathread-lined light plasteel plates hinder mobility as little as possible while the onboard life support system aids the user in combat. \
	The power cell is what makes the armor work without hassle, a sticker in the power supply unit warns anyone reading to responsibly manage battery levels. <br>\
	These 'paralyzed', marketable variations of the suit come with most of their main features removed: from the infamous wound-tending systems, to the less appreciated death alarms."
	icon = 'modular_nova/modules/novaya_ert/icons/armor.dmi'
	worn_icon = 'modular_nova/modules/novaya_ert/icons/wornarmor.dmi'
	icon_state = "voskhod_suit"
	inhand_icon_state = "s_suit"
	allowed = list(/obj/item/gun, /obj/item/melee/baton, /obj/item/melee/energy/sword/saber, /obj/item/restraints/handcuffs, /obj/item/tank/internals)
	armor_type = /datum/armor/space_syndicate
	supports_variations_flags = NONE //It's already huge enough to look like it can work with digis

/obj/item/clothing/suit/space/voskhod/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/dawn_branding)

//Maybe when Teshari aren't an ass to sprite for...
/obj/item/clothing/suit/space/voskhod/mob_can_equip(mob/living/equipper, slot, disable_warning, bypass_equip_delay_self, ignore_equipped, indirect_action)
	if(isteshari(equipper))
		to_chat(equipper, span_warning(LANG("obj.c9ddda167e55766a", list(src))))
		return FALSE

	return ..()

/obj/item/clothing/head/helmet/space/voskhod
	name = "\proper Voskhod-P depowered combat helmet"
	desc = "A composite graphene-plasteel helmet with a ballistic nylon inner padding, complete with a deployable airtight polycarbonate visor and respirator system. <br>\
	This particular unit's rebreathers have been salvaged off; unable to resynthesize any more breathable air for the user."
	icon = 'modular_nova/modules/novaya_ert/icons/armor.dmi'
	worn_icon = 'modular_nova/modules/novaya_ert/icons/wornarmor.dmi'
	icon_state = "voskhod_helmet"
	inhand_icon_state = "space_helmet"
	armor_type = /datum/armor/space_syndicate
	supports_variations_flags = NONE

/obj/item/clothing/head/helmet/space/voskhod/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/dawn_branding)

//...I'll start asking for unique sprites for them.
/obj/item/clothing/head/helmet/space/voskhod/mob_can_equip(mob/living/equipper, slot, disable_warning, bypass_equip_delay_self, ignore_equipped, indirect_action)
	if(isteshari(equipper))
		to_chat(equipper, span_warning(LANG("obj.c9ddda167e55766a", list(src))))
		return FALSE

	return ..()

/// Component that adds the Dawn lore blurb to an atom's examine_more
/datum/component/dawn_branding

/datum/component/dawn_branding/Initialize()
	. = ..()
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/dawn_branding/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE_MORE, PROC_REF(on_examine_more))

/datum/component/dawn_branding/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_ATOM_EXAMINE_MORE)

/datum/component/dawn_branding/proc/on_examine_more(atom/source, mob/mob, list/examine_list)
	SIGNAL_HANDLER
	examine_list += LANG("datum.39a524e44fc7ad7a", null)
