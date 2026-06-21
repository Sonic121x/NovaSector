/*
 * Tier zero entries are unlocked at the start, and are for dna mutants that are:
 * - a roundstart race (felinid)
 * - something of equal power to a roundstart race (flyperson)
 * - mutants without a bonus, just bringing cosmetics (fox ears)
 * basically just meme, cosmetic, and base species entries
*/
/datum/infuser_entry/fly
	name = "排斥"
	infuse_mob_name = "rejected creature"
	desc = "无论出于何种原因，当身体排斥DNA时，DNA会变质，最终变成某种类似苍蝇的DNA混合物。"
	threshold_desc = "the DNA mess takes over, and you become a full-fledged flyperson."
	qualities = list(
		"buzzy-like speech",
		"vomit drinking",
		"unidentifiable organs",
		"this is a bad idea",
	)
	output_organs = list(
		/obj/item/organ/appendix/fly,
		/obj/item/organ/eyes/fly,
		/obj/item/organ/heart/fly,
		/obj/item/organ/lungs/fly,
		/obj/item/organ/stomach/fly,
		/obj/item/organ/tongue/fly,
	)
	infusion_desc = "fly-like"
	tier = DNA_MUTANT_TIER_ZERO

/datum/infuser_entry/vulpini
	name = "狐狸"
	infuse_mob_name = "vulpini"
	desc = "狐狸现在相当稀有，因为2555年的“狐耳”热潮。我的意思是，也因为我们作为太空旅行者，早在很久以前就摧毁了狐狸的自然栖息地，但这适用于大多数动物。"
	threshold_desc = DNA_INFUSION_NO_THRESHOLD
	qualities = list(
		"oh come on really",
		"you bring SHAME to all geneticists",
		"i hope it was worth it",
	)
	input_obj_or_mob = list(
		/mob/living/basic/pet/fox,
	)
	output_organs = list(
		/obj/item/organ/ears/fox,
	)
	infusion_desc = "inexcusable"
	tier = DNA_MUTANT_TIER_ZERO

/datum/infuser_entry/mothroach
	name = "蛾螂"
	infuse_mob_name = "lepi-blattidae"
	desc = "所以他们先是混合了飞蛾和蟑螂的DNA来制造蛾螂，现在我们又混合蛾螂DNA与人形生物来制造蛾人混种？"
	threshold_desc = DNA_INFUSION_NO_THRESHOLD
	qualities = list(
		"eyes weak to bright lights",
		"you flutter when you talk",
		"wings that can't even carry your body weight",
		"i hope it was worth it",
	)
	input_obj_or_mob = list(
		/mob/living/basic/mothroach,
	)
	output_organs = list(
		/obj/item/organ/antennae,
		/obj/item/organ/wings/moth,
		/obj/item/organ/eyes/moth,
		/obj/item/organ/tongue/moth,
	)
	infusion_desc = "fluffy"
	tier = DNA_MUTANT_TIER_ZERO

/datum/infuser_entry/lizard
	name = "蜥蜴"
	infuse_mob_name = "lacertilia"
	desc = "事实证明，将大多数类人生物与蜥蜴DNA融合后，会产生与蜥蜴人惊人相似的特征。多么奇怪的巧合。"
	threshold_desc = DNA_INFUSION_NO_THRESHOLD
	qualities = list(
		"long tails",
		"decorative horns",
		"aesthetic snouts",
		"not much honestly",
	)
	input_obj_or_mob = list(
		/mob/living/basic/lizard,
	)
	output_organs = list(
		/obj/item/organ/horns,
		/obj/item/organ/frills,
		/obj/item/organ/snout,
		/obj/item/organ/tail/lizard,
		/obj/item/organ/tongue/lizard,
	)
	infusion_desc = "scaly"
	tier = DNA_MUTANT_TIER_ZERO

/datum/infuser_entry/felinid
	name = "猫"
	infuse_mob_name = "feline"
	desc = "大家冷静！我并没有通过这个条目暗示任何东西。我们真的对猫人是混有猫科动物DNA的人类感到如此惊讶吗？"
	threshold_desc = DNA_INFUSION_NO_THRESHOLD
	qualities = list(
		"oh, let me guess, you're a big fan of those Japanese tourist bots",
	)
	input_obj_or_mob = list(
		/mob/living/basic/pet/cat,
	)
	output_organs = list(
		/obj/item/organ/ears/cat,
		/obj/item/organ/tail/cat,
	)
	infusion_desc = "domestic"
	tier = DNA_MUTANT_TIER_ZERO

/datum/infuser_entry/penguin
	name = "Penguin"
	infuse_mob_name = "penguin"
	desc = "Honestly, there wasn't much to gleam from a penguin's DNA, other than they walk funny."
	threshold_desc = DNA_INFUSION_NO_THRESHOLD
	qualities = list(
		"you waddle when you walk",
	)
	input_obj_or_mob = list(
		/mob/living/basic/pet/penguin,
	)
	output_organs = list(
		/obj/item/organ/ears/penguin,
	)
	infusion_desc = "waddly"
	tier = DNA_MUTANT_TIER_ZERO

/datum/infuser_entry/plants
	name = "Plant"
	infuse_mob_name = "plant hybrid"
	desc = "Hydroponics research has long been interested in splicing human DNA into plant DNA, creating podpeople. \
		Many scientists didn't want to let those hippies get the leg up on them, so they attempted the opposite - to pretty uninteresting results."
	threshold_desc = DNA_INFUSION_NO_THRESHOLD
	qualities = list(
		"gives you neat hair",
		"not much else, honestly",
	)
	input_obj_or_mob = list(
		/obj/item/food/grown,
		/obj/item/grown,
	)
	output_organs = list(
		/obj/item/organ/appendix/pod,
		/obj/item/organ/brain/pod,
		/obj/item/organ/ears/pod,
		/obj/item/organ/eyes/pod,
		/obj/item/organ/heart/pod,
		/obj/item/organ/liver/pod,
		/obj/item/organ/lungs/pod,
		/obj/item/organ/pod_hair,
		/obj/item/organ/stomach/pod,
		/obj/item/organ/tongue/pod,
	)
	infusion_desc = "botanical"
	tier = DNA_MUTANT_TIER_ZERO

/datum/infuser_entry/plants/get_output_organs(mob/living/carbon/human/target, atom/movable/infused_from)
	// Prioritize pod hair since it's the only thing that matters here
	if(!target.get_organ_by_type(/obj/item/organ/pod_hair))
		return list(/obj/item/organ/pod_hair)

	return ..()
