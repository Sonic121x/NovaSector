/*
 * Dehydrated Carp
 * Instant carp, just add water
 */

//Child of carpplushie because this should do everything the toy does and more
/obj/item/toy/plush/carpplushie/dehy_carp
	offspring_type = /obj/item/toy/plush/carpplushie
	var/mob/owner = null //Carp doesn't attack owner, set when using in hand
	var/mobtype = /mob/living/basic/carp //So admins can change what mob spawns via var fuckery
	var/swelling = FALSE
	flags_1 = parent_type::flags_1 | NO_NEW_GAGS_PREVIEW_1

//Attack self
/obj/item/toy/plush/carpplushie/dehy_carp/attack_self(mob/user)
	if(owner)
		return ..()
	add_fingerprint(user)
	to_chat(user, span_notice("你抚摸[src].你发誓它抬头看向了你."))
	owner = user
	RegisterSignal(owner, COMSIG_QDELETING, PROC_REF(owner_deleted))

/obj/item/toy/plush/carpplushie/dehy_carp/proc/Swell()
	if(swelling)
		return
	swelling = TRUE
	desc = "它在长大！"
	visible_message(span_notice("[src]膨胀起来了！"))

	//Animation
	icon = 'icons/mob/simple/carp.dmi'
	flick("carp_swell", src)
	//Wait for animation to end
	addtimer(CALLBACK(src, PROC_REF(spawn_carp)), 0.6 SECONDS)

/obj/item/toy/plush/carpplushie/dehy_carp/suicide_act(mob/living/carbon/human/user)
	user.visible_message(span_suicide("[user]开始吃[src]。看起来[user.p_theyre()]试图自杀！"))
	playsound(src, 'sound/items/eatfood.ogg', 50, TRUE)
	if(!istype(user))
		return BRUTELOSS
	user.Paralyze(3 SECONDS)
	forceMove(user) //we move it AWAAAYY
	sleep(2 SECONDS)
	if(QDELETED(src))
		return SHAME
	if(!QDELETED(user))
		user.spawn_gibs()
		user.apply_damage(200, def_zone = BODY_ZONE_CHEST)
		forceMove(drop_location()) //we move it back
	swelling = TRUE
	icon = 'icons/mob/simple/carp.dmi'
	flick("carp_swell", src)
	addtimer(CALLBACK(src, PROC_REF(spawn_carp)), 0.6 SECONDS)
	return BRUTELOSS

/obj/item/toy/plush/carpplushie/dehy_carp/proc/spawn_carp()
	if(QDELETED(src))//we got toasted while animating
		return
	//Make space carp
	var/mob/living/spawned_mob = new mobtype(get_turf(src), owner)
	//Make carp non-hostile to user
	if(owner)
		spawned_mob.set_allies(list("[REF(owner)]"))
		spawned_mob.grant_language(/datum/language/common, UNDERSTOOD_LANGUAGE, LANGUAGE_ATOM)
	for(var/mob/living/viewer in viewers(5, get_turf(src)))
		to_chat(viewer, viewer == owner ? span_notice("新长成的[spawned_mob.name]用友善的眼神抬头看着你。") : span_warning("你对此有种不祥的预感。"))
	qdel(src)

/obj/item/toy/plush/carpplushie/dehy_carp/proc/owner_deleted(datum/source)
	SIGNAL_HANDLER

	UnregisterSignal(owner, COMSIG_QDELETING)
	owner = null

/obj/item/toy/plush/carpplushie/dehy_carp/peaceful
	mobtype = /mob/living/basic/carp/passive
	flags_1 = parent_type::flags_1 | NO_NEW_GAGS_PREVIEW_1
