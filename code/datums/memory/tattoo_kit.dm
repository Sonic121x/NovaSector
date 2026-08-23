// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md

/obj/item/tattoo_kit
	name = "tattoo kit"
	desc = "A kit with all the tools necessary for losing a bet, or making otherwise incredibly indelible decisions."
	icon = 'icons/obj/maintenance_loot.dmi'
	icon_state = "tattoo_kit"
	///each use = 1 tattoo
	var/uses = 1
	///how many uses can be stored
	var/max_uses = 5

/obj/item/tattoo_kit/Initialize(mapload)
	. = ..()
	register_context()

/obj/item/tattoo_kit/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()
	if(istype(held_item, /obj/item/toner))
		context[SCREENTIP_CONTEXT_LMB] = "Refill"
		return CONTEXTUAL_SCREENTIP_SET

/obj/item/tattoo_kit/examine(mob/tattoo_artist)
	. = ..()
	if(!uses)
		. += span_warning(LANG("obj.54d80f93aeaa78db", null))
	else
		. += span_notice(LANG("obj.8105762d1924e790", list(uses)))
	. += span_boldnotice(LANG("obj.0b612be2c0c435de", null))

/obj/item/tattoo_kit/item_interaction(mob/living/user, obj/item/toner/ink_cart, list/modifiers)
	if(!istype(ink_cart))
		return NONE
	var/added_amount = round(ink_cart.charges / 5)
	if(added_amount == 0)
		balloon_alert(user, LANG("obj.bae4a0911839f31e", null))
		return ITEM_INTERACT_BLOCKING
	if(uses >= max_uses)
		balloon_alert(user, LANG("obj.e28c7f55e1d974b1", null))
		return ITEM_INTERACT_BLOCKING

	added_amount = min(uses + added_amount, max_uses)
	uses += min(max_uses, added_amount)
	qdel(ink_cart)
	balloon_alert(user, LANG("obj.652b5901a8601a4b", null))
	return ITEM_INTERACT_SUCCESS

/obj/item/tattoo_kit/attack(mob/living/tattoo_holder, mob/living/tattoo_artist, list/modifiers, list/attack_modifiers)
	. = ..()
	if(.)
		return TRUE
	if(!tattoo_artist.mind || tattoo_artist.combat_mode)
		return
	if(!uses)
		balloon_alert(tattoo_artist, LANG("obj.9c04c0ce3dd61ece", null))
		return
	if(!length(tattoo_artist.mind.memories))
		balloon_alert(tattoo_artist, LANG("obj.97a6810681133cce", null))
		return
	var/selected_zone = tattoo_artist.zone_selected
	var/obj/item/bodypart/tattoo_target = tattoo_holder.get_bodypart(selected_zone)
	if(!tattoo_target)
		balloon_alert(tattoo_artist, LANG("obj.69acce453420c808", null))
		return
	if(HAS_TRAIT_FROM(tattoo_target, TRAIT_NOT_ENGRAVABLE, ENGRAVED_TRAIT))
		balloon_alert(tattoo_artist, LANG("obj.02373509203dd18c", null))
		return
	if(HAS_TRAIT(tattoo_target, TRAIT_NOT_ENGRAVABLE))
		balloon_alert(tattoo_artist, LANG("obj.5f6ee97edd8d3e09", null))
		return
	var/datum/memory/memory_to_tattoo = tattoo_artist.mind.select_memory("tattoo")
	if(!memory_to_tattoo || !tattoo_artist.Adjacent(tattoo_holder) || !tattoo_holder.get_bodypart(selected_zone))
		return

	tattoo_artist.visible_message(span_notice(LANG("obj.54ea65723bc7b508", list(tattoo_artist, tattoo_target, tattoo_holder))))
	if(!do_after(tattoo_artist, 5 SECONDS, tattoo_holder))
		return
	if(!tattoo_holder.get_bodypart(selected_zone))
		return
	tattoo_target.AddComponent(/datum/component/tattoo, memory_to_tattoo.generate_story(STORY_TATTOO))
	//prevent this memory from being used again this round
	memory_to_tattoo.memory_flags |= MEMORY_FLAG_ALREADY_USED
