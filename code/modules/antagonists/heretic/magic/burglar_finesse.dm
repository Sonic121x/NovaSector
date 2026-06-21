/datum/action/cooldown/spell/pointed/burglar_finesse
	name = "窃贼的巧手"
	desc = "从受害者的背包中偷取一件随机物品。"
	background_icon_state = "bg_heretic"
	overlay_icon_state = "bg_heretic_border"
	button_icon = 'icons/mob/actions/actions_ecult.dmi'
	button_icon_state = "burglarsfinesse"

	school = SCHOOL_FORBIDDEN
	cooldown_time = 40 SECONDS

	invocation = "Y'O'K!"
	invocation_type = INVOCATION_WHISPER
	spell_requirements = NONE

	cast_range = 6

/datum/action/cooldown/spell/pointed/burglar_finesse/is_valid_target(mob/living/carbon/human/cast_on)
	if(!istype(cast_on))
		return FALSE
	var/obj/item/back_item = cast_on.get_item_by_slot(ITEM_SLOT_BACK)
	return ..() && back_item?.atom_storage

/datum/action/cooldown/spell/pointed/burglar_finesse/cast(mob/living/carbon/human/cast_on)
	. = ..()
	if(cast_on.can_block_magic(antimagic_flags))
		to_chat(cast_on, span_danger("你感到一阵轻微的拉扯，但除此之外并无大碍，你受到了神圣力量的保护！"))
		to_chat(owner, span_danger("[cast_on] 受到了神圣力量的保护！"))
		return FALSE

	var/obj/storage_item = cast_on.get_item_by_slot(ITEM_SLOT_BACK)

	if(isnull(storage_item))
		return FALSE

	var/item = pick(storage_item.atom_storage.return_inv(recursive = FALSE))
	if(isnull(item))
		return FALSE

	to_chat(cast_on, span_warning("你的 [storage_item] 感觉变轻了..."))
	to_chat(owner, span_notice("眨眼间，你从 [cast_on][p_s()] 的 [storage_item] 中抽出了 [item]。"))
	owner.put_in_active_hand(item)
