/datum/action/cooldown/mob_cooldown/bot/honk
	name = "鸣笛"
	desc = "向四周传播欢乐与喜悦！"
	button_icon = 'icons/obj/art/horn.dmi'
	button_icon_state = "bike_horn"
	cooldown_time = 5 SECONDS
	click_to_activate = FALSE
	///callback after we have honked
	var/datum/callback/post_honk_callback

/datum/action/cooldown/mob_cooldown/bot/honk/Activate()
	playsound(owner, 'sound/items/bikehorn.ogg', 50, TRUE, -1)
	post_honk_callback?.Invoke()
	StartCooldown()
	return TRUE

/datum/action/cooldown/mob_cooldown/bot/honk/Destroy()
	. = ..()
	post_honk_callback = null
