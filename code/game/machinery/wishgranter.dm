/obj/machinery/wish_granter
	name = "许愿机"
	desc = "你不再那么确定了…"
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
		to_chat(user, span_boldnotice("许愿机沉默不语。"))
		return

	else if(!ishuman(user))
		to_chat(user, span_boldnotice("你感觉到许愿机内部传来一阵黑暗的悸动，那是你绝不想沾染的东西。你的直觉比任何人都要敏锐。"))
		return

	else if(user.is_antag())
		to_chat(user, span_boldnotice("即使对你这样黑暗的心灵来说，你也知道这不会带来任何好处。某种本能让你退缩了。"))

	else if (!insisting)
		to_chat(user, span_boldnotice("你的第一次触碰让许愿机苏醒，聆听着你。你真的确定要这么做吗？"))
		insisting++

	else
		to_chat(user, span_boldnotice("你开口了。[pick("I want the station to disappear","Humanity is corrupt, mankind must be destroyed","I want to be rich", "I want to rule the world","I want immortality.")]。许愿机回应了。"))
		to_chat(user, span_boldnotice("你的头剧痛了片刻，随后视线变得清晰。你是许愿者的化身，你的力量是无限的！这一切都属于你。你必须确保没人能把它从你身边夺走。首先，不能让任何人知道。"))

		charges--
		insisting = 0

		user.mind.add_antag_datum(/datum/antagonist/wishgranter)

		to_chat(user, span_warning("你对此有种非常不祥的预感。"))

	return
