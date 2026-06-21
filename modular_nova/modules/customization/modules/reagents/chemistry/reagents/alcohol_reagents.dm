// Modular Booze REAGENTS, see the following file for the mixes: modular_nova\modules\customization\modules\food_and_drinks\recipes\drinks_recipes.dm

/datum/reagent/consumable/ethanol/whiskey
	process_flags = REAGENT_ORGANIC | REAGENT_SYNTHETIC //let's not force the detective to change his alcohol brand


/datum/reagent/consumable/ethanol/bloody_mary
	chemical_flags_nova = REAGENT_BLOOD_REGENERATING


// ROBOT ALCOHOL PAST THIS POINT
// WOOO!

/datum/reagent/consumable/ethanol/synthanol
	name = "合成醇"
	description = "一种具有导电能力的流动液体。它对合成人的影响类似于酒精对有机体的影响。"
	color = "#1BB1FF"
	process_flags = REAGENT_ORGANIC | REAGENT_SYNTHETIC
	boozepwr = 50
	quality = DRINK_NICE
	taste_description = "motor oil"

/datum/glass_style/drinking_glass/synthanol
	required_drink_type = /datum/reagent/consumable/ethanol/synthanol
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi' // This should cover anything synthanol related. Will have to individually tag others unless we make an object path for Nova drinks.
	icon_state = "synthanolglass"
	name = "一杯合成醇"
	desc = "这是合成人员员的酒精替代品。如果他们也有味蕾的话，也会觉得这玩意儿糟透了。"

/datum/reagent/consumable/ethanol/synthanol/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	if(!(affected_mob.mob_biotypes & MOB_ROBOTIC))
		affected_mob.reagents.remove_reagent(type, 6 * seconds_per_tick * metabolization_ratio) //gets removed from organics very fast
		if(prob(25))
			affected_mob.vomit(VOMIT_CATEGORY_DEFAULT, lost_nutrition = 5)
	return ..()

/datum/reagent/consumable/ethanol/synthanol/expose_mob(mob/living/carbon/C, method=TOUCH, volume)
	. = ..()
	if(C.mob_biotypes & MOB_ROBOTIC)
		return
	if(method == INGEST)
		to_chat(C, pick(span_danger("那玩意儿糟透了！"), span_danger("那玩意儿真恶心！")))

/datum/reagent/consumable/ethanol/synthanol/robottears
	name = "机器人眼泪"
	description = "An oily substance that an IPC could technically consider a 'drink'."
	color = "#363636"
	quality = DRINK_GOOD
	boozepwr = 25
	taste_description = "existential angst"

/datum/glass_style/drinking_glass/synthanol/robottears
	required_drink_type = /datum/reagent/consumable/ethanol/synthanol/robottears
	icon_state = "robottearsglass"
	name = "一杯机器人眼泪"
	desc = "制作此饮品时没有伤害任何机器人。"

/datum/reagent/consumable/ethanol/synthanol/trinary
	name = "三元"
	description = "一种仅供合成人饮用的果味饮品，虽然这听起来有点奇怪。"
	color = "#ADB21f"
	quality = DRINK_GOOD
	boozepwr = 20
	taste_description = "modem static"

/datum/glass_style/drinking_glass/synthanol/trinary
	required_drink_type = /datum/reagent/consumable/ethanol/synthanol/trinary
	icon_state = "trinaryglass"
	name = "一杯三元"
	desc = "为合成人员员调制的彩色饮品。看起来味道不怎么样。"

/datum/reagent/consumable/ethanol/synthanol/servo
	name = "伺服"
	description = "一种含有部分有机成分，但仅供合成人饮用的饮品。"
	color = "#5B3210"
	quality = DRINK_GOOD
	boozepwr = 25
	taste_description = "motor oil and cocoa"

/datum/glass_style/drinking_glass/synthanol/servo
	required_drink_type = /datum/reagent/consumable/ethanol/synthanol/servo
	icon_state = "servoglass"
	name = "一杯伺服"
	desc = "为IPC调制的巧克力基底饮品。不确定是否真的有人尝试过这个配方。"

/datum/reagent/consumable/ethanol/synthanol/uplink
	name = "上行链路"
	description = "酒精与合成醇的强力混合物。仅对合成人有效。"
	color = "#E7AE04"
	quality = DRINK_GOOD
	boozepwr = 15
	taste_description = "a GUI in visual basic"

/datum/glass_style/drinking_glass/synthanol/uplink
	required_drink_type = /datum/reagent/consumable/ethanol/synthanol/uplink
	icon_state = "uplinkglass"
	name = "一杯上行链路"
	desc = "由最上等的利口酒与合成醇调配而成的精致混合物。仅供合成体饮用。"

/datum/reagent/consumable/ethanol/synthanol/synthncoke
	name = "合成可乐"
	description = "为机器人的口味调整过的经典饮品。"
	color = "#7204E7"
	quality = DRINK_GOOD
	boozepwr = 25
	taste_description = "fizzy motor oil"

/datum/glass_style/drinking_glass/synthanol/synthncoke
	required_drink_type = /datum/reagent/consumable/ethanol/synthanol/synthncoke
	icon_state = "synthncokeglass"
	name = "一杯合成可乐"
	desc = "为适应机器人口味而改良的经典饮品，含有除锈特性。如果你是碳基生物，饮用它可不是个好主意。"

/datum/reagent/consumable/ethanol/synthanol/synthignon
	name = "合成尼翁"
	description = "有人把葡萄酒和机器人的酒精混在一起了。希望你为此感到自豪。"
	color = "#D004E7"
	quality = DRINK_GOOD
	boozepwr = 25
	taste_description = "fancy motor oil"

/datum/glass_style/drinking_glass/synthanol/synthignon
	required_drink_type = /datum/reagent/consumable/ethanol/synthanol/synthignon
	icon_state = "synthignonglass"
	name = "一杯合成尼翁"
	desc = "有人把好葡萄酒和机器人烈酒混在了一起。很浪漫，但糟透了。"

// Other Booze

/datum/reagent/consumable/ethanol/gunfire
	name = "枪火"
	description = "一种尝起来像微小爆炸的饮料。"
	color = "#e4830d"
	boozepwr = 40
	quality = DRINK_GOOD
	taste_description = "tiny explosions"

/datum/glass_style/drinking_glass/gunfire
	required_drink_type = /datum/reagent/consumable/ethanol/gunfire
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "gunfire"
	name = "一杯枪火"
	desc = "当你看着它时，它不断地发出爆裂声，并迸发出微小的火花。"

/datum/reagent/consumable/ethanol/gunfire/on_mob_life(mob/living/carbon/M, seconds_per_tick, metabolization_ratio)
	if (prob(3))
		to_chat(M,span_notice("你感觉到枪火在嘴里噼啪作响。"))
	return ..()

/datum/reagent/consumable/ethanol/hellfire
	name = "地狱火"
	description = "一种不错的饮料，并没有看起来那么热。"
	color = "#fb2203"
	boozepwr = 60
	quality = DRINK_VERYGOOD
	taste_description = "cold flames that lick at the top of your mouth"

/datum/glass_style/drinking_glass/hellfire
	required_drink_type = /datum/reagent/consumable/ethanol/hellfire
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "hellfire"
	name = "一杯地狱火"
	desc = "一种琥珀色的饮品，实际并没有它看起来那么灼热。"

/datum/reagent/consumable/ethanol/hellfire/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_bodytemperature(50 * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick * metabolization_ratio, 0, BODYTEMP_NORMAL + 30)

/datum/reagent/consumable/ethanol/sins_delight
	name = "罪之欢愉"
	description = "这饮料闻起来有七宗罪的味道。"
	color = "#330000"
	boozepwr = 66
	quality = DRINK_FANTASTIC
	taste_description = "overpowering sweetness with a touch of sourness, followed by iron and the sensation of a warm summer breeze"

/datum/glass_style/drinking_glass/sins_delight
	required_drink_type = /datum/reagent/consumable/ethanol/sins_delight
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "sins_delight"
	name = "一杯罪之欢愉"
	desc = "你能闻到七宗罪的气息从杯口弥漫开来。"

/datum/reagent/consumable/ethanol/strawberry_daiquiri
	name = "草莓黛绮丽"
	description = "看起来粉红色的酒精饮料。"
	boozepwr = 20
	color = "#FF4A74"
	quality = DRINK_NICE
	taste_description = "sweet strawberry, lime and the ocean breeze"

/datum/glass_style/drinking_glass/strawberry_daiquiri
	required_drink_type = /datum/reagent/consumable/ethanol/strawberry_daiquiri
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "strawberry_daiquiri"
	name = "一杯草莓黛绮丽"
	desc = "粉红色的饮品，点缀着花朵和一根用来啜饮的大吸管。看起来甜美又清爽，是温暖日子的完美选择。"

/datum/reagent/consumable/ethanol/liz_fizz
	name = "蜥蜴嘶嘶"
	description = "三重柑橘风味，分层铺上冰块和奶油。"
	boozepwr = 0
	color = "#D8FF59"
	quality = DRINK_NICE
	taste_description = "brain freezing sourness"

/datum/glass_style/drinking_glass/liz_fizz
	required_drink_type = /datum/reagent/consumable/ethanol/liz_fizz
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "liz_fizz"
	name = "一杯蜥蜴嘶嘶"
	desc = "看起来像是分层了的柑橘果子露？为什么会有人想要这个，你完全无法理解。"

/datum/reagent/consumable/ethanol/miami_vice
	name = "迈阿密风云"
	description = "一种分层混合了椰林飘香和草莓黛绮丽的饮料"
	boozepwr = 30
	color = "#D8FF59"
	quality = DRINK_FANTASTIC
	taste_description = "sweet and refreshing flavor, complemented with strawberries and coconut, and hints of citrus"

/datum/glass_style/drinking_glass/miami_vice
	required_drink_type = /datum/reagent/consumable/ethanol/miami_vice
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "miami_vice"
	name = "一杯迈阿密风云"
	desc = "草莓与椰子，如同阴与阳。"

/datum/reagent/consumable/ethanol/malibu_sunset
	name = "马里布日落"
	description = "一种由椰子奶油利口酒和热带果汁组成的饮料"
	boozepwr = 20
	color = "#FF9473"
	quality = DRINK_VERYGOOD
	taste_description = "coconut, with orange and grenadine accents"

/datum/glass_style/drinking_glass/malibu_sunset
	required_drink_type = /datum/reagent/consumable/ethanol/malibu_sunset
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "malibu_sunset"
	name = "一杯马里布日落"
	desc = "热带风情的饮品，冰块漂浮在表面，红石榴糖浆染红了底部。"

/datum/reagent/consumable/ethanol/hotlime_miami
	name = "热辣莱姆迈阿密"
	description = "90年代的精髓，如果那是一个血腥烂摊子的话。"
	boozepwr = 40
	color = "#A7FAE8"
	quality = DRINK_FANTASTIC
	taste_description = "coconut and aesthetic violence"

/datum/glass_style/drinking_glass/hotlime_miami
	required_drink_type = /datum/reagent/consumable/ethanol/hotlime_miami
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "hotlime_miami"
	name = "一杯热辣莱姆迈阿密"
	desc = "这看起来非常赏心悦目。"

/datum/reagent/consumable/ethanol/hotlime_miami/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.set_drugginess(2.5 MINUTES * seconds_per_tick * metabolization_ratio)
	if(affected_mob.adjust_stamina_loss(-3.34 * seconds_per_tick * metabolization_ratio, updating_stamina = FALSE))
		return UPDATE_MOB_HEALTH

/datum/reagent/consumable/ethanol/coggrog
	name = "齿轮格罗格"
	description = "现在你可以用拉特瓦尔的力量填满自己了！"
	color = rgb(255, 201, 49)
	boozepwr = 10
	quality = DRINK_FANTASTIC
	taste_description = "a brass taste with a hint of oil"

/datum/glass_style/drinking_glass/coggrog
	required_drink_type = /datum/reagent/consumable/ethanol/coggrog
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "coggrog"
	name = "一杯齿轮格罗格"
	desc = "就连拉特瓦的四位将军也无法承受这个！Qevax Jryy！"

/datum/reagent/consumable/ethanol/badtouch
	name = "糟糕触碰"
	description = "一种酸涩的复古饮品。有人说发明者经常挨耳光。"
	color = rgb(31, 181, 99)
	boozepwr = 35
	quality = DRINK_GOOD
	taste_description = "a slap to the face"

/datum/glass_style/drinking_glass/badtouch
	required_drink_type = /datum/reagent/consumable/ethanol/badtouch
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "badtouch"
	name = "一杯糟糕触碰"
	desc = "毕竟我们不过是哺乳动物罢了。"

/datum/reagent/consumable/ethanol/marsblast
	name = "火星冲击"
	description = "一种辛辣而充满男子气概的饮料，旨在纪念火星的第一批殖民者。"
	color = rgb(246, 143, 55)
	boozepwr = 70
	quality = DRINK_FANTASTIC
	taste_description = "hot red sand"

/datum/glass_style/drinking_glass/marsblast
	required_drink_type = /datum/reagent/consumable/ethanol/marsblast
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "marsblast"
	name = "一杯火星冲击"
	desc = "一杯就足以让你的脸变得和那颗行星一样红。"

/datum/reagent/consumable/ethanol/mercuryblast
	name = "水星冲击"
	description = "一种酸涩、灼烧般冰冷的饮品，肯定能让饮用者感到寒意。"
	color = rgb(29, 148, 213)
	boozepwr = 40
	quality = DRINK_VERYGOOD
	taste_description = "chills down your spine"

/datum/glass_style/drinking_glass/mercuryblast
	required_drink_type = /datum/reagent/consumable/ethanol/mercuryblast
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "mercuryblast"
	name = "一杯水星冲击"
	desc = "制作这杯饮品时没有温度计受到伤害。"

/datum/reagent/consumable/ethanol/mercuryblast/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	affected_mob.adjust_bodytemperature(-50 * TEMPERATURE_DAMAGE_COEFFICIENT * seconds_per_tick * metabolization_ratio, T0C)

/datum/reagent/consumable/ethanol/piledriver
	name = "打桩机"
	description = "一种明亮的饮品，会给你留下灼烧感。"
	color = rgb(241, 146, 59)
	boozepwr = 45
	quality = DRINK_NICE
	taste_description = "a fire in your throat"

/datum/glass_style/drinking_glass/piledriver
	required_drink_type = /datum/reagent/consumable/ethanol/piledriver
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "piledriver"
	name = "一杯打桩机"
	desc = "这可不是唯一会让你喉咙发痛的东西。"

/datum/reagent/consumable/ethanol/zenstar
	name = "禅星"
	description = "一种酸涩而平淡的饮品，相当令人失望。"
	color = rgb(51, 87, 203)
	boozepwr = 35
	quality = DRINK_NICE
	taste_description = "disappointment"

/datum/glass_style/drinking_glass/zenstar
	required_drink_type = /datum/reagent/consumable/ethanol/zenstar
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "zenstar"
	name = "一杯禅星"
	desc = "You'd think something so balanced would actually taste nice... you'd be dead wrong."


// RACE SPECIFIC DRINKS

/datum/reagent/consumable/ethanol/coldscales
	name = "冷鳞"
	color = "#5AEB52" //(90, 235, 82)
	description = "一种看起来冰冷的饮品，专为有鳞片的人调制。"
	boozepwr = 50 //strong!
	taste_description = "dead flies"

/datum/glass_style/drinking_glass/coldscales
	required_drink_type = /datum/reagent/consumable/ethanol/coldscales
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "coldscales"
	name = "一杯冷鳞"
	desc = "一杯看起来诱人的柔和绿色饮品！"

/datum/reagent/consumable/ethanol/coldscales/expose_mob(mob/living/exposed_mob, methods, reac_volume)
	if(islizard(exposed_mob))
		quality = RACE_DRINK
	else
		quality = DRINK_GOOD
	return ..()

/datum/reagent/consumable/ethanol/oil_drum
	name = "油桶"
	color = "#000000" //(0, 0, 0)
	description = "工业级油与一些乙醇混合制成的饮品。不知为何，并未发现其有毒。"
	boozepwr = 45
	taste_description = "oil spill"

/datum/glass_style/drinking_glass/oil_drum
	required_drink_type = /datum/reagent/consumable/ethanol/oil_drum
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "oil_drum"
	name = "一桶油"
	desc = "一罐灰色的酒和油的混合物……"

/datum/reagent/consumable/ethanol/oil_drum/expose_mob(mob/living/exposed_mob, methods, reac_volume)
	if(MOB_ROBOTIC)
		quality = RACE_DRINK
	else
		quality = DRINK_GOOD
	return ..()

/datum/reagent/consumable/ethanol/nord_king
	name = "北方之王"
	color = "#EB1010" //(235, 16, 16)
	description = "浓烈的蜂蜜酒混合了更多蜂蜜和乙醇。深受其人类顾客喜爱。"
	boozepwr = 50 //strong!
	taste_description = "honey and red wine"

/datum/glass_style/drinking_glass/nord_king
	required_drink_type = /datum/reagent/consumable/ethanol/nord_king
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "nord_king"
	name = "一桶北方之王"
	desc = "一桶滴着红色蜂蜜酒的小桶。"

/datum/reagent/consumable/ethanol/nord_king/expose_mob(mob/living/exposed_mob, methods, reac_volume)
	if(ishumanbasic(exposed_mob) || isdwarf(exposed_mob))
		quality = RACE_DRINK
	else
		quality = DRINK_GOOD
	return ..()

/datum/reagent/consumable/ethanol/velvet_kiss
	name = "天鹅绒之吻"
	color = "#EB1010" //(235, 16, 16)
	description = "一种与葡萄酒混合的血色饮品。"
	boozepwr = 10 //weak
	taste_description = "iron with grapejuice"

/datum/glass_style/drinking_glass/velvet_kiss
	required_drink_type = /datum/reagent/consumable/ethanol/velvet_kiss
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "velvet_kiss"
	name = "一杯天鹅绒之吻"
	desc = "为上流阶层或亡灵准备的红白饮品。"

/datum/reagent/consumable/ethanol/velvet_kiss/expose_mob(mob/living/exposed_mob, methods, reac_volume)
	if(iszombie(exposed_mob) || isvampire(exposed_mob) || isdullahan(exposed_mob)) //Rare races!
		quality = RACE_DRINK
	else
		quality = DRINK_GOOD
	return ..()

/datum/reagent/consumable/ethanol/abduction_fruit
	name = "绑架果实"
	color = "#DEFACD" //(222, 250, 205)
	description = "混合果汁以制造出外星风味。"
	boozepwr = 80 //Strong
	taste_description = "grass and lime"

/datum/glass_style/drinking_glass/abduction_fruit
	required_drink_type = /datum/reagent/consumable/ethanol/abduction_fruit
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "abduction_fruit"
	name = "一杯绑架果实"
	desc = "混合了本不该混合的水果……"

/datum/reagent/consumable/ethanol/abduction_fruit/expose_mob(mob/living/exposed_mob, methods, reac_volume)
	if(isabductor(exposed_mob) || isxenohybrid(exposed_mob))
		quality = RACE_DRINK
	else
		quality = DRINK_GOOD
	return ..()

/datum/reagent/consumable/ethanol/bug_zapper
	name = "虫虫克星"
	color = "#F5882A" //(222, 250, 205)
	description = "铜和柠檬汁。几乎算不上是饮品。"
	boozepwr = 5 //No booze really
	taste_description = "copper and AC power"

/datum/glass_style/drinking_glass/bug_zapper
	required_drink_type = /datum/reagent/consumable/ethanol/bug_zapper
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "bug_zapper"
	name = "一杯虫虫克星"
	desc = "一种铜、柠檬汁和能量的奇怪混合物，本意并非供人类饮用。"

/datum/reagent/consumable/ethanol/bug_zapper/expose_mob(mob/living/exposed_mob, methods, reac_volume)
	if(isinsect(exposed_mob) || isflyperson(exposed_mob) || ismoth(exposed_mob))
		quality = RACE_DRINK
	else
		quality = DRINK_GOOD
	return ..()

/datum/reagent/consumable/ethanol/mush_crush
	name = "蘑菇粉碎"
	color = "#F5882A" //(222, 250, 205)
	description = "一杯土。"
	boozepwr = 5 //No booze really
	taste_description = "dirt and iron"

/datum/glass_style/drinking_glass/mush_crush
	required_drink_type = /datum/reagent/consumable/ethanol/mush_crush
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "mush_crush"
	name = "一杯蘑菇粉碎"
	desc = "在那些想自己种食物而不是喝泥土的人中很受欢迎。"

/datum/reagent/consumable/ethanol/mush_crush/expose_mob(mob/living/exposed_mob, methods, reac_volume)
	if(ispodperson(exposed_mob) || issnail(exposed_mob))
		quality = RACE_DRINK
	else
		quality = DRINK_GOOD
	return ..()

/datum/reagent/consumable/ethanol/hollow_bone
	name = "空心骨"
	color = "#FCF7D4" //(252, 247, 212)
	description = "毒素和牛奶的混合物，令人惊讶地无害。"
	boozepwr = 15
	taste_description = "Milk and salt"

/datum/glass_style/drinking_glass/hollow_bone
	required_drink_type = /datum/reagent/consumable/ethanol/hollow_bone
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "hollow_bone"
	name = "一颅空心骨"
	desc = "牛奶与伤骨汁的混合，为相当瘦削的人带来享受。"

/datum/reagent/consumable/ethanol/hollow_bone/expose_mob(mob/living/exposed_mob, methods, reac_volume)
	if(isplasmaman(exposed_mob) || isskeleton(exposed_mob))
		quality = RACE_DRINK
	else
		quality = DRINK_GOOD
	return ..()

/datum/reagent/consumable/ethanol/jell_wyrm
	name = "果冻蠕虫"
	color = "#FF6200" //(255, 98, 0)
	description = "二氧化碳、毒素和热量的可怕混合物。专为黏液基生命体准备。"
	boozepwr = 40
	taste_description = "tropical sea"

/datum/glass_style/drinking_glass/jell_wyrm
	required_drink_type = /datum/reagent/consumable/ethanol/jell_wyrm
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "jell_wyrm"
	name = "一杯果冻蠕虫"
	desc = "一种气泡饮料，对那些不知道它是为谁准备的人来说相当诱人。"

/datum/reagent/consumable/ethanol/jell_wyrm/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(prob(20))
		if(affected_mob.adjust_tox_loss(0.83 * seconds_per_tick * metabolization_ratio, updating_health = FALSE, required_biotype = affected_biotype))
			return UPDATE_MOB_HEALTH

#define JELLWYRM_DISGUST 25

/datum/reagent/consumable/ethanol/jell_wyrm/expose_mob(mob/living/exposed_mob, methods, reac_volume)
	if(isjellyperson(exposed_mob) || isslimeperson(exposed_mob) || isluminescent(exposed_mob))
		quality = RACE_DRINK
	else //if youre not a slime, jell wyrm should be GROSS
		exposed_mob.adjust_disgust(JELLWYRM_DISGUST)
	return ..()

#undef JELLWYRM_DISGUST

/datum/reagent/consumable/ethanol/laval_spit //Yes Laval
	name = "熔岩唾沫"
	color = "#DE3009" //(222, 48, 9)
	description = "加热矿物和一些莫纳罗亚火山成分。专为岩石基生命设计。"
	boozepwr = 30
	taste_description = "tropical island"

/datum/glass_style/drinking_glass/laval_spit
	required_drink_type = /datum/reagent/consumable/ethanol/laval_spit
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "laval_spit"
	name = "一杯熔岩唾沫"
	desc = "为那些能承受熔岩热度的人准备的滚烫饮品。"

/datum/reagent/consumable/ethanol/laval_spit/expose_mob(mob/living/exposed_mob, methods, reac_volume)
	if(isgolem(exposed_mob))
		quality = RACE_DRINK
	else
		quality = DRINK_GOOD
	return ..()

/datum/reagent/consumable/ethanol/frisky_kitty
	name = "Frisky Kitty"
	color = "#FCF7D4" //(252, 247, 212)
	description = "温牛奶混合猫薄荷。"
	boozepwr = 0
	taste_description = "Warm milk and catnip"

/datum/glass_style/drinking_glass/frisky_kitty
	required_drink_type = /datum/reagent/consumable/ethanol/frisky_kitty
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "frisky_kitty"
	name = "一杯frisky kitty"
	desc = "温牛奶和一些猫薄荷。"

/datum/reagent/consumable/ethanol/frisky_kitty/expose_mob(mob/living/exposed_mob, methods, reac_volume)
	if(isfeline(exposed_mob))
		quality = RACE_DRINK
	else
		quality = DRINK_GOOD
	return ..()


/datum/reagent/consumable/ethanol/bloodshot_base
	name = "Bloodshot Base"
	description = "制作血弹所需的私酿营养与酒精混合物。单独品尝味道不怎么样，至少对嗜血者而言。"
	color = "#c29ca1"
	boozepwr = 25 // Still more concentrated than in Bloodshot.
	taste_description = "nutritious mix with an alcoholic kick to it"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED


/datum/reagent/consumable/ethanol/bloodshot
	name = "Bloodshot"
	description = "The history of the 'Bloodshot' is based in a mix of flavor-neutral chems devised to help deliver nutrients to a Hemophage's tumorous organs. Due to the expense of the real thing and the clinical nature of it, this liquor has been designed as a 'improvised' alternative; though, still tasting like a hangover cure. It smells like iron, giving a clue to the key ingredient."
	color = "#a30000"
	boozepwr = 20 // The only booze in it is Bloody Mary
	taste_description = "blood filled to the brim with nutrients of all kinds"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	chemical_flags_nova = REAGENT_BLOOD_REGENERATING


/datum/glass_style/drinking_glass/bloodshot
	required_drink_type = /datum/reagent/consumable/ethanol/bloodshot
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "bloodshot"
	name = "一杯bloodshot"
	desc = "The history of the 'Bloodshot' is based in a mix of flavor-neutral chems devised to help deliver nutrients to a Hemophage's tumorous organs. Due to the expense of the real thing and the clinical nature of it, this liquor has been designed as a 'improvised' alternative; though, still tasting like a hangover cure. It smells like iron, giving a clue to the key ingredient."


#define BLOODSHOT_DISGUST 25

/datum/reagent/consumable/ethanol/bloodshot/expose_mob(mob/living/exposed_mob, methods, reac_volume)
	if(ishemophage(exposed_mob))
		quality = RACE_DRINK

	else if(exposed_mob.get_blood_volume() < exposed_mob.blood_volume_normal)
		quality = DRINK_GOOD

	if(!quality) // Basically, you don't have a reason to want to have this in your system, it doesn't taste good to you!
		exposed_mob.adjust_disgust(BLOODSHOT_DISGUST)

	return ..()

#undef BLOODSHOT_DISGUST

/datum/reagent/consumable/ethanol/bloodshot/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(drinker.get_blood_volume() < drinker.blood_volume_normal)
		//Bloodshot quickly restores blood loss.
		drinker.adjust_blood_volume(3.34 * seconds_per_tick * metabolization_ratio, maximum = BLOOD_VOLUME_NORMAL)

/datum/reagent/consumable/ethanol/blizzard_brew
	name = "Blizzard Brew"
	description = "一份古老的配方。最好尽可能以矮人方式冰镇后享用。"
	color = rgb(180, 231, 216)
	boozepwr = 25
	metabolization_rate = 1.25 * REAGENTS_METABOLISM
	taste_description = "ancient icicles"
	overdose_threshold = 25

/datum/glass_style/drinking_glass/blizzard_brew
	required_drink_type = /datum/reagent/consumable/ethanol/blizzard_brew
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "blizzard_brew"
	name = "一杯Blizzard Brew"
	desc = "一个古老的配方。最好尽可能以矮人风格冰镇后享用。"

/datum/reagent/consumable/ethanol/blizzard_brew/expose_mob(mob/living/exposed_mob, methods, reac_volume)
	if(isdwarf(exposed_mob))
		quality = RACE_DRINK
	else
		quality = DRINK_NICE
	return ..()

/datum/reagent/consumable/ethanol/blizzard_brew/overdose_start(mob/living/carbon/drinker, metabolization_ratio)
	. = ..()
	drinker.apply_status_effect(/datum/status_effect/frozenstasis/irresistable)

/datum/reagent/consumable/ethanol/blizzard_brew/on_mob_delete(mob/living/carbon/drinker)
	drinker.remove_status_effect(/datum/status_effect/frozenstasis/irresistable)
	return ..()

/datum/reagent/consumable/ethanol/blizzard_brew/overdose_process(mob/living/affected_mob, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(!affected_mob.has_status_effect(/datum/status_effect/frozenstasis/irresistable))
		holder.remove_reagent(type, volume) // remove it all if we were broken out
		return

/datum/reagent/consumable/ethanol/molten_mead
	name = "Molten Mead"
	description = "以点燃胡须而闻名。饮用风险自负！"
	color = rgb(224, 78, 16)
	boozepwr = 35
	metabolization_rate = 1.25 * REAGENTS_METABOLISM
	taste_description = "burning wasps"
	overdose_threshold = 25

/datum/glass_style/drinking_glass/molten_mead
	required_drink_type = /datum/reagent/consumable/ethanol/molten_mead
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "molten_mead"
	name = "一杯Molten Mead"
	desc = "以点燃胡须而闻名。饮用风险自负！"

/datum/reagent/consumable/ethanol/molten_mead/expose_mob(mob/living/exposed_mob, methods, reac_volume)
	if(isdwarf(exposed_mob))
		quality = RACE_DRINK
	else
		quality = DRINK_VERYGOOD
	return ..()

/datum/reagent/consumable/ethanol/molten_mead/overdose_start(mob/living/carbon/drinker, metabolization_ratio)
	drinker.adjust_fire_stacks(2)
	drinker.ignite_mob()
	..()

/datum/reagent/consumable/ethanol/hippie_hooch
	name = "Hippie Hooch"
	description = "和平与爱！应人力资源部要求，这款饮品能让你快速清醒。"
	color = rgb(77, 138, 34)
	boozepwr = -20
	taste_description = "eggy hemp"
	var/static/list/status_effects_to_clear = list(
		/datum/status_effect/confusion,
		/datum/status_effect/dizziness,
		/datum/status_effect/drowsiness,
		/datum/status_effect/speech/slurring/drunk,
	)

/datum/glass_style/drinking_glass/hippie_hooch
	required_drink_type = /datum/reagent/consumable/ethanol/hippie_hooch
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "hippie_hooch"
	name = "一杯Hippie Hooch"
	desc = "和平与爱！应人力资源部要求，这款饮品保证能让你快速清醒。"

/datum/reagent/consumable/ethanol/hippie_hooch/expose_mob(mob/living/exposed_mob, methods, reac_volume)
	if(isdwarf(exposed_mob))
		quality = RACE_DRINK
	else
		quality = DRINK_FANTASTIC
	return ..()

/datum/reagent/consumable/ethanol/hippie_hooch/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, metabolization_ratio)
	for(var/effect in status_effects_to_clear)
		affected_mob.remove_status_effect(effect)
	affected_mob.reagents.remove_reagent(/datum/reagent/consumable/ethanol, 5 * seconds_per_tick * metabolization_ratio, include_subtypes = TRUE)
	. = ..()
	if(affected_mob.adjust_tox_loss(-0.334 * seconds_per_tick * metabolization_ratio, updating_health = FALSE, required_biotype = affected_biotype))
		. = UPDATE_MOB_HEALTH
	affected_mob.adjust_drunk_effect(-16.67 * seconds_per_tick * metabolization_ratio)

/datum/reagent/consumable/ethanol/research_rum
	name = "Research Rum"
	description = "由矮人科学家调制，这种发光的粉色酿造物定能超级激发你的思维。怎么做到的？科学！"
	color = rgb(169, 69, 169)
	boozepwr = 50
	taste_description = "slippery grey matter"

/datum/glass_style/drinking_glass/research_rum
	required_drink_type = /datum/reagent/consumable/ethanol/research_rum
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "research_rum"
	name = "一杯Research Rum"
	desc = "由矮人科学家调制而成，这种发光的粉色佳酿定能超频你的思维。怎么做到的？科研！"

/datum/reagent/consumable/ethanol/research_rum/expose_mob(mob/living/exposed_mob, methods, reac_volume)
	if(isdwarf(exposed_mob))
		quality = RACE_DRINK
	else
		quality = DRINK_GOOD
	return ..()

/datum/reagent/consumable/ethanol/research_rum/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	if(prob(5))
		drinker.say(pick_list_replacements(VISTA_FILE, "ballmer_good_msg"), forced = "ballmer")

/datum/reagent/consumable/ethanol/golden_grog
	name = "Golden Grog"
	description = "由一位时间与金钱都过多的矮人军需官调制的饮品。通常被想要炫耀财富的网红们点单。"
	color = rgb(247, 230, 141)
	boozepwr = 70
	taste_description = "sweet credit holochips"

/datum/glass_style/drinking_glass/golden_grog
	required_drink_type = /datum/reagent/consumable/ethanol/golden_grog
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "golden_grog"
	name = "一杯黄金格罗格"
	desc = "由一位时间与金钱都过于充裕的矮人军需官调制出的饮品。常被想要炫耀财富的网红们点单。"

/datum/reagent/consumable/ethanol/golden_grog/expose_mob(mob/living/exposed_mob, methods, reac_volume)
	if(isdwarf(exposed_mob))
		quality = RACE_DRINK
	else
		quality = DRINK_FANTASTIC
	return ..()

// RACIAL DRINKS END

/datum/reagent/consumable/ethanol/appletini
	name = "苹果马提尼"
	color = "#9bd1a9" //(155, 209, 169)
	description = "没人能拒绝的亮绿色苹果味饮料！"
	boozepwr = 50
	taste_description = "Sweet and green"
	quality = DRINK_GOOD

/datum/glass_style/drinking_glass/appletini
	required_drink_type = /datum/reagent/consumable/ethanol/appletini
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "appletini"
	name = "一杯苹果马提尼"
	desc = "马提尼杯中的苹果风味饮品"

/datum/reagent/consumable/ethanol/quadruple_sec/cityofsin //making this a subtype was some REAL JANK, but it saves me a headache, and it looks good!
	name = "罪恶之城"
	color = "#eb9378" //(235, 147, 120)
	description = "为声名狼藉之人准备的顺滑、精致的饮品"
	boozepwr = 70
	taste_description = "Your own sins"
	quality = DRINK_VERYGOOD //takes extra effort
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/drinking_glass/cityofsin
	required_drink_type = /datum/reagent/consumable/ethanol/quadruple_sec/cityofsin
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "cityofsin"
	name = "一杯罪恶之城"
	desc = "看着它，会让你回想起自己犯过的每一个错误。"

/datum/reagent/consumable/ethanol/cringe_weaver
	name = "尬织者"
	description = "An infrangibly awful-tasting drink that 'smart' people inexplicably covet. For when they ask for a Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
	color = "#2BFE3C"
	boozepwr = -20 //spicy. sobering. burning. cringe.
	taste_description = "cringe and latin"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/consumable/ethanol/cringe_weaver/on_mob_life(mob/living/carbon/drinker, seconds_per_tick, metabolization_ratio)
	. = ..()
	var/obj/item/organ/liver/liver = drinker.get_organ_slot(ORGAN_SLOT_LIVER)
	if(liver && HAS_TRAIT(liver, TRAIT_CORONER_METABOLISM))
		if(drinker.heal_bodypart_damage(1.67 * seconds_per_tick * metabolization_ratio, 1.67 * seconds_per_tick * metabolization_ratio)) //coroners love drinking formaldehyde
			return UPDATE_MOB_HEALTH
	else
		drinker.adjust_disgust(1.67 * seconds_per_tick * metabolization_ratio)

/datum/glass_style/drinking_glass/cringe_weaver
	required_drink_type = /datum/reagent/consumable/ethanol/cringe_weaver
	name = "尬织者"
	desc = "辛辣、醒酒、灼烧感，当然——还有无可辩驳的尴尬。深受那些会向戴帽子的男人要一颗李子的顾客喜爱。"
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "cringe_weaver"

/datum/reagent/consumable/ethanol/shakiri
	name = "沙基里酒"
	description = "一种由发酵的基里果制成的甜美、芬芳的红色饮品。在光照下似乎会微微闪烁。"
	boozepwr = 45
	color = "#cf3c3c"
	quality = DRINK_GOOD
	taste_description = "delicious liquified jelly"
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/glass_style/drinking_glass/shakiri
	required_drink_type = /datum/reagent/consumable/ethanol/shakiri
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "shakiri"
	name = "一杯沙基里酒"
	desc = "一种由发酵的基里果制成的甜美、芬芳的红色饮品。在光照下似乎会微微闪烁。"

/datum/reagent/consumable/ethanol/shakiri_spritz
	name = "沙基里气泡酒"
	description = "一种由沙基里酒、橙汁和苏打水制成的碳酸鸡尾酒。"
	color = "#cf863c"
	quality = DRINK_GOOD
	boozepwr = 45
	taste_description = "tangy, carbonated sweetness"

/datum/glass_style/drinking_glass/shakiri_spritz
	required_drink_type = /datum/reagent/consumable/ethanol/shakiri_spritz
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "shakiri_spritz"
	name = "一杯沙基里气泡酒"
	desc = "一种由沙基里酒、橙汁和苏打水制成的碳酸鸡尾酒。"

/datum/reagent/consumable/ethanol/crimson_hurricane
	name = "绯红飓风"
	description = "一种源自人类的浓烈、柑橘风味的鸡尾酒，现在改用沙基里酒和基里果冻制成，口感甜美宜人。"
	color = "#b86637"
	quality = DRINK_VERYGOOD
	boozepwr = 60
	taste_description = "thick, fruity sweetness with a punch"

/datum/glass_style/drinking_glass/crimson_hurricane
	required_drink_type = /datum/reagent/consumable/ethanol/crimson_hurricane
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "crimson_hurricane"
	name = "一杯绯红飓风"
	desc = "一种源自人类的浓烈柑橘风味鸡尾酒，现在加入了沙基里酒和基里果冻，成为一款令人愉悦的甜味饮品。"

/datum/reagent/consumable/ethanol/shakiri_rogers
	name = "Shakiri Rogers"
	description = "对经典罗伊·罗杰斯鸡尾酒的改良，用沙基里酒代替了石榴糖浆。甜美而清爽。"
	color = "#6F2B1A"
	quality = DRINK_GOOD
	boozepwr = 45
	taste_description = "fruity, carbonated soda with a slight kick"

/datum/glass_style/drinking_glass/shakiri_rogers
	required_drink_type = /datum/reagent/consumable/ethanol/shakiri_rogers
	icon = 'modular_nova/master_files/icons/obj/drinks.dmi'
	icon_state = "shakiri_rogers"
	name = "一杯沙基里·罗杰斯"
	desc = "经典罗伊·罗杰斯的变体，用沙基里代替了石榴糖浆。甜美而清爽。"
