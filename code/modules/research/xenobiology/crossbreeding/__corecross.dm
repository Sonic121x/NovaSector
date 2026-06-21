//////////////////////////////////////////////
//////////     SLIME CROSSBREEDS    //////////
//////////////////////////////////////////////
// A system of combining two extract types. //
// Performed by feeding a slime 10 of an    //
// extract color.                           //
//////////////////////////////////////////////
/*==========================================*\
To add a crossbreed:
	The file name is automatically selected
	by the crossbreeding effect, which uses
	the format slimecross/[modifier]/[color].

	If a crossbreed doesn't exist, don't
	worry. If no file is found at that
	location, it will simple display that
	the crossbreed was too unstable.

	As a result, do not feel the need to
	try to add all of the crossbred
	effects at once, if you're here and
	trying to make a new slime type. Just
	get your slimetype in the codebase and
	get around to the crossbreeds eventually!
\*==========================================*/

/obj/item/slimecross //The base type for crossbred extracts. Mostly here for posterity, and to set base case things.
	name = "杂交史莱姆提取物"
	desc = "一种极其强大的史莱姆提取物，是通过杂交培育而成的。"
	icon = 'icons/obj/science/slimecrossing.dmi'
	icon_state = "base"
	var/colour = "null"
	var/effect = "null"
	var/effect_desc = "null"
	force = 0
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/slimecross/examine(mob/user)
	. = ..()
	if(effect_desc)
		. += span_notice("[effect_desc]")

/obj/item/slimecross/Initialize(mapload)
	. = ..()
	name = effect + " " + colour + "提取物"
	var/itemcolor = COLOR_WHITE
	switch(colour)
		if(SLIME_TYPE_ORANGE)
			itemcolor = "#FFA500"
		if(SLIME_TYPE_PURPLE)
			itemcolor = "#B19CD9"
		if(SLIME_TYPE_BLUE)
			itemcolor = "#ADD8E6"
		if(SLIME_TYPE_METAL)
			itemcolor = "#7E7E7E"
		if(SLIME_TYPE_YELLOW)
			itemcolor = COLOR_YELLOW
		if(SLIME_TYPE_DARK_PURPLE)
			itemcolor = COLOR_DARK_PURPLE
		if(SLIME_TYPE_DARK_BLUE)
			itemcolor = COLOR_BLUE
		if(SLIME_TYPE_SILVER)
			itemcolor = "#D3D3D3"
		if(SLIME_TYPE_BLUESPACE)
			itemcolor = COLOR_LIME
		if(SLIME_TYPE_SEPIA)
			itemcolor = "#704214"
		if(SLIME_TYPE_CERULEAN)
			itemcolor = "#2956B2"
		if(SLIME_TYPE_PYRITE)
			itemcolor = "#FAFAD2"
		if(SLIME_TYPE_RED)
			itemcolor = COLOR_RED
		if(SLIME_TYPE_GREEN)
			itemcolor = COLOR_VIBRANT_LIME
		if(SLIME_TYPE_PINK)
			itemcolor = "#FF69B4"
		if(SLIME_TYPE_GOLD)
			itemcolor = COLOR_GOLD
		if(SLIME_TYPE_OIL)
			itemcolor = "#505050"
		if(SLIME_TYPE_BLACK)
			itemcolor = COLOR_BLACK
		if(SLIME_TYPE_LIGHT_PINK)
			itemcolor = "#FFB6C1"
		if(SLIME_TYPE_ADAMANTINE)
			itemcolor = "#008B8B"
	add_atom_colour(itemcolor, FIXED_COLOUR_PRIORITY)

/obj/item/slimecrossbeaker //To be used as a result for extract reactions that make chemicals.
	name = "结果提取物"
	desc = "你不应该看到这个。"
	icon = 'icons/obj/science/slimecrossing.dmi'
	icon_state = "base"
	var/del_on_empty = TRUE
	var/list/list_reagents

/obj/item/slimecrossbeaker/Initialize(mapload)
	. = ..()
	create_reagents(50, INJECTABLE | DRAWABLE | SEALED_CONTAINER)
	if(list_reagents)
		for(var/reagent in list_reagents)
			reagents.add_reagent(reagent, list_reagents[reagent])
	if(del_on_empty)
		START_PROCESSING(SSobj,src)

/obj/item/slimecrossbeaker/Destroy()
	STOP_PROCESSING(SSobj,src)
	return ..()

/obj/item/slimecrossbeaker/process()
	if(!reagents.total_volume)
		visible_message(span_notice("[src] 已被完全耗尽，并融化消失了。"))
		qdel(src)

/obj/item/slimecrossbeaker/bloodpack //Pack of 50u blood. Deletes on empty.
	name = "血液提取物"
	desc = "一团液态的血液，不知怎的竟然还能保持连贯不散。"
	color = COLOR_RED
	list_reagents = list(/datum/reagent/blood = 50)

/obj/item/slimecrossbeaker/pax //5u synthpax.
	name = "促进和平的提取物"
	desc = "一小团孢子的和平素物质。"
	color = "#FFCCCC"
	list_reagents = list(/datum/reagent/pax/peaceborg = 5)

/obj/item/slimecrossbeaker/omnizine //15u omnizine.
	name = "愈合提取物"
	desc = "一种由全锌制成的提取物。"
	color = COLOR_MAGENTA
	list_reagents = list(/datum/reagent/medicine/omnizine = 15)

/obj/item/slimecrossbeaker/autoinjector //As with the above, but automatically injects whomever it is used on with contents.
	var/ignore_flags = FALSE
	var/self_use_only = FALSE

/obj/item/slimecrossbeaker/autoinjector/Initialize(mapload)
	. = ..()
	reagents.flags = DRAWABLE // Cannot be refilled, since it's basically an autoinjector!

/obj/item/slimecrossbeaker/autoinjector/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!iscarbon(interacting_with))
		return NONE
	var/mob/living/carbon/injecting_mob = interacting_with
	if(!reagents.total_volume)
		to_chat(user, span_warning("[src] 是空的！"))
		return ITEM_INTERACT_BLOCKING
	if(self_use_only && injecting_mob != user)
		to_chat(user, span_warning("这只能对你自己使用。"))
		return ITEM_INTERACT_BLOCKING
	if(reagents.total_volume && (ignore_flags || injecting_mob.try_inject(user, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE)))
		reagents.trans_to(injecting_mob, reagents.total_volume, transferred_by = user)
		if(user != injecting_mob)
			to_chat(injecting_mob, span_warning("[user] 将 [src] 按在你身上！"))
			to_chat(user, span_notice("你将 [src] 按在 [injecting_mob] 身上，注射了 [injecting_mob.p_them()]。"))
		else
			to_chat(user, span_notice("你将 [src] 按在自己身上，它在你身上摊平了！"))
		return ITEM_INTERACT_SUCCESS
	else
		to_chat(user, span_warning("没有地方可以扎 [src]！"))
		return ITEM_INTERACT_BLOCKING

/obj/item/slimecrossbeaker/autoinjector/regenpack
	ignore_flags = TRUE //It is, after all, intended to heal.
	name = "修补溶液"
	desc = "一团散发着甜味的半固态物质，似乎很容易就粘附在皮肤上。"
	color = COLOR_MAGENTA
	list_reagents = list(/datum/reagent/medicine/regen_jelly = 20)

/obj/item/slimecrossbeaker/autoinjector/slimejelly //Primarily for slimepeople, but you do you.
	self_use_only = TRUE
	ignore_flags = TRUE
	name = "史莱姆果冻泡泡"
	desc = "一团黏液状的胶状物。它似乎会粘附在你的皮肤上，但却不会附着在其他物体上。"
	color = COLOR_VIBRANT_LIME
	list_reagents = list(/datum/reagent/toxin/slimejelly = 50)

/obj/item/slimecrossbeaker/autoinjector/peaceandlove
	name = "平静精华"
	desc = "一个浅粉色、黏糊糊的球体。仅仅触碰它就会让你感到一阵眩晕。"
	color = "#DDAAAA"
	list_reagents = list(/datum/reagent/pax/peaceborg = 10, /datum/reagent/drug/space_drugs = 15) //Peace, dudes

/obj/item/slimecrossbeaker/autoinjector/peaceandlove/Initialize(mapload)
	. = ..()
	reagents.flags = NONE // It won't be *that* easy to get your hands on pax.

/obj/item/slimecrossbeaker/autoinjector/slimestimulant
	name = "生命凝胶"
	desc = "一种呈紫色且不断冒泡的混合物，旨在促进伤口愈合并增强身体机能。"
	color = COLOR_MAGENTA
	list_reagents = list(/datum/reagent/medicine/regen_jelly = 30, /datum/reagent/drug/methamphetamine = 9)
