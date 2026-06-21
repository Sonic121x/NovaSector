/* Morbid Mood Events -
Any mood events related to TRAIT_MORBID.
Ususally this is an inverse of a typically good, alturistic action (such as saving someones life), punishing it with a negative mood event,
and rewards typically antisocial/unsavory actions (such as graverobbing) with a positive mood event.
Intended to push a creepy, mad scientist/doctor vibe, or someone who is downright monstrous in nature.
*/

// Positive Events - We did something unsavory in the name of mad science

/datum/mood_event/morbid_dismemberment
	description = "没有什么比一次干净利落的肢解更令人满足了！"
	mood_change = 2
	timeout = 2 MINUTES

/datum/mood_event/morbid_dissection_success
	description = "我为我的工作感到自豪。没有人能像我这样解剖一具尸体。"
	mood_change = 2
	timeout = 2 MINUTES

/datum/mood_event/morbid_abominable_surgery_success
	description = "毕加索本人用画笔也难以企及我用手术刀所能做到的。"
	mood_change = 2
	timeout = 2 MINUTES

/datum/mood_event/morbid_revival_success
	description = "它活了！啊哈哈哈哈哈哈！！"
	mood_change = 6
	timeout = 8 MINUTES

/datum/mood_event/morbid_graverobbing
	description = "死者不需要财产。而我，恰恰相反，活得好好的，并且非常需要。"
	mood_change = 2
	timeout = 2 MINUTES

/datum/mood_event/morbid_hauntium
	description = "我感觉与灵体有了更好的联系，我太喜欢这个了！"
	mood_change = 3
	timeout = 6 MINUTES

/datum/mood_event/morbid_aquarium_good
	description = "呃呃，所有的鱼都在睡觉……"
	mood_change = 3
	timeout = 90 SECONDS

// Negative Events - We helped someone stay alive.

/datum/mood_event/morbid_tend_wounds
	description = "为什么我必须把才华浪费在这种琐事上？照料这些呼吸者纯属白费力气。"
	mood_change = -2
	timeout = 2 MINUTES

/datum/mood_event/morbid_saved_life
	description = "我本可以用他们的尸体做更多事，而不是去拯救他们那无用的生命。真糟糕。"
	mood_change = -6
	timeout = 2 MINUTES

/datum/mood_event/morbid_aquarium_bad
	description = "在水族馆里看鱼真没劲。"
	mood_change = -3
	timeout = 90 SECONDS
