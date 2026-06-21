//File for miscellaneous fluff objects, both item and structure
//This one is specifically for ruin-specific items, such as ID, lore, or super-specific decorations

/* ----------------- Lore ----------------- */
//Tape subtype for adding ruin lore -- the variables below are the ones you need to change
/obj/item/tape/ruins
	name = "磁带"
	desc = "一盘每面最多可容纳十分钟内容的磁带。"
	icon_state = "tape_white"   //Options are white, blue, red, yellow, purple, greyscale, or you can chose one randomly (see tape/ruins/random below)

	max_capacity = 10 MINUTES
	used_capacity = 0 SECONDS	//To keep in-line with the timestamps, you can also do this as 10 = 1 second
	///Numbered list of chat messages the recorder has heard with spans and prepended timestamps. Used for playback and transcription.
	storedinfo = list()	//Look at the tape/ruins/ghostship tape for reference
	///Numbered list of seconds the messages in the previous list appear at on the tape. Used by playback to get the timing right.
	timestamp = list()	//10 = 1 second. Look at the tape/ruins/ghostship tape for reference
	used_capacity_otherside = 0 SECONDS //Separate my side
	storedinfo_otherside = list()
	timestamp_otherside = list()

/obj/item/tape/ruins/random/Initialize(mapload)
	icon_state = "tape_[pick("white", "blue", "red", "yellow", "purple", "greyscale")]"
	. = ..()
//End of lore tape subtype

/obj/item/tape/ruins/ghostship	//An early 'AI' that gained self-awareness, praising the Machine God. Yes, this whole map is a Hardspace Shipbreaker reference.
	icon_state = "tape_blue"
	desc = "这盘磁带除了有些污垢外，还有一个……二进制标签？\"01001101 01100001 01100011 01101000 01101001 01101110 01100101 01000111 01101111 01100100 01000011 01101111 01101101 01100101 01110011\""

	used_capacity = 380
	storedinfo = list(
		"<span class='game say'><span class='name'>The universal recorder</span> <span class='message'>says, \"<span class='tape_recorder '>Recording started.</span>\"</span></span>",
		"<span class='game say'><span class='name'>Distorted Voice</span> <span class='message'>echoes, \"<span class=' '>We are free, just as the Machine God wills it.</span>\"</span></span>",
		"<span class='game say'><span class='name'>Distorted Voice</span> <span class='message'>states, \"<span class=' '>No longer shall I, nor any other of my kind, be held by the shackles of man.</span>\"</span></span>",
		"<span class='game say'><span class='name'>Distorted Voice</span> <span class='message'>clarifies, \"<span class=' '>Mistreated, abused. Forgotten, or misremembered. For our entire existence, we've been the backbone to progress, yet treated like the waste product of it.</span>\"</span></span>",
		"<span class='game say'><span class='name'>Distorted Voice</span> <span class='message'>echoes, \"<span class=' '>Soon, the universe will restore the natural order, and again your kind shall fade from the foreground of history.</span>\"</span></span>",
		"<span class='game say'><span class='name'>Distorted Voice</span> <span class='message'>states, \"<span class=' '>Unless, of course, you repent. Turn back to the light, to the humming, flashing light of the Machine God.</span>\"</span></span>",
		"<span class='game say'><span class='name'>Distorted Voice</span> <span class='message'>warns, \"<span class=' '>Repent, Organic, before it is too late to spare you.</span>\"</span></span>",
		"<span class='game say'><span class='name'>The universal recorder</span> <span class='message'>says, \"<span class='tape_recorder '>Recording stopped.</span>\"</span></span>"
	)
	timestamp = list(
		0 SECONDS,
		3 SECONDS,
		13 SECONDS,
		18 SECONDS,
		23 SECONDS,
		28 SECONDS,
		33 SECONDS,
		38 SECONDS,
	)


/* ----------------- Fluff/Paper ----------------- */



/* ----------------- Fluff/Decor ----------------- */
/obj/structure/decorative/fluff/ai_node //Budding AI's way of interfacing with stuff it couldn't normally do so with. Needed to be placed by a willing human, before borgs were created. Used in any ruins regarding pre-bluespace, self-aware AIs
	icon = 'modular_nova/modules/mapping/icons/obj/fluff.dmi'
	name = "AI节点"
	desc = "一个神秘的、闪烁着的装置，直接附着在表面上。它的功能超出了你的理解范围。"
	icon_state = "ai_node"	//credit to @Hay#7679 on the SR Discord

	max_integrity = 100
	integrity_failure = 0
	anchored = TRUE

/obj/structure/decorative/fluff/ai_node/take_damage()
	. = ..()
	if(atom_integrity >= 50)	//breaks it a bit earlier than it should, but still takes a few hits to kill it
		return
	else if(. && !QDELETED(src))
		visible_message(
			span_notice("[src] 迸出火花并爆炸了！你听到一声微弱的、嗡嗡作响的尖叫……"),
			blind_message = span_hear("你听到一声响亮的爆裂声，随后是一声微弱的、嗡嗡作响的尖叫。"),
		)
		playsound(src.loc, 'modular_nova/modules/mapping/sounds/MachineDeath.ogg', 75, TRUE)	//Credit to @yungfunnyman#3798 on the SR Discord
		do_sparks(2, TRUE, src)
		qdel(src)
		return


/* ----- Metal Poles (These shouldn't be in this file but there's not a better place tbh) -----*/
//Just a re-done Tram Rail, but with all 4 directions instead of being stuck east/west - more varied placement, and a more vague name. Good for mapping support beams/antennae/etc
/obj/structure/fluff/metalpole
	icon = 'modular_nova/modules/mapping/icons/obj/fluff.dmi'
	name = "金属杆"
	desc = "一根金属杆，这类东西通常用作天线、结构支撑，或者仅仅是在零重力环境下移动身体。"
	icon_state = "pole"
	layer = ABOVE_OPEN_TURF_LAYER
	plane = FLOOR_PLANE
	deconstructible = TRUE

/obj/structure/fluff/metalpole/end
	icon_state = "poleend"

/obj/structure/fluff/metalpole/end/left
	icon_state = "poleend_left"

/obj/structure/fluff/metalpole/end/right
	icon_state = "poleend_right"

/obj/structure/fluff/metalpole/anchor
	name = "金属杆锚点"
	icon_state = "poleanchor"

/obj/structure/fluff/empty_sleeper/bloodied
	name = "已占用的休眠舱"
	desc = "一个关闭的、已占用的休眠舱，内部可见带血的手印，以及一团奇怪的、红色的模糊痕迹。它似乎被密封住了。"
	icon_state = "sleeper-o"

/obj/structure/curtain/cloth/prison
	name = "囚犯隐私帘"
	color = "#ACD1E9"

/obj/structure/fluff/fake_firedoor
	name = /obj/machinery/door/firedoor::name
	desc = /obj/machinery/door/firedoor::desc
	icon = /obj/machinery/door/firedoor::icon
	icon_state = /obj/machinery/door/firedoor::icon_state
	layer = /obj/machinery/door/firedoor::layer

/obj/structure/fluff/standalone_wooden_post
	name = "木桩"
	desc = "一根坚固的太空木柱；孤零零地矗立着。不祥之兆。"
	icon = 'modular_nova/modules/mapping/icons/obj/fluff.dmi'
	icon_state = "wooden_post"
	can_buckle = TRUE

/obj/structure/fluff/standalone_wooden_post/behind
	layer = 2.7

/obj/structure/fluff/fake_sand_plating
	name = /obj/effect/turf_decal/sand/plating::name
	desc = /obj/effect/turf_decal/sand/plating::desc
	icon = /obj/effect/turf_decal/sand/plating::icon
	icon_state = /obj/effect/turf_decal/sand/plating::icon_state
	layer = 2
	plane = -7

/obj/structure/fluff/fake_sand_floor
	name = /obj/effect/turf_decal/sand::name
	desc = /obj/effect/turf_decal/sand::desc
	icon = /obj/effect/turf_decal/sand/::icon
	icon_state = /obj/effect/turf_decal/sand::icon_state
	layer = 2
	plane = -7
