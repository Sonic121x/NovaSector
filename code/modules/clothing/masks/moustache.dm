/obj/item/clothing/mask/fakemoustache
	name = "假胡子"
	desc = "警告：胡子是假的。"
	icon_state = "fake-moustache"
	alternate_worn_layer = ABOVE_BODY_FRONT_HEAD_LAYER
	w_class = WEIGHT_CLASS_TINY
	flags_inv = HIDEFACE
	species_exception = list(/datum/species/golem)

/obj/item/clothing/mask/fakemoustache/italian
	name = "意式胡子"
	desc = "由正宗的意大利胡须毛制成。佩戴者会产生一种无法抗拒的、想要疯狂打手势的冲动。"

/obj/item/clothing/mask/fakemoustache/italian/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/speechmod, replacements = strings("italian_replacement.json", "italian"), end_string = list(" Ravioli, ravioli, give me the formuoli!"," Mamma-mia!"," Mamma-mia! That's a spicy meat-ball!", " La la la la la funiculi funicula!"), end_string_chance = 3, slots = ITEM_SLOT_MASK)
