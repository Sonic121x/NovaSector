/obj/item/clothing/under/abductor/fail
	desc = "过数十年的时光，内部的先进防御系统已经失效。"
	name = "失效的绑架者连身衣"
	icon = 'icons/obj/clothing/under/syndicate.dmi'
	icon_state = "abductor"
	inhand_icon_state = "bl_suit"
	worn_icon = 'icons/mob/clothing/under/syndicate.dmi'
	armor_type = /datum/armor/clothing_under/abductor_fail

/datum/armor/clothing_under/abductor_fail
	wound = 10

/obj/item/clothing/suit/armor/abductor/vest/fail
	name = "失效的绑架者背心"
	desc = "经过数十年的时光，内部的先进防御系统已经失效。"
	icon = 'icons/obj/antags/abductor.dmi'
	icon_state = "vest_combat"
	inhand_icon_state = "armor"
	blood_overlay_type = "armor"
	only_functional = TRUE
	armor_type = /datum/armor/abductor_fail
	allowed = list(
		/obj/item/abductor,
		/obj/item/melee/baton,
		/obj/item/gun/energy,
		/obj/item/restraints/handcuffs,
	)

/obj/item/clothing/head/helmet/abductor/fail
	name = "失效的绑架者头盔"
/obj/item/clothing/head/helmet/abductor/fail
	name = "失效的绑架者头盔"
	desc = "过数十年的时光，内部的先进防御系统已经失效。"
	icon_state = "alienhelmet"
	inhand_icon_state = null
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	sound_vary = TRUE
	equip_sound = 'sound/items/handling/helmet/helmet_equip1.ogg'
	pickup_sound = 'sound/items/handling/helmet/helmet_pickup1.ogg'
	drop_sound = 'sound/items/handling/helmet/helmet_drop1.ogg'
	armor_type = /datum/armor/abductor_fail

/obj/item/clothing/head/helmet/abductor/fail/Initialize()
	. = ..()
	AddComponent(/datum/component/hat_stabilizer, loose_hat = FALSE)

/datum/armor/abductor_fail
	melee = 10
	wound = 10
