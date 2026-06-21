#define RABBIT_CD_TIME (30 SECONDS)

/obj/item/clothing/head/hats/tophat
	name = "高顶礼帽"
	desc = "这是一顶看起来像阿米什风格的帽子。"
	icon_state = "tophat"
	inhand_icon_state = "that"
	dog_fashion = /datum/dog_fashion/head
	throwforce = 1
	/// Cooldown for how often we can pull rabbits out of here
	COOLDOWN_DECLARE(rabbit_cooldown)

/obj/item/clothing/head/hats/tophat/attackby(obj/item/hitby_item, mob/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(istype(hitby_item, /obj/item/gun/magic/wand))
		abracadabra(hitby_item, user)

/obj/item/clothing/head/hats/tophat/proc/abracadabra(obj/item/hitby_wand, mob/magician)
	if(!COOLDOWN_FINISHED(src, rabbit_cooldown))
		to_chat(magician, span_warning("你在[src]里找不到另一只兔子！看来还没有另一只兔子在里面迷路……"))
		return

	COOLDOWN_START(src, rabbit_cooldown, RABBIT_CD_TIME)
	playsound(get_turf(src), 'sound/items/weapons/emitter.ogg', 70)
	do_smoke(1, src, src, effect_type = /obj/effect/particle_effect/fluid/smoke/quick)

	if(prob(10))
		magician.visible_message(span_danger("[magician]用[hitby_wand]轻敲[src]，然后伸手进去掏出了一只兔——等等，那些是蜜蜂！"), span_danger("你用你的[hitby_wand.name]轻敲[src]，然后掏出了……<b>蜜蜂！</b>"))
		var/wait_how_many_bees_did_that_guy_pull_out_of_his_hat = rand(4, 8)
		for(var/b in 1 to wait_how_many_bees_did_that_guy_pull_out_of_his_hat)
			var/mob/living/basic/bee/barry = new(get_turf(magician))
			if(prob(20))
				barry.say(pick("BUZZ BUZZ", "PULLING A RABBIT OUT OF A HAT IS A TIRED TROPE", "I DIDN'T ASK TO BEE HERE"), forced = "bee hat")
	else
		magician.visible_message(span_notice("[magician]用[hitby_wand]轻敲[src]，然后伸手进去掏出了一只小兔子！真可爱！"), span_notice("你用你的[hitby_wand.name]轻敲[src]，然后掏出了一只可爱的小兔子！"))
		var/mob/living/basic/rabbit/bunbun = new(get_turf(magician))
		bunbun.mob_try_pickup(magician, instant=TRUE)

/obj/item/clothing/head/hats/tophat/balloon
	name = "气球高顶礼帽"
	desc = "这是一顶色彩鲜艳的高顶礼帽，与你多彩的个性相得益彰。"
	icon_state = "balloon_tophat"
	inhand_icon_state = "balloon_that"
	throwforce = 0
	resistance_flags = FIRE_PROOF
	dog_fashion = null

#undef RABBIT_CD_TIME
