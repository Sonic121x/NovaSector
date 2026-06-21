/datum/skill/gaming
	name = "游戏"
	title = "Gamer"
	desc = "我作为游戏玩家的熟练度。这能帮助我轻松击败Boss，在《猎户座小径》中极限操作，并让我想来点游戏燃料。"
	modifiers = list(SKILL_PROBS_MODIFIER = list(0, 5, 10, 15, 15, 20, 25),
				SKILL_RANDS_MODIFIER = list(0, 1, 2, 3, 4, 5, 7))
	skill_item_path = /obj/item/clothing/neck/cloak/skill_reward/gaming

/datum/skill/gaming/New()
	. = ..()
	levelUpMessages[1] = span_nicegreen("我开始掌握这些游戏的操作了...")
	levelUpMessages[4] = span_nicegreen("我开始理解这些街机游戏的玩法了。如果我能极限优化最佳策略，并用精炼的技巧来突出我的游戏风格...")
	levelUpMessages[6] = span_nicegreen("凭借惊人的决心和努力，我已达到了[name]能力的顶峰。我在想怎样才能变得更强...也许游戏燃料真的能帮我玩得更好..？")
