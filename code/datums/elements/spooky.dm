/datum/element/spooky
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 2
	///will it spawn a new instrument
	var/too_spooky = TRUE
	///If, once someone is skeletonized, the element is detached
	var/single_use = FALSE
	///The base multiplier of stamina damage applied by the item
	var/stam_damage_mult

/datum/element/spooky/Attach(datum/target, too_spooky = TRUE, single_use = FALSE, stam_damage_mult = 1)
	. = ..()
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE
	src.too_spooky = too_spooky
	src.single_use = single_use
	src.stam_damage_mult = stam_damage_mult
	RegisterSignal(target, COMSIG_ITEM_ATTACK, PROC_REF(spectral_attack))

/datum/element/spooky/Detach(datum/source)
	UnregisterSignal(source, COMSIG_ITEM_ATTACK)
	return ..()

/datum/element/spooky/proc/spectral_attack(datum/source, mob/living/carbon/target, mob/user)
	SIGNAL_HANDLER

	if(ishuman(user) && !isskeleton(user)) //this weapon wasn't meant for mortals.
		var/mob/living/carbon/human/human_user = user
		if(rattle_bones(human_user, stam_dam_mult = stam_damage_mult * 2))
			to_chat(human_user, span_userdanger("你的耳朵本不该承受这种灵异之声。"))
			INVOKE_ASYNC(src, PROC_REF(spectral_change), human_user, user, source)
		return

	to_chat(target, span_userdanger("<b>DOOT</b"))

	if(isskeleton(target)) // skeletons are totally immune, no redundant skeletonization or bad mood event.
		return

	target.add_mood_event("spooked", /datum/mood_event/spooked)

	if(!ishuman(target))//the sound will spook basic mobs.
		target.set_jitter_if_lower(30 SECONDS)
		target.set_stutter(40 SECONDS)
		return

	var/mob/living/carbon/human/human = target
	if(rattle_bones(human))
		INVOKE_ASYNC(src, PROC_REF(spectral_change), human, user, source)

///Cause jitteriness and stamina to the target relative to the amount of their bodyparts made of flesh and bone.
/datum/element/spooky/proc/rattle_bones(mob/living/carbon/human/human, stam_dam_mult = stam_damage_mult)
	if(isskeleton(human))
		return FALSE //undeads are unaffected by the spook-pocalypse.
	var/bone_amount = 0
	for(var/obj/item/bodypart/part as anything in human.get_bodyparts())
		if((part.biological_state & BIO_FLESH_BONE) == BIO_FLESH_BONE)
			bone_amount++
	if(bone_amount)
		human.set_jitter_if_lower(12 SECONDS * bone_amount)
		human.set_stutter(6.5 SECONDS * bone_amount)
		human.adjust_stamina_loss(3 * bone_amount * stam_dam_mult)
	if(iszombie(human))
		human.adjust_stamina_loss(25)
		human.Paralyze(15) //zombies can't resist the doot
	return bone_amount

/datum/element/spooky/proc/spectral_change(mob/living/carbon/human/human, mob/living/user, obj/item/source)
	if(human.get_stamina_loss() <= 95)
		return

	if(single_use)
		to_chat(user, span_warning("你觉得[source]已经失去了它的灵异感..."))
		Detach(source)

	human.Paralyze(2 SECONDS)
	human.set_species(/datum/species/skeleton)
	human.visible_message(span_warning("[human]已经放弃了作为凡人的生活。"))
	to_chat(human, span_boldnotice("你是一个灵异骷髅！"))
	to_chat(human,
		span_boldnotice("A new life and identity has begun.\
		[too_spooky ? "Help your fellow skeletons into bringing out the spooky-pocalypse." : ""] \
		You haven't forgotten your past life, and are still beholden to past loyalties.")
	)
	INVOKE_ASYNC(src, PROC_REF(change_name), human) //time for a new name!

	if(!too_spooky)
		return
	var/turf/turf = get_turf(human)
	if(!prob(90))
		to_chat(human, span_boldwarning("灵异之神忘了给你配送乐器。下次亡灵生活祝你好运。"))
		return
	var/obj/item/instrument = pick(
		/obj/item/instrument/saxophone/spectral,
		/obj/item/instrument/trumpet/spectral,
		/obj/item/instrument/trombone/spectral,
	)
	new instrument(turf)

/datum/element/spooky/proc/change_name(mob/living/carbon/human/spooked)
	var/skeleton_name = spooked.client ? sanitize_name(tgui_input_text(spooked, "输入你的新骷髅名字", "骷髅化器", spooked.real_name, MAX_NAME_LEN)) : null
	if(!skeleton_name)
		skeleton_name = "\improper spooky skeleton"
	spooked.fully_replace_character_name(null, skeleton_name)
