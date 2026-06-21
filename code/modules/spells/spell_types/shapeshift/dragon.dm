
/datum/action/cooldown/spell/shapeshift/dragon
	name = "龙形态"
	desc = "化身成一只小灰烬龙。"
	invocation = span_danger("<b>%CASTER</b>发出一声震耳欲聋的咆哮！")
	invocation_self_message = span_danger("你发出一声震耳欲聋的咆哮！")
	invocation_type = INVOCATION_EMOTE
	spell_requirements = NONE

	possible_shapes = list(/mob/living/simple_animal/hostile/megafauna/dragon/lesser)
