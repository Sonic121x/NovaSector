// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md

/datum/action/cooldown/spell/pointed/untie_shoes
	name = "Untie Shoes"
	desc = "This unassuming spell unties and then knots the target's shoes."
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
		to_chat(owner, span_notice(LANG("datum.a9634ca4ebedd05c", null)))

	if(spell_level == 3)
		summons_shoes = TRUE
		to_chat(owner, span_notice(LANG("datum.7e6823b3ba1ae544", null)))

	if(spell_level == 4)
		invocation_type = INVOCATION_NONE
		to_chat(owner, span_boldnotice(LANG("datum.197abee82d3cd6ae", null)))

/datum/action/cooldown/spell/pointed/untie_shoes/is_valid_target(atom/cast_on)
	return isliving(cast_on)

// We need to override this, as trying to change next_use_time in cast() will just result in it being overridden.
/datum/action/cooldown/spell/pointed/untie_shoes/before_cast(atom/cast_on)
	return ..() | SPELL_NO_IMMEDIATE_COOLDOWN

/datum/action/cooldown/spell/pointed/untie_shoes/cast(mob/living/carbon/cast_on)
	. = ..()
	if(cast_on.can_block_magic(antimagic_flags))
		to_chat(owner, span_warning(LANG("datum.2ce7047e239a5e7e", null)))
		return FALSE

	if(isanimal_or_basicmob(cast_on))
		cast_on.add_movespeed_modifier(/datum/movespeed_modifier/magic_ties)
		addtimer(CALLBACK(cast_on, TYPE_PROC_REF(/mob/living, remove_movespeed_modifier), /datum/movespeed_modifier/magic_ties), 3 SECONDS * spell_level, TIMER_UNIQUE|TIMER_OVERRIDE)
		to_chat(owner, span_warning(LANG("datum.0c2eac92680edb9b", list(cast_on))))
		if(invocation_type != INVOCATION_NONE) // extra feedback since it's weird for them
			cast_on.balloon_alert_to_viewers(LANG("datum.5deb4c2615cc7f53", null))
		else
			cast_on.balloon_alert(owner, LANG("datum.5deb4c2615cc7f53", null))
		playsound(cast_on, 'sound/effects/magic/summonitems_generic.ogg', 50, TRUE)
		return TRUE

	var/shoe_to_cast = /obj/item/clothing/shoes/sneakers/random

	if(HAS_TRAIT(owner, TRAIT_CHUUNIBYOU))
		shoe_to_cast = /obj/item/clothing/shoes/sneakers/marisa
	if(HAS_TRAIT(owner, TRAIT_SPLATTERCASTER))
		shoe_to_cast = /obj/item/clothing/shoes/laceup

	var/obj/item/clothing/shoes/shoes_to_tie = cast_on.get_item_by_slot(ITEM_SLOT_FEET)

	if(isnull(shoes_to_tie))
		if(!summons_shoes)
			to_chat(owner, span_warning(LANG("datum.8d5a9c0f37499f5b", list(cast_on))))
			return FALSE

		shoes_to_tie = new shoe_to_cast(cast_on)
		if(!cast_on.equip_to_slot_or_del(shoes_to_tie,	ITEM_SLOT_FEET))
			to_chat(owner, span_warning(LANG("datum.6c35f4ea19cb722e", list(cast_on))))
			return FALSE

		if(invocation_type != INVOCATION_NONE)
			playsound(cast_on, 'sound/effects/magic/summonitems_generic.ogg', 50, TRUE)

	switch(shoes_to_tie.tied)
		if(SHOES_TIED)
			if(shoes_to_tie.fastening_type == SHOES_SLIPON)
				if(bypass_tie_status)
					to_chat(owner, span_warning(LANG("datum.793e8ffa3121369c", list(cast_on))))
					cast_on.balloon_alert(owner, LANG("datum.545623cb031b418a", null))
					shoes_to_tie.fastening_type = SHOES_LACED
					if(invocation_type != INVOCATION_NONE)
						playsound(cast_on, 'sound/effects/magic/summonitems_generic.ogg', 50, TRUE)
					return TRUE
				else
					to_chat(owner, span_warning(LANG("datum.634d6b69fca01b98", list(cast_on))))
					cast_on.balloon_alert(owner, LANG("datum.12acca8ed4713d3e", null))
					return FALSE

			to_chat(owner, span_warning(LANG("datum.4377e56fea8b0bf7", list(cast_on))))
			cast_on.balloon_alert(owner, LANG("datum.444446aef1c6296c", null))
			shoes_to_tie.adjust_laces(SHOES_UNTIED, force_lacing = TRUE)
		if(SHOES_UNTIED)
			to_chat(owner, span_warning(LANG("datum.b0d50179de629cfe", list(cast_on))))
			cast_on.balloon_alert(owner, LANG("datum.36456ef3d75c8f76", null))
			shoes_to_tie.adjust_laces(SHOES_KNOTTED, force_lacing = TRUE)
		if(SHOES_KNOTTED)
			to_chat(owner, span_warning(LANG("datum.849c039f5b8739c9", list(cast_on))))
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
