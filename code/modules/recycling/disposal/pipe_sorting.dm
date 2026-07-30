// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
// A three-way junction that sorts objects based on check_sorting(H) proc
// This is a base type, use subtypes on the map.
/obj/structure/disposalpipe/sorting
	name = "sorting disposal pipe"
	desc = "An underfloor disposal pipe with a sorting mechanism."
	icon_state = "pipe-j1s"
	initialize_dirs = DISP_DIR_RIGHT | DISP_DIR_FLIP

/obj/structure/disposalpipe/sorting/nextdir(obj/structure/disposalholder/H)
	var/sortdir = dpdir & ~(dir | REVERSE_DIR(dir))
	if(H.dir != sortdir) // probably came from the negdir
		if(check_sorting(H)) // if destination matches filtered type...
			return sortdir // exit through sortdirection

	// go with the flow to positive direction
	return dir

/// Sorting check, to be overridden in subtypes
/obj/structure/disposalpipe/sorting/proc/check_sorting(obj/structure/disposalholder/H)
	return FALSE

// Mail sorting junction, uses package tags to sort objects.
/obj/structure/disposalpipe/sorting/mail
	flip_type = /obj/structure/disposalpipe/sorting/mail/flip
	var/sortType = 0
	// sortType is to be set in map editor.
	// Supports both singular numbers and strings of numbers similar to access level strings.
	// Look at the list called TAGGERLOCATIONS in /_globalvars/lists/flavor_misc.dm
	var/list/sortTypes = list()

/obj/structure/disposalpipe/sorting/mail/flip
	flip_type = /obj/structure/disposalpipe/sorting/mail
	icon_state = "pipe-j2s"
	initialize_dirs = DISP_DIR_LEFT | DISP_DIR_FLIP

/obj/structure/disposalpipe/sorting/mail/Initialize(mapload)
	. = ..()
	// Generate a list of soring tags.
	if(sortType)
		if(isnum(sortType))
			sortTypes |= sortType
		else if(istext(sortType))
			var/list/sorts = splittext(sortType,";")
			for(var/x in sorts)
				var/n = text2num(x)
				if(n)
					sortTypes |= n

/obj/structure/disposalpipe/sorting/mail/examine(mob/user)
	. = ..()
	if(sortTypes.len)
		. += LANG("obj.831ec6a5", null)
		for(var/t in sortTypes)
			. += LANG("obj.5aa6f726", list(GLOB.TAGGERLOCATIONS[t]))
	else
		. += LANG("obj.66467605", null)

/obj/structure/disposalpipe/sorting/mail/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/dest_tagger))
		return NONE
	var/relevant_tag = astype(tool, /obj/item/dest_tagger).currTag

	if(!relevant_tag)// Tagger has a tag set
		return ITEM_INTERACT_BLOCKING
	if(relevant_tag in sortTypes)
		sortTypes -= relevant_tag
		to_chat(user, span_notice(LANG("obj.7e803923", list(GLOB.TAGGERLOCATIONS[relevant_tag]))))
	else
		sortTypes |= relevant_tag
		to_chat(user, span_notice(LANG("obj.211382a4", list(GLOB.TAGGERLOCATIONS[relevant_tag]))))
	playsound(src, 'sound/machines/beep/twobeep_high.ogg', 100, TRUE)
	return ITEM_INTERACT_SUCCESS

/obj/structure/disposalpipe/sorting/mail/check_sorting(obj/structure/disposalholder/H)
	return (H.destinationTag in sortTypes)




// Wrap sorting junction, sorts objects destined for the mail office mail table (tomail = TRUE)
/obj/structure/disposalpipe/sorting/wrap
	desc = "An underfloor disposal pipe which sorts wrapped and unwrapped objects."
	flip_type = /obj/structure/disposalpipe/sorting/wrap/flip
	initialize_dirs = DISP_DIR_RIGHT | DISP_DIR_FLIP

/obj/structure/disposalpipe/sorting/wrap/check_sorting(obj/structure/disposalholder/H)
	return H.tomail

/obj/structure/disposalpipe/sorting/wrap/flip
	icon_state = "pipe-j2s"
	flip_type = /obj/structure/disposalpipe/sorting/wrap
	initialize_dirs = DISP_DIR_LEFT | DISP_DIR_FLIP
