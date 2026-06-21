/datum/action/cooldown/spell/pointed/death_glare
	name = "死亡凝视"
	desc = "向受害者投去死亡凝视"
	var/glare_outline = COLOR_DARK_RED
	spell_requirements = NONE
	cooldown_time = 10 SECONDS

/datum/action/cooldown/spell/pointed/death_glare/is_valid_target(atom/cast_on)
	if(!isliving(cast_on))
		to_chat(owner, span_warning("只有活物才会受到我们凝视的影响！"))
		return FALSE
	var/mob/living/living_target = cast_on
	if(living_target.has_movespeed_modifier(/datum/movespeed_modifier/glare_slowdown))
		to_chat(owner, span_warning("这个目标已经受到凝视影响了！"))
		return FALSE
	if(!can_see(living_target, owner, 9))
		to_chat(owner, span_warning("这个目标看不见我们的凝视！"))
		return FALSE
	var/direction_to_compare = get_dir(living_target, owner)
	var/target_direction = living_target.dir
	if(direction_to_compare != target_direction)
		to_chat(owner, span_warning("这个目标背对着我们！"))
		return FALSE

	return TRUE

/datum/action/cooldown/spell/pointed/death_glare/cast(mob/living/cast_on)
	. = ..()
	cast_on.add_filter("glare", 2, list("type" = "outline", "color" = glare_outline, "size" = 1))
	cast_on.add_movespeed_modifier(/datum/movespeed_modifier/glare_slowdown)
	to_chat(cast_on, span_warning("你感觉有什么东西在注视着你..."))
	addtimer(CALLBACK(src, PROC_REF(remove_effect), cast_on), 5 SECONDS)
	return TRUE

/datum/action/cooldown/spell/pointed/death_glare/proc/remove_effect(mob/living/cast_on)
	cast_on.remove_movespeed_modifier(/datum/movespeed_modifier/glare_slowdown)
	cast_on.remove_filter("glare")

/datum/movespeed_modifier/glare_slowdown
	multiplicative_slowdown = 3
