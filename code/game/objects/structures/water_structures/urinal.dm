// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/structure/urinal
	name = "urinal"
	desc = "The HU-452, an experimental urinal. Comes complete with experimental urinal cake."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "urinal"
	density = FALSE
	anchored = TRUE
	/// Can you currently put an item inside
	var/exposed = FALSE
	/// What's in the urinal
	var/obj/item/hidden_item

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/urinal, 32)

/obj/structure/urinal/Initialize(mapload)
	. = ..()
	if(mapload)
		hidden_item = new /obj/item/food/urinalcake(src)
		find_and_mount_on_atom()

/obj/structure/urinal/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == hidden_item)
		hidden_item = null

/obj/structure/urinal/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return

	if(user.pulling && isliving(user.pulling))
		var/mob/living/grabbed_mob = user.pulling
		if(user.grab_state >= GRAB_AGGRESSIVE)
			if(grabbed_mob.loc != get_turf(src))
				to_chat(user, span_notice(LANG("obj.d8939e1d18fe2b06", list(grabbed_mob.name, src))))
				return
			user.changeNext_move(CLICK_CD_MELEE)
			user.visible_message(span_danger(LANG("obj.9570ee0c03b31447", list(user, grabbed_mob, src))), span_danger(LANG("obj.4a5b07de597e7ddf", list(grabbed_mob, src))))
			grabbed_mob.emote("scream")
			grabbed_mob.adjust_brute_loss(8)
		else
			to_chat(user, span_warning(LANG("obj.ef8434d1d066a322", null)))
		return

	if(exposed)
		if(hidden_item)
			to_chat(user, span_notice(LANG("obj.81a23449b13247cc", list(hidden_item))))
			user.put_in_hands(hidden_item)
		else
			to_chat(user, span_warning(LANG("obj.7328f9a62bbc98e9", null)))
		return
	return ..()

/obj/structure/urinal/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!exposed)
		return NONE

	if(hidden_item)
		to_chat(user, span_warning(LANG("obj.7afad2316272cee2", null)))
		return ITEM_INTERACT_BLOCKING

	if(tool.w_class > WEIGHT_CLASS_TINY)
		to_chat(user, span_warning(LANG("obj.b28ad6a77b229198", list(tool))))
		return ITEM_INTERACT_BLOCKING

	if(!user.transferItemToLoc(tool, src))
		to_chat(user, span_warning(LANG("obj.b02cbe5644a6eeed", list(tool))))
		return ITEM_INTERACT_BLOCKING

	hidden_item = tool
	to_chat(user, span_notice(LANG("obj.0bc0520a2c084cfc", list(tool))))
	return ITEM_INTERACT_SUCCESS

/obj/structure/urinal/screwdriver_act(mob/living/user, obj/item/I)
	if(..())
		return TRUE
	to_chat(user, span_notice(LANG("obj.94975cdd85e26e44", list(exposed ? "screw the cap back into place" : "unscrew the cap to the drain protector"))))
	playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 50, TRUE)
	if(I.use_tool(src, user, 20))
		user.visible_message(span_notice("[user] [exposed ? "screws the cap back into place" : "unscrew the cap to the drain protector"]!"),
			span_notice(LANG("obj.52638468bb05caa5", list(exposed ? "screw the cap back into place" : "unscrew the cap on the drain"))),
			span_hear(LANG("obj.98c5495ae16a8d32", null)))
		exposed = !exposed
	return TRUE

/obj/structure/urinal/wrench_act_secondary(mob/living/user, obj/item/tool)
	tool.play_tool_sound(user)
	deconstruct(TRUE)
	balloon_alert(user, LANG("obj.112ea80a3ac380f3", null))
	return ITEM_INTERACT_SUCCESS

/obj/structure/urinal/atom_deconstruct(disassembled = TRUE)
	new /obj/item/wallframe/urinal(loc)
	hidden_item?.forceMove(drop_location())

/obj/item/wallframe/urinal
	name = "urinal frame"
	desc = "An unmounted urinal. Attach it to a wall to use."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "urinal"
	result_path = /obj/structure/urinal
	pixel_shift = 32

/obj/item/food/urinalcake
	name = "urinal cake"
	desc = "The noble urinal cake, protecting the station's pipes from the station's pee. Do not eat."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "urinalcake"
	w_class = WEIGHT_CLASS_TINY
	food_reagents = list(
		/datum/reagent/chlorine = 3,
		/datum/reagent/ammonia = 1,
	)
	foodtypes = TOXIC | GROSS
	preserved_food = TRUE

/obj/item/food/urinalcake/attack_self(mob/living/user)
	user.visible_message(span_notice(LANG("obj.3255392e195d78f3", list(user, src))), span_notice(LANG("obj.e29f23218ea41596", list(src))), LANG("obj.a5b232644f56e74f", null))
	icon_state = "urinalcake_squish"
	addtimer(VARSET_CALLBACK(src, icon_state, "urinalcake"), 0.8 SECONDS)
