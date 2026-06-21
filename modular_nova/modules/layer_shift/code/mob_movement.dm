#define MOB_LAYER_SHIFT_INCREMENT 1
/// The amount by which layers are multiplied before being modified.
/// Helps avoiding floating point errors.
#define MOB_LAYER_MULTIPLIER 100
#define MOB_LAYER_SHIFT_MIN 3.95
//#define MOB_LAYER 4   // This is a byond standard define
#define MOB_LAYER_SHIFT_MAX 4.05

/mob/living/verb/shift_layer_up()
	set name = "Shift Layer Upwards"
	set category = "IC"

	if(incapacitated)
		to_chat(src, span_warning("你现在无法这么做！"))
		return FALSE

	if(layer >= MOB_LAYER_SHIFT_MAX)
		to_chat(src, span_warning("你无法再提高你的层级优先级了。"))
		return FALSE

	layer = min(((layer * MOB_LAYER_MULTIPLIER) + MOB_LAYER_SHIFT_INCREMENT) / MOB_LAYER_MULTIPLIER, MOB_LAYER_SHIFT_MAX)
	var/layer_priority = round(layer * MOB_LAYER_MULTIPLIER - MOB_LAYER * MOB_LAYER_MULTIPLIER, MOB_LAYER_SHIFT_INCREMENT) // Just for text feedback
	to_chat(src, span_notice("你的层级优先级现在是 [layer_priority]。"))

	return TRUE


/mob/living/verb/shift_layer_down()
	set name = "Shift Layer Downwards"
	set category = "IC"

	if(incapacitated)
		to_chat(src, span_warning("你现在无法这么做！"))
		return FALSE

	if(layer <= MOB_LAYER_SHIFT_MIN)
		to_chat(src, span_warning("你无法再降低你的层级优先级了。"))
		return FALSE

	layer = max(((layer * MOB_LAYER_MULTIPLIER) - MOB_LAYER_SHIFT_INCREMENT) / MOB_LAYER_MULTIPLIER, MOB_LAYER_SHIFT_MIN)
	var/layer_priority = round(layer * MOB_LAYER_MULTIPLIER - MOB_LAYER * MOB_LAYER_MULTIPLIER, MOB_LAYER_SHIFT_INCREMENT) // Just for text feedback
	to_chat(src, span_notice("你的层级优先级现在是 [layer_priority]。"))

	return TRUE


/datum/emote/living/shift_layer_up
	key = "shiftlayerup"
	key_third_person = "shiftlayerup"
	message = null
	mob_type_blacklist_typecache = list(/mob/living/brain)
	cooldown = 0.25 SECONDS

/datum/emote/living/shift_layer_up/run_emote(mob/user, params, type_override, intentional)
	if(!can_run_emote(user))
		to_chat(user, span_warning("你现在无法改变层级。"))
		return FALSE

	var/mob/living/layer_shifter = user

	return layer_shifter.shift_layer_up()


/datum/emote/living/shift_layer_down
	key = "shiftlayerdown"
	key_third_person = "shiftlayerdown"
	message = null
	mob_type_blacklist_typecache = list(/mob/living/brain)
	cooldown = 0.25 SECONDS

/datum/emote/living/shift_layer_down/run_emote(mob/user, params, type_override, intentional)
	if(!can_run_emote(user))
		to_chat(user, span_warning("你现在无法改变层级。"))
		return FALSE

	var/mob/living/layer_shifter = user

	return layer_shifter.shift_layer_down()

#undef MOB_LAYER_SHIFT_INCREMENT
#undef MOB_LAYER_MULTIPLIER
#undef MOB_LAYER_SHIFT_MIN
#undef MOB_LAYER_SHIFT_MAX
