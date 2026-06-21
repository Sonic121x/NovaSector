/obj/item/organ/ears
	name = "耳朵"
	icon_state = "ears"
	desc = "耳朵分为三部分：内耳、中耳和外耳。通常只有其中一部分是可见的。"
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EARS
	gender = PLURAL

	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY

	low_threshold_passed = span_info("你的耳朵开始不时地产生内部共鸣的鸣响。")
	now_failing = span_warning("你完全听不见了！")
	now_fixed = span_info("声音再次缓缓涌入你的耳朵。")
	low_threshold_cleared = span_info("你耳朵里的鸣响已经平息了。")
	visual = FALSE

	/// temporary deafness, measured in seconds. While > 0, the person is unable to hear anything.
	var/temporary_deafness = 0

	// `damage` in this case measures long term damage to the ears, if too high,
	// the person will not have either `deaf` or `ear_damage` decrease
	// without external aid (earmuffs, drugs)

	/// Resistance against loud noises
	var/bang_protect = EAR_PROTECTION_NONE
	/// Multiplier for both long term and short term ear damage
	var/damage_multiplier = 1

/obj/item/organ/ears/on_life(seconds_per_tick)
	// only inform when things got worse, needs to happen before we heal
	if((damage > low_threshold && prev_damage < low_threshold) || (damage > high_threshold && prev_damage < high_threshold))
		to_chat(owner, span_warning("你耳朵里的鸣响声变得更响，暂时盖过了所有外部声音。"))

	. = ..()
	// if we have non-damage related deafness like mutations, quirks or clothing (earmuffs), don't bother processing here.
	// Ear healing from earmuffs or chems happen elsewhere
	if(HAS_TRAIT_NOT_FROM(owner, TRAIT_DEAF, EAR_DAMAGE))
		return
	// no healing if failing
	if(organ_flags & ORGAN_FAILING)
		return
	adjust_temporary_deafness(-seconds_per_tick SECONDS)
	if((damage > low_threshold) && SPT_PROB(damage / 60, seconds_per_tick))
		adjust_temporary_deafness(4 SECONDS)
		SEND_SOUND(owner, sound('sound/items/weapons/flash_ring.ogg'))

/obj/item/organ/ears/on_mob_insert(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()
	if(temporary_deafness)
		on_deafened()
	REMOVE_TRAIT(organ_owner, TRAIT_DEAF, NO_EARS)

/obj/item/organ/ears/on_mob_remove(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()
	if(temporary_deafness)
		on_undeafened(organ_owner)
	// Do not apply with special flag, even if it would ultimately be redundant by new ears being hot-swapped in.
	// This is so we don't trip signal_addtrait when hot-swapping ears, which could cause inappropriate behavior like nuking sound effects.
	if(!special)
		ADD_TRAIT(organ_owner, TRAIT_DEAF, NO_EARS)

/obj/item/organ/ears/get_status_appendix(advanced, add_tooltips)
	if(owner.stat == DEAD || !HAS_TRAIT(owner, TRAIT_DEAF))
		return
	if(advanced)
		if(HAS_TRAIT_FROM(owner, TRAIT_DEAF, QUIRK_TRAIT))
			return conditional_tooltip("Subject is permanently deaf.", "Irreparable under normal circumstances.", add_tooltips)
		if(HAS_TRAIT_FROM(owner, TRAIT_DEAF, GENETIC_MUTATION))
			return conditional_tooltip("Subject is genetically deaf.", "Use medication such as [/datum/reagent/medicine/mutadone::name].", add_tooltips)
		if((organ_flags & ORGAN_FAILING) || HAS_TRAIT_FROM(owner, TRAIT_DEAF, EAR_DAMAGE))
			return conditional_tooltip("Subject is [(organ_flags & ORGAN_FAILING) ? "permanently": "temporarily"] deaf from ear damage.", "Repair surgically, use medication such as [/datum/reagent/medicine/inacusiate::name], or protect ears with earmuffs.", add_tooltips)
	return "Subject is deaf."

/obj/item/organ/ears/show_on_condensed_scans()
	// Always show if we have an appendix
	return ..() || (owner.stat != DEAD && HAS_TRAIT(owner, TRAIT_DEAF))

///Adjust the temporary deafness of the person, up or down
/obj/item/organ/ears/proc/adjust_temporary_deafness(amount)
	// organ failure makes us permanently deafened. Also, doesn't do anything if not in someone or during godmode
	if(amount > 0 && owner && HAS_TRAIT(owner, TRAIT_GODMODE))
		return

	temporary_deafness = max(temporary_deafness + amount * damage_multiplier, 0)

	if(!owner)
		return

	if(temporary_deafness && !HAS_TRAIT_FROM(owner, TRAIT_DEAF, EAR_DAMAGE))
		on_deafened()
	else if(!temporary_deafness && HAS_TRAIT_FROM(owner, TRAIT_DEAF, EAR_DAMAGE))
		on_undeafened()

///Called when temporary deafness begins
/obj/item/organ/ears/proc/on_deafened()
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(adjust_speech))
	ADD_TRAIT(owner, TRAIT_DEAF, EAR_DAMAGE)

///Called when temporary deafness reaches zero. Has to have an 'organ_owner' arg, because by the time it's called on 'on_mob_remove', owner is already null
/obj/item/organ/ears/proc/on_undeafened(mob/living/organ_owner = owner)
	REMOVE_TRAIT(organ_owner, TRAIT_DEAF, EAR_DAMAGE)
	UnregisterSignal(organ_owner, COMSIG_MOB_SAY)

/obj/item/organ/ears/on_begin_failure()
	add_organ_trait(TRAIT_DEAF)

/obj/item/organ/ears/on_failure_recovery()
	remove_organ_trait(TRAIT_DEAF)

/// Being deafened by loud noises makes you shout
/obj/item/organ/ears/proc/adjust_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER

	if(HAS_TRAIT_NOT_FROM(owner, TRAIT_DEAF, EAR_DAMAGE) || HAS_TRAIT(owner, TRAIT_SIGN_LANG))
		return

	var/message = speech_args[SPEECH_MESSAGE]
	// Replace only end-of-sentence punctuation with exclamation marks (hence the empty space)
	// We don't wanna mess with things like ellipses
	message = replacetext(message, ". ", "! ")
	message = replacetext(message, "? ", "?! ")
	// Special case for the last character
	switch(copytext_char(message, -1))
		if(".")
			if(copytext_char(message, -2) != "..") // Once again ignoring ellipses, let people trail off
				message = copytext_char(message, 1, -1) + "!"
		if("?")
			message = copytext_char(message, 1, -1) + "?!"
		if("!")
			pass()
		else
			message += "!"

	speech_args[SPEECH_MESSAGE] = message
	return COMPONENT_UPPERCASE_SPEECH

/obj/item/organ/ears/feel_for_damage(self_aware)
	// Ear damage has audible effects, so we don't really need to "feel" it when self-examining
	return ""

/obj/item/organ/ears/invincible
	damage_multiplier = 0

/obj/item/organ/ears/cat
	name = "猫耳"
	icon = 'icons/obj/clothing/head/costume.dmi'
	worn_icon = 'icons/mob/clothing/head/costume.dmi'
	icon_state = "kitty"
	visual = TRUE
	damage_multiplier = 2

	restyle_flags = EXTERNAL_RESTYLE_FLESH

	//dna_block = /datum/dna_block/feature/accessory/ears // NOVA EDIT REMOVAL - Customization - We have our own system to handle DNA.

	bodypart_overlay = /datum/bodypart_overlay/mutant/cat_ears

/// Bodypart overlay for the horrible cat ears
/datum/bodypart_overlay/mutant/cat_ears
	layers = EXTERNAL_FRONT | EXTERNAL_BEHIND
	color_source = ORGAN_COLOR_HAIR
	feature_key = FEATURE_EARS
	dyable = TRUE

	/// Layer upon which we add the inner ears overlay
	var/inner_layer = EXTERNAL_FRONT

/datum/bodypart_overlay/mutant/cat_ears/can_draw_on_bodypart(obj/item/bodypart/bodypart_owner, mob/living/carbon/owner, is_husked = FALSE)
	return ..() && !(bodypart_owner.owner?.obscured_slots & HIDEHAIR)

/datum/bodypart_overlay/mutant/cat_ears/get_image(image_layer, obj/item/bodypart/limb)
	var/mutable_appearance/base_ears = ..()
	base_ears.color = (dye_color || draw_color)

	// Only add inner ears on the inner layer
	if(image_layer != bitflag_to_layer(inner_layer))
		return base_ears

	// Construct image of inner ears, apply to base ears as an overlay
	feature_key += "inner"
	var/mutable_appearance/inner_ears = ..()
	feature_key = initial(feature_key)
	var/mutable_appearance/ear_holder = mutable_appearance(layer = image_layer)
	ear_holder.overlays += base_ears
	ear_holder.overlays += inner_ears
	return ear_holder

/datum/bodypart_overlay/mutant/cat_ears/color_image(image/overlay, layer, obj/item/bodypart/limb)
	return // We color base ears manually above in get_image

/obj/item/organ/ears/cat/cybernetic
	name = "基础赛博猫耳"
	icon = 'icons/obj/medical/organs/organs.dmi'
	icon_state = "ears-c-cat"
	desc = "一种旨在模拟耳朵运作的基础赛博器官。"
	damage_multiplier = 2.4
	bodypart_overlay = /datum/bodypart_overlay/mutant/cat_ears/cybernetic
	sprite_accessory_override = /datum/sprite_accessory/ears/cat/cybernetic
	organ_flags = ORGAN_ROBOTIC
	failing_desc = "seems to be broken."
	restyle_flags = NONE

/obj/item/organ/ears/cat/cybernetic/upgraded
	name = "赛博猫耳"
	icon_state = "ears-c-cat-u"
	desc = "一只赛博猫耳，仍然不如人耳耐用。"
	damage_multiplier = 1.5

/obj/item/organ/ears/cat/cybernetic/volume
	name = "音量调节赛博猫耳"
	icon_state = "ears-c-cat-u2"
	desc = "能够抑制响亮噪音以保护使用者的高级赛博猫耳。"
	damage_multiplier = 1
	bang_protect = 1

/obj/item/organ/ears/cat/cybernetic/whisper
	name = "耳语敏感赛博猫耳"
	icon_state = "ears-c-cat-green"
	desc = "让使用者能更容易听到耳语。然而，使用者会变得对响亮噪音极其脆弱。"
	damage_multiplier = 3 // 4 would be excessive
	organ_traits = list(TRAIT_GOOD_HEARING)
	bodypart_overlay = /datum/bodypart_overlay/mutant/cat_ears/cybernetic/green

/obj/item/organ/ears/cat/cybernetic/xray
	name = "穿墙赛博猫耳"
	icon_state = "ears-c-cat-blue"
	desc = "借助现代猫科工程的力量，让使用者能够听到墙后的对话。然而，使用者会变得对响亮噪音极其脆弱。"
	damage_multiplier = 3 // As above, 4 would be excessive
	organ_traits = list(TRAIT_XRAY_HEARING)
	bodypart_overlay = /datum/bodypart_overlay/mutant/cat_ears/cybernetic/blue

/datum/bodypart_overlay/mutant/cat_ears/cybernetic
	color_source = null
	dyable = FALSE
	/// Color of the inner ear
	var/inner_color = "#F0004A"

/datum/bodypart_overlay/mutant/cat_ears/cybernetic/get_image(image_layer, obj/item/bodypart/limb)
	if (image_layer != bitflag_to_layer(inner_layer))
		return ..()
	var/mutable_appearance/ear_holder = ..()
	var/mutable_appearance/inner = ear_holder.overlays[2]
	inner.color = inner_color
	return ear_holder

/datum/bodypart_overlay/mutant/cat_ears/cybernetic/get_overlay(layer, obj/item/bodypart/limb)
	if (layer != inner_layer)
		return ..()
	var/list/all_images = ..()
	//var/mutable_appearance/ear_holder = all_images[1] // NOVA EDIT REMOVAL - Our ear overlays are done differently, see /datum/bodypart_overlay/mutant/get_images()
	var/mutable_appearance/inner = all_images[2] // NOVA EDIT CHANGE - ORIGINAL: var/mutable_appearance/inner = ear_holder.overlays[2]
	inner.color = inner_color // NOVA EDIT ADDITION - We do not actually call get_image, instead we call get_singular_image(). This works fine here though.
	all_images += emissive_appearance(inner.icon, inner.icon_state, limb, layer = inner.layer, alpha = inner.alpha * 0.75)
	return all_images

/datum/bodypart_overlay/mutant/cat_ears/cybernetic/green
	inner_color = "#00D844"

/datum/bodypart_overlay/mutant/cat_ears/cybernetic/blue
	inner_color = "#0079EA"

/obj/item/organ/ears/ghost
	name = "幽灵耳朵"
	desc = "更能听见你了……虽然它无法听穿墙壁。"
	icon_state = "ears-ghost"
	movement_type = PHASING
	organ_flags = parent_type::organ_flags | ORGAN_GHOST

/obj/item/organ/ears/penguin
	name = "企鹅耳朵"
	desc = "企鹅快乐脚丫的源头。"

/obj/item/organ/ears/penguin/on_mob_insert(mob/living/carbon/human/ear_owner)
	. = ..()
	to_chat(ear_owner, span_notice("你突然感觉自己失去了平衡。"))
	ear_owner.AddElementTrait(TRAIT_WADDLING, ORGAN_TRAIT, /datum/element/waddling)

/obj/item/organ/ears/penguin/on_mob_remove(mob/living/carbon/human/ear_owner)
	. = ..()
	to_chat(ear_owner, span_notice("你的平衡感回来了。"))
	REMOVE_TRAIT(ear_owner, TRAIT_WADDLING, ORGAN_TRAIT)

/obj/item/organ/ears/cybernetic
	name = "基础赛博格耳朵"
	icon_state = "ears-c"
	desc = "一种旨在模拟耳朵运作的基础赛博格器官。"
	damage_multiplier = 1.2
	organ_flags = ORGAN_ROBOTIC
	failing_desc = "seems to be broken."

/obj/item/organ/ears/cybernetic/upgraded
	name = "赛博格耳朵"
	icon_state = "ears-c-u"
	desc =  "一种性能超越有机耳朵的赛博格耳朵。"
	damage_multiplier = 0.75

/obj/item/organ/ears/cybernetic/whisper
	name = "耳语敏感型赛博格耳朵"
	icon_state = "ears-c-u"
	desc = "让使用者能更容易地听到耳语。然而，使用者也会对巨大噪音格外脆弱。"
	// Same sensitivity as felinid ears
	damage_multiplier = 2
	// The original idea was to use signals to do this not traits. Unfortunately, the star effect used for whispers applies before any relevant signals
	// This seems like the least invasive solution
	organ_traits = list(TRAIT_GOOD_HEARING)

/obj/item/organ/ears/cybernetic/volume
	name = "音量调节型赛博格耳朵"
	icon_state = "ears-c-u"
	desc = "能够抑制巨大噪音以保护使用者的先进赛博格耳朵。"
	bang_protect = EAR_PROTECTION_NORMAL
	damage_multiplier = 0.5

/obj/item/organ/ears/cybernetic/volume
	name = "音量调节型赛博格耳朵"
	icon_state = "ears-c-u"
	desc = "能够抑制巨大噪音以保护使用者的先进赛博格耳朵。"
	bang_protect = 1
	damage_multiplier = 0.5

// "X-ray ears" that let you hear through walls
/obj/item/organ/ears/cybernetic/xray
	name = "穿墙型赛博格耳朵"
	icon_state = "ears-c-u"
	desc = "借助现代工程的力量，允许使用者听到墙壁另一侧的说话声。然而，使用者也会对巨大噪音格外脆弱。"
	// Same sensitivity as felinid ears
	damage_multiplier = 2
	organ_traits = list(TRAIT_XRAY_HEARING)

/obj/item/organ/ears/cybernetic/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	apply_organ_damage(20 / severity)

/obj/item/organ/ears/pod
	name = "荚果耳朵"
	desc = "你见过的最奇怪的沙拉。"
	foodtype_flags = PODPERSON_ORGAN_FOODTYPES
	color = COLOR_LIME
