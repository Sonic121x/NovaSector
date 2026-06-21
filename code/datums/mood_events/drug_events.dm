/datum/mood_event/high
	mood_change = 6
	description = "哇哦，兄~弟~……我嗨~翻~了……"

/datum/mood_event/stoned
	mood_change = 6
	description = "我~好~嗨~哦……"

/datum/mood_event/maintenance_high
	mood_change = 6
	description = "我站在世界之巅，宝贝！Tide席卷全球！"
	timeout = 2 MINUTES

/datum/mood_event/maintenance_high/add_effects(param)
	var/value = rand(-1, 6) // chance for it to suck
	mood_change = value
	if(value < 0)
		description = "不！别这样！我的手套！啊啊啊啊啊！"
	else
		description = initial(description)

/datum/mood_event/hang_over
	mood_change = -4
	description = "我宿醉得厉害！"
	timeout = 1 MINUTES

/datum/mood_event/smoked
	description = "我最近抽过烟了。"
	mood_change = 2
	timeout = 6 MINUTES

/datum/mood_event/wrong_brand
	description = "我讨厌那个牌子的香烟。"
	mood_change = -2
	timeout = 6 MINUTES

/datum/mood_event/overdose
	mood_change = -8
	timeout = 5 MINUTES

/datum/mood_event/overdose/add_effects(drug_name)
	description = "我觉得我好像有点过量服用那个[drug_name]了！"

/datum/mood_event/withdrawal_light
	mood_change = -2

/datum/mood_event/withdrawal_light/add_effects(drug_name)
	description = "我真想来点[drug_name]……"

/datum/mood_event/withdrawal_medium
	mood_change = -5

/datum/mood_event/withdrawal_medium/add_effects(drug_name)
	description = "我真的需要[drug_name]。"

/datum/mood_event/withdrawal_severe
	mood_change = -8

/datum/mood_event/withdrawal_severe/add_effects(drug_name)
	description = "天哪，我需要来点那个[drug_name]！"

/datum/mood_event/happiness_drug
	description = "什么都感觉不到了……"
	mood_change = 50

/datum/mood_event/happiness_drug_good_od
	description = "好！好！！好！！！"
	mood_change = 100
	timeout = 30 SECONDS
	special_screen_obj = "mood_happiness_good"

/datum/mood_event/happiness_drug_bad_od
	description = "不！不！！不！！！"
	mood_change = -100
	timeout = 30 SECONDS
	special_screen_obj = "mood_happiness_bad"

/datum/mood_event/narcotic_medium
	description = "我感觉舒适地麻木了。"
	mood_change = 4
	timeout = 3 MINUTES

/datum/mood_event/narcotic_heavy
	description = "我感觉像被棉花包裹起来了！"
	mood_change = 9
	timeout = 3 MINUTES

/datum/mood_event/antinarcotic_medium
	description = "我真希望再次麻木！"
	mood_change = -4
	timeout = 3 MINUTES

/datum/mood_event/antinarcotic_heavy
	description = "不！！让棉花回来！"
	mood_change = -9
	timeout = 3 MINUTES

/datum/mood_event/stimulant_medium
	description = "我精力充沛！感觉无所不能！"
	mood_change = 4
	timeout = 3 MINUTES

/datum/mood_event/stimulant_heavy
	description = "呃啊 啊啊啊！哈 哈 哈 哈 哈！呃呃。"
	mood_change = 6
	timeout = 3 MINUTES

#define EIGENTRIP_MOOD_RANGE 10

/datum/mood_event/eigentrip
	description = "我和另一个现实中的自己交换了位置！"
	mood_change = 0
	timeout = 10 MINUTES

/datum/mood_event/eigentrip/add_effects(param)
	var/value = rand(-EIGENTRIP_MOOD_RANGE,EIGENTRIP_MOOD_RANGE)
	mood_change = value
	if(value < 0)
		description = "我和另一个现实中的自己交换了位置！我想回家！"
	else
		description = "我和另一个现实中的自己交换了位置！不过，这里比我以前的生活好多了。"

#undef EIGENTRIP_MOOD_RANGE

/datum/mood_event/nicotine_withdrawal_moderate
	description = "有一阵子没抽烟了。感觉有点烦躁不安..."
	mood_change = -5

/datum/mood_event/nicotine_withdrawal_severe
	description = "头痛欲裂。冷汗直冒。感觉焦虑不安。需要抽根烟来冷静一下！"
	mood_change = -8

/datum/mood_event/hauntium_spirits
	description = "我感觉我的灵魂正在腐化！"
	mood_change = -8
	timeout = 8 MINUTES

/datum/mood_event/sadness_inverse
	description = "我太悲伤了..."
	mood_change = -150
	special_screen_obj = "mood_happiness_bad"
