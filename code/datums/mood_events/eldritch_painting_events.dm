// These mood events are related to /obj/structure/sign/painting/eldritch
// Names are based on the subtype of painting they belong to

// Mood applied for ripping the painting
/datum/mood_event/eldritch_painting
	description = "自从砍掉那幅画后，我就一直听到奇怪的笑声..."
	mood_change = -6
	timeout = 3 MINUTES

/datum/mood_event/eldritch_painting/weeping
	description = "他来了！"
	mood_change = -3
	timeout = 11 SECONDS

/datum/mood_event/eldritch_painting/weeping_heretic
	description = "他的苦难激励着我！"
	mood_change = 5
	timeout = 3 MINUTES

/datum/mood_event/eldritch_painting/weeping_withdrawal
	description = "我的头脑很清醒。他不在这里。"
	mood_change = 1
	timeout = 3 MINUTES

/datum/mood_event/eldritch_painting/desire_heretic
	description = "虚空在尖叫。"
	mood_change = -2
	timeout = 3 MINUTES

/datum/mood_event/eldritch_painting/desire_examine
	description = "饥饿暂时得到了满足……"
	mood_change = 3
	timeout = 3 MINUTES

/datum/mood_event/eldritch_painting/heretic_vines
	description = "噢，多么可爱的花啊！"
	mood_change = 3
	timeout = 3 MINUTES

/datum/mood_event/eldritch_painting/rust_examine
	description = "那幅画真的让我毛骨悚然。"
	mood_change = -2
	timeout = 3 MINUTES

/datum/mood_event/eldritch_painting/rust_heretic_examine
	description = "攀爬。腐朽。锈蚀。"
	mood_change = 6
	timeout = 3 MINUTES
