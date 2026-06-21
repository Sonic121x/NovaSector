/datum/round_event_control/anomaly/anomaly_bioscrambler
	name = "异常:生物扰乱"
	typepath = /datum/round_event/anomaly/anomaly_bioscrambler

	min_players = 10
	max_occurrences = 5
	weight = 20
	description = "这种异常会替换附近人员的肢体。"
	min_wizard_trigger_potency = 0
	max_wizard_trigger_potency = 2

/datum/round_event/anomaly/anomaly_bioscrambler
	start_when = ANOMALY_START_MEDIUM_TIME
	announce_when = ANOMALY_ANNOUNCE_MEDIUM_TIME
	anomaly_path = /obj/effect/anomaly/bioscrambler

/datum/round_event/anomaly/anomaly_bioscrambler/announce(fake)
	if(isnull(impact_area))
		impact_area = placer.findValidArea()
	priority_announce("在 [ANOMALY_ANNOUNCE_MEDIUM_TEXT] [impact_area.name] 检测到生物肢体置换剂。请穿着生化防护服或其他防护装备以抵御其影响。", "异常警报", ANNOUNCER_ANOMALIES) // NOVA EDIT CHANGE - ORIGINAL: priority_announce("Biologic limb swapping agent detected on [ANOMALY_ANNOUNCE_MEDIUM_TEXT] [impact_area.name]. Wear biosuits or other protective gear to counter the effects.", "Anomaly Alert")
