/obj/item/clothing/head/helmet/space/santahat
	name = "圣诞老人帽"
	desc = "吼吼吼。圣诞快乐！"
	icon = 'icons/obj/clothing/head/wizard.dmi'
	worn_icon = 'icons/mob/clothing/head/wizard.dmi'
	icon_state = "santahat"
	inhand_icon_state = "santahat"
	flags_cover = HEADCOVERSEYES
	dog_fashion = /datum/dog_fashion/head/santa
	fishing_modifier = 0
	visor_dirt = null

/obj/item/clothing/head/helmet/space/santahat/beardless
	icon = 'icons/obj/clothing/head/costume.dmi'
	worn_icon = 'icons/mob/clothing/head/costume.dmi'
	icon_state = "santahatnorm"
	inhand_icon_state = "that"
	flags_inv = NONE

/obj/item/clothing/suit/space/santa
	name = "圣诞老人服"
	desc = "好有节日氛围！"
	icon_state = "santa"
	icon = 'icons/obj/clothing/suits/wizard.dmi'
	worn_icon = 'icons/mob/clothing/suits/wizard.dmi'
	inhand_icon_state = "santa"
	slowdown = 0
	allowed = list(/obj/item) //for stuffing exta special presents
	fishing_modifier = 0
