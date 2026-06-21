/obj/item/dnainjector
	name = "\improper DNA注射器"
	desc = "一种廉价的单次使用自动注射器，可为使用者注入DNA。"
	icon = 'icons/obj/medical/syringe.dmi'
	icon_state = "dnainjector"
	inhand_icon_state = "dnainjector"
	worn_icon_state = "pen"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_TINY

	/// Modified to damage caused from injection, currently unused though
	var/damage_coeff = 1
	/// Adds all mutations in this list to the injected mob, activating it rather than mutating it if possible.
	var/list/add_mutations
	/// If the injected mob has any mutations in this list activated or mutated, they will be removed.
	var/list/remove_mutations
	/// Tracks if it's been used
	VAR_FINAL/used = FALSE
	/// Duration of the mutations added/activated or DNA changes. Does not affect removed mutations.
	var/duration = INFINITY
	/// A DNA datum that has its fields copied to the target on injection.
	var/datum/dna/stored_dna

/obj/item/dnainjector/Initialize(mapload, datum/dna/stored_dna, damage_coeff = 1)
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)
	if(used)
		update_appearance()
	src.stored_dna = stored_dna
	src.damage_coeff = damage_coeff

/obj/item/dnainjector/Destroy()
	if(stored_dna?.holder)
		stack_trace("DNA injector got owned DNA somehow")
		stored_dna = null
	else
		QDEL_NULL(stored_dna)
	return ..()

/obj/item/dnainjector/vv_edit_var(vname, vval)
	. = ..()
	if(vname == NAMEOF(src, used))
		update_appearance()

/obj/item/dnainjector/update_icon_state()
	. = ..()
	icon_state = inhand_icon_state = "[initial(icon_state)][used ? "0" : null]"

/obj/item/dnainjector/update_desc(updates)
	. = ..()
	desc = "[initial(desc)][used ? "This one is used up." : null]"

/obj/item/dnainjector/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/item/dnainjector/proc/inject(mob/living/carbon/target, mob/user)
	if(!target.can_mutate())
		return FALSE
	if(target.stat == DEAD) //prevents dead people from having their DNA changed
		to_chat(user, span_notice("你没法在[target.p_theyre()]死了的时候调整[target]的DNA."))
		return FALSE
	for(var/removed_mutation in remove_mutations)
		target.dna.remove_mutation(removed_mutation, GLOB.standard_mutation_sources)

	for(var/datum/mutation/added_mutation as anything in add_mutations)
		if(added_mutation::warn_admins_on_inject && target != user && !ismonkey(target))
			message_admins("[ADMIN_LOOKUPFLW(user)] injected [key_name_admin(target)] with [src] containing [added_mutation::name].")
		if(target.dna.mutation_in_sequence(added_mutation))
			target.dna.activate_mutation(added_mutation)
			if(duration != INFINITY)
				addtimer(CALLBACK(target.dna, TYPE_PROC_REF(/datum/dna, remove_mutation), added_mutation, MUTATION_SOURCE_ACTIVATED), duration)
		else
			target.dna.add_mutation(added_mutation, MUTATION_SOURCE_MUTATOR)
			if(duration != INFINITY)
				addtimer(CALLBACK(target.dna, TYPE_PROC_REF(/datum/dna, remove_mutation), added_mutation, MUTATION_SOURCE_MUTATOR), duration)

	if(stored_dna)
		target.apply_status_effect(/datum/status_effect/temporary_transformation/dna_injector, duration, stored_dna)
	return TRUE

/obj/item/dnainjector/attack(mob/target, mob/user)
	if(!ISADVANCEDTOOLUSER(user))
		to_chat(user, span_warning("你没有足够的灵巧度来做这件事！"))
		return
	if(used)
		to_chat(user, span_warning("这个注射器用光了!"))
		return
	if(ishuman(target))
		var/mob/living/carbon/human/humantarget = target
		if (!humantarget.try_inject(user, injection_flags = INJECT_TRY_SHOW_ERROR_MESSAGE))
			return
	log_combat(user, target, "attempted to inject", src)

	if(target != user)
		target.visible_message(span_danger("[user]尝试向[target]注射[src]!"), \
			span_userdanger("[user]尝试向你注射[src]."))
		if(!do_after(user, 3 SECONDS, target) || used)
			return
		target.visible_message(span_danger("[user]用含有[src]的注射器注射[target]"), \
						span_userdanger("[user]用含有[src]的注射器向你注射."))

	else
		to_chat(user, span_notice("你给自己注射了[src]."))

	log_combat(user, target, "injected", src)

	if(!inject(target, user)) //Now we actually do the heavy lifting.
		to_chat(user, span_notice("[target]看起来没有可兼容的DNA。"))
		return

	used = TRUE
	update_appearance()

/obj/item/dnainjector/timed
	duration = 60 SECONDS

/obj/item/dnainjector/timed/hulk
	name = "\improper DNA注射器（浩克）"
	desc = "这会让你变得又大又壮，但也会让你患上严重的皮肤病。"
	add_mutations = list(/datum/mutation/hulk)

/obj/item/dnainjector/timed/h2m
	name = "\improper DNA注射器（人类 > 猴子）"
	desc = "会让你变成个跳蚤包。"
	add_mutations = list(/datum/mutation/race)

/obj/item/dnainjector/activator
	name = "\improper DNA激活器"
	desc = "注射时激活当前突变，如果受试者拥有该突变。"
	var/force_mutate = FALSE
	var/research = FALSE //Set to true to get expended and filled injectors for chromosomes
	var/filled = FALSE
	var/crispr_charge = FALSE // Look for viruses, look at symptoms, if research and Dormant DNA Activator or Viral Evolutionary Acceleration, set to true

/obj/item/dnainjector/activator/inject(mob/living/carbon/target, mob/user)
	if(!target.can_mutate())
		return FALSE
	for(var/mutation in add_mutations)
		var/datum/mutation/added_mutation = mutation
		if(istype(added_mutation, /datum/mutation))
			mutation = added_mutation.type
		if(!target.dna.activate_mutation(added_mutation))
			if(force_mutate)
				target.dna.add_mutation(added_mutation, MUTATION_SOURCE_MUTATOR)
		else if(research && target.client)
			filled = TRUE
		for(var/datum/disease/advance/disease in target.diseases)
			for(var/datum/symptom/symp in disease.symptoms)
				if((symp.type == /datum/symptom/genetic_mutation) || (symp.type == /datum/symptom/viralevolution))
					crispr_charge = TRUE
		log_combat(user, target, "[!force_mutate ? "failed to inject" : "injected"]", "[src] ([mutation])[crispr_charge ? " with CRISPR charge" : ""]")
	return TRUE

/// DNA INJECTORS

/obj/item/dnainjector/acidflesh
	name = "\improper DNA注射器（酸蚀血肉）"
	add_mutations = list(/datum/mutation/acidflesh)

/obj/item/dnainjector/antiacidflesh
	name = "\improper DNA注射器（酸蚀血肉）"
	remove_mutations = list(/datum/mutation/acidflesh)

/obj/item/dnainjector/antenna
	name = "\improper DNA注射器（触角）"
	add_mutations = list(/datum/mutation/antenna)

/obj/item/dnainjector/antiantenna
	name = "\improper DNA注射器（抗触角）"
	remove_mutations = list(/datum/mutation/antenna)

/obj/item/dnainjector/antiglow
	name = "\improper DNA注射器（抗发光）"
	add_mutations = list(/datum/mutation/glow/anti)

/obj/item/dnainjector/removeantiglow
	name = "\improper DNA注射器（抗抗发光）"
	remove_mutations = list(/datum/mutation/glow/anti)

/obj/item/dnainjector/blindmut
	name = "\improper DNA注射器（失明）"
	desc = "让你什么都看不见。"
	add_mutations = list(/datum/mutation/blind)

/obj/item/dnainjector/antiblind
	name = "\improper DNA注射器（抗失明）"
	desc = "这真是个奇迹！！！"
	remove_mutations = list(/datum/mutation/blind)

/obj/item/dnainjector/chameleonmut
	name = "\improper DNA注射器（变色龙）"
	add_mutations = list(/datum/mutation/chameleon)

/obj/item/dnainjector/antichameleon
	name = "\improper DNA注射器（抗变色龙）"
	remove_mutations = list(/datum/mutation/chameleon)

/obj/item/dnainjector/chavmut
	name = "\improper DNA注射器（小混混）"
	add_mutations = list(/datum/mutation/chav)

/obj/item/dnainjector/antichav
	name = "\improper DNA注射器（抗小混混）"
	remove_mutations = list(/datum/mutation/chav)

/obj/item/dnainjector/clumsymut
	name = "\improper DNA注射器（笨拙）"
	desc = "制造小丑仆从。"
	add_mutations = list(/datum/mutation/clumsy)

/obj/item/dnainjector/anticlumsy
	name = "\improper DNA注射器（抗笨拙）"
	desc = "给安保小丑使用。"
	remove_mutations = list(/datum/mutation/clumsy)

/obj/item/dnainjector/coughmut
	name = "\improper DNA注射器（咳嗽）"
	desc = "会从你的喉咙里发出恐怖的声音。"
	add_mutations = list(/datum/mutation/cough)

/obj/item/dnainjector/anticough
	name = "\improper DNA注射器（抗咳嗽）"
	desc = "会停止那可怕的声音。"
	remove_mutations = list(/datum/mutation/cough)

/obj/item/dnainjector/cryokinesis
	name = "\improper DNA注射器（低温操控）"
	add_mutations = list(/datum/mutation/cryokinesis)

/obj/item/dnainjector/anticryokinesis
	name = "\improper DNA注射器（抗低温操控）"
	remove_mutations = list(/datum/mutation/cryokinesis)

/obj/item/dnainjector/deafmut
	name = "\improper DNA注射器（耳聋）"
	desc = "抱歉，你刚才说什么？"
	add_mutations = list(/datum/mutation/deaf)

/obj/item/dnainjector/antideaf
	name = "\improper DNA注射器（抗耳聋）"
	desc = "将让你重获听力。"
	remove_mutations = list(/datum/mutation/deaf)

/obj/item/dnainjector/dwarf
	name = "\improper DNA注射器（侏儒症）"
	desc = "毕竟是个小世界。"
	add_mutations = list(/datum/mutation/dwarfism)

/obj/item/dnainjector/antidwarf
	name = "\improper DNA注射器（抗侏儒症）"
	desc = "助你长得高大强壮。"
	remove_mutations = list(/datum/mutation/dwarfism)

/obj/item/dnainjector/elvismut
	name = "\improper DNA注射器（猫王）"
	add_mutations = list(/datum/mutation/elvis)

/obj/item/dnainjector/antielvis
	name = "\improper DNA注射器（抗猫王）"
	remove_mutations = list(/datum/mutation/elvis)

/obj/item/dnainjector/epimut
	name = "\improper DNA注射器（癫痫）"
	desc = "摇啊摇啊摇动房间！"
	add_mutations = list(/datum/mutation/epilepsy)

/obj/item/dnainjector/antiepi
	name = "\improper DNA注射器（抗癫痫）"
	desc = "将把你从摇动房间的状态中修复。"
	remove_mutations = list(/datum/mutation/epilepsy)

/obj/item/dnainjector/geladikinesis
	name = "\improper DNA注射器（凝冰术）"
	add_mutations = list(/datum/mutation/geladikinesis)

/obj/item/dnainjector/antigeladikinesis
	name = "\improper DNA注射器（抗凝冰术）"
	remove_mutations = list(/datum/mutation/geladikinesis)

/obj/item/dnainjector/gigantism
	name = "\improper DNA注射器（巨人症）"
	add_mutations = list(/datum/mutation/gigantism)

/obj/item/dnainjector/antigigantism
	name = "\improper DNA注射器（抗巨人症）"
	remove_mutations = list(/datum/mutation/gigantism)

/obj/item/dnainjector/glassesmut
	name = "\improper DNA注射器（眼镜）"
	desc = "会让你需要书呆子眼镜。"
	add_mutations = list(/datum/mutation/nearsight)

/obj/item/dnainjector/antiglasses
	name = "\improper DNA注射器（抗眼镜）"
	desc = "丢掉那些眼镜吧！"
	remove_mutations = list(/datum/mutation/nearsight)

/obj/item/dnainjector/glow
	name = "\improper DNA注射器（发光）"
	add_mutations = list(/datum/mutation/glow)

/obj/item/dnainjector/removeglow
	name = "\improper DNA注射器（抗发光）"
	remove_mutations = list(/datum/mutation/glow)

/obj/item/dnainjector/hulkmut
	name = "\improper DNA注射器（浩克）"
	desc = "这会让你变得高大强壮，但也会让你患上严重的皮肤病。"
	add_mutations = list(/datum/mutation/hulk)

/obj/item/dnainjector/antihulk
	name = "\improper DNA注射器（抗浩克）"
	desc = "治愈绿皮肤。"
	remove_mutations = list(/datum/mutation/hulk)

/obj/item/dnainjector/h2m
	name = "\improper DNA注射器（人类 > 猴子）"
	desc = "会让你变成跳蚤袋。"
	add_mutations = list(/datum/mutation/race)

/obj/item/dnainjector/m2h
	name = "\improper DNA注射器（猴子 > 人类）"
	desc = "会让你……毛发少一些。"
	remove_mutations = list(/datum/mutation/race)

/obj/item/dnainjector/illiterate
	name = "\improper DNA注射器（文盲）"
	add_mutations = list(/datum/mutation/illiterate)

/obj/item/dnainjector/antiilliterate
	name = "\improper DNA注射器（抗文盲）"
	remove_mutations = list(/datum/mutation/illiterate)

/obj/item/dnainjector/insulated
	name = "\improper DNA注射器（绝缘）"
	add_mutations = list(/datum/mutation/insulated)

/obj/item/dnainjector/antiinsulated
	name = "\improper DNA注射器（抗绝缘）"
	remove_mutations = list(/datum/mutation/insulated)

/obj/item/dnainjector/lasereyesmut
	name = "\improper DNA注射器（激光眼）"
	add_mutations = list(/datum/mutation/laser_eyes)

/obj/item/dnainjector/antilasereyes
	name = "\improper DNA注射器（抗激光眼）"
	remove_mutations = list(/datum/mutation/laser_eyes)

/obj/item/dnainjector/mindread
	name = "\improper DNA注射器（读心）"
	add_mutations = list(/datum/mutation/mindreader)

/obj/item/dnainjector/antimindread
	name = "\improper DNA注射器（抗读心）"
	remove_mutations = list(/datum/mutation/mindreader)

/obj/item/dnainjector/mutemut
	name = "\improper DNA注射器（失声）"
	add_mutations = list(/datum/mutation/mute)

/obj/item/dnainjector/antimute
	name = "\improper DNA注射器（抗失声）"
	remove_mutations = list(/datum/mutation/mute)

/obj/item/dnainjector/olfaction
	name = "\improper DNA注射器（嗅觉强化）"
	add_mutations = list(/datum/mutation/olfaction)

/obj/item/dnainjector/antiolfaction
	name = "\improper DNA注射器（抗嗅觉强化）"
	remove_mutations = list(/datum/mutation/olfaction)

/obj/item/dnainjector/piglatinmut
	name = "\improper DNA注射器（猪拉丁语）"
	add_mutations = list(/datum/mutation/piglatin)

/obj/item/dnainjector/antipiglatin
	name = "\improper DNA注射器（抗猪拉丁语）"
	remove_mutations = list(/datum/mutation/piglatin)

/obj/item/dnainjector/paranoia
	name = "\improper DNA注射器（偏执狂）"
	add_mutations = list(/datum/mutation/paranoia)

/obj/item/dnainjector/antiparanoia
	name = "\improper DNA注射器（抗偏执狂）"
	remove_mutations = list(/datum/mutation/paranoia)

/obj/item/dnainjector/pressuremut
	name = "\improper DNA注射器（压力适应）"
	desc = "赋予你火焰抗性。"
	add_mutations = list(/datum/mutation/adaptation/pressure)

/obj/item/dnainjector/antipressure
	name = "\improper DNA注射器（抗压力适应）"
	desc = "治愈火焰伤害。"
	remove_mutations = list(/datum/mutation/adaptation/pressure)

/obj/item/dnainjector/radioactive
	name = "\improper DNA注射器（放射性）"
	add_mutations = list(/datum/mutation/radioactive)

/obj/item/dnainjector/antiradioactive
	name = "\improper DNA注射器（抗放射性）"
	remove_mutations = list(/datum/mutation/radioactive)

/obj/item/dnainjector/shock
	name = "\improper DNA注射器（电击触摸）"
	add_mutations = list(/datum/mutation/shock)

/obj/item/dnainjector/antishock
	name = "\improper DNA注射器（抗电击触摸）"
	remove_mutations = list(/datum/mutation/shock)

/obj/item/dnainjector/spastic
	name = "\improper DNA注射器（痉挛症）"
	add_mutations = list(/datum/mutation/spastic)

/obj/item/dnainjector/antispastic
	name = "\improper DNA注射器（抗痉挛症）"
	remove_mutations = list(/datum/mutation/spastic)

/obj/item/dnainjector/spatialinstability
	name = "\improper DNA注射器（空间失稳）"
	add_mutations = list(/datum/mutation/badblink)

/obj/item/dnainjector/antispatialinstability
	name = "\improper DNA注射器（抗空间失稳）"
	remove_mutations = list(/datum/mutation/badblink)

/obj/item/dnainjector/stuttmut
	name = "\improper DNA注射器（口吃症）"
	desc = "让你变-变-变成结巴。"
	add_mutations = list(/datum/mutation/nervousness)

/obj/item/dnainjector/antistutt
	name = "\improper DNA注射器（抗口吃）"
	desc = "修复那种语言障碍。"
	remove_mutations = list(/datum/mutation/nervousness)

/obj/item/dnainjector/swedishmut
	name = "\improper DNA注射器（瑞典语）"
	add_mutations = list(/datum/mutation/swedish)

/obj/item/dnainjector/antiswedish
	name = "\improper DNA注射器（抗瑞典语）"
	remove_mutations = list(/datum/mutation/swedish)

/obj/item/dnainjector/telemut
	name = "\improper DNA注射器（心灵传动）"
	desc = "超级大脑念力！"
	add_mutations = list(/datum/mutation/telekinesis)

/obj/item/dnainjector/telemut/darkbundle
	name = "\improper DNA注射器"
	desc = "很好。让仇恨在你体内流淌。"

/obj/item/dnainjector/antitele
	name = "\improper DNA注射器（抗心灵传动）"
	desc = "将使你无法控制自己的心智。"
	remove_mutations = list(/datum/mutation/telekinesis)

/obj/item/dnainjector/firemut
	name = "\improper DNA注射器（温度适应）"
	desc = "赋予你火焰。"
	add_mutations = list(/datum/mutation/adaptation/thermal)

/obj/item/dnainjector/antifire
	name = "\improper DNA注射器（抗温度适应）"
	desc = "治愈火焰。"
	remove_mutations = list(/datum/mutation/adaptation/thermal)

/obj/item/dnainjector/thermal
	name = "\improper DNA注射器（热视觉）"
	add_mutations = list(/datum/mutation/thermal)

/obj/item/dnainjector/antithermal
	name = "\improper DNA注射器（抗热视觉）"
	remove_mutations = list(/datum/mutation/thermal)

/obj/item/dnainjector/tourmut
	name = "\improper DNA注射器（秽语症）"
	desc = "让你患上严重的秽语症。"
	add_mutations = list(/datum/mutation/tourettes)

/obj/item/dnainjector/antitour
	name = "\improper DNA注射器（抗秽语症）"
	desc = "将治愈秽语症。"
	remove_mutations = list(/datum/mutation/tourettes)

/obj/item/dnainjector/twoleftfeet
	name = "\improper DNA注射器（同手同脚）"
	add_mutations = list(/datum/mutation/extrastun)

/obj/item/dnainjector/antitwoleftfeet
	name = "\improper DNA注射器（抗同手同脚）"
	remove_mutations = list(/datum/mutation/extrastun)

/obj/item/dnainjector/unintelligiblemut
	name = "\improper DNA注射器（语无伦次）"
	add_mutations = list(/datum/mutation/unintelligible)

/obj/item/dnainjector/antiunintelligible
	name = "\improper DNA注射器（抗语无伦次）"
	remove_mutations = list(/datum/mutation/unintelligible)

/obj/item/dnainjector/void
	name = "\improper DNA注射器（虚空）"
	add_mutations = list(/datum/mutation/void)

/obj/item/dnainjector/antivoid
	name = "\improper DNA注射器（抗虚空）"
	remove_mutations = list(/datum/mutation/void)

/obj/item/dnainjector/xraymut
	name = "\improper DNA注射器（X射线）"
	desc = "终于能看见船长在干什么了。"
	add_mutations = list(/datum/mutation/xray)

/obj/item/dnainjector/antixray
	name = "\improper DNA注射器（抗X射线）"
	desc = "它会让你看得更清楚。"
	remove_mutations = list(/datum/mutation/xray)

/obj/item/dnainjector/wackymut
	name = "\improper DNA注射器（古怪）"
	add_mutations = list(/datum/mutation/wacky)

/obj/item/dnainjector/antiwacky
	name = "\improper DNA注射器（抗古怪）"
	remove_mutations = list(/datum/mutation/wacky)

/obj/item/dnainjector/webbing
	name = "\improper DNA注射器（蹼化）"
	add_mutations = list(/datum/mutation/webbing)

/obj/item/dnainjector/antiwebbing
	name = "\improper DNA注射器（抗蹼化）"
	remove_mutations = list(/datum/mutation/webbing)

/obj/item/dnainjector/clever
	name = "\improper DNA注射器（聪慧）"
	add_mutations = list(/datum/mutation/clever)

/obj/item/dnainjector/anticlever
	name = "\improper DNA注射器（抗聪慧）"
	remove_mutations = list(/datum/mutation/clever)
