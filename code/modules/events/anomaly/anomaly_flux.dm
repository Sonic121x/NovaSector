/datum/round_event_control/anomaly/anomaly_flux
	name = "异常:高能磁波  (高强度)"
	typepath = /datum/round_event/anomaly/anomaly_flux

	min_players = 10
	max_occurrences = 5
	weight = 20
	description = "该异常会电击并爆炸。"
	min_wizard_trigger_potency = 1
	max_wizard_trigger_potency = 4

/datum/round_event/anomaly/anomaly_flux
	start_when = ANOMALY_START_DANGEROUS_TIME
	announce_when = ANOMALY_ANNOUNCE_DANGEROUS_TIME
	anomaly_path = /obj/effect/anomaly/flux

/datum/round_event/anomaly/anomaly_flux/announce(fake)
	if(isnull(impact_area))
		impact_area = placer.findValidArea()
	priority_announce("在[ANOMALY_ANNOUNCE_DANGEROUS_TEXT] [impact_area.name]检测到高能通量波。", "异常警报", ANNOUNCER_FLUXANOMALIES) //NOVA EDIT CHANGE - ORIGINAL: priority_announce("Hyper-energetic flux wave detected on [ANOMALY_ANNOUNCE_DANGEROUS_TEXT] [impact_area.name].", "Anomaly Alert")
