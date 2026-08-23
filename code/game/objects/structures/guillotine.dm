// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/// The guillotine is not being interacted with at the moment
#define GUILLOTINE_ACTION_IDLE 0
/// The blade is ready to be dropped
#define GUILLOTINE_BLADE_RAISED 1
/// The blade is moving
#define GUILLOTINE_BLADE_MOVING 2
/// The blade has landed in the stocks
#define GUILLOTINE_BLADE_DROPPED 3
/// The blade is being sharpened
#define GUILLOTINE_BLADE_SHARPENING 4
/// The guillotine blade is being interacted with by the executor
#define GUILLOTINE_ACTION_INUSE 5
/// The guillotine is being unfastened
#define GUILLOTINE_ACTION_WRENCH 6

/// This is maxiumum sharpness and will decapitate without failure
#define GUILLOTINE_BLADE_MAX_SHARP 10
/// Minimum amount of sharpness for decapitation. Any less and it will just do severe brute damage
#define GUILLOTINE_DECAP_MIN_SHARP 7
/// How long the guillotine animation lasts
#define GUILLOTINE_ANIMATION_LENGTH (0.9 SECONDS)
/// How much we need to move the player to center their head
#define GUILLOTINE_HEAD_OFFSET 16
/// How much to increase/decrease a head when it's buckled/unbuckled
#define GUILLOTINE_LAYER_DIFF 1.2
/// Delay for executing someone
#define GUILLOTINE_ACTIVATE_DELAY (3 SECONDS)
/// Delay for wrenching the guillotine
#define GUILLOTINE_WRENCH_DELAY (1 SECONDS)

/obj/structure/guillotine
	name = "guillotine"
	desc = "A large structure used to remove the heads of traitors and treasonists."
	icon = 'icons/obj/guillotine.dmi'
	icon_state = "guillotine_raised"
	icon_preview = 'icons/obj/fluff/previews.dmi'
	icon_state_preview = "guilliotine"
	can_buckle = TRUE
	anchored = TRUE
	density = TRUE
	max_buckled_mobs = 1
	buckle_lying = 0
	buckle_prevents_pull = TRUE
	layer = ABOVE_MOB_LAYER
	custom_materials = list(
		/datum/material/wood = SHEET_MATERIAL_AMOUNT * 20,
		/datum/material/alloy/plasteel = SHEET_MATERIAL_AMOUNT * 3,
		/datum/material/iron = SMALL_MATERIAL_AMOUNT,
		/datum/material/glass = SMALL_MATERIAL_AMOUNT,
	)
	/// The sound the guillotine makes when it successfully cuts off a head
	var/drop_sound = 'sound/items/weapons/guillotine.ogg'
	/// The current state of the blade
	var/blade_status = GUILLOTINE_BLADE_RAISED
	/// How sharp the blade is
	var/blade_sharpness = GUILLOTINE_BLADE_MAX_SHARP
	/// The number of mobs the blade has killed
	var/kill_count = 0
	/// What's currently happening to the guillotine
	var/current_action = GUILLOTINE_ACTION_IDLE

/obj/structure/guillotine/Initialize(mapload)
	LAZYINITLIST(buckled_mobs)
	. = ..()

/obj/structure/guillotine/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/stack/sheet/plasteel))
		if(blade_sharpness == GUILLOTINE_BLADE_MAX_SHARP)
			to_chat(user, span_warning(LANG("obj.2377e11d143a3f50", null)))
			return ITEM_INTERACT_BLOCKING

		to_chat(user, span_notice(LANG("obj.95b45dae2f9339d4", null)))
		if(!do_after(user, 100, target = user))
			to_chat(user, span_notice(LANG("obj.e0cd1a123f3384b6", null)))
			return ITEM_INTERACT_BLOCKING

		blade_sharpness = min(GUILLOTINE_BLADE_MAX_SHARP, blade_sharpness+3)
		tool.use(1)
		to_chat(user, span_notice(LANG("obj.de1243292a71f509", null)))
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/sharpener))
		add_fingerprint(user)
		if (blade_status == GUILLOTINE_BLADE_SHARPENING)
			return ITEM_INTERACT_BLOCKING

		if (blade_status != GUILLOTINE_BLADE_RAISED)
			to_chat(user, span_warning(LANG("obj.9da8679320416b0b", null)))
			return ITEM_INTERACT_BLOCKING

		if (blade_sharpness == GUILLOTINE_BLADE_MAX_SHARP)
			to_chat(user, span_warning(LANG("obj.8c80f756b0a04124", null)))
			return ITEM_INTERACT_BLOCKING

		blade_status = GUILLOTINE_BLADE_SHARPENING
		if(!do_after(user, 0.7 SECONDS, target = src))
			blade_status = GUILLOTINE_BLADE_RAISED
			return ITEM_INTERACT_BLOCKING

		blade_status = GUILLOTINE_BLADE_RAISED
		user.visible_message(span_notice(LANG("obj.eacedcc346cd6738", list(user))),
			                 span_notice(LANG("obj.0ec15affebe75578", null)))
		blade_sharpness += 1
		playsound(src, 'sound/items/unsheath.ogg', 100, TRUE)
		return ITEM_INTERACT_SUCCESS

	return NONE

/obj/structure/guillotine/examine(mob/user)
	. = ..()

	var/msg = "It is [anchored ? "wrenched to the floor." : "unsecured. A wrench should fix that."]"

	if (blade_status == GUILLOTINE_BLADE_RAISED)
		msg += LANG("obj.2c4b2fc868b1409e", null)

		if (blade_sharpness >= GUILLOTINE_DECAP_MIN_SHARP)
			msg += LANG("obj.bab59b14ba72a6f2", null)
		else
			msg += LANG("obj.17dec7f290a1db61", null)
	else
		msg += LANG("obj.44ea87e68aad5868", null)

	. += span_notice(msg)

	if (LAZYLEN(buckled_mobs))
		. += span_notice(LANG("obj.507c5d19a8a39651", null))

/obj/structure/guillotine/attack_hand(mob/living/user, list/modifiers)
	add_fingerprint(user)

	// Currently being used by something
	if (current_action)
		return

	switch (blade_status)
		if (GUILLOTINE_BLADE_MOVING)
			return
		if (GUILLOTINE_BLADE_DROPPED)
			blade_status = GUILLOTINE_BLADE_MOVING
			icon_state = "guillotine_raise"
			addtimer(CALLBACK(src, PROC_REF(raise_blade)), GUILLOTINE_ANIMATION_LENGTH)
			return
		if (GUILLOTINE_BLADE_RAISED)
			if (LAZYLEN(buckled_mobs))
				if (user.combat_mode)
					user.visible_message(span_warning(LANG("obj.664b05477b302266", list(user))),
						                 span_warning(LANG("obj.c9a0b27a826ab091", null)))
					current_action = GUILLOTINE_ACTION_INUSE

					if (do_after(user, GUILLOTINE_ACTIVATE_DELAY, target = src) && blade_status == GUILLOTINE_BLADE_RAISED)
						current_action = GUILLOTINE_ACTION_IDLE
						blade_status = GUILLOTINE_BLADE_MOVING
						icon_state = "guillotine_drop"
						addtimer(CALLBACK(src, PROC_REF(drop_blade), user), GUILLOTINE_ANIMATION_LENGTH - 2) // Minus two so we play the sound and decap faster
					else
						current_action = GUILLOTINE_ACTION_IDLE
				else
					var/mob/living/carbon/human/victim = buckled_mobs[1]

					if (victim)
						victim.regenerate_icons()

					unbuckle_all_mobs()
			else
				blade_status = GUILLOTINE_BLADE_MOVING
				icon_state = "guillotine_drop"
				addtimer(CALLBACK(src, PROC_REF(drop_blade), user), GUILLOTINE_ANIMATION_LENGTH)

/// Sets the guillotine blade in a raised position
/obj/structure/guillotine/proc/raise_blade()
	blade_status = GUILLOTINE_BLADE_RAISED
	icon_state = "guillotine_raised"

/// Drops the guillotine blade, potentially beheading or harming the buckled mob
/obj/structure/guillotine/proc/drop_blade(mob/user)
	if (has_buckled_mobs() && blade_sharpness)
		var/mob/living/carbon/human/victim = buckled_mobs[1]

		if (!victim)
			return

		var/obj/item/bodypart/head/head = victim.get_bodypart("head")

		playsound(src, drop_sound, 100, TRUE)
		if(head)
			if (blade_sharpness >= GUILLOTINE_DECAP_MIN_SHARP || head.brute_dam >= 100)
				head.dismember()
				log_combat(user, victim, "beheaded", src)
				victim.regenerate_icons()
				unbuckle_all_mobs()
				kill_count += 1

				var/blood_overlay = "bloody"

				if (kill_count == 2)
					blood_overlay = "bloodier"
				else if (kill_count > 2)
					blood_overlay = "bloodiest"

				blood_overlay = "guillotine_" + blood_overlay + "_overlay"
				cut_overlays()
				add_overlay(mutable_appearance(icon, blood_overlay))

				// The crowd is pleased
				// The delay is to make large crowds have a longer lasting applause
				var/delay_offset = 0
				for(var/mob/living/carbon/human/spectator in viewers(7, src))
					addtimer(CALLBACK(spectator, TYPE_PROC_REF(/mob/, emote), "clap"), delay_offset * 0.3)
					delay_offset++
			else
				victim.apply_damage(15 * blade_sharpness, BRUTE, head, attacking_item = src)
				log_combat(user, victim, "dropped the blade on", src, " non-fatally")
				victim.emote("scream")

			if (blade_sharpness > 1)
				blade_sharpness -= 1

	blade_status = GUILLOTINE_BLADE_DROPPED
	icon_state = "guillotine"

/obj/structure/guillotine/user_buckle_mob(mob/living/M, mob/user, check_loc = TRUE)
	if (!anchored)
		to_chat(usr, span_warning(LANG("obj.acb3909a82cc6dff", list(src))))
		return FALSE

	if (!ishuman(M))
		to_chat(usr, span_warning(LANG("obj.5b6969efadfae913", list(M.p_they()))))
		return FALSE // Can't decapitate non-humans

	if (blade_status != GUILLOTINE_BLADE_RAISED)
		to_chat(usr, span_warning(LANG("obj.6649cb11e5b5c08f", null)))
		return FALSE

	return ..(M, user, check_loc = FALSE) //check_loc = FALSE to allow moving people in from adjacent turfs

/obj/structure/guillotine/post_buckle_mob(mob/living/M)
	if (!ishuman(M))
		return

	M.add_mood_event("dying", /datum/mood_event/deaths_door)
	var/mob/living/carbon/human/victim = M

	if (victim.dna)
		if (victim.dna.species)
			var/datum/species/S = victim.dna.species

			if (istype(S))
				victim.render_only_head()
				victim.remove_overlay(BODY_ADJ_LAYER)
				victim.pixel_y += -GUILLOTINE_HEAD_OFFSET // Offset their body so it looks like they're in the guillotine
				victim.layer += GUILLOTINE_LAYER_DIFF
			else
				unbuckle_all_mobs()
		else
			unbuckle_all_mobs()
	else
		unbuckle_all_mobs()

	..()

/obj/structure/guillotine/post_unbuckle_mob(mob/living/M)
	M.regenerate_icons()
	M.pixel_y -= -GUILLOTINE_HEAD_OFFSET // Move their body back
	M.layer -= GUILLOTINE_LAYER_DIFF
	M.clear_mood_event("dying")
	..()

/obj/structure/guillotine/can_be_unfasten_wrench(mob/user, silent)
	if (LAZYLEN(buckled_mobs))
		if (!silent)
			to_chat(user, span_warning(LANG("obj.cea3a5ec05fb4a98", null)))
		return FAILED_UNFASTEN

	if (current_action && current_action != GUILLOTINE_ACTION_WRENCH)
		return FAILED_UNFASTEN

	current_action = GUILLOTINE_ACTION_WRENCH
	return ..()

/obj/structure/guillotine/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	if(default_unfasten_wrench(user, tool, time = GUILLOTINE_WRENCH_DELAY))
		setDir(SOUTH)
		current_action = GUILLOTINE_ACTION_IDLE
		return ITEM_INTERACT_SUCCESS
	current_action = GUILLOTINE_ACTION_IDLE
	return FALSE

#undef GUILLOTINE_BLADE_MAX_SHARP
#undef GUILLOTINE_DECAP_MIN_SHARP
#undef GUILLOTINE_ANIMATION_LENGTH
#undef GUILLOTINE_HEAD_OFFSET
#undef GUILLOTINE_LAYER_DIFF
#undef GUILLOTINE_ACTIVATE_DELAY
#undef GUILLOTINE_WRENCH_DELAY

#undef GUILLOTINE_ACTION_IDLE
#undef GUILLOTINE_BLADE_RAISED
#undef GUILLOTINE_BLADE_MOVING
#undef GUILLOTINE_BLADE_DROPPED
#undef GUILLOTINE_BLADE_SHARPENING
#undef GUILLOTINE_ACTION_INUSE
#undef GUILLOTINE_ACTION_WRENCH
