
/datum/action/cooldown/spell/pointed/untie_shoes
	name = "解绑鞋带"
	desc = "这个不起眼的法术会解开并重新系上目标的鞋带。"
	ranged_mousepointer = 'icons/effects/mouse_pointers/lace.dmi'
	button_icon_state = "lace"

	school = SCHOOL_CONJURATION
	cooldown_time = 3 SECONDS
	cooldown_reduction_per_rank = 0.2 SECONDS

	spell_max_level = 4
	invocation = "Acetato!"
	invocation_type = INVOCATION_SHOUT
	spell_requirements = NONE
	antimagic_flags = MAGIC_RESISTANCE|MAGIC_RESISTANCE_HOLY

	cast_range = INFINITY
	active_msg = "You prepare to tie your target's shoes!"

	/// Ignores inability to tie laces, such as jackboots, magboots, or sandals.
	var/bypass_tie_status = FALSE
	/// Summons shoes to untie if the target has none.
	var/summons_shoes = FALSE

/datum/action/cooldown/spell/pointed/untie_shoes/New(Target)
	. = ..()
	// tgs first spell with multiple invocations!!!!!!
	invocation = pick("Acetato!", "Agaletto!")

/datum/action/cooldown/spell/pointed/untie_shoes/level_spell(bypass_cap)
	. = ..()
	if(spell_level == 2)
		bypass_tie_status = TRUE
		to_chat(owner, span_notice("你现在可以为无鞋带的鞋子（例如长筒靴）召唤鞋带了。"))

	if(spell_level == 3)
		summons_shoes = TRUE
		to_chat(owner, span_notice("如果目标没有穿鞋，你现在可以为其召唤鞋子。"))

	if(spell_level == 4)
		invocation_type = INVOCATION_NONE
		to_chat(owner, span_boldnotice("你的咒语吟唱现在变得无声了！"))

/datum/action/cooldown/spell/pointed/untie_shoes/is_valid_target(atom/cast_on)
	return isliving(cast_on)

// We need to override this, as trying to change next_use_time in cast() will just result in it being overridden.
/datum/action/cooldown/spell/pointed/untie_shoes/before_cast(atom/cast_on)
	return ..() | SPELL_NO_IMMEDIATE_COOLDOWN

/datum/action/cooldown/spell/pointed/untie_shoes/cast(mob/living/carbon/cast_on)
	. = ..()
	if(cast_on.can_block_magic(antimagic_flags))
		to_chat(owner, span_warning("法术没有效果！"))
		return FALSE

	if(isanimal_or_basicmob(cast_on))
		cast_on.add_movespeed_modifier(/datum/movespeed_modifier/magic_ties)
		addtimer(CALLBACK(cast_on, TYPE_PROC_REF(/mob/living, remove_movespeed_modifier), /datum/movespeed_modifier/magic_ties), 3 SECONDS * spell_level, TIMER_UNIQUE|TIMER_OVERRIDE)
		to_chat(owner, span_warning("你用脆弱的魔法鞋带绑住了[cast_on]！"))
		if(invocation_type != INVOCATION_NONE) // extra feedback since it's weird for them
			cast_on.balloon_alert_to_viewers("magically tied!")
		else
			cast_on.balloon_alert(owner, "魔法系紧！")
		playsound(cast_on, 'sound/effects/magic/summonitems_generic.ogg', 50, TRUE)
		return TRUE

	var/shoe_to_cast = /obj/item/clothing/shoes/sneakers/random

	if(HAS_TRAIT(owner, TRAIT_CHUUNIBYOU))
		shoe_to_cast = /obj/item/clothing/shoes/sneakers/marisa
	if(HAS_TRAIT(owner, TRAIT_SPLATTERCASTER))
		shoe_to_cast = /obj/item/clothing/shoes/laceup

	var/obj/item/clothing/shoes/shoes_to_tie = cast_on.shoes

	if(isnull(shoes_to_tie))
		if(!summons_shoes)
			to_chat(owner, span_warning("[cast_on]没有穿任何鞋子！"))
			return FALSE

		shoes_to_tie = new shoe_to_cast(cast_on)
		if(!cast_on.equip_to_slot_or_del(shoes_to_tie,	ITEM_SLOT_FEET))
			to_chat(owner, span_warning("无法为[cast_on]装备鞋子！"))
			return FALSE

		if(invocation_type != INVOCATION_NONE)
			playsound(cast_on, 'sound/effects/magic/summonitems_generic.ogg', 50, TRUE)

	switch(shoes_to_tie.tied)
		if(SHOES_TIED)
			if(shoes_to_tie.fastening_type == SHOES_SLIPON)
				if(bypass_tie_status)
					to_chat(owner, span_warning("你为[cast_on]的鞋子魔法般地赋予了鞋带！"))
					cast_on.balloon_alert(owner, "系好了！")
					shoes_to_tie.fastening_type = SHOES_LACED
					if(invocation_type != INVOCATION_NONE)
						playsound(cast_on, 'sound/effects/magic/summonitems_generic.ogg', 50, TRUE)
					return TRUE
				else
					to_chat(owner, span_warning("[cast_on]穿着无鞋带的鞋子！"))
					cast_on.balloon_alert(owner, "没有鞋带！")
					return FALSE

			to_chat(owner, span_warning("你解开了[cast_on]的鞋带！"))
			cast_on.balloon_alert(owner, "解开了！")
			shoes_to_tie.adjust_laces(SHOES_UNTIED, force_lacing = TRUE)
		if(SHOES_UNTIED)
			to_chat(owner, span_warning("你把[cast_on]的鞋带系成了死结！"))
			cast_on.balloon_alert(owner, "打结了！")
			shoes_to_tie.adjust_laces(SHOES_KNOTTED, force_lacing = TRUE)
		if(SHOES_KNOTTED)
			to_chat(owner, span_warning("[cast_on]的鞋带已经系成死结了！"))
			return FALSE

// We need to override this, as trying to change next_use_time in cast() will just result in it being overridden.
/datum/action/cooldown/spell/pointed/untie_shoes/after_cast(atom/cast_on)
	. = ..()
	var/extra_time = 0 SECONDS
	if((cast_on.z != owner.z) || get_dist(cast_on, owner) > 7)
		extra_time += cooldown_time * 10 // :)

	StartCooldown(cooldown_time + extra_time)

/datum/action/cooldown/spell/pointed/untie_shoes/get_spell_title()
	switch(spell_level)
		if(2)
			return "Laceless "
		if(3)
			return "Prankster's "
		if(4)
			return "Sneakerly "
		if(5)
			return "Clown's Own "

	return ""
