/datum/experiment/physical
	name = "物理实验"
	description = "一项需要物理反应才能继续的实验"
	exp_tag = "Physical Experiment"
	performance_hint = "To perform physical experiments you must use a hand-held scanner unit to track objects in our world relevant to \
		your experiment. Activate the experiment on your scanner, scan the object to track, and then complete the objective."
	/// The atom that is currently being watched by this experiment
	var/atom/currently_scanned_atom
	/// Linked experiment handler
	var/datum/component/experiment_handler/linked_experiment_handler

/datum/experiment/physical/is_complete()
	return completed

/datum/experiment/physical/perform_experiment_actions(datum/component/experiment_handler/experiment_handler, atom/target)
	if(currently_scanned_atom)
		unregister_events()
	currently_scanned_atom = target
	linked_experiment_handler = experiment_handler
	if(register_events())
		return TRUE
	currently_scanned_atom = null
	linked_experiment_handler = null
	return FALSE

/**
 * Handles registering to events relevant to the experiment
 */
/datum/experiment/physical/proc/register_events()
	return FALSE

/**
 * Handles unregistering to events relevant to the experiment
 */
/datum/experiment/physical/proc/unregister_events()
	return
