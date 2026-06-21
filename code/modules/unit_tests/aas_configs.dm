/datum/unit_test/aas_configs

/datum/unit_test/aas_configs/Run()
	var/expected_max_length = MAX_AAS_LENGTH

	for(var/config_type in valid_subtypesof(/datum/aas_config_entry))
		var/datum/aas_config_entry/entry = allocate(config_type)
		for(var/key, line in entry.announcement_lines_map)
			if(length_char(line) > expected_max_length)
				TEST_FAIL("配置文件'[config_type]'中的公告行'[key]'超过最大长度[expected_max_length]字符（实际长度：[length(line)]）")
