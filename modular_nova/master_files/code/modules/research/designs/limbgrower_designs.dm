/datum/design/leftarm/New()
	category += list(SPECIES_SNAIL)
	return ..()

/datum/design/rightarm/New()
	category += list(SPECIES_SNAIL)
	return ..()

/datum/design/leftleg/New()
	category += list(SPECIES_SNAIL)
	return ..()

/datum/design/rightleg/New()
	category += list(SPECIES_SNAIL)
	return ..()

/datum/design/tongue/snail
	name = "蜗牛舌头"
	id = "snailtongue"
	build_path = /obj/item/organ/tongue/snail
	category = list(
		SPECIES_SNAIL,
		RND_CATEGORY_INITIAL,
	)

/datum/design/liver/snail
	name = "蜗牛肝脏"
	id = "snailliver"
	build_path = /obj/item/organ/liver/snail
	category = list(
		SPECIES_SNAIL,
		RND_CATEGORY_INITIAL,
	)

/datum/design/heart/snail
	name = "蜗牛心脏"
	id = "snailheart"
	build_path = /obj/item/organ/heart/snail
	category = list(
		SPECIES_SNAIL,
		RND_CATEGORY_INITIAL,
	)
