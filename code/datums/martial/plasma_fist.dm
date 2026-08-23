// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
#define TORNADO_COMBO "HHD"
#define THROWBACK_COMBO "DHD"
#define PLASMA_COMBO "HDDDH"

/datum/martial_art/plasma_fist
	name = "Plasma Fist"
	id = MARTIALART_PLASMAFIST
	help_verb = "Recall Teachings"
	var/nobomb = FALSE
	var/plasma_power = 1 //starts at a 1, 2, 4 explosion.
	var/plasma_increment = 1 //how much explosion power gets added per kill (1 = 1, 2, 4. 2 = 2, 4, 8 and so on)
	var/plasma_cap = 12 //max size explosion level
	var/datum/action/cooldown/spell/aoe/repulse/tornado_spell
	display_combos = TRUE

/datum/martial_art/plasma_fist/New()
	. = ..()
	tornado_spell = new(src)

/datum/martial_art/plasma_fist/Destroy()
	tornado_spell = null
	return ..()

/datum/martial_art/plasma_fist/proc/check_streak(mob/living/attacker, mob/living/defender)
	if(findtext(streak,TORNADO_COMBO))
		if(attacker == defender)//helps using apotheosis
			return FALSE
		reset_streak()
		return Tornado(attacker, defender)
	if(findtext(streak,THROWBACK_COMBO))
		if(attacker == defender)//helps using apotheosis
			return FALSE
		reset_streak()
		return Throwback(attacker, defender)
	if(findtext(streak,PLASMA_COMBO))
		reset_streak()
		if(attacker == defender && !nobomb)
			return Apotheosis(attacker, defender)
		return Plasma(attacker, defender)
	return FALSE

/datum/martial_art/plasma_fist/proc/Tornado(mob/living/attacker, mob/living/defender)
	attacker.say(LANG("datum.0aaa572135ac49dc", null), forced="plasma fist")
	dance_rotate(attacker, CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), attacker, 'sound/items/weapons/punch1.ogg', 15, TRUE, -1))
	tornado_spell.cast(attacker)
	log_combat(attacker, defender, "tornado sweeped (Plasma Fist)")
	return TRUE

/datum/martial_art/plasma_fist/proc/Throwback(mob/living/attacker, mob/living/defender)
	defender.visible_message(
		span_danger(LANG("datum.22cc8208eb3dc9e2", list(attacker, defender))),
		span_userdanger(LANG("datum.e8048de5ee621e71", list(attacker))),
		span_hear(LANG("datum.6c7f8149b8c68cd4", null)),
		null,
		attacker,
	)
	to_chat(attacker, span_danger(LANG("datum.db4e604ecba92912", list(defender))))
	playsound(defender, 'sound/items/weapons/punch1.ogg', 50, TRUE, -1)
	var/atom/throw_target = get_edge_target_turf(defender, get_dir(defender, get_step_away(defender, attacker)))
	defender.throw_at(throw_target, 200, 4,attacker)
	attacker.say(LANG("datum.2f5253bc6d3ae196", null), forced="plasma fist")
	log_combat(attacker, defender, "threw back (Plasma Fist)")
	return TRUE

/datum/martial_art/plasma_fist/proc/Plasma(mob/living/attacker, mob/living/defender)
	var/hasclient = !!defender.client

	attacker.do_attack_animation(defender, ATTACK_EFFECT_PUNCH)
	playsound(defender, 'sound/items/weapons/punch1.ogg', 50, TRUE, -1)
	attacker.say(LANG("datum.b5ef43e2ba5762ab", null), forced="plasma fist")
	defender.visible_message(
		span_danger(LANG("datum.dfeead672d1319ea", list(attacker, defender))),
		span_userdanger(LANG("datum.a1b7ac8406068932", list(attacker))),
		span_hear(LANG("datum.6c7f8149b8c68cd4", null)),
		null,
		attacker,
	)
	to_chat(attacker, span_danger(LANG("datum.98ecabe317cbeadb", list(defender))))
	log_combat(attacker, defender, "gibbed (Plasma Fist)")
	var/turf/Dturf = get_turf(defender)
	defender.investigate_log("has been gibbed by plasma fist.", INVESTIGATE_DEATHS)
	defender.gib(DROP_ALL_REMAINS)
	if(nobomb)
		return

	if(!hasclient)
		to_chat(attacker, span_warning(LANG("datum.da4c55f6feeaeb83", list(span_notice("Apotheosis")))))
		new /obj/effect/temp_visual/plasma_soul(Dturf)//doesn't beam to you, so it just hangs around and poofs.

	else if(plasma_power >= plasma_cap)
		to_chat(attacker, span_warning(LANG("datum.fb53979388a1ae69", list(span_notice("Apotheosis")))))
		new /obj/effect/temp_visual/plasma_soul(Dturf)//doesn't beam to you, so it just hangs around and poofs.

	else
		plasma_power += plasma_increment
		to_chat(attacker, span_nicegreen(LANG("datum.c722f4f48e8325cd", list(span_notice("Apotheosis"), plasma_power))))
		new /obj/effect/temp_visual/plasma_soul(Dturf, attacker)
		var/oldcolor = attacker.color
		attacker.color = "#9C00FF"
		flash_color(attacker, flash_color = "#9C00FF", flash_time = 3 SECONDS)
		animate(attacker, color = oldcolor, time = 3 SECONDS)

	return TRUE

/datum/martial_art/plasma_fist/proc/Apotheosis(mob/living/user, mob/living/target)
	user.say(LANG("datum.6b008f49b5120195", null), forced="plasma fist")
	if (ishuman(user))
		var/mob/living/carbon/human/human_attacker = user
		human_attacker.set_species(/datum/species/plasmaman)
		human_attacker.add_traits(list(TRAIT_FORCED_STANDING, TRAIT_BOMBIMMUNE), type)
		human_attacker.unequip_everything()
		human_attacker.underwear = "Nude"
		human_attacker.undershirt = "Nude"
		human_attacker.socks = "Nude"
		human_attacker.bra = "Nude" // NOVA EDIT ADDITION - Underwear and bra split
		human_attacker.update_body()

	var/turf/boomspot = get_turf(user)
	//before ghosting to prevent issues
	log_combat(user, user, "triggered final plasma explosion with size [plasma_power], [plasma_power*2], [plasma_power*4] (Plasma Fist)")
	message_admins("[key_name_admin(user)] triggered final plasma explosion with size [plasma_power], [plasma_power*2], [plasma_power*4].")

	to_chat(user, span_userdanger(LANG("datum.a5381ed2d318c600", null)))
	user.ghostize(FALSE) //prevents... horrible memes just believe me

	user.apply_damage(rand(50, 70), BRUTE, wound_bonus = CANT_WOUND)

	addtimer(CALLBACK(src, PROC_REF(Apotheosis_end), user), 6 SECONDS)
	playsound(boomspot, 'sound/items/weapons/punch1.ogg', 50, TRUE, -1)
	explosion(user, devastation_range = plasma_power, heavy_impact_range = plasma_power*2, light_impact_range = plasma_power*4, ignorecap = TRUE, explosion_cause = src)
	plasma_power = 1 //just in case there is any clever way to cause it to happen again
	return TRUE

/datum/martial_art/plasma_fist/proc/Apotheosis_end(mob/living/dying)
	dying.remove_traits(list(TRAIT_FORCED_STANDING, TRAIT_BOMBIMMUNE), type)
	if(dying.stat == DEAD)
		return
	dying.investigate_log("has been killed by plasma fist apotheosis.", INVESTIGATE_DEATHS)
	dying.death()

/datum/martial_art/plasma_fist/harm_act(mob/living/attacker, mob/living/defender)
	if(defender.check_block(attacker, 10, attacker.name, UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL

	add_to_streak("H", defender)
	return check_streak(attacker, defender) ? MARTIAL_ATTACK_SUCCESS : MARTIAL_ATTACK_INVALID

/datum/martial_art/plasma_fist/disarm_act(mob/living/attacker, mob/living/defender)
	if(defender.check_block(attacker, 0, attacker.name, UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL
	add_to_streak("D", defender)
	if(check_streak(attacker, defender))
		return MARTIAL_ATTACK_SUCCESS
	if(attacker == defender)//there is no disarming yourself, so we need to let plasma fist user know
		to_chat(attacker, span_notice(LANG("datum.12457fbf1e6c5c89", null)))
		return MARTIAL_ATTACK_FAIL
	return MARTIAL_ATTACK_INVALID

/datum/martial_art/plasma_fist/grab_act(mob/living/attacker, mob/living/defender)
	if(defender.check_block(attacker, 0, "[attacker]'s grab", UNARMED_ATTACK))
		return MARTIAL_ATTACK_FAIL

	add_to_streak("G", defender)
	return check_streak(attacker, defender) ? MARTIAL_ATTACK_SUCCESS : MARTIAL_ATTACK_INVALID

/datum/martial_art/plasma_fist/get_style_help()
	. = list()

	var/datum/martial_art/plasma_fist/martial = GET_ACTIVE_MARTIAL_ART(holder)
	. += LANG("datum.b438a2302d86204b", null)
	. += LANG("datum.7b04489135e2d755", list(span_notice("Tornado Sweep")))
	. += LANG("datum.519e0700aed9ba58", list(span_notice("Throwback")))
	. += LANG("datum.ff9d30998434ad4b", list(span_notice("The Plasma Fist"), martial.nobomb ? "" : " Each kill with this grows your [span_notice("Apotheosis")] explosion size."))
	if(!martial.nobomb)
		. += LANG("datum.6824d3fba662fbd1", list(span_notice("Apotheosis"), span_notice("The Plasma Fist")))
	return .


/obj/effect/temp_visual/plasma_soul
	name = "plasma energy"
	desc = "Leftover energy brought out from The Plasma Fist."
	icon = 'icons/effects/effects.dmi'
	icon_state = "plasmasoul"
	duration = 3 SECONDS
	var/atom/movable/beam_target

/obj/effect/temp_visual/plasma_soul/Initialize(mapload, _beam_target)
	. = ..()
	beam_target = _beam_target
	if(beam_target)
		var/datum/beam/beam = Beam(beam_target, "plasmabeam", beam_type=/obj/effect/ebeam/plasma_fist, time = 3 SECONDS)
		animate(beam.visuals, alpha = 0, time = 3 SECONDS)
	animate(src, alpha = 0, transform = matrix()*0.5, time = 3 SECONDS)

/obj/effect/temp_visual/plasma_soul/Destroy()
	if(!beam_target)
		visible_message(span_notice(LANG("obj.32e6546290dd75df", list(src))))
	. = ..()

/obj/effect/ebeam/plasma_fist
	name = "plasma"
	mouse_opacity = MOUSE_OPACITY_ICON
	desc = "Flowing energy."

/datum/martial_art/plasma_fist/nobomb
	name = "Novice Plasma Fist"
	nobomb = TRUE

#undef TORNADO_COMBO
#undef THROWBACK_COMBO
#undef PLASMA_COMBO
