/**
 * # Voucher Set
 *
 * A set consisting of a various equipment that can be then used as a reward for redeeming a voucher.
 *
 * See [Voucher Redeemer](/datum/element/voucher_redeemer) for where these sets are handled.
 */
/datum/voucher_set
	/// Required, Name of the set.
	var/name
	/// Optional, description of the set
	var/description
	/// Optional, Icon of the set. Defaults to first item if not set.
	var/icon
	/// Optional, Icon state of the set. Defaults to first item if not set.
	var/icon_state
	/// Required, List of items contained in the set
	var/list/atom/set_items
	/// Optional, what key to use for blackbox feedback. No data will be recorded if not set.
	var/blackbox_key

/datum/voucher_set/New()
	. = ..()
	if(!length(set_items))
		stack_trace("Voucher set [type] has no items set.")
		return
	if(isnull(icon))
		icon = initial(set_items[1].icon)
	if(isnull(icon_state))
		icon_state = initial(set_items[1].icon_state)
	if(isnull(name))
		stack_trace("Voucher set [type] has no name set.")

/datum/voucher_set/proc/spawn_set(atom/spawn_loc)
	for(var/item in set_items)
		new item(spawn_loc)

/datum/voucher_set/mining
	blackbox_key = "mining_voucher_redeemed"

/datum/voucher_set/mining/crusher_kit
	name = "破碎机套"
	description = "包含一把动能粉碎者、一个扩展型便携氧气罐和一个便携灭火器。动能粉碎者是一种多用途近战采矿工具，既能采矿也能对抗当地生物，但除了最有经验和/或最不怕死的矿工外，其他人很难有效使用它。"
	icon = 'icons/obj/mining.dmi'
	icon_state = "crusher"
	set_items = list(
		/obj/item/kinetic_crusher,
		/obj/item/extinguisher/mini,
		/obj/item/tank/internals/emergency_oxygen/engi,
	)

/datum/voucher_set/mining/extraction_kit
	name = "提取和营救套"
	description = "包含一套富尔顿提取包和一个信标信号器，让你无需使用采矿穿梭机就能将矿物、物品和尸体送回站内。作为额外奖励，你还获得30个标记信标，帮助你更好地标记路径。"
	icon = 'icons/obj/fulton.dmi'
	icon_state = "extraction_pack"
	set_items = list(
		/obj/item/extraction_pack,
		/obj/item/fulton_core,
		/obj/item/stack/marker_beacon/thirty,
	)

/datum/voucher_set/mining/resonator_kit
	name = "谐振器套"
	description = "包含一个谐振器和一台便携灭火器。谐振器是一种手持设备，能产生小型能量场，这些能量场会共振直至爆炸，从而粉碎岩石。它在低压环境下会造成额外伤害。"
	icon = 'icons/obj/mining.dmi'
	icon_state = "resonator"
	set_items = list(
		/obj/item/resonator,
		/obj/item/extinguisher/mini,
	)

/datum/voucher_set/mining/survival_capsule
	name = "庇护所胶囊和探险家携行具"
	description = "包含一件探险家背带，让你能携带更多采矿装备，并且里面已经备有一个备用庇护所胶囊。"
	icon = 'icons/obj/clothing/belts.dmi'
	icon_state = "explorer1"
	set_items = list(
		/obj/item/storage/belt/mining/vendor,
	)

/datum/voucher_set/mining/minebot_kit
	name = "挖矿机器人套"
	description = "包含一个小型矿工机器人伙伴，它能帮助你储存矿石和狩猎野生动物。套装还附带一个升级版工业焊枪（80单位燃料）、一个焊接面罩以及一个能让射击穿透矿工机器人的KA改装套件。"
	icon = 'icons/mob/silicon/aibots.dmi'
	icon_state = "mining_drone"
	set_items = list(
		/mob/living/basic/mining_drone,
		/obj/item/weldingtool/hugetank,
		/obj/item/clothing/head/utility/welding,
		/obj/item/borg/upgrade/modkit/minebot_passthrough,
	)

/datum/voucher_set/mining/conscription_kit
	name = "采矿征兵包"
	description = "包含一套全新的矿工入门装备，供一名船员使用，包括一把原型动能加速器、一把生存刀、一个手电筒、一套勘探服、透视眼镜、自动矿物扫描仪、一个矿工背包、一个防毒面具、一个矿工无线电钥匙以及一张带有基础矿工权限的特殊ID卡。"
	icon = 'icons/obj/storage/backpack.dmi'
	icon_state = "duffel-explorer"
	set_items = list(
		/obj/item/storage/backpack/duffelbag/mining_conscript,
	)

/datum/voucher_set/mining/punching_mitts
	name = "拳击手套"
	description = "包含一副拳击手套，让你用赤手空拳将当地荒野变成碎石坑。"
	icon = 'icons/obj/clothing/gloves.dmi'
	icon_state = "punch_mitts"
	set_items = list(
		/obj/item/clothing/gloves/fingerless/punch_mitts,
		/obj/item/clothing/head/cowboy,
	)
