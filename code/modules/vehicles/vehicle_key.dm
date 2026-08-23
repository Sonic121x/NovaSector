// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
/obj/item/key
	name = "key"
	desc = "A small grey key."
	icon = 'icons/mob/rideables/vehicles.dmi'
	icon_state = "key"
	w_class = WEIGHT_CLASS_TINY

/obj/item/key/atv
	name = "ATV key"
	desc = "A small grey key for starting and operating ATVs."

/obj/item/key/security
	desc = "A keyring with a small steel key, and a rubber stun baton accessory."
	icon_state = "keysec"

/obj/item/key/security/suicide_act(mob/living/user)
	if(!user.emote("spin")) //In the off chance that someone attempts this suicide while under the effects of mime's bane they deserve the silliness.
		user.visible_message(span_suicide(LANG("obj.5ae8d40f9f356c5a", list(user, src, user.p_their(), user.p_their(), user.p_theyre(), user.p_they()))))
		playsound(src, 'sound/misc/sadtrombone.ogg', 50, TRUE, -1)
		return SHAME
	user.visible_message(span_suicide(LANG("obj.123df82b210c827a", list(user, src, user.p_their(), user.p_their(), user.p_theyre()))))
	user.say(LANG("obj.8f412ba8b3c65a28", null), forced="secway key suicide") //Not doing a shamestate here, because even if they fail to speak they're spinning.
	addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living/, gib)), 2 SECONDS)
	return MANUAL_SUICIDE

/obj/item/key/janitor
	desc = "A keyring with a small steel key, and a pink fob reading \"Pussy Wagon\"."
	icon_state = "keyjanitor"
	icon_angle = 90
	force = 2
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 9
	hitsound = SFX_SWING_HIT
	attack_verb_continuous = list("stubs", "pokes")
	attack_verb_simple = list("stub", "poke")
	sharpness = SHARP_EDGED
	embed_type = /datum/embedding/janicart_key
	wound_bonus = -1
	exposed_wound_bonus = 2

/datum/embedding/janicart_key
	pain_mult = 1
	embed_chance = 30
	fall_chance = 70

/obj/item/key/janitor/suicide_act(mob/living/user)
	switch(user.mind?.get_skill_level(/datum/skill/cleaning))
		if(SKILL_LEVEL_APPRENTICE to SKILL_LEVEL_JOURNEYMAN) //At least they tried
			user.visible_message(span_suicide(LANG("obj.4f12769c6f885cb4", list(user, src, user.p_their(), user.p_theyre()))))
			user.AddElement(/datum/element/cleaning)
			addtimer(CALLBACK(src, PROC_REF(manual_suicide), user), 5.1 SECONDS)
			return MANUAL_SUICIDE
		if(SKILL_LEVEL_EXPERT to SKILL_LEVEL_MASTER) //They are worthy enough, but can it go even further beyond?
			user.visible_message(span_suicide(LANG("obj.7da5f440d9e9916c", list(user, src, user.p_their(), user.p_theyre()))))
			user.AddElement(/datum/element/cleaning)
			for(var/i in 1 to 100)
				addtimer(CALLBACK(user, TYPE_PROC_REF(/atom, add_atom_colour), (i % 2)? "#a245bb" : "#7a7d82", ADMIN_COLOUR_PRIORITY), i)
			addtimer(CALLBACK(src, PROC_REF(manual_suicide), user), 101)
			return MANUAL_SUICIDE
		if(SKILL_LEVEL_LEGENDARY to INFINITY) //Holy shit, look at that janny go!
			user.visible_message(span_suicide(LANG("obj.a84023f0c3ece465", list(user, src, user.p_their(), user.p_theyre()))))
			user.AddElement(/datum/element/cleaning)
			playsound(src, 'sound/effects/magic/lightning_chargeup.ogg', 50, TRUE, -1)
			user.reagents.add_reagent(/datum/reagent/drug/methamphetamine, 10) //Gotta go fast!
			for(var/i in 1 to 150)
				addtimer(CALLBACK(user, TYPE_PROC_REF(/atom, add_atom_colour), (i % 2)? "#a245bb" : "#7a7d82", ADMIN_COLOUR_PRIORITY), i)
			addtimer(CALLBACK(src, PROC_REF(manual_suicide), user), 151)
			return MANUAL_SUICIDE

	//Their mind is too weak to ascend as a janny
	user.visible_message(span_suicide(LANG("obj.b0e75caeaf5a0b6c", list(user, src, user.p_their(), user.p_theyre()))))
	user.gib(DROP_ALL_REMAINS)
	return MANUAL_SUICIDE

/obj/item/key/proc/manual_suicide(mob/living/user)
	if(user)
		user.remove_atom_colour(ADMIN_COLOUR_PRIORITY)
		user.visible_message(span_suicide(LANG("obj.9974d9e613ea206d", list(user, user.p_they(), user.p_are()))))
		if(user.mind?.get_skill_level(/datum/skill/cleaning) >= SKILL_LEVEL_LEGENDARY) //Janny janny janny janny janny
			playsound(src, 'sound/effects/adminhelp.ogg', 50, TRUE, -1)
		user.adjust_oxy_loss(200)
		user.death(FALSE)

/obj/item/key/lasso
	name = "bone lasso"
	desc = "The perfect tool for directing a Goliath! If only it made them move any faster..."
	force = 12
	icon_state = "lasso"
	inhand_icon_state = "chain"
	worn_icon_state = "whip"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	attack_verb_continuous = list("flogs", "whips", "lashes", "disciplines")
	attack_verb_simple = list("flog", "whip", "lash", "discipline")
	hitsound = 'sound/items/weapons/whip.ogg'
	slot_flags = ITEM_SLOT_BELT
	custom_materials = list(/datum/material/bone = SHEET_MATERIAL_AMOUNT)
