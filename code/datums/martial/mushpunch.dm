// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/datum/martial_art/mushpunch
	name = "Mushroom Punch"
	id = MARTIALART_MUSHPUNCH

/datum/martial_art/mushpunch/harm_act(mob/living/attacker, mob/living/defender)
	INVOKE_ASYNC(src, PROC_REF(charge_up_attack), attacker, defender)
	return MARTIAL_ATTACK_SUCCESS

/datum/martial_art/mushpunch/proc/charge_up_attack(mob/living/attacker, mob/living/defender)

	to_chat(attacker, span_spiderbroodmother(LANG("datum.613dd13fbac5dc7e", null)))
	if(!do_after(attacker, 2.5 SECONDS, defender))
		to_chat(attacker, span_spiderbroodmother(LANG("datum.93aae2a46c4dce96", null)))
		return

	var/final_damage = rand(15, 30)
	var/atk_verb = pick("punch", "smash", "crack")
	if(defender.check_block(attacker, final_damage, "[attacker]'s [atk_verb]", UNARMED_ATTACK))
		return

	attacker.do_attack_animation(defender, ATTACK_EFFECT_PUNCH)
	defender.visible_message(
		span_danger(LANG("datum.096781cbecf9ad3a", list(attacker, atk_verb, defender, defender.p_them()))), \
		span_userdanger(LANG("datum.65df5c1f51b80e36", list(atk_verb, attacker))),
		span_hear(LANG("datum.6c7f8149b8c68cd4", null)),
		null,
		attacker,
	)
	to_chat(attacker, span_danger(LANG("datum.6546b2e4cdb85045", list(atk_verb, defender, defender.p_them()))))
	defender.apply_damage(final_damage, attacker.get_attack_type())
	playsound(defender, 'sound/effects/meteorimpact.ogg', 25, TRUE, -1)
	var/throwtarget = get_edge_target_turf(attacker, get_dir(attacker, get_step_away(defender, attacker)))
	defender.throw_at(throwtarget, 4, 2, attacker)//So stuff gets tossed around at the same time.
	defender.Paralyze(2 SECONDS)
	log_combat(attacker, defender, "[atk_verb] (Mushroom Punch)")

/obj/item/mushpunch
	name = "odd mushroom"
	desc = "<I>Sapienza Ophioglossoides</I>:An odd mushroom from the flesh of a mushroom person. \
		It has apparently retained some innate power of its owner, as it quivers with barely-contained POWER!"
	icon = 'icons/obj/service/hydroponics/seeds.dmi'
	icon_state = "mycelium-angel"

/obj/item/mushpunch/attack_self(mob/living/user)
	if(!istype(user))
		return
	to_chat(user, span_spiderbroodmother(LANG("obj.7b3562648ab20d0d", list(src))))
	var/datum/martial_art/mushpunch/mush = new(user)
	mush.teach(user)
	visible_message(
		span_warning(LANG("obj.e9ed66c6120aefc7", list(user, src))),
		span_notice(LANG("obj.9ec0a398294a3312", list(src))),
	)

	qdel(src)
