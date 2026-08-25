// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/machinery/computer/arcade/amputation
	name = "Mediborg's Amputation Adventure"
	desc = "A picture of a blood-soaked medical cyborg flashes on the screen. \
		The mediborg has a speech bubble that says, \"Put your hand in the machine if you aren't a <b>coward!</b>\""
	icon_state = MAP_SWITCH("arcade", "/obj/machinery/computer/arcade")
	circuit = /obj/item/circuitboard/computer/arcade/amputation
	interaction_flags_machine = NONE //borgs can't play, but the illiterate can.

/obj/machinery/computer/arcade/amputation/attack_tk(mob/user)
	return //that's a pretty damn big guillotine

/obj/machinery/computer/arcade/amputation/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(!iscarbon(user))
		return
	to_chat(user, span_warning(LANG("obj.0e51d1760ab1d825", null)))
	user.played_game()
	var/obj/item/bodypart/chopchop = user.get_active_hand()
	if(do_after(user, 5 SECONDS, target = src, extra_checks = CALLBACK(src, PROC_REF(do_they_still_have_that_hand), user, chopchop)))
		playsound(src, 'sound/items/weapons/slice.ogg', 25, TRUE, -1)
		to_chat(user, span_userdanger(LANG("obj.1de703ce0f543e6d", null)))
		chopchop.dismember()
		qdel(chopchop)
		user.mind?.adjust_experience(/datum/skill/gaming, 100)
		user.won_game()
		victory_tickets(rand(6,10))
		return
	if(!do_they_still_have_that_hand(user, chopchop))
		to_chat(user, span_warning(LANG("obj.ca3ade6f4fa0b96f", null)))
		playsound(src, 'sound/items/weapons/slice.ogg', 25, TRUE, -1)
	else
		to_chat(user, span_notice(LANG("obj.6616d66c27b2aec9", null)))
	user.lost_game()

///Makes sure the user still has their starting hand, preventing the user from pulling the arm out and still getting prizes.
/obj/machinery/computer/arcade/amputation/proc/do_they_still_have_that_hand(mob/user, obj/item/bodypart/chopchop)
	if(QDELETED(chopchop) || chopchop.owner != user)
		return FALSE
	return TRUE

///Dispenses wrapped gifts instead of arcade prizes, also known as the ancap christmas tree
/obj/machinery/computer/arcade/amputation/festive
	name = "Mediborg's Festive Amputation Adventure"
	desc = "A picture of a blood-soaked medical cyborg wearing a Santa hat flashes on the screen. The mediborg has a speech bubble that says, \"Put your hand in the machine if you aren't a <b>coward!</b>\""
	prize_override = list(/obj/item/gift/anything = 1)
