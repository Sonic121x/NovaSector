#define TIGHT_SLOWDOWN 2

/obj/item/clothing/suit/corset
	name = "束腰"
	desc = "一件紧绷的乳胶束腰。怎么会有人能穿得进去？"
	icon_state = "corset"
	inhand_icon_state = null
	icon = 'modular_nova/modules/modular_items/lewd_items/icons/obj/lewd_clothing/lewd_suits.dmi'
	worn_icon = 'modular_nova/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_suit/lewd_suits.dmi'
	worn_icon_digi = 'modular_nova/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_suit/lewd_suits-digi.dmi'
	worn_icon_taur_snake = 'modular_nova/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_suit/lewd_suits-snake.dmi'
	worn_icon_taur_paw = 'modular_nova/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_suit/lewd_suits-paw.dmi'
	worn_icon_taur_hoof = 'modular_nova/modules/modular_items/lewd_items/icons/mob/lewd_clothing/lewd_suit/lewd_suits-hoof.dmi'
	body_parts_covered = CHEST
	slowdown = 1 // You can't run with that thing literally squeezing your chest

	/// Has it been laced tightly?
	var/laced_tight = FALSE

/obj/item/clothing/suit/corset/click_alt(mob/user)
	laced_tight = !laced_tight
	to_chat(user, span_notice("你 [laced_tight ? "tighten" : "loosen"] 了束腰，让它变得 [laced_tight ? "harder" : "easier"] 呼吸。"))
	playsound_if_pref(user, laced_tight ? 'sound/items/handling/cloth/cloth_pickup1.ogg' : 'sound/items/handling/cloth/cloth_drop1.ogg', 40, TRUE)
	. = CLICK_ACTION_SUCCESS
	if(laced_tight)
		slowdown = TIGHT_SLOWDOWN
		return
	slowdown = initial(slowdown)

/obj/item/clothing/suit/corset/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(laced_tight && src == user.wear_suit)
		to_chat(user, span_purple("束腰紧紧勒住了你的肋骨！呼吸突然变得困难多了。"))

/obj/item/clothing/suit/corset/dropped(mob/living/carbon/human/user)
	. = ..()
	if(laced_tight && src == user.wear_suit)
		to_chat(user, span_purple("呼。现在你可以正常呼吸了。"))

#undef TIGHT_SLOWDOWN
