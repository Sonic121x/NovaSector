/obj/item/book/granter/action/spell/mime
	name = "哑剧艺术指南 第0卷"
	desc = "这部传奇系列中缺失的一卷。可惜它什么也没教你。"
	icon_state ="bookmime"
	remarks = list("...")
	book_sounds = list('sound/effects/space_wind.ogg')

/obj/item/book/granter/action/spell/mime/attack_self(mob/user)
	. = ..()
	if(!.)
		return

	// Gives the user a vow ability if they don't have one
	var/datum/action/cooldown/spell/vow_of_silence/vow = locate() in user.actions
	if(!vow && user.mind)
		vow = new(user.mind)
		vow.Grant(user)

/obj/item/book/granter/action/spell/mime/mimery_blockade
	granted_action = /datum/action/cooldown/spell/forcewall/mime
	action_name = "Invisible Blockade"
	name = "高级哑剧艺术指南 第1卷"
	desc = "翻页时没有任何声音。"

/obj/item/book/granter/action/spell/mime/mimery_guns
	granted_action = /datum/action/cooldown/spell/pointed/projectile/finger_guns
	action_name = "Finger Guns"
	name = "高级哑剧艺术指南 第2卷"
	desc = "上面一个字也没写……"
