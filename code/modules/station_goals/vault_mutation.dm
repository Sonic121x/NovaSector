
/datum/mutation/breathless
	name = "Breathless"
	desc = "一种皮肤内的突变，允许通过皮肤过滤和吸收氧气。"
	text_gain_indication = span_notice("你的肺部感觉棒极了。")
	text_lose_indication = span_warning("你的肺部感觉恢复正常了。")
	locked = TRUE

/datum/mutation/breathless/on_acquiring(mob/living/carbon/human/acquirer)
	. = ..()
	ADD_TRAIT(acquirer, TRAIT_NOBREATH, GENETIC_MUTATION)

/datum/mutation/breathless/on_losing(mob/living/carbon/human/owner)//this shouldnt happen under normal condition but just to be sure
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_NOBREATH, GENETIC_MUTATION)

/datum/mutation/quick
	name = "Quick"
	desc = "一种腿部肌肉内的突变，使其能以比通常容量高出20%的效率运作。"
	text_gain_indication = span_notice("你的双腿感觉更快更强壮了。")
	text_lose_indication = span_warning("你的双腿感觉更虚弱更迟缓了。")
	locked = TRUE

/datum/mutation/quick/on_acquiring(mob/living/carbon/human/acquirer)
	. = ..()
	acquirer.add_movespeed_modifier(/datum/movespeed_modifier/dna_vault_speedup)

/datum/mutation/quick/on_losing(mob/living/carbon/human/owner)
	. = ..()
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/dna_vault_speedup)

/datum/mutation/tough
	name = "Tough"
	desc = "一种表皮内的突变，使其更抗撕裂。"
	text_gain_indication = span_notice("你的皮肤感觉更坚韧了。")
	text_lose_indication = span_warning("你的皮肤感觉更脆弱了。")
	locked = TRUE

/datum/mutation/tough/on_acquiring(mob/living/carbon/human/acquirer)
	. = ..()
	acquirer.physiology.brute_mod *= 0.7
	ADD_TRAIT(acquirer, TRAIT_PIERCEIMMUNE, GENETIC_MUTATION)

/datum/mutation/tough/on_losing(mob/living/carbon/human/owner)
	. = ..()
	owner.physiology.brute_mod /= 0.7
	REMOVE_TRAIT(owner, TRAIT_PIERCEIMMUNE, GENETIC_MUTATION)

/datum/mutation/dextrous
	name = "Dextrous"
	desc = "一种神经系统内的突变，允许更灵敏和更快速的动作。"
	text_gain_indication = span_notice("你的肢体感觉更灵巧、反应更灵敏了。")
	text_lose_indication = span_warning("你的肢体感觉不那么灵巧和灵敏了。")
	locked = TRUE

/datum/mutation/dextrous/on_acquiring(mob/living/carbon/human/acquirer)
	. = ..()
	acquirer.next_move_modifier *= 0.5

/datum/mutation/dextrous/on_losing(mob/living/carbon/human/owner)
	. = ..()
	owner.next_move_modifier /= 0.5

/datum/mutation/fire_immunity
	name = "Fire Immunity"
	desc = "一种身体内的突变，使其变得不可燃并能承受更高的温度。"
	text_gain_indication = span_notice("你的身体感觉能够抵御火焰了。")
	text_lose_indication = span_warning("你的身体感觉再次容易受到火焰伤害了。")
	locked = TRUE

/datum/mutation/fire_immunity/on_acquiring(mob/living/carbon/human/acquirer)
	. = ..()
	acquirer.physiology.burn_mod *= 0.5
	acquirer.add_traits(list(TRAIT_RESISTHEAT, TRAIT_NOFIRE), GENETIC_MUTATION)

/datum/mutation/fire_immunity/on_losing(mob/living/carbon/human/owner)
	. = ..()
	owner.physiology.burn_mod /= 0.5
	owner.remove_traits(list(TRAIT_RESISTHEAT, TRAIT_NOFIRE), GENETIC_MUTATION)

/datum/mutation/quick_recovery
	name = "Quick Recovery"
	desc = "神经系统中的一种突变，使其能够从被击倒状态中恢复。"
	text_gain_indication = span_notice("你感觉自己能更容易地从跌倒中恢复。")
	text_lose_indication = span_warning("你感觉从跌倒中恢复又变得困难了。")
	locked = TRUE

/datum/mutation/quick_recovery/on_acquiring(mob/living/carbon/human/acquirer)
	. = ..()
	acquirer.physiology.stun_mod *= 0.5

/datum/mutation/quick_recovery/on_losing(mob/living/carbon/human/owner)
	. = ..()
	owner.physiology.stun_mod /= 0.5

/datum/mutation/plasmocile
	name = "Plasmocile"
	desc = "肺部的一种突变，使其对等离子体的毒性具有免疫力。"
	text_gain_indication = span_notice("你的肺部感觉对空气污染物有了抵抗力。")
	text_lose_indication = span_warning("你的肺部感觉再次对空气污染物变得脆弱。")
	locked = TRUE

/datum/mutation/plasmocile/on_acquiring(mob/living/carbon/human/acquirer)
	. = ..()
	var/obj/item/organ/lungs/improved_lungs = acquirer.get_organ_slot(ORGAN_SLOT_LUNGS)
	ADD_TRAIT(owner, TRAIT_VIRUSIMMUNE, GENETIC_MUTATION)
	if(improved_lungs)
		apply_buff(improved_lungs)
	RegisterSignal(acquirer, COMSIG_CARBON_LOSE_ORGAN, PROC_REF(remove_modification))
	RegisterSignal(acquirer, COMSIG_CARBON_GAIN_ORGAN, PROC_REF(reapply_modification))

/datum/mutation/plasmocile/on_losing(mob/living/carbon/human/owner)
	. = ..()
	var/obj/item/organ/lungs/improved_lungs = owner.get_organ_slot(ORGAN_SLOT_LUNGS)
	REMOVE_TRAIT(owner, TRAIT_VIRUSIMMUNE, GENETIC_MUTATION)
	UnregisterSignal(owner, COMSIG_CARBON_LOSE_ORGAN)
	UnregisterSignal(owner, COMSIG_CARBON_GAIN_ORGAN)
	if(improved_lungs)
		remove_buff(improved_lungs)

/datum/mutation/plasmocile/proc/remove_modification(mob/source, obj/item/organ/old_organ)
	SIGNAL_HANDLER

	if(istype(old_organ, /obj/item/organ/lungs))
		remove_buff(old_organ)

/datum/mutation/plasmocile/proc/reapply_modification(mob/source, obj/item/organ/new_organ)
	SIGNAL_HANDLER

	if(istype(new_organ, /obj/item/organ/lungs))
		apply_buff(new_organ)

/datum/mutation/plasmocile/proc/apply_buff(obj/item/organ/lungs/our_lungs)
	our_lungs.plas_breath_dam_min *= 0
	our_lungs.plas_breath_dam_max *= 0

/datum/mutation/plasmocile/proc/remove_buff(obj/item/organ/lungs/our_lungs)
	our_lungs.plas_breath_dam_min = initial(our_lungs.plas_breath_dam_min)
	our_lungs.plas_breath_dam_max = initial(our_lungs.plas_breath_dam_max)
