/**
 * # Ninja Mask
 *
 * Space ninja's mask.  Other than looking cool, doesn't do anything.
 *
 * A mask which only spawns as a part of space ninja's starting kit.  Functions as a gas mask.
 *
 */
/obj/item/clothing/mask/gas/ninja
	name = "忍者面具"
	desc = "一款紧贴面部的纳米增强面具，既能作为空气过滤器，也是一项后现代时尚宣言。"
	icon_state = "ninja"
	inhand_icon_state = "sechailer"
	strip_delay = 12 SECONDS
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	flags_inv = HIDEFACIALHAIR | HIDEFACE | HIDESNOUT
	flags_cover = MASKCOVERSMOUTH | PEPPERPROOF
	pepper_tint = FALSE

/obj/item/clothing/mask/gas/ninja/plasmaman
	starting_filter_type = /obj/item/gas_filter/plasmaman

/obj/item/clothing/under/syndicate/ninja
	name = "忍者服"
	desc = "一套为极致舒适与战术性设计的纳米增强连体服。"
	icon_state = "ninja_suit"
	strip_delay = 12 SECONDS
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	can_adjust = FALSE
