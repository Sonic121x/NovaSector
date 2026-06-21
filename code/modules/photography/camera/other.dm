/obj/item/camera/spooky
	name = "昏沉相机"
	desc = "拍立得相机，有人说它能看到鬼魂！"
	see_ghosts = CAMERA_SEE_GHOSTS_BASIC

/obj/item/camera/spooky/steal_souls(list/victims)
	for(var/mob/living/target in victims)
		if(!(target.mob_biotypes & MOB_SPIRIT))
			continue

		// time to steal your soul
		if(istype(target, /mob/living/basic/revenant))
			var/mob/living/basic/revenant/peek_a_boo = target
			peek_a_boo.apply_status_effect(/datum/status_effect/revenant/revealed, 2 SECONDS) // no hiding
			peek_a_boo.apply_status_effect(/datum/status_effect/incapacitating/paralyzed/revenant, 2 SECONDS)

		target.visible_message(
			span_warning("[target] 剧烈地畏缩了一下！"),
			span_revendanger("你感觉自己的精华因被拍照而正在流失！"),
		)
		target.apply_damage(rand(10, 15))

/obj/item/camera/spooky/badmin
	desc = "拍立得相机，有人说它能看到鬼魂！它的末端似乎有一个额外的放大镜。"
	see_ghosts = CAMERA_SEE_GHOSTS_ORBIT

/obj/item/camera/detective
	name = "侦探的相机"
	desc = "一台用于犯罪调查的、静音且容量更大的宝丽来相机。"
	print_monochrome = TRUE
	flash_enabled = FALSE
	silent = TRUE
	pictures_max = 30
	pictures_left = 30
