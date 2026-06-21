/obj/item/clothing/suit/space/hunter
	name = "赏金猎人外套"
	desc = "这是 MK.II 型防暴服的定制版本，经过特殊改造以使其外观显得坚固耐用。如果能找到头盔的话，它还能当作太空服使用。"
	icon_state = "hunter"
	inhand_icon_state = "swat_suit"
	allowed = list(/obj/item/gun, /obj/item/melee/baton, /obj/item/restraints/handcuffs, /obj/item/tank/internals, /obj/item/knife/combat)
	armor_type = /datum/armor/space_hunter
	strip_delay = 13 SECONDS
	resistance_flags = FIRE_PROOF | ACID_PROOF
	cell = /obj/item/stock_parts/power_store/cell/hyper

/datum/armor/space_hunter
	melee = 60
	bullet = 40
	laser = 40
	energy = 50
	bomb = 100
	bio = 100
	fire = 100
	acid = 100
