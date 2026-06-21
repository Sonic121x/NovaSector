//Contains generic skillchips that are fairly short and simple

/obj/item/skillchip/wine_taster
	name = "WINE 技能芯片"
	desc = "Wine.Is.Not.Equal 版本 5。"
	auto_traits = list(TRAIT_WINE_TASTER)
	skill_name = "Wine Tasting"
	skill_description = "Recognize wine vintage from taste alone. Never again lack an opinion when presented with an unknown drink."
	skill_icon = "wine-bottle"
	activate_message = span_notice("你回忆起了葡萄酒的味道。")
	deactivate_message = span_notice("你对葡萄酒的记忆蒸发了。")

/obj/item/skillchip/bonsai
	name = "Hedge 3 技能芯片"
	desc = "学习如何将树篱和盆栽植物修剪成新的形状。第三版。"
	auto_traits = list(TRAIT_BONSAI)
	skill_name = "Hedgetrimming"
	skill_description = "Trim hedges and potted plants into marvelous new shapes with any old knife. Not applicable to plastic plants."
	skill_icon = "spa"
	activate_message = span_notice("你的脑海中充满了植物布置方案。")
	deactivate_message = span_notice("你再也记不起树篱长什么样了。")

/obj/item/skillchip/useless_adapter
	name = "技能芯片适配器"
	desc = "哟伙计，听说你喜欢技能芯片，所以我们给你的技能芯片里又放了个技能芯片，这样你就能……呃……"
	skill_name = "Useless adapter"
	skill_description = "Allows you to insert another skillchip into this adapter after it has been inserted into your brain..."
	skill_icon = "plug"
	activate_message = span_notice("你现在可以通过这个适配器激活另一个芯片了，但你不确定自己为什么要这么做……")
	deactivate_message = span_notice("你不再拥有那个无用的技能芯片适配器了。")
	skillchip_flags = SKILLCHIP_ALLOWS_MULTIPLE
	// Literally does nothing.
	complexity = 0
	slot_use = 0

/obj/item/skillchip/light_remover
	name = "N16H7M4R3 技能芯片"
	desc = "一个关于安全拆卸灯泡的技能芯片。想出那个糟糕名字的人应该被解雇。"
	auto_traits = list(TRAIT_LIGHTBULB_REMOVER)
	skill_name = "Lightbulb Removing"
	skill_description = "Stop failing taking out lightbulbs today, no gloves needed!"
	skill_icon = "lightbulb"
	activate_message = span_notice("你感觉你的痛觉感受器对高温物体不那么敏感了。")
	deactivate_message = span_notice("你感觉高温物体又能阻止你了……")

/obj/item/skillchip/disk_verifier
	name = "K33P-TH4T-D15K 技能芯片"
	desc = "一个印有核认证磁盘微型图案的技能芯片。"
	auto_traits = list(TRAIT_DISK_VERIFIER)
	skill_name = "Nuclear Disk Verification"
	skill_description = "Nuclear authentication disks have an extremely long serial number for verification. This skillchip stores that number, which allows the user to automatically spot forgeries."
	skill_icon = "save"
	activate_message = span_notice("你感觉你的大脑会自动验证盘状物体上的长序列号。")
	deactivate_message = span_notice("对荒谬的磁盘相关长序列号的先天识别能力从你脑海中消退了。")

/obj/item/skillchip/entrails_reader
	name = "3NTR41LS 技能芯片"
	auto_traits = list(TRAIT_ENTRAILS_READER)
	skill_name = "Entrails Reader"
	skill_description = "Be able to learn about a person's life, by looking at their internal organs. Not to be confused with looking into the future."
	skill_icon = "lungs"
	activate_message = span_notice("你感觉自己很懂如何解读器官。")
	deactivate_message = span_notice("关于肝脏损伤、心脏劳损和肺部疤痕的知识从你脑海中消退了。")

/obj/item/skillchip/appraiser
	name = "“正品ID卡鉴定，即刻就来！”技能芯片"
	desc = "按照技能芯片的命名标准，这名字已经不能再更绝望和自明了。"
	auto_traits = list(TRAIT_ID_APPRAISER)
	skill_name = "ID Appraisal"
	skill_description = "Appraise an ID and see if it's issued from centcom, or just a cruddy station-printed one."
	skill_icon = "magnifying-glass"
	activate_message = span_notice("你感觉自己能识别ID卡上特殊的、微小的细节。")
	deactivate_message = span_notice("某些ID卡是不是有什么特别之处？")

/obj/item/skillchip/sabrage
	name = "Le S48R4G3 技能芯片"
	desc = "一个散发着淡淡酒香的技能芯片。最好与军刀或其他锋利的刀刃配合使用。"
	auto_traits = list(TRAIT_SABRAGE_PRO)
	skill_name = "Sabrage Proficiency"
	skill_description = "Grants the user knowledge of the intricate structure of a champagne bottle's structural weakness at the neck, \
	improving their proficiency at being a show-off at officer parties."
	skill_icon = "bottle-droplet"
	activate_message = span_notice("你对香槟瓶以及如何移除其瓶塞的方法有了新的理解。")
	deactivate_message = span_notice("关于香槟瓶内微妙物理学的知识从你脑海中消退了。")

/obj/item/skillchip/brainwashing
	name = "可疑技能芯片"
	auto_traits = list(TRAIT_BRAINWASHING)
	skill_name = "Brainwashing"
	skill_description = "WARNING: The integrity of this chip is compromised. Please discard this skillchip."
	skill_icon = "soap"
	activate_message = span_notice("...但突然间你恍然大悟...好像是把大脑放进洗衣机里？")
	deactivate_message = span_warning("关于秘密洗脑技术的所有知识都消失了。")

/obj/item/skillchip/brainwashing/examine(mob/user)
	. = ..()
	. += span_warning("它看起来已经被时间腐蚀了，把这东西放进你的脑袋里可能不是个好主意...")

/obj/item/skillchip/brainwashing/on_activate(mob/living/carbon/user, silent = FALSE)
	to_chat(user, span_danger("当芯片将损坏的记忆传入你的大脑时，你感到一阵剧烈的头痛！"))
	user.adjust_organ_loss(ORGAN_SLOT_BRAIN, 20)
	. = ..()

/obj/item/skillchip/chefs_kiss
	name = "K1SS技能芯片"
	desc = "这个技能芯片隐约散发着苹果派的香气，多么可爱。使用前请咨询营养师。"
	auto_traits = list(TRAIT_CHEF_KISS)
	skill_name = "Chef's Kiss"
	skill_description = "Allows you to kiss food you've created to make them with love."
	skill_icon = "cookie"
	activate_message = span_notice("你回忆起从祖母那里学到的，她们是如何用爱烘焙饼干的。")
	deactivate_message = span_notice("你忘记了祖母传授给你的所有记忆。她真的是你的亲祖母吗？")

/obj/item/skillchip/intj
	name = "集成直觉思维与判断技能芯片"
	auto_traits = list(TRAIT_REMOTE_TASTING)
	skill_name = "Mental Flavour Calculus"
	skill_description = "When examining food, you can experience the flavours just as well as if you were eating it."
	skill_icon = FA_ICON_DRUMSTICK_BITE
	activate_message = span_notice("你想到自己最喜欢的食物，并意识到可以在脑海中旋转它的风味。")
	deactivate_message = span_notice("你感觉以食物为基础的精神殿堂正在崩塌...")

/obj/item/skillchip/drunken_brawler
	name = "F0RC3 4DD1CT10N技能芯片"
	desc = "一个散发着酒精味的技能芯片，据说能在醉酒时提升一个人的格斗技巧，好像这能让你免于肝硬化似的。"
	auto_traits = list(TRAIT_DRUNKEN_BRAWLER)
	skill_name = "Drunken Unarmed Proficiency"
	skill_description = "When intoxicated, you gain increased unarmed effectiveness."
	skill_icon = "wine-bottle"
	activate_message = span_notice("说实话，你真该喝一杯。谁知道什么时候会有人在这附近袭击你。")
	deactivate_message = span_notice("你突然觉得清醒地在空间站里走动安全多了...")

/obj/item/skillchip/master_angler
	name = "Mast-Angl-Er技能芯片"
	desc = "一个充满了关于钓鱼和鱼类的百科全书式摘录和趣闻的技能芯片。"
	auto_traits = list(TRAIT_REVEAL_FISH, TRAIT_EXAMINE_FISHING_SPOT, TRAIT_EXAMINE_FISH, TRAIT_EXAMINE_DEEPER_FISH)
	skill_name = "Fisherman's Discernment"
	skill_description = "Lists fishes when examining a fishing spot, gives a hint of whatever thing's biting the hook and more."
	skill_icon = "fish"
	activate_message = span_notice("你感受到几位饱经风霜、经验丰富的渔夫的知识和激情在你体内燃烧。")
	deactivate_message = span_notice("你不再有在阳光明媚的河边抛掷鱼竿的冲动了。")

	actions_types = list(/datum/action/cooldown/fishing_tip)

/datum/action/cooldown/fishing_tip
	name = "分发钓鱼小贴士"
	desc = "回忆一条关于钓鱼的智慧箴言。"
	button_icon = 'icons/hud/radial_fishing.dmi'
	button_icon_state = "river"
	background_icon_state = "bg_default"
	overlay_icon_state = "bg_default_border"
	cooldown_time = 2.5 SECONDS //enough time to skim through tips.

/datum/action/cooldown/fishing_tip/Activate(atom/target_atom)
	. = ..()
	send_tip_of_the_round(owner, pick(GLOB.fishing_tips), source = "Ancient fishing wisdom")

/obj/item/skillchip/disposals
	name = "T4RG3T.bin skillchip"
	desc = "Become a dauntless disposaler, target trash right where it belongs."
	auto_traits = list(TRAIT_THROWINGARM)
	skill_name = "Dauntless Disposaler"
	skill_description = "You have an uncanny ability to perfectly land every toss into disposal units."
	skill_icon = "trash-can"
	activate_message = span_notice("You seem laser focused on the nearby disposal unit.")
	deactivate_message = span_notice("The nearby disposal unit fades into the background of your vision.")
