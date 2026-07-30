// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md

/mob/living/basic/slime/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	powerlevel = 0 // oh no, the power!

///If a slime is attack with an empty hand, shoves included, try to wrestle them off the mob they are on
/mob/living/basic/slime/proc/on_attack_hand(mob/living/basic/slime/defender_slime, mob/living/attacker)
	SIGNAL_HANDLER

	if(isnull(buckled))
		return

	if(buckled == attacker ? prob(60) : prob(30)) //its easier to remove the slime from yourself
		attacker.visible_message(span_warning(LANG("mob.1a233b14", list(attacker, defender_slime.name, buckled == attacker ? "" : buckled))), \
		span_danger(LANG("mob.61ec3cc7", list(buckled == attacker ? "You attempt" : "[attacker] attempts", defender_slime.name, buckled == attacker ? "" : buckled))))
		playsound(loc, 'sound/items/weapons/punchmiss.ogg', 25, TRUE, -1)
		return

	attacker.visible_message(span_warning(LANG("mob.76e0b410", list(attacker, defender_slime.name))), span_notice(LANG("mob.4f00f6d8", list(defender_slime.name))))
	playsound(loc, 'sound/items/weapons/shove.ogg', 50, TRUE, -1)

	defender_slime.discipline_slime()

/mob/living/basic/slime/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	//Lets you feed slimes plasma. Checks before the passthrough force check
	if(istype(tool, /obj/item/stack/sheet/mineral/plasma) && !IS_UNCONSCIOUS_OR_CRIT(src))
		use_sheet(tool, user)
		return ITEM_INTERACT_SUCCESS

	//Checks if the item passes through the slime first. Safe items can be used simply
	if(check_item_passthrough(tool, user))
		return ITEM_INTERACT_SUCCESS

	try_discipline_slime(tool)

	if(!istype(tool, /obj/item/storage/bag/xeno))
		return ..()

	use_xeno_bag(tool, user)
	return ITEM_INTERACT_SUCCESS


///Checks if an item harmlessly passes through the slime
/mob/living/basic/slime/proc/check_item_passthrough(obj/item/attacking_item, mob/living/user)
	if(attacking_item.force <= 0)
		return FALSE

	if(!prob(25))
		return FALSE

	user.do_attack_animation(src)
	user.changeNext_move(CLICK_CD_MELEE)
	to_chat(user, span_danger(LANG("mob.360039ae", list(attacking_item, src))))
	return TRUE

///Attempts to use the item to discipline the unruly slime
/mob/living/basic/slime/proc/try_discipline_slime(obj/item/attacking_item)
	if(attacking_item.force < 3)
		return

	var/force_effect =  attacking_item.force * (life_stage == SLIME_LIFE_STAGE_BABY ? 2 : 1)
	if(prob(10 + force_effect))
		discipline_slime()

///Handles feeding a sheet of plasma to a slime
/mob/living/basic/slime/proc/use_sheet(obj/item/stack/sheet/mineral/plasma/delicious_sheet, mob/living/user)
	befriend(user)
	to_chat(user, span_notice(LANG("mob.bbf8e9b2", null)))
	delicious_sheet.use(1)
	new /obj/effect/temp_visual/heart(loc)
	return

///Handles feeding a slim with a bag full of extracts
/mob/living/basic/slime/proc/use_xeno_bag(obj/item/storage/bag/xeno/xeno_bag, mob/living/user)
	if(!crossbreed_modification)
		to_chat(user, span_warning(LANG("mob.b5dc4ea2", null)))
		return
	var/has_output = FALSE //Have we outputted text?
	var/has_found = FALSE //Have we found an extract to be added?
	for(var/obj/item/slime_extract/extract in xeno_bag.contents)
		if(extract.crossbreed_modification == crossbreed_modification)
			xeno_bag.atom_storage.attempt_remove(extract, get_turf(src), silent = TRUE)
			qdel(extract)
			applied_crossbreed_amount++
			has_found = TRUE
		if(applied_crossbreed_amount >= SLIME_EXTRACT_CROSSING_REQUIRED)
			to_chat(user, span_notice(LANG("mob.d9978070", null)))
			playsound(src, 'sound/effects/blob/attackblob.ogg', 50, TRUE)
			spawn_corecross()
			has_output = TRUE
			break

	if(has_output)
		return

	if(!has_found)
		to_chat(user, span_warning(LANG("mob.221b378c", null)))
	else
		to_chat(user, span_notice(LANG("mob.e6fbb3c6", null)))
		playsound(src, 'sound/effects/blob/attackblob.ogg', 50, TRUE)

///Handles the adverse effects of water on slimes
/mob/living/basic/slime/proc/apply_water()
	adjust_brute_loss(rand(15,20))
	discipline_slime()

///Stops the slime from feeding, and might remove rabidity and targets
/mob/living/basic/slime/proc/discipline_slime()
	stop_feeding(silent = TRUE)
	if(life_stage == SLIME_LIFE_STAGE_BABY && prob(80))
		ai_controller?.clear_blackboard_key(BB_CURRENT_TARGET)
		ai_controller?.clear_blackboard_key(BB_CURRENT_HUNTING_TARGET)

	if(prob(10))
		ai_controller?.set_blackboard_key(BB_SLIME_RABID, FALSE)
