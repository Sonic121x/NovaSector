// test purposes - Also a lot of fun
/datum/action/cooldown/spell/conjure/summon_ed_swarm
	name = "执行正义之法杖"
	desc = "此咒语彰显了巫师的公正裁决。"

	summon_radius = 3
	summon_type = list(/mob/living/basic/bot/secbot/ed209)
	summon_amount = 10

/datum/action/cooldown/spell/conjure/summon_ed_swarm/post_summon(atom/summoned_object, atom/cast_on)
	if(!istype(summoned_object, /mob/living/basic/bot/secbot/ed209))
		return

	var/mob/living/basic/bot/secbot/ed209/summoned_bot = summoned_object
	summoned_bot.name = "巫师的正义机器人"

	summoned_bot.security_mode_flags = ~SECBOT_DECLARE_ARRESTS
	summoned_bot.bot_mode_flags &= ~BOT_MODE_REMOTE_ENABLED
	summoned_bot.bot_mode_flags |= BOT_COVER_EMAGGED

	summoned_bot.projectile_type = /obj/projectile/beam/laser
	summoned_bot.projectile_sound = 'sound/items/weapons/laser.ogg'
