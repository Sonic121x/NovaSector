/obj/item/key
	name = "钥匙"
	desc = "一把灰钥匙。"
	icon = 'icons/mob/rideables/vehicles.dmi'
	icon_state = "key"
	w_class = WEIGHT_CLASS_TINY

/obj/item/key/atv
	name = "全地形车钥匙"
	desc = "一个灰色的小钥匙，用于启动和操作全地形车。"

/obj/item/key/security
	desc = "一个带有钢钥匙的钥匙环，以及一个橡胶制的电棍附件。"
	icon_state = "keysec"

/obj/item/key/security/suicide_act(mob/living/carbon/user)
	if(!user.emote("spin")) //In the off chance that someone attempts this suicide while under the effects of mime's bane they deserve the silliness.
		user.visible_message(span_suicide("[user]正把\the [src]塞进[user.p_their()]耳朵里并启动[user.p_their()]马达！看起来[user.p_theyre()]试图自杀……但[user.p_they()]噼啪作响然后熄火了！"))
		playsound(src, 'sound/misc/sadtrombone.ogg', 50, TRUE, -1)
		return SHAME
	user.visible_message(span_suicide("[user] 正把 \the [src] 塞进 [user.p_their()] 耳朵里并启动 [user.p_their()] 马达！看起来 [user.p_theyre()] 想自杀！"))
	user.say("Vroom vroom!!", forced="secway key suicide") //Not doing a shamestate here, because even if they fail to speak they're spinning.
	addtimer(CALLBACK(user, TYPE_PROC_REF(/mob/living/, gib)), 2 SECONDS)
	return MANUAL_SUICIDE

/obj/item/key/janitor
	desc = "一个带有小钢钥匙的钥匙环，还有一个粉色的挂坠，上面写着“猫咪马车”。"
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

/obj/item/key/janitor/suicide_act(mob/living/carbon/user)
	switch(user.mind?.get_skill_level(/datum/skill/cleaning))
		if(SKILL_LEVEL_NONE to SKILL_LEVEL_NOVICE) //Their mind is too weak to ascend as a janny
			user.visible_message(span_suicide("[user] is putting \the [src] in [user.p_their()] mouth and is trying to become one with the janicart, but has no idea where to start! It looks like [user.p_theyre()] trying to commit suicide!"))
			user.gib(DROP_ALL_REMAINS)
			return MANUAL_SUICIDE
		if(SKILL_LEVEL_APPRENTICE to SKILL_LEVEL_JOURNEYMAN) //At least they tried
			user.visible_message(span_suicide("[user] 正把 \the [src] 塞进 [user.p_their()] 嘴里，并低效地与清洁车融为一体！看起来 [user.p_theyre()] 试图自杀！"))
			user.AddElement(/datum/element/cleaning)
			addtimer(CALLBACK(src, PROC_REF(manual_suicide), user), 5.1 SECONDS)
			return MANUAL_SUICIDE
		if(SKILL_LEVEL_EXPERT to SKILL_LEVEL_MASTER) //They are worthy enough, but can it go even further beyond?
			user.visible_message(span_suicide("[user] is putting \the [src] in [user.p_their()] mouth and has skillfully become one with the janicart! It looks like [user.p_theyre()] trying to commit suicide!"))
			user.AddElement(/datum/element/cleaning)
			for(var/i in 1 to 100)
				addtimer(CALLBACK(user, TYPE_PROC_REF(/atom, add_atom_colour), (i % 2)? "#a245bb" : "#7a7d82", ADMIN_COLOUR_PRIORITY), i)
			addtimer(CALLBACK(src, PROC_REF(manual_suicide), user), 101)
			return MANUAL_SUICIDE
		if(SKILL_LEVEL_LEGENDARY to INFINITY) //Holy shit, look at that janny go!
			user.visible_message(span_suicide("[user]正把\the [src]塞进[user.p_their()]嘴里，史诗般地与清洁车合为一体，甚至还开启了超速模式！看起来[user.p_theyre()]想自杀！"))
			user.AddElement(/datum/element/cleaning)
			playsound(src, 'sound/effects/magic/lightning_chargeup.ogg', 50, TRUE, -1)
			user.reagents.add_reagent(/datum/reagent/drug/methamphetamine, 10) //Gotta go fast!
			for(var/i in 1 to 150)
				addtimer(CALLBACK(user, TYPE_PROC_REF(/atom, add_atom_colour), (i % 2)? "#a245bb" : "#7a7d82", ADMIN_COLOUR_PRIORITY), i)
			addtimer(CALLBACK(src, PROC_REF(manual_suicide), user), 151)
			return MANUAL_SUICIDE

/obj/item/key/proc/manual_suicide(mob/living/user)
	if(user)
		user.remove_atom_colour(ADMIN_COLOUR_PRIORITY)
		user.visible_message(span_suicide("[user] 忘了 [user.p_they()] 其实不是清洁车！这得挨板子！"))
		if(user.mind?.get_skill_level(/datum/skill/cleaning) >= SKILL_LEVEL_LEGENDARY) //Janny janny janny janny janny
			playsound(src, 'sound/effects/adminhelp.ogg', 50, TRUE, -1)
		user.adjust_oxy_loss(200)
		user.death(FALSE)

/obj/item/key/lasso
	name = "骨套索"
	desc = "指挥戈利亚的完美工具！要是它能让他们跑得更快就好了……"
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
