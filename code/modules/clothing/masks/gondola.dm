/obj/item/clothing/mask/gondola
	name = "贡多拉面具"
	desc = "货真价实的贡多拉皮毛。"
	icon_state = "gondola"
	inhand_icon_state = null
	flags_inv = HIDEFACE|HIDEHAIR|HIDEFACIALHAIR|HIDESNOUT
	w_class = WEIGHT_CLASS_SMALL

/obj/item/clothing/mask/gondola/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/speechmod, replacements = strings("spurdo_replacement.json", "spurdo"), slots = ITEM_SLOT_MASK)
