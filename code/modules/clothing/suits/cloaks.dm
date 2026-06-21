//Cloaks. No, not THAT kind of cloak.

/obj/item/clothing/neck/cloak
	name = "棕色斗篷"
	desc = "可以围在你脖子上的斗篷。"
	icon = 'icons/obj/clothing/cloaks.dmi'
	worn_icon = 'icons/mob/clothing/neck.dmi'
	icon_state = "qmcloak"
	inhand_icon_state = null
	w_class = WEIGHT_CLASS_SMALL
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	flags_inv = HIDESUITSTORAGE

/obj/item/clothing/neck/cloak/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/surgery_aid, "cloak")

/obj/item/clothing/neck/cloak/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] 正用 [src] 勒住 [user.p_them()] 自己！看起来 [user.p_theyre()] 试图自杀！"))
	return OXYLOSS

/obj/item/clothing/neck/cloak/hos
	name = "安保部长斗篷"
	desc = "由安全里斯授权，以铁腕手段管理空间站。"
	icon_state = "hoscloak"

/obj/item/clothing/neck/cloak/qm
	name = "军需官斗篷"
	desc = "由货舱尼亚号运输而来，为空间站提供生存所需的资源。"

/obj/item/clothing/neck/cloak/cmo
	name = "医疗部长斗篷"
	desc = "由医疗托比亚所绘制，英勇的男男女女们正在抵御瘟疫，守护着这片土地。"
	icon_state = "cmocloak"

/obj/item/clothing/neck/cloak/ce
	name = "工程部长斗篷"
	desc = "由工程托比亚所制造，他们是无限力量的掌控者。"
	icon_state = "cecloak"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/cloak/rd
	name = "科研部长斗篷"
	desc = "由科研利卡研制。由宇宙学，科学，神秘学家们所佩戴"
	icon_state = "rdcloak"

/obj/item/clothing/neck/cloak/cap
	name = "舰长斗篷"
	desc = "十三号空间站指挥官所戴的斗篷。"
	icon_state = "capcloak"

/obj/item/clothing/neck/cloak/hop
	name = "人事部长斗篷"
	desc = "人事部长所穿的斗篷，闻起来有股淡淡的官僚味。"
	icon_state = "hopcloak"

/obj/item/clothing/neck/cloak/skill_reward
	var/associated_skill_path = /datum/skill
	var/element_type = /datum/element/skill_reward
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE

/obj/item/clothing/neck/cloak/skill_reward/Initialize(mapload)
	. = ..()
	AddElement(element_type, associated_skill_path)

/obj/item/clothing/neck/cloak/skill_reward/gaming
	name = "传奇玩家斗篷"
	desc = "由空间站上技术最强的职业玩家穿戴，这件传说中的披风只能通过达到真正的游戏大成者来获得。这个披风象征着专注、承诺和卓绝的意志力。这是众多休闲玩家永远无法理解的东西。"
	icon_state = "gamercloak"
	associated_skill_path = /datum/skill/gaming

/obj/item/clothing/neck/cloak/skill_reward/cleaning
	name = "传奇清洁工斗篷"
	desc = "由技艺最精湛的清洁工穿戴，这件传奇斗篷只有达到清洁工开悟境界才能获得。这个地位象征代表着一个不仅受过广泛污垢战斗训练，而且愿意动用全套清洁用品库，将污垢那可怜的屁股从空间站表面彻底抹除的存在。"
	icon_state = "cleanercloak"
	associated_skill_path = /datum/skill/cleaning

/obj/item/clothing/neck/cloak/skill_reward/mining
	name = "传奇矿工斗篷"
	desc = "由站在拉瓦兰食物链顶端的传奇矿工穿戴，这件传说中的披风只能通过领悟真正的矿石知识启蒙获得。这个披风代表着一种存在：此人对矿物的理解超过了绝大多数矿工所能知晓的范围，移山填谷对祂来说不过雕虫小技。"
	icon_state = "minercloak"
	associated_skill_path = /datum/skill/mining

/obj/item/clothing/neck/cloak/skill_reward/playing
	name = "传奇老兵斗篷"
	desc = "这件传奇的斗篷只有最资深的员工中那最睿智的几位才有资格穿戴的。要获得它，必须与纳米传讯公司保持长达<b>5000小时的持续雇佣关系</b>。 这件物品的持有者意味着在几乎所有可衡量的领域比你都强大的多，就那么简单，真正的老资历，真正的强者。"
	icon_state = "playercloak"
	element_type = /datum/element/skill_reward/veteran
