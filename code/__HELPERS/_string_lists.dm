#define pick_list(FILE, KEY) (pick(strings(FILE, KEY)))
#define pick_list_weighted(FILE, KEY) (pick_weight(strings(FILE, KEY)))
#define pick_list_replacements(FILE, KEY) (strings_replacement(FILE, KEY))
#define json_load(FILE) (json_decode(file2text(FILE)))

GLOBAL_LIST(string_cache)
GLOBAL_VAR(string_filename_current_key)


/proc/strings_replacement(filepath, key)
	filepath = sanitize_filepath(filepath)
	load_strings_file(filepath)

	if((filepath in GLOB.string_cache) && (key in GLOB.string_cache[filepath]))
		var/response = pick(GLOB.string_cache[filepath][key])
		var/regex/needs_replacing = regex("@pick\\((\\D+?)\\)", "g")
		response = needs_replacing.Replace(response, GLOBAL_PROC_REF(strings_subkey_lookup))
		return response
	else
		CRASH("strings list not found: [STRING_DIRECTORY]/[filepath], index=[key]")

/proc/strings(filepath as text, key as text, directory = STRING_DIRECTORY)
	if(IsAdminAdvancedProcCall())
		return

	filepath = sanitize_filepath(filepath)
	load_strings_file(filepath, directory)
	if((filepath in GLOB.string_cache) && (key in GLOB.string_cache[filepath]))
		return GLOB.string_cache[filepath][key]
	else
		CRASH("strings list not found: [directory]/[filepath], index=[key]")

/proc/strings_subkey_lookup(match, group1)
	return pick_list(GLOB.string_filename_current_key, group1)

/proc/load_strings_file(filepath, directory = STRING_DIRECTORY)
	if(IsAdminAdvancedProcCall())
		return

	GLOB.string_filename_current_key = filepath
	if(filepath in GLOB.string_cache)
		return //no work to do

	if(!GLOB.string_cache)
		GLOB.string_cache = new

	GLOB.string_cache[filepath] = json_load("[directory]/[filepath]")

	// NOVA EDIT ADDITION START - i18n - strings/ flavor 数据已并入主目录（strings 命名空间）：全服非英文
	// 时递归反查字符串叶子（译文在 strings/i18n/<locale>/strings.json）。多词门槛 + 「只有 flavor 被抽进
	// 目录」→ names/口音表/词频表等天然 no-op，无需运行时白名单。(取代旧的平行副本方案。)
	// READY 门保证 GLOB 阶段只缓存 canonical English；ConfigLoaded 的单一初始化入口随后补翻 flavor 表。
	if(lang_runtime_is_ready() && GLOB.i18n_server_locale != DEFAULT_UI_LOCALE && islist(GLOB.string_cache[filepath]))
		lang_reverse_tree(GLOB.string_cache[filepath])
	// NOVA EDIT ADDITION END
