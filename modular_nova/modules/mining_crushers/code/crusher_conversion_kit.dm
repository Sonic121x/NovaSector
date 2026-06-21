/**
 * Kinetic Crusher Conversion Kit
 *
 * Lavaland's "Hard Mode" option for players, requiring melee attacks (backstabs even better),
 * but allowing you to upgrade it with trophies gained from fighting lavaland monsters, making it
 * a good tradeoff and a decent playstyle. This item overhauls all the crushers, merging them into one item
 * which allows them to choose one of the variants.
 */
/obj/item/crusher_conversion_kit
	name = "破碎者转换套件"
	desc = "一种为适应竖井矿工需求而设计的工具。激活后，此套件允许用户选择并将基础套件转换为多种动能破碎者变体之一。在手中使用以激活。"
	icon = 'modular_nova/modules/mining_crushers/icons/crusher_conversion_kit.dmi'
	icon_state = "crusher_kit"
	lefthand_file = 'modular_nova/modules/mining_crushers/icons/kit_lefthand.dmi'
	righthand_file = 'modular_nova/modules/mining_crushers/icons/kit_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	/// Tooltips for the crusher variants shown in the selection UI
	var/static/list/subtype2descriptions = list(
		/obj/item/kinetic_crusher = "Tools of the trade. Versatile, reliable.",
		/obj/item/kinetic_crusher/machete = "Compact, with a faster recharge. Sacrifices power for butchering speed.",
		/obj/item/kinetic_crusher/spear = "Long, two meter reach. Ideal for spacing. Too large for armor slots. Deals less damage.",
		/obj/item/kinetic_crusher/hammer = "Heavy hitter. Deals flat damage, but knocks back foes.",
		/obj/item/kinetic_crusher/claw = "Deadly backstabs. The weakest of the five from any other angle.",
	)

/obj/item/crusher_conversion_kit/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/subtype_picker, subtype2descriptions, CALLBACK(src, PROC_REF(on_crusher_conversion)))

/// Handles post-conversion behavior when the kit becomes a crusher, such as effects or custom logic.
/obj/item/crusher_conversion_kit/proc/on_crusher_conversion(obj/item/kinetic_crusher/tool, mob/living/picker)
	if (!tool || !ismob(picker))
		return
	
	picker.put_in_hands(tool)
	tool.on_variant_switch(picker)
