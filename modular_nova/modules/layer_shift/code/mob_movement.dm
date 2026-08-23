#define MOB_LAYER_SHIFT_INCREMENT 1
/// The amount by which layers are multiplied before being modified.
/// Helps avoiding floating point errors.
#define MOB_LAYER_MULTIPLIER 100
#define MOB_LAYER_SHIFT_MIN 3.95
//#define MOB_LAYER 4   // This is a byond standard define
#define MOB_LAYER_SHIFT_MAX 4.05

GAME_VERB(/mob/living, shift_layer_up, "上移图层", "IC")
	if(incapacitated)
		to_chat(src, span_warning(LANG("mob.93b3c96537cf2a59", null)))
		return FALSE

	if(layer >= MOB_LAYER_SHIFT_MAX)
		to_chat(src, span_warning(LANG("mob.e8f75d26e792393c", null)))
		return FALSE

	layer = min(((layer * MOB_LAYER_MULTIPLIER) + MOB_LAYER_SHIFT_INCREMENT) / MOB_LAYER_MULTIPLIER, MOB_LAYER_SHIFT_MAX)
	var/layer_priority = round(layer * MOB_LAYER_MULTIPLIER - MOB_LAYER * MOB_LAYER_MULTIPLIER, MOB_LAYER_SHIFT_INCREMENT) // Just for text feedback
	to_chat(src, span_notice(LANG("mob.f26cc19984d5e862", list(layer_priority))))

	return TRUE


GAME_VERB(/mob/living, shift_layer_down, "下移图层", "IC")
	if(incapacitated)
		to_chat(src, span_warning(LANG("mob.93b3c96537cf2a59", null)))
		return FALSE

	if(layer <= MOB_LAYER_SHIFT_MIN)
		to_chat(src, span_warning(LANG("mob.389ab76b0081a252", null)))
		return FALSE

	layer = max(((layer * MOB_LAYER_MULTIPLIER) - MOB_LAYER_SHIFT_INCREMENT) / MOB_LAYER_MULTIPLIER, MOB_LAYER_SHIFT_MIN)
	var/layer_priority = round(layer * MOB_LAYER_MULTIPLIER - MOB_LAYER * MOB_LAYER_MULTIPLIER, MOB_LAYER_SHIFT_INCREMENT) // Just for text feedback
	to_chat(src, span_notice(LANG("mob.f26cc19984d5e862", list(layer_priority))))

	return TRUE


/datum/emote/living/shift_layer_up
	key = "shiftlayerup"
	key_third_person = "shiftlayerup"
	message = null
	mob_type_blacklist_typecache = list(/mob/living/brain)
	cooldown = 0.25 SECONDS

/datum/emote/living/shift_layer_up/run_emote(mob/user, params, type_override, intentional)
	if(!can_run_emote(user))
		to_chat(user, span_warning(LANG("datum.cad91a794a648209", null)))
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
		to_chat(user, span_warning(LANG("datum.cad91a794a648209", null)))
		return FALSE

	var/mob/living/layer_shifter = user

	return layer_shifter.shift_layer_down()

#undef MOB_LAYER_SHIFT_INCREMENT
#undef MOB_LAYER_MULTIPLIER
#undef MOB_LAYER_SHIFT_MIN
#undef MOB_LAYER_SHIFT_MAX
