/// 新人软管制的点击判定表：拦什么、放什么、以及哪些「刻意不拦」。
///
/// 这条判定跑在 `COMSIG_MOB_CLICKON` 上，是**每次点击**都要过的热路径，所以写成了一串按
/// 命中率排序的 `istype()`（原生类型比较，且不像 typecache 那样吃内存——单
/// `typecacheof(/obj/machinery/atmospherics)` 就要驻留约 900 条路径）。
/// 代价是这串比较**顺序敏感**：`ismachinery()` 那道闸门一旦挪位或某个分支被写进错误的
/// 层级，机器类会整片从判定里漏出去，而游戏里不会报任何错——只是管制悄悄失效。
///
/// 「刻意不拦」的两条尤其要钉死，它们看起来像遗漏，其实是设计：
/// · **撬棍**不在拆解工具名单里——被困住时撬门是新人自救的手段。
/// · **Shift 点击（检查）**在信号处理器里直接放行——受管制的恰恰是最需要读环境的人。
/datum/unit_test/newbie_guard_refusal

/datum/unit_test/newbie_guard_refusal/Run()
	var/mob/living/carbon/human/subject = allocate(/mob/living/carbon/human/consistent)
	var/datum/component/newbie_guard/guard = subject.AddComponent(/datum/component/newbie_guard)
	TEST_ASSERT_NOTNULL(guard, "新人软管制组件应能挂载到 /mob/living 上")

	var/obj/item/wrench = allocate(/obj/item/wrench)
	var/obj/item/crowbar = allocate(/obj/item/crowbar)
	var/obj/item/grenade = allocate(/obj/item/grenade/smokebomb)

	var/obj/machinery/firealarm/alarm = allocate(/obj/machinery/firealarm)
	var/obj/machinery/vending/plain_machine = allocate(/obj/machinery/vending/cola)
	var/obj/structure/cable/wire = allocate(/obj/structure/cable)
	var/obj/item/food/donut/harmless = allocate(/obj/item/food/donut/plain)

	// ① 违禁物品：拿在手上就拦，与点什么无关（含点自己手里的物品 = 引爆/激活那条路径）。
	TEST_ASSERT_EQUAL(guard.get_refusal(harmless, grenade), NEWBIE_GUARD_REFUSE_ITEM, "手持手雷点任何东西都应被拦下")
	TEST_ASSERT_EQUAL(guard.get_refusal(grenade, grenade), NEWBIE_GUARD_REFUSE_ITEM, "点自己手里的手雷（引爆路径）应被拦下")

	// ② 高危目标：无论拿什么都拦，空手也拦。
	TEST_ASSERT_EQUAL(guard.get_refusal(alarm, null), NEWBIE_GUARD_REFUSE_TARGET, "空手点火警应被拦下")
	TEST_ASSERT_EQUAL(guard.get_refusal(alarm, crowbar), NEWBIE_GUARD_REFUSE_TARGET, "拿撬棍点火警应被拦下")
	TEST_ASSERT_EQUAL(guard.get_refusal(wire, null), NEWBIE_GUARD_REFUSE_TARGET, "空手点电缆应被拦下（电缆不是 machinery，走的是另一条分支）")

	// ③ 拆解工具用在普通机器上：只在带工具时拦。这条同时验证 ismachinery 闸门之后
	//    「非高危机器」没有被整片放行，也没有被整片拦死。
	TEST_ASSERT_EQUAL(guard.get_refusal(plain_machine, wrench), NEWBIE_GUARD_REFUSE_TOOL, "用扳手拆普通机器应被拦下")
	TEST_ASSERT_EQUAL(guard.get_refusal(plain_machine, null), NEWBIE_GUARD_REFUSE_NONE, "空手使用普通机器不应被拦下")
	TEST_ASSERT_EQUAL(guard.get_refusal(plain_machine, harmless), NEWBIE_GUARD_REFUSE_NONE, "拿着无关物品使用普通机器不应被拦下")

	// ④ 刻意不拦：撬棍。改这条前先想清楚被困在着火房间里的新人怎么出来。
	TEST_ASSERT_EQUAL(guard.get_refusal(plain_machine, crowbar), NEWBIE_GUARD_REFUSE_NONE, "撬棍刻意不在拆解工具名单内")

	// ⑤ 普通游玩不受影响：拿着工具点非设施目标、空手点普通物品，都必须放行。
	TEST_ASSERT_EQUAL(guard.get_refusal(harmless, wrench), NEWBIE_GUARD_REFUSE_NONE, "拿扳手点甜甜圈不应被拦下")
	TEST_ASSERT_EQUAL(guard.get_refusal(harmless, null), NEWBIE_GUARD_REFUSE_NONE, "空手点普通物品不应被拦下")
	TEST_ASSERT_EQUAL(guard.get_refusal(subject, null), NEWBIE_GUARD_REFUSE_NONE, "空手点自己不应被拦下（攻击另由 TRAIT_PACIFISM 拦）")
	TEST_ASSERT_EQUAL(guard.get_refusal(null, null), NEWBIE_GUARD_REFUSE_NONE, "空目标不应被拦下")

	qdel(guard)
	TEST_ASSERT(!HAS_TRAIT_FROM(subject, TRAIT_PACIFISM, NEWBIE_GUARD_TRAIT), "组件销毁后必须撤掉自己加的和平化特质")
