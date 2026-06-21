/datum/experiment/physical/meat_wall_explosion
	name = "极端烹饪实验"
	description = "有人提议利用我们的工程设备来探索可以创造出何种新型烹饪器具。"

/datum/experiment/physical/meat_wall_explosion/register_events()
	if(!iswallturf(currently_scanned_atom))
		linked_experiment_handler.announce_message("Incorrect object for experiment.")
		return FALSE

	if(!currently_scanned_atom.has_material_type(/datum/material/meat))
		linked_experiment_handler.announce_message("Object is not made out of the correct materials.")
		return FALSE

	RegisterSignal(currently_scanned_atom, COMSIG_ATOM_BULLET_ACT, PROC_REF(check_experiment))
	linked_experiment_handler.announce_message("Experiment ready to start.")
	return TRUE

/datum/experiment/physical/meat_wall_explosion/unregister_events()
	UnregisterSignal(currently_scanned_atom, COMSIG_ATOM_BULLET_ACT)

/datum/experiment/physical/meat_wall_explosion/check_progress()
	. += EXPERIMENT_PROG_BOOL("Fire an emitter at a tracked meat wall", is_complete())

/datum/experiment/physical/meat_wall_explosion/proc/check_experiment(datum/source, obj/projectile/proj)
	SIGNAL_HANDLER
	if(istype(proj, /obj/projectile/beam/emitter))
		UnregisterSignal(currently_scanned_atom, COMSIG_ATOM_BULLET_ACT)
		finish_experiment(linked_experiment_handler)

/datum/experiment/physical/meat_wall_explosion/finish_experiment(datum/component/experiment_handler/experiment_handler, datum/techweb/linked_web_override)
	. = ..()
	new /obj/effect/gibspawner/generic(currently_scanned_atom)
	var/turf/meat_wall = currently_scanned_atom
	var/turf/new_turf = meat_wall.ScrapeAway()
	new /obj/effect/gibspawner/generic(new_turf)
	new /obj/item/food/meat/steak/plain(new_turf)

/datum/experiment/physical/arcade_winner
	name = "游戏测试体验"
	description = "他们是怎么把这些街机游戏做得这么有趣的？让我们玩一个并赢得它来一探究竟。"

/datum/experiment/physical/arcade_winner/register_events()
	if(!istype(currently_scanned_atom, /obj/machinery/computer/arcade))
		linked_experiment_handler.announce_message("Incorrect object for experiment.")
		return FALSE

	RegisterSignal(currently_scanned_atom, COMSIG_ARCADE_VICTORY, PROC_REF(win_arcade))
	linked_experiment_handler.announce_message("Experiment ready to start.")
	return TRUE

/datum/experiment/physical/arcade_winner/unregister_events()
	UnregisterSignal(currently_scanned_atom, COMSIG_ARCADE_VICTORY)

/datum/experiment/physical/arcade_winner/check_progress()
	. += EXPERIMENT_PROG_BOOL("Win an arcade game at a tracked arcade cabinet.", is_complete())

/datum/experiment/physical/arcade_winner/proc/win_arcade(datum/source)
	SIGNAL_HANDLER
	UnregisterSignal(currently_scanned_atom, COMSIG_ARCADE_VICTORY)
	finish_experiment(linked_experiment_handler)
