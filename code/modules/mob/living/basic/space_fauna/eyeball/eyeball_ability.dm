// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/action/cooldown/spell/pointed/death_glare
	name = "death glare"
	desc = "give a death stare to the victim"
	var/glare_outline = COLOR_DARK_RED
	spell_requirements = NONE
	cooldown_time = 10 SECONDS

/datum/action/cooldown/spell/pointed/death_glare/is_valid_target(atom/cast_on)
	if(!isliving(cast_on))
		to_chat(owner, span_warning(LANG("datum.4c46e9e46d89f007", null)))
		return FALSE
	var/mob/living/living_target = cast_on
	if(living_target.has_movespeed_modifier(/datum/movespeed_modifier/glare_slowdown))
		to_chat(owner, span_warning(LANG("datum.c37e2ffb7afdce22", null)))
		return FALSE
	if(!can_see(living_target, owner, 9))
		to_chat(owner, span_warning(LANG("datum.2f96566382d0d19d", null)))
		return FALSE
	var/direction_to_compare = get_dir(living_target, owner)
	var/target_direction = living_target.dir
	if(direction_to_compare != target_direction)
		to_chat(owner, span_warning(LANG("datum.c1f98e1f7dda2b53", null)))
		return FALSE

	return TRUE

/datum/action/cooldown/spell/pointed/death_glare/cast(mob/living/cast_on)
	. = ..()
	cast_on.add_filter("glare", 2, list("type" = "outline", "color" = glare_outline, "size" = 1))
	cast_on.add_movespeed_modifier(/datum/movespeed_modifier/glare_slowdown)
	to_chat(cast_on, span_warning(LANG("datum.14637e9b959c7feb", null)))
	addtimer(CALLBACK(src, PROC_REF(remove_effect), cast_on), 5 SECONDS)
	return TRUE

/datum/action/cooldown/spell/pointed/death_glare/proc/remove_effect(mob/living/cast_on)
	cast_on.remove_movespeed_modifier(/datum/movespeed_modifier/glare_slowdown)
	cast_on.remove_filter("glare")

/datum/movespeed_modifier/glare_slowdown
	multiplicative_slowdown = 3
