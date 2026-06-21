// Hey! Listen! Update \config\lavaruinblacklist.txt with your new ruins!

/datum/map_template/ruin/lavaland
	ruin_type = ZTRAIT_LAVA_RUINS
	prefix = "_maps/RandomRuins/LavaRuins/"
	default_area = /area/lavaland/surface/outdoors/unexplored

/datum/map_template/ruin/lavaland/biodome
	cost = 5
	allow_duplicates = FALSE

/datum/map_template/ruin/lavaland/biodome/beach
	name = "熔岩遗迹-生物穹顶海滩"
	id = "biodome-beach"
	description = "Seemingly plucked from a tropical destination, this beach is calm and cool, with the salty waves roaring softly in the background. \
	Comes with a rustic wooden bar and suicidal bartender."
	suffix = "lavaland_biodome_beach.dmm"
	enclosed_for_terrain = TRUE

/datum/map_template/ruin/lavaland/biodome/winter
	name = "熔岩遗迹-生物穹顶冬日"
	id = "biodome-winter"
	description = "For those getaways where you want to get back to nature, but you don't want to leave the fortified military compound where you spend your days. \
	Includes a unique(*) laser pistol display case, and the recently introduced I.C.E(tm)."
	suffix = "lavaland_surface_biodome_winter.dmm"

/datum/map_template/ruin/lavaland/biodome/clown
	name = "熔岩遗迹-生物穹顶小丑星球"
	id = "biodome-clown"
	description = "欢迎来到小丑星球！哔哔哔哔哔哔等等！"
	suffix = "lavaland_biodome_clown_planet.dmm"

/datum/map_template/ruin/lavaland/lizgas
	name = "熔岩遗迹-蜥蜴的气体"
	id = "lizgas2"
	description = "一家新开业的蜥蜴加油站，属于蜥蜴燃气连锁品牌。"
	suffix = "lavaland_surface_gas.dmm"
	allow_duplicates = FALSE

/datum/map_template/ruin/lavaland/cube
	name = "熔岩遗迹-许愿者立方体"
	id = "wishgranter-cube"
	description = "这里不会有什么好事。吸取他们的教训，转身离开吧。"
	suffix = "lavaland_surface_cube.dmm"
	cost = 10
	allow_duplicates = FALSE
	enclosed_for_terrain = TRUE

/datum/map_template/ruin/lavaland/seed_vault
	name = "熔岩遗迹-种子库"
	id = "seed-vault"
	description = "The creators of these vaults were a highly advanced and benevolent race, and launched many into the stars, hoping to aid fledgling civilizations. \
	However, all the inhabitants seem to do is grow drugs and guns."
	suffix = "lavaland_surface_seed_vault.dmm"
	cost = 10
	allow_duplicates = FALSE
	enclosed_for_terrain = TRUE

// NOVA EDIT REMOVAL BEGIN - MAPPING
/*
/datum/map_template/ruin/lavaland/ash_walker
	name = "Lava-Ruin Ash Walker Nest"
	id = "ash-walker"
	description = "A race of unbreathing lizards live here, that run faster than a human can, worship a broken dead city, and are capable of reproducing by something involving tentacles? \
	Probably best to stay clear."
	suffix = "lavaland_surface_ash_walker1.dmm"
	cost = 20
	allow_duplicates = FALSE
	enclosed_for_terrain = TRUE

/datum/map_template/ruin/lavaland/syndicate_base
	name = "Lava-Ruin Syndicate Lava Base"
	id = "lava-base"
	description = "A secret base researching illegal bioweapons, it is closely guarded by an elite team of syndicate agents."
	suffix = "lavaland_surface_syndicate_base1.dmm"
	cost = 20
	allow_duplicates = FALSE
*/
//NOVA EDIT REMOVAL END

/datum/map_template/ruin/lavaland/free_golem
	name = "熔岩遗迹-自由魔像飞船"
	id = "golem-ship"
	description = "Lumbering humanoids, made out of precious metals, move inside this ship. They frequently leave to mine more minerals, which they somehow turn into more of them. \
	Seem very intent on research and individual liberty, and also geology-based naming?"
	cost = 20
	prefix = "_maps/RandomRuins/AnywhereRuins/"
	suffix = "golem_ship.dmm"
	allow_duplicates = FALSE

/datum/map_template/ruin/lavaland/gaia
	name = "熔岩遗迹-伊甸园碎片"
	id = "gaia"
	description = "谁能想到在这样一个可怕的星球上会有如此宁静的地方？"
	cost = 5
	suffix = "lavaland_surface_gaia.dmm"
	allow_duplicates = FALSE
	enclosed_for_terrain = TRUE

/datum/map_template/ruin/lavaland/sin
	cost = 10
	allow_duplicates = FALSE

/datum/map_template/ruin/lavaland/sin/envy
	name = "熔岩遗迹-嫉妒之墟"
	id = "envy"
	description = "当你得到他们所拥有的东西时，你最终就会快乐。"
	suffix = "lavaland_surface_envy.dmm"

/datum/map_template/ruin/lavaland/sin/gluttony
	name = "熔岩遗迹-暴食之墟"
	id = "gluttony"
	description = "如果你吃得足够多，那么吃就会成为你唯一做的事。"
	suffix = "lavaland_surface_gluttony.dmm"

/datum/map_template/ruin/lavaland/sin/greed
	name = "熔岩遗迹-贪婪之墟"
	id = "greed"
	description = "Sure you don't need magical powers, but you WANT them, and \
		that's what's important."
	suffix = "lavaland_surface_greed.dmm"

/datum/map_template/ruin/lavaland/sin/pride
	name = "熔岩遗迹-傲慢之墟"
	id = "pride"
	description = "虫洞救生带是给失败者用的，而你比他们强多了。"
	suffix = "lavaland_surface_pride.dmm"

/datum/map_template/ruin/lavaland/sin/sloth
	name = "熔岩遗迹-懒惰之墟"
	id = "sloth"
	description = "..."
	suffix = "lavaland_surface_sloth.dmm"
	// Generates nothing but atmos runtimes and salt
	cost = 0
	terrain_padding = 2

/datum/map_template/ruin/lavaland/ratvar
	name = "熔岩遗迹-陨落神祇"
	id = "ratvar"
	description = "拉特瓦尔的最终安息之地。"
	suffix = "lavaland_surface_dead_ratvar.dmm"
	cost = 0
	allow_duplicates = FALSE

/datum/map_template/ruin/lavaland/hierophant
	name = "熔岩遗迹-圣职者竞技场"
	id = "hierophant"
	description = "一块巨大而奇特的方形金属块。里面等待着的只有死亡和许许多多的方块。"
	suffix = "lavaland_surface_hierophant.dmm"
	always_place = TRUE
	allow_duplicates = FALSE
	terrain_padding = 2

/datum/map_template/ruin/lavaland/blood_drunk_miner
	name = "熔岩遗迹-嗜血矿工"
	id = "blooddrunk"
	description = "一组奇怪的石板排列，以及一个疯狂、野兽般的矿工正在沉思。"
	suffix = "lavaland_surface_blooddrunk1.dmm"
	cost = 0
	allow_duplicates = FALSE //will only spawn one variant of the ruin
	enclosed_for_terrain = TRUE

/datum/map_template/ruin/lavaland/blood_drunk_miner/guidance
	name = "熔岩遗迹-嗜血矿工（指引）"
	suffix = "lavaland_surface_blooddrunk2.dmm"
	enclosed_for_terrain = TRUE

/datum/map_template/ruin/lavaland/blood_drunk_miner/hunter
	name = "熔岩遗迹-嗜血矿工（猎手）"
	suffix = "lavaland_surface_blooddrunk3.dmm"
	enclosed_for_terrain = TRUE

/datum/map_template/ruin/lavaland/blood_drunk_miner/random
	name = "熔岩遗迹-嗜血矿工（随机）"
	suffix = null
	always_place = TRUE

/datum/map_template/ruin/lavaland/blood_drunk_miner/random/New()
	suffix = pick("lavaland_surface_blooddrunk1.dmm", "lavaland_surface_blooddrunk2.dmm", "lavaland_surface_blooddrunk3.dmm")
	return ..()

/datum/map_template/ruin/lavaland/ufo_crash
	name = "熔岩遗迹-UFO坠毁点"
	id = "ufo-crash"
	description = "事实证明，让被绑架者保持昏迷真的非常重要。谁知道呢？"
	suffix = "lavaland_surface_ufo_crash.dmm"
	cost = 5
	enclosed_for_terrain = TRUE

/datum/map_template/ruin/lavaland/xeno_nest
	name = "熔岩遗迹-异形巢穴"
	id = "xeno-nest"
	description = "These xenomorphs got bored of horrifically slaughtering people on space stations, and have settled down on a nice lava-filled hellscape to focus on what's really important in life. \
	Quality memes."
	suffix = "lavaland_surface_xeno_nest.dmm"
	cost = 20
	enclosed_for_terrain = TRUE

/datum/map_template/ruin/lavaland/fountain
	name = "熔岩遗迹-喷泉大厅"
	id = "lava_fountain"
	description = "喷泉侧面有一个警告。危险：可能具有未声明的副作用，只有在实现时才会变得明显。"
	prefix = "_maps/RandomRuins/AnywhereRuins/"
	suffix = "fountain_hall.dmm"
	cost = 5

/datum/map_template/ruin/lavaland/survivalcapsule
	name = "熔岩遗迹-生存舱废墟"
	id = "survivalcapsule"
	description = "这里曾是普通矿工的庇护所，如今却成了他们的坟墓。"
	suffix = "lavaland_surface_survivalpod.dmm"
	cost = 5

/datum/map_template/ruin/lavaland/pizza
	name = "熔岩遗迹-废墟披萨派对"
	id = "pizza"
	description = "小蒂米的生日披萨派对在蓝空异常经过时急转直下。"
	suffix = "lavaland_surface_pizzaparty.dmm"
	allow_duplicates = FALSE
	cost = 5

/datum/map_template/ruin/lavaland/cultaltar
	name = "熔岩遗迹-召唤仪式"
	id = "cultaltar"
	description = "一个进行邪恶崇拜的地方，中央的血迹涂鸦诡异地发着光。恶魔般的笑声在洞穴中回荡。"
	suffix = "lavaland_surface_cultaltar.dmm"
	allow_duplicates = FALSE
	cost = 10

/datum/map_template/ruin/lavaland/hermit
	name = "熔岩遗迹-临时避难所"
	id = "hermitcave"
	description = "一个孤独隐士的栖身之所，勉强维持生计，苟延残喘。"
	suffix = "lavaland_surface_hermit.dmm"
	allow_duplicates = FALSE
	cost = 10

/datum/map_template/ruin/lavaland/miningripley
	name = "熔岩遗迹-里普利机甲"
	id = "ripley"
	description = "一台严重受损的矿用里普利，属于一位非常不幸的矿工。你可能得花点功夫才能修好这东西。"
	suffix = "lavaland_surface_random_ripley.dmm"
	allow_duplicates = FALSE
	cost = 5
	enclosed_for_terrain = TRUE

/datum/map_template/ruin/lavaland/dark_wizards
	name = "熔岩遗迹-黑暗巫师祭坛"
	id = "dark_wizards"
	description = "一处黑暗巫师盘踞的遗迹。他们守护着什么秘密？"
	suffix = "lavaland_surface_wizard.dmm"
	cost = 5
	enclosed_for_terrain = TRUE

/datum/map_template/ruin/lavaland/strong_stone
	name = "熔岩遗迹-坚固之石"
	id = "strong_stone"
	description = "一块看起来特别强大的石头。"
	suffix = "lavaland_strong_rock.dmm"
	allow_duplicates = FALSE
	cost = 2

/datum/map_template/ruin/lavaland/puzzle
	name = "熔岩遗迹-远古谜题"
	id = "puzzle"
	description = "有待解开的谜题。"
	suffix = "lavaland_surface_puzzle.dmm"
	cost = 5

/datum/map_template/ruin/lavaland/elite_tumor
	name = "熔岩遗迹-搏动肿瘤"
	id = "tumor"
	description = "一个寄宿着强大野兽的奇怪肿瘤……"
	suffix = "lavaland_surface_elite_tumor.dmm"
	cost = 5
	always_place = TRUE
	allow_duplicates = TRUE

/datum/map_template/ruin/lavaland/elephant_graveyard
	name = "熔岩遗迹-巨象坟场"
	id = "Graveyard"
	description = "一处废弃的墓地，召唤着那些无法继续前行的人。"
	suffix = "lavaland_surface_elephant_graveyard.dmm"
	allow_duplicates = FALSE
	cost = 10
	enclosed_for_terrain = TRUE

/datum/map_template/ruin/lavaland/bileworm_nest
	name = "熔岩遗迹-胆汁蠕虫巢穴"
	id = "bileworm_nest"
	description = "一个远离严酷荒野的小小庇护所……如果你是胆汁蠕虫的话。"
	cost = 5
	suffix = "lavaland_surface_bileworm_nest.dmm"
	allow_duplicates = FALSE
	enclosed_for_terrain = TRUE

/datum/map_template/ruin/lavaland/lava_phonebooth
	name = "熔岩遗迹-电话亭"
	id = "lava_phonebooth"
	description = "纳米传讯为推广全息板使用而进行的一次尝试。这台不知怎么流落到了这里。"
	suffix = "lavaland_surface_phonebooth.dmm"
	allow_duplicates = FALSE
	cost = 5

/datum/map_template/ruin/lavaland/battle_site
	name = "熔岩遗迹-战场遗址"
	id = "battle_site"
	description = "很久以前野兽与人形生物战斗的遗址。胜者未知，但败者一目了然。"
	suffix = "lavaland_battle_site.dmm"
	allow_duplicates = TRUE
	cost = 3

/datum/map_template/ruin/lavaland/vent
	name = "熔岩遗迹-矿脉喷口"
	id = "ore_vent"
	description = "一个喷出矿石的喷口。似乎是自然现象。"
	suffix = "lavaland_surface_ore_vent.dmm"
	allow_duplicates = TRUE
	cost = 0
	mineral_cost = 1
	always_place = TRUE

/datum/map_template/ruin/lavaland/watcher_grave
	name = "熔岩遗迹-守望者之墓"
	id = "watcher-grave"
	description = "一个孤独的洞穴，一个孤儿正在等待新的父母。"
	suffix = "lavaland_surface_watcher_grave.dmm"
	cost = 5
	allow_duplicates = FALSE

/datum/map_template/ruin/lavaland/mook_village
	name = "熔岩遗迹-穆克村落"
	id = "mook_village"
	description = "一个居住着友善穆克族群的村庄！"
	suffix = "lavaland_surface_mookvillage.dmm"
	allow_duplicates = FALSE
	cost = 5

/datum/map_template/ruin/lavaland/shuttle_wreckage
	name = "熔岩遗迹-穿梭机残骸"
	id = "shuttle_wreckage"
	description = "并非每艘穿梭机都能返回中央司令部。"
	suffix = "lavaland_surface_shuttle_wreckage.dmm"
	allow_duplicates = FALSE
	enclosed_for_terrain = TRUE


/datum/map_template/ruin/lavaland/crashsite
	name = "熔岩遗迹-逃生舱坠毁点"
	id = "crashsite"
	description = "他们发射得太早了"
	suffix = "lavaland_surface_crashsite.dmm"
	allow_duplicates = FALSE
	enclosed_for_terrain = TRUE

/datum/map_template/ruin/lavaland/shoe_facotry
	name = "Lava-Ruin Shoe Factory"
	id = "shoe_factory"
	description = "An abandoned shoe factory."
	prefix = "_maps/RandomRuins/AnywhereRuins/"
	suffix = "shoe_factory.dmm"
	allow_duplicates = FALSE
	cost = 10
