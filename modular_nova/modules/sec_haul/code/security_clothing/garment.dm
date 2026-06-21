/obj/item/storage/bag/garment/hos/blue
	name = "安全主管的备用服装袋"
	desc = "一个用于存放备用款式衣物和鞋子的额外袋子。这个属于安全主管。"
	icon = 'modular_nova/modules/sec_haul/icons/garment.dmi'
	icon_state = "garment_bag_blue"

/obj/item/storage/bag/garment/hos/blue/PopulateContents()
	new /obj/item/clothing/neck/cloak/hos/blue(src)
	new /obj/item/clothing/suit/armor/hos/hos_formal/black(src)
	new /obj/item/clothing/under/rank/security/head_of_security/nova/blue(src)
	new /obj/item/clothing/under/rank/security/head_of_security/nova/formal/blue(src)
	new /obj/item/clothing/under/imperialvest/hos(src)
	new /obj/item/clothing/under/imperialskirtvest/hos(src)
	new /obj/item/clothing/under/rank/security/head_of_security/nova/parade(src)
	new /obj/item/clothing/under/rank/security/head_of_security/nova/parade/female(src)
	new /obj/item/clothing/under/rank/security/head_of_security/nova/alt(src)
	new /obj/item/clothing/under/rank/security/head_of_security/nova/alt/skirt(src)
	new /obj/item/clothing/shoes/jackboots/sec/blue(src)

/obj/item/storage/bag/garment/warden/blue
	name = "典狱长的备用服装袋"
	desc = "一个用于存放备用款式衣物和鞋子的袋子。这个属于典狱长。"
	icon = 'modular_nova/modules/sec_haul/icons/garment.dmi'
	icon_state = "garment_bag_blue"

/obj/item/storage/bag/garment/warden/blue/PopulateContents()
	new /obj/item/clothing/head/hats/warden(src)
	new /obj/item/clothing/head/beret/sec/navywarden/nova(src)
	new /obj/item/clothing/head/beret/sec/navywarden(src)
	new /obj/item/clothing/suit/armor/vest/warden(src)
	new /obj/item/clothing/suit/jacket/warden/blue(src)
	new /obj/item/clothing/suit/armor/vest/warden/blue(src)
	new /obj/item/clothing/under/rank/security/warden/nova/blue(src)
	new /obj/item/clothing/under/rank/security/warden/nova/suit/blue(src)
	new /obj/item/clothing/shoes/jackboots/sec/blue(src)
