//Biosuit complete with shoes (in the item sprite)
/obj/item/clothing/head/bio_hood
	name = "生物防化头罩"
	icon_state = "bio"
	inhand_icon_state = "bio_hood"
	desc = "一种保护头部和面部免受生物污染的头罩。"
	icon = 'icons/obj/clothing/head/bio.dmi'
	worn_icon = 'icons/mob/clothing/head/bio.dmi'
	icon_state = "bio"
	inhand_icon_state = "bio_hood"
	clothing_flags = THICKMATERIAL | BLOCK_GAS_SMOKE_EFFECT | SNUG_FIT | STACKABLE_HELMET_EXEMPT | HEADINTERNALS
	armor_type = /datum/armor/head_bio_hood
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR|HIDEFACE|HIDESNOUT
	resistance_flags = ACID_PROOF
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	// Icon_state passed into clothing dirt component
	var/dirt_state = "bio_dirt"

/obj/item/clothing/head/bio_hood/Initialize(mapload)
	. = ..()
	if (dirt_state)
		AddComponent(/datum/component/clothing_dirt, dirt_state)
	AddElement(/datum/element/adjust_fishing_difficulty, 6)
	AddComponent(/datum/component/hat_stabilizer, loose_hat = TRUE)

/datum/armor/head_bio_hood
	bio = 100
	fire = 30
	acid = 100

/obj/item/clothing/suit/bio_suit
	name = "生物防化服"
	desc = "防止生物污染的衣服。"
	icon = 'icons/obj/clothing/suits/bio.dmi'
	icon_state = "bio"
	worn_icon = 'icons/mob/clothing/suits/bio.dmi'
	inhand_icon_state = "bio_suit"
	w_class = WEIGHT_CLASS_BULKY
	clothing_flags = THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	slowdown = 0.5
	allowed = list(/obj/item/tank/internals, /obj/item/reagent_containers/dropper, /obj/item/flashlight/pen, /obj/item/reagent_containers/syringe, /obj/item/reagent_containers/hypospray, /obj/item/reagent_containers/cup/beaker, /obj/item/gun/syringe)
	armor_type = /datum/armor/suit_bio_suit
	flags_inv = HIDEGLOVES|HIDEJUMPSUIT|HIDEBELT
	strip_delay = 7 SECONDS
	equip_delay_other = 7 SECONDS
	resistance_flags = ACID_PROOF

/obj/item/clothing/suit/bio_suit/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/adjust_fishing_difficulty, 6)

//Standard biosuit, orange stripe
/datum/armor/suit_bio_suit
	bio = 100
	fire = 30
	acid = 100

/obj/item/clothing/head/bio_hood/general
	icon_state = "bio"

/obj/item/clothing/suit/bio_suit/general
	icon_state = "bio"

//Virology biosuit, green stripe
/obj/item/clothing/head/bio_hood/virology
	icon_state = "bio_virology"

/obj/item/clothing/suit/bio_suit/virology
	icon_state = "bio_virology"

//Security biosuit, grey with red stripe across the chest
/obj/item/clothing/head/bio_hood/security
	armor_type = /datum/armor/bio_hood_security
	icon_state = "bio_security"

/datum/armor/bio_hood_security
	melee = 25
	bullet = 15
	laser = 25
	energy = 35
	bomb = 25
	bio = 100
	fire = 30
	acid = 100

/obj/item/clothing/suit/bio_suit/security
	armor_type = /datum/armor/bio_suit_security
	icon_state = "bio_security"

/datum/armor/bio_suit_security
	melee = 25
	bullet = 15
	laser = 25
	energy = 35
	bomb = 25
	bio = 100
	fire = 30
	acid = 100

/obj/item/clothing/suit/bio_suit/security/Initialize(mapload)
	. = ..()
	allowed += GLOB.security_vest_allowed

//Janitor's biosuit, grey with purple arms
/obj/item/clothing/head/bio_hood/janitor
	icon_state = "bio_janitor"

/obj/item/clothing/suit/bio_suit/janitor
	icon_state = "bio_janitor"

/obj/item/clothing/suit/bio_suit/janitor/Initialize(mapload)
	. = ..()
	allowed += list(/obj/item/storage/bag/trash, /obj/item/reagent_containers/spray)

//Scientist's biosuit, white with a pink-ish hue
/obj/item/clothing/head/bio_hood/scientist
	icon_state = "bio_scientist"

/obj/item/clothing/suit/bio_suit/scientist
	icon_state = "bio_scientist"

//CMO's biosuit, blue stripe
/obj/item/clothing/head/bio_hood/cmo
	icon_state = "bio_cmo"

/obj/item/clothing/suit/bio_suit/cmo
	icon_state = "bio_cmo"

/obj/item/clothing/suit/bio_suit/cmo/Initialize(mapload)
	. = ..()
	allowed += list(/obj/item/melee/baton/telescopic)

//Plague Dr mask can be found in clothing/masks/gasmask.dm
/obj/item/clothing/suit/bio_suit/plaguedoctorsuit
	name = "瘟疫医生服"
	desc = "在过去，它保护医生免受黑死病的侵害。这肯定也能帮你对抗病毒。"
	icon_state = "plaguedoctor"
	inhand_icon_state = "bio_suit"
	strip_delay = 4 SECONDS
	equip_delay_other = 2 SECONDS

/obj/item/clothing/suit/bio_suit/plaguedoctorsuit/Initialize(mapload)
	. = ..()
	allowed += list(/obj/item/book/bible, /obj/item/nullrod, /obj/item/cane)
