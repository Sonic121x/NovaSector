/datum/action/cooldown/spell/conjure/link_worlds
	name = "链接世界"
	desc = "这将为你开辟一个全新的游戏空间！不过他们肯定会不高兴的。"
	sound = 'sound/items/weapons/marauder.ogg'
	button_icon = 'icons/mob/simple/lavaland/nest.dmi'
	button_icon_state = "nether"
	cooldown_time = 1 MINUTES
	cooldown_reduction_per_rank = 10 SECONDS
	invocation = "FL'NT N' ST'L!"
	invocation_type = INVOCATION_SHOUT
	spell_requirements = NONE
	summon_radius = 1
	summon_type = list(/obj/structure/spawner/nether)
	summon_amount = 1
