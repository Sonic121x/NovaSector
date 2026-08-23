// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/machinery/wish_granter
	name = "wish granter"
	desc = "You're not so sure about this, anymore..."
	icon = 'icons/obj/machines/beacon.dmi'
	icon_state = "syndbeacon"

	use_power = NO_POWER_USE
	density = TRUE

	var/charges = 1
	var/insisting = 0

/obj/machinery/wish_granter/attack_hand(mob/living/carbon/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(charges <= 0)
		to_chat(user, span_boldnotice(LANG("obj.7aa0b44a4dce34b8", null)))
		return

	else if(!ishuman(user))
		to_chat(user, span_boldnotice(LANG("obj.adc1785b85459074", null)))
		return

	else if(user.is_antag())
		to_chat(user, span_boldnotice(LANG("obj.e4ac5688594c2b49", null)))

	else if (!insisting)
		to_chat(user, span_boldnotice(LANG("obj.801799619d45c120", null)))
		insisting++

	else
		to_chat(user, span_boldnotice(LANG("obj.7c0227c2eb24bc4d", list(pick("I want the station to disappear","Humanity is corrupt, mankind must be destroyed","I want to be rich", "I want to rule the world","I want immortality.")))))
		to_chat(user, span_boldnotice(LANG("obj.b777a2e1c831ffe2", null)))

		charges--
		insisting = 0

		user.mind.add_antag_datum(/datum/antagonist/wishgranter)

		to_chat(user, span_warning(LANG("obj.7c3ce82af7d7e31d", null)))

	return
