/// i18n 漏翻采集器（miss_log.dm）的 run 提取纯函数测试。
///
/// lang_i18n_extract_runs 决定「什么算一条漏翻记录」：门槛错了要么日志被人名/数字刷屏，
/// 要么真漏翻（如 2 词小写短语）被静默丢弃。此测试冻结门槛语义：
///   ① ≥3 拉丁词的 run 收录；② 恰 2 词且含小写开头词收录（"toggle safety"），
///      2 词全大写开头跳过（"John Smith" 人名）；③ CJK 打断 run；④ HTML 标签/实体剥除；
///   ⑤ run 内部数字保留、尾部数字/标点修剪；⑥ 全中文/空文本零产出。
/datum/unit_test/i18n_miss_log

/datum/unit_test/i18n_miss_log/Run()
	// ① 基础句子收录（含尾随标点）
	var/list/runs = lang_i18n_extract_runs("The engine is on fire!")
	TEST_ASSERT_EQUAL(length(runs), 1, "整句应提取为一条 run")
	TEST_ASSERT_EQUAL(runs[1], "The engine is on fire!", "run 应保留原词与标点")

	// ② 词数门槛：2 词含小写开头收录；2 词全 Title Case（人名类）跳过
	runs = lang_i18n_extract_runs("toggle safety")
	TEST_ASSERT_EQUAL(length(runs), 1, "2 词小写短语应收录")
	runs = lang_i18n_extract_runs("John Smith")
	TEST_ASSERT_EQUAL(length(runs), 0, "2 词 Title Case（人名类）应跳过")

	// ③ CJK 打断：中英混排只收英文段
	runs = lang_i18n_extract_runs("这是一段 partially translated sentence here 的文本")
	TEST_ASSERT_EQUAL(length(runs), 1, "中英混排应只提取英文段")
	TEST_ASSERT_EQUAL(runs[1], "partially translated sentence here", "英文段应完整提取")

	// ④ HTML 标签与实体剥除
	runs = lang_i18n_extract_runs("<span class='warning'>You hear something skittering.</span>&nbsp;")
	TEST_ASSERT_EQUAL(length(runs), 1, "HTML 标签应剥除且不混入 run")
	TEST_ASSERT_EQUAL(runs[1], "You hear something skittering.", "标签属性词不应进入 run")

	// ⑤ run 内数字保留、尾部中性 token 修剪
	runs = lang_i18n_extract_runs("Requires 3 more units now 5")
	TEST_ASSERT_EQUAL(length(runs), 1, "内部数字不应打断 run")
	TEST_ASSERT_EQUAL(runs[1], "Requires 3 more units now", "尾部孤立数字应修剪")

	// ⑥ 无英文内容零产出
	TEST_ASSERT_EQUAL(length(lang_i18n_extract_runs("引擎着火了！")), 0, "全中文应零产出")
	TEST_ASSERT_EQUAL(length(lang_i18n_extract_runs("")), 0, "空串应零产出")
	TEST_ASSERT_EQUAL(length(lang_i18n_extract_runs(null)), 0, "null 应零产出")
