/datum/action/cooldown/spell/pointed/barnyardcurse
	name = "谷仓之咒"
	desc = "这个咒语会让不幸之人丧失理智，变得像牲畜一样，说话和表情都像牲畜一般。"
	button_icon_state = "barn"
	ranged_mousepointer = 'icons/effects/mouse_pointers/barn_target.dmi'

	school = SCHOOL_TRANSMUTATION
	cooldown_time = 15 SECONDS
	cooldown_reduction_per_rank = 3 SECONDS

	invocation = "KN'A FTAGHU, PUCK 'BTHNK!"
	invocation_type = INVOCATION_SHOUT
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

	active_msg = "You prepare to curse a target..."
	deactive_msg = "You dispel the curse."

/datum/action/cooldown/spell/pointed/barnyardcurse/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(cast_on))
		return FALSE

	var/mob/living/carbon/human/human_target = cast_on
	if(!human_target.wear_mask)
		return TRUE

	return !(human_target.wear_mask.type in GLOB.cursed_animal_masks)

/datum/action/cooldown/spell/pointed/barnyardcurse/cast(mob/living/carbon/human/cast_on)
	. = ..()
	if(cast_on.can_block_magic(antimagic_flags))
		cast_on.visible_message(
			span_danger("[cast_on]的脸突然燃起火焰，火焰瞬间向外爆开，但[cast_on.p_them()]却毫发无伤！"),
			span_danger("你的脸开始燃烧，但火焰被你的反魔法防护弹开了！"),
		)
		to_chat(owner, span_warning("法术没有产生效果！"))
		return FALSE

	var/chosen_type = pick(GLOB.cursed_animal_masks)
	var/obj/item/clothing/mask/animal/cursed_mask = new chosen_type(get_turf(target))

	cast_on.visible_message(
		span_danger("[target]的脸突然燃起火焰，一个农畜的脑袋取代了它的位置！"),
		span_userdanger("你的脸燃烧起来，火焰过后不久，你意识到自己长着一张[cursed_mask.animal_type]的脸！"),
	)

	// Can't drop? Nuke it
	if(!cast_on.dropItemToGround(cast_on.wear_mask))
		qdel(cast_on.wear_mask)

	cast_on.equip_to_slot_if_possible(cursed_mask, ITEM_SLOT_MASK, TRUE, TRUE)
	cast_on.flash_act()
	return TRUE
