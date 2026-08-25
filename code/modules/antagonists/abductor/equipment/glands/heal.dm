// NOVA EDIT - I18N CODEMOD - 玩家可见字符串已改写为 LANG()；请勿手改 key，见 modular_nova/modules/i18n/readme.md
#define REJECTION_VOMIT_FLAGS (MOB_VOMIT_BLOOD | MOB_VOMIT_STUN | MOB_VOMIT_KNOCKDOWN | MOB_VOMIT_FORCE)

/obj/item/organ/heart/gland/heal
	abductor_hint = "organic replicator. Forcibly ejects damaged and robotic organs from the abductee and regenerates them. Additionally, forcibly removes reagents (via vomit) from the abductee if they have moderate toxin damage or poison within the bloodstream, and regenerates blood to a healthy threshold if too low. The abductee will also reject implants such as mindshields."
	cooldown_low = 200
	cooldown_high = 400
	uses = -1
	human_only = TRUE
	icon_state = "health"
	mind_control_uses = 3
	mind_control_duration = 3000

/obj/item/organ/heart/gland/heal/activate()
	if(!(owner.mob_biotypes & MOB_ORGANIC))
		return

	for(var/implant in owner.implants)
		reject_implant(implant)
		return

	for(var/organ in owner.organs)
		if(istype(organ, /obj/item/organ/cyberimp))
			reject_cyberimp(organ)
			return

	var/obj/item/organ/appendix/appendix = owner.get_organ_slot(ORGAN_SLOT_APPENDIX)
	if((!appendix && !HAS_TRAIT(owner, TRAIT_NOHUNGER)) || (appendix && ((appendix.organ_flags & ORGAN_FAILING) || IS_ROBOTIC_ORGAN(appendix))))
		replace_appendix(appendix)
		return

	var/obj/item/organ/liver/liver = owner.get_organ_slot(ORGAN_SLOT_LIVER)
	if((!liver && !HAS_TRAIT(owner, TRAIT_LIVERLESS_METABOLISM)) || (liver && ((liver.damage > liver.high_threshold) || IS_ROBOTIC_ORGAN(liver))))
		replace_liver(liver)
		return

	var/obj/item/organ/lungs/lungs = owner.get_organ_slot(ORGAN_SLOT_LUNGS)
	if((!lungs && !HAS_TRAIT(owner, TRAIT_NOBREATH)) || (lungs && ((lungs.damage > lungs.high_threshold) || IS_ROBOTIC_ORGAN(lungs))))
		replace_lungs(lungs)
		return

	var/obj/item/organ/stomach/stomach = owner.get_organ_slot(ORGAN_SLOT_STOMACH)
	if((!stomach && !HAS_TRAIT(owner, TRAIT_NOHUNGER)) || (stomach && ((stomach.damage > stomach.high_threshold) || IS_ROBOTIC_ORGAN(stomach))))
		replace_stomach(stomach)
		return

	var/obj/item/organ/eyes/eyes = owner.get_organ_slot(ORGAN_SLOT_EYES)
	if(!eyes || (eyes && ((eyes.damage > eyes.low_threshold) || IS_ROBOTIC_ORGAN(eyes))))
		replace_eyes(eyes)
		return

	var/obj/item/bodypart/limb
	var/list/limb_list = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	for(var/zone in limb_list)
		limb = owner.get_bodypart(zone)
		if(!limb)
			replace_limb(zone)
			return
		if((limb.get_damage() >= (limb.max_damage / 2)) || (!IS_ORGANIC_LIMB(limb)) && !HAS_TRAIT(owner, TRAIT_NODISMEMBER))
			replace_limb(zone, limb)
			return

	if(owner.get_tox_loss() > 40)
		replace_blood()
		return
	var/tox_amount = 0
	for(var/datum/reagent/toxin/T in owner.reagents.reagent_list)
		tox_amount += owner.reagents.get_reagent_amount(T.type)
	if(tox_amount > 10)
		replace_blood()
		return
	if(owner.get_blood_volume() < BLOOD_VOLUME_OKAY)
		owner.set_blood_volume(BLOOD_VOLUME_NORMAL)
		to_chat(owner, span_warning(LANG("obj.1789724b748c579e", null)))
		return

	var/obj/item/bodypart/chest/chest = owner.get_bodypart(BODY_ZONE_CHEST)
	if((chest.get_damage() >= (chest.max_damage / 4)) || (!IS_ORGANIC_LIMB(chest)))
		replace_chest(chest)
		return

/obj/item/organ/heart/gland/heal/proc/reject_implant(obj/item/implant/implant)
	owner.visible_message(span_warning(LANG("obj.0d2d59cc5dd0cb86", list(owner))), span_userdanger(LANG("obj.660e3923cf7b471d", null)))
	owner.vomit(REJECTION_VOMIT_FLAGS, lost_nutrition = 0)
	implant.removed(owner)
	qdel(implant)

/obj/item/organ/heart/gland/heal/proc/reject_cyberimp(obj/item/organ/cyberimp/implant)
	owner.visible_message(span_warning(LANG("obj.aa7a48433df3bf7c", list(owner, implant.name))), span_userdanger(LANG("obj.d856989fbee670b8", list(implant.name))))
	owner.vomit(REJECTION_VOMIT_FLAGS, lost_nutrition = 0)
	implant.Remove(owner)
	implant.forceMove(owner.drop_location())

/obj/item/organ/heart/gland/heal/proc/replace_appendix(obj/item/organ/appendix/appendix)
	if(appendix)
		owner.vomit(REJECTION_VOMIT_FLAGS, lost_nutrition = 0)
		appendix.Remove(owner)
		appendix.forceMove(owner.drop_location())
		owner.visible_message(span_warning(LANG("obj.aa7a48433df3bf7c", list(owner, appendix.name))), span_userdanger(LANG("obj.d856989fbee670b8", list(appendix.name))))
	else
		to_chat(owner, span_warning(LANG("obj.9a4fda06a12cacc2", null)))

	var/appendix_type = /obj/item/organ/appendix
	if(owner?.dna?.species?.mutantappendix)
		appendix_type = owner.dna.species.mutantappendix
	var/obj/item/organ/appendix/new_appendix = new appendix_type()
	new_appendix.Insert(owner)

/obj/item/organ/heart/gland/heal/proc/replace_liver(obj/item/organ/liver/liver)
	if(liver)
		owner.visible_message(span_warning(LANG("obj.aa7a48433df3bf7c", list(owner, liver.name))), span_userdanger(LANG("obj.d856989fbee670b8", list(liver.name))))
		owner.vomit(REJECTION_VOMIT_FLAGS, lost_nutrition = 0)
		liver.Remove(owner)
		liver.forceMove(owner.drop_location())
	else
		to_chat(owner, span_warning(LANG("obj.9a4fda06a12cacc2", null)))

	var/liver_type = /obj/item/organ/liver
	if(owner?.dna?.species?.mutantliver)
		liver_type = owner.dna.species.mutantliver
	var/obj/item/organ/liver/new_liver = new liver_type()
	new_liver.Insert(owner)

/obj/item/organ/heart/gland/heal/proc/replace_lungs(obj/item/organ/lungs/lungs)
	if(lungs)
		owner.visible_message(span_warning(LANG("obj.aa7a48433df3bf7c", list(owner, lungs.name))), span_userdanger(LANG("obj.d856989fbee670b8", list(lungs.name))))
		owner.vomit(REJECTION_VOMIT_FLAGS, lost_nutrition = 0)
		lungs.Remove(owner)
		lungs.forceMove(owner.drop_location())
	else
		to_chat(owner, span_warning(LANG("obj.a5d60c89039caebf", null)))

	var/lung_type = /obj/item/organ/lungs
	if(owner.dna.species && owner.dna.species.mutantlungs)
		lung_type = owner.dna.species.mutantlungs
	var/obj/item/organ/lungs/new_lungs = new lung_type()
	new_lungs.Insert(owner)

/obj/item/organ/heart/gland/heal/proc/replace_stomach(obj/item/organ/stomach/stomach)
	if(stomach)
		owner.visible_message(span_warning(LANG("obj.aa7a48433df3bf7c", list(owner, stomach.name))), span_userdanger(LANG("obj.d856989fbee670b8", list(stomach.name))))
		owner.vomit(REJECTION_VOMIT_FLAGS, lost_nutrition = 0)
		stomach.Remove(owner)
		stomach.forceMove(owner.drop_location())
	else
		to_chat(owner, span_warning(LANG("obj.9a4fda06a12cacc2", null)))

	var/stomach_type = /obj/item/organ/stomach
	if(owner?.dna?.species?.mutantstomach)
		stomach_type = owner.dna.species.mutantstomach
	var/obj/item/organ/stomach/new_stomach = new stomach_type()
	new_stomach.Insert(owner)

/obj/item/organ/heart/gland/heal/proc/replace_eyes(obj/item/organ/eyes/eyes)
	if(eyes)
		owner.visible_message(span_warning(LANG("obj.bf8b3951e09c4385", list(owner, eyes.name))), span_userdanger(LANG("obj.e9136315f2e9ce13", list(eyes.name))))
		playsound(owner, 'sound/effects/splat.ogg', 50, TRUE)
		eyes.Remove(owner)
		eyes.forceMove(owner.drop_location())
	else
		to_chat(owner, span_warning(LANG("obj.1f4d42cff3a73ec1", null)))

	addtimer(CALLBACK(src, PROC_REF(finish_replace_eyes)), rand(10 SECONDS, 20 SECONDS))

/obj/item/organ/heart/gland/heal/proc/finish_replace_eyes()
	var/eye_type = /obj/item/organ/eyes
	if(owner.dna.species && owner.dna.species.mutanteyes)
		eye_type = owner.dna.species.mutanteyes
	var/obj/item/organ/eyes/new_eyes = new eye_type()
	new_eyes.Insert(owner)
	owner.visible_message(span_warning(LANG("obj.7738bdea56bdb41b", list(owner))), span_userdanger(LANG("obj.f97e445491b745a2", null)))

/obj/item/organ/heart/gland/heal/proc/replace_limb(body_zone, obj/item/bodypart/limb)
	if(limb)
		owner.visible_message(span_warning(LANG("obj.9e0571b725672c8c", list(owner, limb.plaintext_zone, owner.p_their()))), span_userdanger(LANG("obj.2e5743221cea31b4", list(limb.plaintext_zone))))
		playsound(owner, SFX_DESECRATION, 50, TRUE, -1)
		limb.drop_limb()
	else
		to_chat(owner, span_warning(LANG("obj.2e9c29e38ee5b78e", list(parse_zone(body_zone)))))

	addtimer(CALLBACK(src, PROC_REF(finish_replace_limb), body_zone), rand(15 SECONDS, 30 SECONDS))

/obj/item/organ/heart/gland/heal/proc/finish_replace_limb(body_zone)
	owner.visible_message(span_warning(LANG("obj.a80bf4ff3e9f443d", list(owner, parse_zone(body_zone), owner.p_their()))),
	span_userdanger(LANG("obj.ce7bc49b3b1b7394", list(parse_zone(body_zone)))),
	span_warning(LANG("obj.7bc209536a390eab", null)))
	playsound(owner, 'sound/effects/magic/demon_consume.ogg', 50, TRUE)
	owner.regenerate_limb(body_zone)

/obj/item/organ/heart/gland/heal/proc/replace_blood()
	owner.visible_message(span_warning(LANG("obj.f1e152a50718aaac", list(owner))), span_userdanger(LANG("obj.93305a2cfc287529", null)))
	keep_replacing_blood()

/obj/item/organ/heart/gland/heal/proc/keep_replacing_blood()
	var/keep_going = FALSE
	owner.vomit(vomit_flags = (MOB_VOMIT_BLOOD | MOB_VOMIT_FORCE), lost_nutrition = 0, distance = 3)
	owner.Stun(15)
	owner.adjust_tox_loss(-15, forced = TRUE)

	owner.adjust_blood_volume(20, maximum = BLOOD_VOLUME_NORMAL)
	if(owner.get_blood_volume() < BLOOD_VOLUME_NORMAL)
		keep_going = TRUE

	if(owner.get_tox_loss())
		keep_going = TRUE
	for(var/datum/reagent/toxin/R in owner.reagents.reagent_list)
		owner.reagents.remove_reagent(R.type, 4)
		if(owner.reagents.has_reagent(R.type))
			keep_going = TRUE
	if(keep_going)
		addtimer(CALLBACK(src, PROC_REF(keep_replacing_blood)), 3 SECONDS)

/obj/item/organ/heart/gland/heal/proc/replace_chest(obj/item/bodypart/chest/chest)
	if(!IS_ORGANIC_LIMB(chest))
		owner.visible_message(span_warning(LANG("obj.e9299a3525829e48", list(owner, chest.name))), span_userdanger(LANG("obj.c1398d06253c914b", list(chest.name))))
		playsound(owner, 'sound/effects/magic/clockwork/anima_fragment_attack.ogg', 50, TRUE)
		var/list/dirs = GLOB.alldirs.Copy()
		for(var/i in 1 to 3)
			var/obj/effect/decal/cleanable/blood/gibs/robot_debris/debris = new(get_turf(owner))
			debris.streak(dirs)
	else
		owner.visible_message(span_warning(LANG("obj.ec420bae61afa532", list(owner, chest.name))), span_warning(LANG("obj.3562fa4b7f31abf3", list(chest.name))))
		playsound(owner, 'sound/effects/splat.ogg', 50, TRUE)
		var/list/dirs = GLOB.alldirs.Copy()
		for(var/i in 1 to 3)
			var/obj/effect/decal/cleanable/blood/gibs/gibs = new(get_turf(owner), owner.get_static_viruses(), blood_dna_info)
			gibs.streak(dirs)

	var/obj/item/bodypart/chest/new_chest = new(null)
	new_chest.replace_limb(owner)
	qdel(chest)

#undef REJECTION_VOMIT_FLAGS
