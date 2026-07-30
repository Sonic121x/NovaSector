/**
 * 史莱姆自动命名：每种类型必须得到互不相同、且已重建过的名字。
 *
 * 守的是一类只在运行期暴露的汉化 bug：`update_name()` 先用正则剥掉类型默认名
 * 「grey baby slime (123)」末尾的「(id)」后缀，据此判断这是自动名、可以按真实颜色重建。
 * 若该默认名的译文把半角括号写成了全角（机翻常见），后缀就剥不掉、条件短路，
 * 于是每只史莱姆都停在类型默认名——线上表现为「全是灰色幼年史莱姆」。
 * 编译和 DreamChecker 都测不出来。
 */
/datum/unit_test/slime_naming

/datum/unit_test/slime_naming/Run()
	var/static/regex/id_suffix = new(" \\(\\d+\\)$")
	var/list/seen_names = list()

	for(var/slime_type_path in subtypesof(/datum/slime_type))
		var/mob/living/basic/slime/test_slime = allocate(/mob/living/basic/slime, null, slime_type_path, SLIME_LIFE_STAGE_BABY)

		TEST_ASSERT_NOTNULL(test_slime.slime_type, "[slime_type_path] 的史莱姆没有拿到 slime_type")

		// 重建后的名字一定带半角「 (数字)」后缀——那是 update_name() 自己拼的。
		TEST_ASSERT(id_suffix.Find(test_slime.name), \
			"[slime_type_path] 的史莱姆名 [test_slime.name] 缺少 (id) 后缀，说明 update_name() 的重建分支没进去；\
			多半是类型默认名的译文把 (123) 写成了全角，剥后缀的正则匹配不上。")

		// 不同类型剥掉随机 id 后必须仍然互不相同。
		var/base_name = id_suffix.Replace(test_slime.name, "")
		TEST_ASSERT(isnull(seen_names[base_name]), \
			"[slime_type_path] 的史莱姆名重建后是 [base_name]，与 [seen_names[base_name]] 撞名；\
			所有史莱姆塌缩成同一个名字正是那个 bug 的表现。")
		seen_names[base_name] = slime_type_path
