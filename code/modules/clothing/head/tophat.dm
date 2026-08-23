// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
#define RABBIT_CD_TIME (30 SECONDS)

/obj/item/clothing/head/hats/tophat
	name = "top-hat"
	desc = "It's an amish looking hat."
	icon_state = "tophat"
	inhand_icon_state = "that"
	dog_fashion = /datum/dog_fashion/head
	throwforce = 1
	/// Cooldown for how often we can pull rabbits out of here
	COOLDOWN_DECLARE(rabbit_cooldown)

/obj/item/clothing/head/hats/tophat/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/gun/magic/wand))
		return ..()

	abracadabra(tool, user)
	return ITEM_INTERACT_SUCCESS

/obj/item/clothing/head/hats/tophat/proc/abracadabra(obj/item/hitby_wand, mob/magician)
	if(!COOLDOWN_FINISHED(src, rabbit_cooldown))
		to_chat(magician, span_warning(LANG("obj.8c125ef878a16a0d", list(src))))
		return

	COOLDOWN_START(src, rabbit_cooldown, RABBIT_CD_TIME)
	playsound(get_turf(src), 'sound/items/weapons/emitter.ogg', 70)
	do_smoke(1, src, src, effect_type = /obj/effect/particle_effect/fluid/smoke/quick)

	if(prob(10))
		magician.visible_message(span_danger(LANG("obj.ddb15db3738790de", list(magician, src, hitby_wand))), span_danger(LANG("obj.afac0217081963a5", list(src, hitby_wand.name))))
		var/wait_how_many_bees_did_that_guy_pull_out_of_his_hat = rand(4, 8)
		for(var/b in 1 to wait_how_many_bees_did_that_guy_pull_out_of_his_hat)
			var/mob/living/basic/bee/barry = new(get_turf(magician))
			if(prob(20))
				barry.say(pick("BUZZ BUZZ", "PULLING A RABBIT OUT OF A HAT IS A TIRED TROPE", "I DIDN'T ASK TO BEE HERE"), forced = "bee hat")
	else
		magician.visible_message(span_notice(LANG("obj.39b77f0bd671ba61", list(magician, src, hitby_wand))), span_notice(LANG("obj.a2540c5b648919b4", list(src, hitby_wand.name))))
		var/mob/living/basic/rabbit/bunbun = new(get_turf(magician))
		bunbun.mob_try_pickup(magician, instant=TRUE)

/obj/item/clothing/head/hats/tophat/balloon
	name = "balloon top-hat"
	desc = "It's a colourful looking top-hat to match your colourful personality."
	icon_state = "balloon_tophat"
	inhand_icon_state = "balloon_that"
	throwforce = 0
	resistance_flags = FIRE_PROOF
	dog_fashion = null
	custom_materials = list(/datum/material/plastic = SHEET_MATERIAL_AMOUNT * 3.6)

#undef RABBIT_CD_TIME
