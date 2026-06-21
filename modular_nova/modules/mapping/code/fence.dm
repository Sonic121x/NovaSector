// Fences and stuff

// Interlink specific fences so people can't cut their way into restricted areas
/obj/structure/fence/interlink
	name = "强化围栏"
	desc = "纳米传讯的最新研发成果：一道强化金属围栏。这能把那些烦人的助手挡在外面！"
	cuttable = FALSE
	invulnerable = TRUE // This only prevents cutting through with wirecutters; everything below handles the rest.
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	move_resist = INFINITY
