/obj/structure/sign/poster/timeclock_psa
	name = "人事主管蛾 - 打卡下班！"
	desc = "这张信息告示使用了人事主管蛾™，提醒观看者为空间站的企业资源规划工作尽一份力，在长时间缺席或休闲前打卡下班。"
	icon = 'modular_nova/modules/plexagon_selfserve/icons/sign.dmi'
	icon_state = "moff-clockout"
	anchored = TRUE

/obj/structure/sign/poster/timeclock_psa/Initialize(mapload)
	if(prob(4))
		name = "打卡下班！！"
		icon_state = "punch-clock"
		desc = "打卡钟的信息告示今天看起来比平时更具攻击性。最好在动手惹事之前先打卡下班！"
	return ..()

MAPPING_DIRECTIONAL_HELPERS(/obj/structure/sign/poster/timeclock_psa, 32)
