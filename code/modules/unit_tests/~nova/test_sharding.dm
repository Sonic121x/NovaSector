// Parallel unit test runs. A runner starts N servers from the same build with
// `-params "test-shard=K&test-shards=N"` (K counts from 1); each server runs only its slice of the
// suite and writes its own results file, which the runner merges (tools/i18n/pseudo-test.sh).
// Without those params nothing changes: every test runs and results go to data/unit_tests.json.

#define TEST_SHARD_DURATIONS_FILE "data/unit_test_durations.json"
/// Weight for a test with no recorded duration (deciseconds).
#define TEST_SHARD_DEFAULT_WEIGHT 5
#define TEST_SHARD_LONGER_WEIGHT 60

/// Returns list(shard, shard_count), or null when this server runs the whole suite.
/proc/nova_unit_test_shard_params()
	var/shard_count = text2num(world.params["test-shards"])
	var/shard = text2num(world.params["test-shard"])
	if(!shard_count || shard_count < 2 || !shard || shard < 1 || shard > shard_count)
		return null
	return list(shard, shard_count)

/proc/nova_unit_test_results_path()
	var/list/shard_params = nova_unit_test_shard_params()
	return shard_params ? "data/unit_tests.shard-[shard_params[1]].json" : "data/unit_tests.json"

/// Keeps only this server's slice of `tests_to_run`, preserving priority order.
///
/// Every shard computes the same assignment from the same inputs, so no coordination is needed.
/// Tests are balanced by their last recorded duration (longest-processing-time first). Tests that
/// depend on create_and_destroy having already run in the same world stay on its shard.
/proc/nova_unit_test_shard(list/tests_to_run)
	var/list/shard_params = nova_unit_test_shard_params()
	if(!shard_params)
		return tests_to_run
	var/shard = shard_params[1]
	var/shard_count = shard_params[2]

	var/list/recorded = list()
	if(fexists(TEST_SHARD_DURATIONS_FILE))
		recorded = json_decode(file2text(TEST_SHARD_DURATIONS_FILE)) || list()

	// Units of work: one test, except create_and_destroy and everything ordered after it.
	var/list/units = list()
	var/list/create_and_destroy_unit
	for(var/datum/unit_test/test_path as anything in tests_to_run)
		var/weight = recorded["[test_path]"]
		if(!isnum(weight))
			weight = test_path::priority >= TEST_LONGER ? TEST_SHARD_LONGER_WEIGHT : TEST_SHARD_DEFAULT_WEIGHT
		weight *= test_path::times_to_run
		if(test_path::priority >= TEST_CREATE_AND_DESTROY)
			if(!create_and_destroy_unit)
				create_and_destroy_unit = list(0, list(), length(units) + 1)
				units += list(create_and_destroy_unit)
			create_and_destroy_unit[1] += weight
			create_and_destroy_unit[2] += test_path
			continue
		units += list(list(weight, list(test_path), length(units) + 1))

	// Heaviest first; equal weights keep suite order, so every shard computes the same assignment.
	sortTim(units, GLOBAL_PROC_REF(cmp_unit_test_shard_weight))

	var/list/loads = new /list(shard_count)
	for(var/index in 1 to shard_count)
		loads[index] = 0
	var/list/mine = list()
	for(var/list/unit as anything in units)
		var/target = 1
		for(var/candidate in 2 to shard_count)
			if(loads[candidate] < loads[target])
				target = candidate
		loads[target] += unit[1]
		if(target == shard)
			for(var/test_path in unit[2])
				mine[test_path] = TRUE

	var/list/sliced = list()
	for(var/test_path in tests_to_run)
		if(mine[test_path])
			sliced += test_path
	log_world("Unit test shard [shard]/[shard_count]: [length(sliced)] of [length(tests_to_run)] tests, estimated [loads[shard] / 10]s")
	return sliced

/// Units are list(weight, tests, suite_position).
/proc/cmp_unit_test_shard_weight(list/unit_a, list/unit_b)
	return unit_b[1] - unit_a[1] || unit_a[3] - unit_b[3]

#undef TEST_SHARD_DURATIONS_FILE
#undef TEST_SHARD_DEFAULT_WEIGHT
#undef TEST_SHARD_LONGER_WEIGHT
