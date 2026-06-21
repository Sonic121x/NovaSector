
//generally nanotrasen themed corpses

/obj/effect/mob_spawn/corpse/human/bridgeofficer
	name = "舰桥军官"
	outfit = /datum/outfit/nanotrasenbridgeofficer

/datum/outfit/nanotrasenbridgeofficer
	name = "舰桥军官"
	ears = /obj/item/radio/headset/heads/hop
	uniform = /obj/item/clothing/under/rank/centcom/officer
	suit = /obj/item/clothing/suit/armor/bulletproof
	shoes = /obj/item/clothing/shoes/sneakers/black
	glasses = /obj/item/clothing/glasses/sunglasses
	id = /obj/item/card/id/advanced/centcom
	id_trim = /datum/id_trim/centcom/corpse/bridge_officer

/obj/effect/mob_spawn/corpse/human/commander
	name = "指挥官"
	outfit = /datum/outfit/nanotrasencommander

/datum/outfit/nanotrasencommander
	name = "\improper 纳米传讯私人安全指挥官"
	uniform = /obj/item/clothing/under/rank/centcom/commander
	suit = /obj/item/clothing/suit/armor/bulletproof
	ears = /obj/item/radio/headset/heads/captain
	glasses = /obj/item/clothing/glasses/eyepatch
	mask = /obj/item/cigarette/cigar/cohiba
	head = /obj/item/clothing/head/hats/centhat
	gloves = /obj/item/clothing/gloves/tackler/combat
	shoes = /obj/item/clothing/shoes/combat/swat
	r_pocket = /obj/item/lighter
	id = /obj/item/card/id/advanced/centcom
	id_trim = /datum/id_trim/centcom/corpse/commander

/obj/effect/mob_spawn/corpse/human/nanotrasensoldier
	name = "\improper 纳米传讯私人安全官"
	outfit = /datum/outfit/nanotrasensoldier

/datum/outfit/nanotrasensoldier
	name = "纳米传讯私人安全官"
	uniform = /obj/item/clothing/under/rank/security/officer
	suit = /obj/item/clothing/suit/armor/vest
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/tackler/combat
	mask = /obj/item/clothing/mask/gas/sechailer/swat
	head = /obj/item/clothing/head/helmet/swat/nanotrasen
	back = /obj/item/storage/backpack/security
	id = /obj/item/card/id/advanced
	id_trim = /datum/id_trim/centcom/corpse/private_security

/obj/effect/mob_spawn/corpse/human/intern //this is specifically the comms intern from the event
	name = "中央指挥部实习生"
	outfit = /datum/outfit/centcom/centcom_intern/unarmed
	mob_name = "Nameless Intern"

/obj/effect/mob_spawn/corpse/human/intern/special(mob/living/carbon/human/spawned_human, mob/mob_possessor, apply_prefs)
	. = ..()
	spawned_human.gender = MALE //we're making it canon babies
	spawned_human.update_body()
