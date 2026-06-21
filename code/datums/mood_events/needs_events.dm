//nutrition
/datum/mood_event/fat
	description = "<B>我太胖了……</B>" //muh fatshaming
	mood_change = -6

/datum/mood_event/too_wellfed
	description = "我想我吃得太多了。"
	mood_change = 0

/datum/mood_event/wellfed
	description = "我吃撑了！"
	mood_change = 8

/datum/mood_event/fed
	description = "我最近吃过东西了。"
	mood_change = 5

/datum/mood_event/hungry
	description = "我有点饿了。"
	mood_change = -3

/datum/mood_event/hungry_very
	description = "我饿了！"
	mood_change = -6

/datum/mood_event/starving
	description = "我快饿死了！"
	mood_change = -10

//charge
/datum/mood_event/supercharged
	description = "我体内能量多得装不下了，得赶紧释放一些！"
	mood_change = -10

/datum/mood_event/overcharged
	description = "我感觉自己充电过度了，也许该释放一些能量。"
	mood_change = -4

/datum/mood_event/charged
	description = "我感觉能量在血管中奔涌！"
	mood_change = 6

/datum/mood_event/lowpower
	description = "我的能量快耗尽了，得找个地方充充电。"
	mood_change = -6

/datum/mood_event/decharged
	description = "我急需补充电力！"
	mood_change = -10

//Disgust
/datum/mood_event/gross
	description = "我看到了恶心的东西。"
	mood_change = -4

/datum/mood_event/verygross
	description = "我觉得我要吐了……"
	mood_change = -6

/datum/mood_event/disgusted
	description = "天哪，太恶心了……"
	mood_change = -8

/datum/mood_event/disgust/bad_smell
	description = "我能闻到这房间里有什么东西腐烂的可怕气味。"
	mood_change = -6

/datum/mood_event/disgust/nauseating_stench
	description = "腐烂尸体的恶臭令人难以忍受！"
	mood_change = -12

/datum/mood_event/disgust/dirty_food
	description = "那东西太脏了，没法吃……"
	mood_change = -6
	timeout = 4 MINUTES

/datum/mood_event/disgust/dirty_food/add_effects(...)
	if(HAS_PERSONALITY(owner, /datum/personality/ascetic))
		mood_change *= 0.25
		description = "那食物有点脏，但还能吃。"
	if(HAS_PERSONALITY(owner, /datum/personality/gourmand))
		mood_change *= 1.5
		description = "那食物太脏了，是在垃圾桶里做的吗？！"

//Generic needs events
/datum/mood_event/shower
	description = "我最近洗了个舒服的澡。"
	mood_change = 4
	timeout = 5 MINUTES

/datum/mood_event/shower/add_effects(shower_reagent)
	if(istype(shower_reagent, /datum/reagent/blood))
		if(HAS_TRAIT(owner, TRAIT_MORBID) || HAS_TRAIT(owner, TRAIT_EVIL) || (owner.mob_biotypes & MOB_UNDEAD))
			description = "一场美妙的血浴感觉真不错。"
			mood_change = 6 // you sicko
		else
			description = "我最近洗了个糟糕的血雨澡！"
			mood_change = -4
			timeout = 3 MINUTES
	else if(istype(shower_reagent, /datum/reagent/water))
		if(HAS_TRAIT(owner, TRAIT_WATER_HATER) && !HAS_TRAIT(owner, TRAIT_WATER_ADAPTATION))
			description = "我讨厌浑身湿透！"
			mood_change = -2
			timeout = 3 MINUTES
		else
			return // just normal clean shower
	else // it's dirty ass water
		description = "我最近洗了个脏兮兮的澡！"
		mood_change = -3
		timeout = 3 MINUTES

/datum/mood_event/hot_spring
	description = "泡在蒸汽腾腾的水里真放松……"
	mood_change = 5

/datum/mood_event/hot_spring_hater
	description = "不，不，不，不，我不想洗澡！"
	mood_change = -2

/datum/mood_event/hot_spring_left
	description = "那是一次愉快的沐浴。"
	mood_change = 4
	timeout = 4 MINUTES

/datum/mood_event/hot_spring_hater_left
	description = "我讨厌洗澡！也讨厌一踏出浴池就冷得要命的感觉！"
	mood_change = -3
	timeout = 2 MINUTES

/datum/mood_event/fresh_laundry
	description = "没有什么比得上刚洗好的连体工作服带来的感觉了。"
	mood_change = 2
	timeout = 10 MINUTES

/datum/mood_event/surrounded_by_silicon
	description = "我被完美的生命形态包围了！！"
	mood_change = 8

/datum/mood_event/around_many_silicon
	description = "我身边有好多硅基生命体！"
	mood_change = 4

/datum/mood_event/around_silicon
	description = "我身边的硅基生命体简直完美无瑕。"
	mood_change = 2

/datum/mood_event/around_organic
	description = "我身边的有机体让我想起了血肉之躯的劣等性。"
	mood_change = -2

/datum/mood_event/around_many_organic
	description = "这么多恶心的有机体！"
	mood_change = -4

/datum/mood_event/surrounded_by_organic
	description = "我被恶心的有机体包围了！！"
	mood_change = -8

/datum/mood_event/completely_robotic
	description = "我已抛弃了脆弱的血肉，我的形态完美无缺！！"
	mood_change = 8

/datum/mood_event/very_robotic
	description = "我更像机器人而非有机体！"
	mood_change = 4

/datum/mood_event/balanced_robotic
	description = "我半是机器，半是有机体。"
	mood_change = 0

/datum/mood_event/very_organic
	description = "我痛恨这脆弱无力的血肉！"
	mood_change = -4

/datum/mood_event/completely_organic
	description = "我完全是有机体，这太悲惨了！！"
	mood_change = -8
