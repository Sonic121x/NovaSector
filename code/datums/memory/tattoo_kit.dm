
/obj/item/tattoo_kit
	name = "纹身工具包"
	desc = "一套包含所有必要工具的工具包，用于兑现赌约，或做出其他极其难以磨灭的决定。"
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
		. += span_warning("这个工具包已经没有使用次数了！")
	else
		. += span_notice("这个工具包有足够的墨水，可供使用[uses] use\s 。")
	. += span_boldnotice("你可以使用墨粉盒来补充墨水。")

/obj/item/tattoo_kit/item_interaction(mob/living/user, obj/item/toner/ink_cart, list/modifiers)
	if(!istype(ink_cart))
		return NONE
	var/added_amount = round(ink_cart.charges / 5)
	if(added_amount == 0)
		balloon_alert(user, "没有剩余了！")
		return ITEM_INTERACT_BLOCKING
	if(uses >= max_uses)
		balloon_alert(user, "已经满了！")
		return ITEM_INTERACT_BLOCKING

	added_amount = min(uses + added_amount, max_uses)
	uses += min(max_uses, added_amount)
	qdel(ink_cart)
	balloon_alert(user, "添加了纹身墨水")
	return ITEM_INTERACT_SUCCESS

/obj/item/tattoo_kit/attack(mob/living/tattoo_holder, mob/living/tattoo_artist, list/modifiers, list/attack_modifiers)
	. = ..()
	if(.)
		return TRUE
	if(!tattoo_artist.mind || tattoo_artist.combat_mode)
		return
	if(!uses)
		balloon_alert(tattoo_artist, "墨水不足！")
		return
	if(!length(tattoo_artist.mind.memories))
		balloon_alert(tattoo_artist, "没有值得铭记的东西可刻！")
		return
	var/selected_zone = tattoo_artist.zone_selected
	var/obj/item/bodypart/tattoo_target = tattoo_holder.get_bodypart(selected_zone)
	if(!tattoo_target)
		balloon_alert(tattoo_artist, "没有肢体可纹身！")
		return
	if(HAS_TRAIT_FROM(tattoo_target, TRAIT_NOT_ENGRAVABLE, ENGRAVED_TRAIT))
		balloon_alert(tattoo_artist, "身体部位已有纹身！")
		return
	if(HAS_TRAIT(tattoo_target, TRAIT_NOT_ENGRAVABLE))
		balloon_alert(tattoo_artist, "身体部位无法纹身！")
		return
	var/datum/memory/memory_to_tattoo = tattoo_artist.mind.select_memory("tattoo")
	if(!memory_to_tattoo || !tattoo_artist.Adjacent(tattoo_holder) || !tattoo_holder.get_bodypart(selected_zone))
		return

	tattoo_artist.visible_message(span_notice("[tattoo_artist]开始在[tattoo_holder]的[tattoo_target]上纹身..."))
	if(!do_after(tattoo_artist, 5 SECONDS, tattoo_holder))
		return
	if(!tattoo_holder.get_bodypart(selected_zone))
		return
	tattoo_target.AddComponent(/datum/component/tattoo, memory_to_tattoo.generate_story(STORY_TATTOO))
	//prevent this memory from being used again this round
	memory_to_tattoo.memory_flags |= MEMORY_FLAG_ALREADY_USED
