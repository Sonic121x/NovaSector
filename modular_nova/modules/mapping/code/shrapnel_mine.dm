/obj/effect/mine/shrapnel/human_only
	name = "精制破片地雷"
	desc = "一种致命的地雷，这一个似乎被改装成只对人类触发？"

/obj/effect/mine/shrapnel/human_only/on_entered(datum/source, atom/movable/AM)
	if(!ishuman(AM))
		return
	. = ..()
