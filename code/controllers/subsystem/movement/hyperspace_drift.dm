///This subsystem handles the hyperspace shuttle pull movement loops
MOVEMENT_SUBSYSTEM_DEF(hyperspace_drift)
	name = "超空间漂移"
	priority = FIRE_PRIORITY_HYPERSPACE_DRIFT
	ss_flags = SS_NO_INIT|SS_TICKER
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
