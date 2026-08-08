/// M64 → KOLBEN/NACHTREIHER 转换配方：黑名单枪不得被当成原料送进 check_requirements。
///
/// 玩家上报「大修套件无法使用」。根因是 `_crafting.dm` 里两道过滤不一致：数量统计那层排除了
/// blacklist 与配方自身产物，**实例收集那层没排**，于是 `collected_requirements[...][1]` 可能是
/// 那把已改造好的成品枪；配方拿它去查余弹，非零就拒绝——玩家看到的是「枪明明是空的却做不了」。
///
/// 只能测这半边：`check_contents` 的返回是 `PERFORM_ALL_TESTS(crafting) || check_requirements(...)`，
/// 单测里前者恒真、后者根本不执行，所以走 check_contents 的测试对这条路是**空的**（踩过一次：
/// 加修复前后都绿）。这里直接喂 check_requirements 一份「泄漏了黑名单枪」的实参，钉住
/// 「一旦泄漏就会拒绝」这个因果；配上 _crafting.dm 那侧的过滤才构成完整修复。
/datum/unit_test/m64_conversion

/datum/unit_test/m64_conversion/Run()
	var/mob/living/carbon/human/crafter = allocate(/mob/living/carbon/human/consistent)
	var/turf/bench = get_turf(crafter)

	var/datum/crafting_recipe/recipe = locate(/datum/crafting_recipe/riot_sol_super) in GLOB.crafting_recipes
	TEST_ASSERT_NOTNULL(recipe, "M64 转换配方应已注册进 GLOB.crafting_recipes")

	var/obj/item/gun/ballistic/shotgun/riot/sol/shotgun = allocate(/obj/item/gun/ballistic/shotgun/riot/sol)
	shotgun.forceMove(bench)
	if(shotgun.magazine)
		var/guard = 0
		while(shotgun.magazine.ammo_count() && guard++ < 50)
			var/obj/item/ammo_casing/round = shotgun.magazine.get_round()
			if(isnull(round))
				break
			qdel(round)
	if(shotgun.chambered)
		QDEL_NULL(shotgun.chambered)
	TEST_ASSERT_EQUAL(shotgun.get_ammo(), 0, "测试前提：原料 M64 应已清空")

	// 干净的实参：只有空弹原料枪 → 应放行。
	TEST_ASSERT(recipe.check_requirements(crafter, list(/obj/item/gun/ballistic/shotgun/riot/sol = list(shotgun))), \
		"只有空弹 M64 时配方应放行")

	// 泄漏的实参：已改造、带弹的成品枪排在首位 → 配方会拒绝。这正是过滤缺失时的现场。
	var/obj/item/gun/ballistic/shotgun/riot/sol/super/converted = allocate(/obj/item/gun/ballistic/shotgun/riot/sol/super)
	converted.forceMove(bench)
	TEST_ASSERT(converted.get_ammo() > 0, "测试前提：成品枪应带弹")
	TEST_ASSERT(!recipe.check_requirements(crafter, list(/obj/item/gun/ballistic/shotgun/riot/sol = list(converted, shotgun))), \
		"黑名单成品枪若泄漏进实参，配方会拒绝——所以 _crafting.dm 的实例收集必须过滤 blacklist")

	// 黑名单本身要覆盖到成品枪，否则上面的过滤无从生效。
	TEST_ASSERT(converted.type in recipe.blacklist, "成品枪类型应在配方 blacklist 里")
